import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

// ─── Types ────────────────────────────────────────────────────────────────────
interface DailyActivity {
  date: string;
  steps: number;
  distanceKm: number;
  activeMinutes: number;
  calories: number;
  walkCount: number;
  workoutCount: number;
  workoutCompleted: boolean;
  goalCompleted: boolean;
}

interface UserProfile {
  dailyStepGoal: number;
  dailyWalkingGoalKm: number;
  dailyActiveMinuteGoal: number;
  dailyWalkGoal: number;
  name: string;
}

interface StreakData {
  currentStreak: number;
  longestStreak: number;
  totalDaysCompleted: number;
  lastActivityDate: admin.firestore.Timestamp | null;
  completedDates: string[];
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
function toDateKey(date: Date): string {
  return date.toISOString().substring(0, 10);
}

function isGoalMet(activity: DailyActivity, profile: UserProfile): boolean {
  return (
    activity.steps >= profile.dailyStepGoal &&
    activity.distanceKm >= profile.dailyWalkingGoalKm &&
    activity.activeMinutes >= profile.dailyActiveMinuteGoal &&
    activity.walkCount >= profile.dailyWalkGoal
  );
}

// ─── 1. Update streak when daily activity changes ─────────────────────────────
export const onDailyActivityWrite = functions.firestore
  .document("users/{userId}/daily_activity/{dateKey}")
  .onWrite(async (change, context) => {
    const userId = context.params.userId;
    const dateKey = context.params.dateKey;

    if (!change.after.exists) return null;

    const activity = change.after.data() as DailyActivity;

    // Get user profile to check goals
    const profileSnap = await db
      .collection("users")
      .doc(userId)
      .collection("profile")
      .doc("data")
      .get();

    if (!profileSnap.exists) return null;
    const profile = profileSnap.data() as UserProfile;

    // Check if goal was met
    const goalMet = isGoalMet(activity, profile);

    // Update goalCompleted on the activity doc if needed
    if (goalMet !== activity.goalCompleted) {
      await change.after.ref.update({ goalCompleted: goalMet });
    }

    if (!goalMet) return null;

    // ── Update streak ──
    const streakRef = db
      .collection("users")
      .doc(userId)
      .collection("streak")
      .doc("data");

    const streakSnap = await streakRef.get();
    let streak: StreakData = streakSnap.exists
      ? (streakSnap.data() as StreakData)
      : {
          currentStreak: 0,
          longestStreak: 0,
          totalDaysCompleted: 0,
          lastActivityDate: null,
          completedDates: [],
        };

    const today = new Date(dateKey + "T00:00:00Z");
    const todayKey = dateKey;

    // Avoid double-counting
    if (streak.completedDates.includes(todayKey)) return null;

    const yesterday = new Date(today);
    yesterday.setUTCDate(yesterday.getUTCDate() - 1);
    const yesterdayKey = toDateKey(yesterday);

    let newCurrent: number;
    if (streak.completedDates.includes(yesterdayKey)) {
      newCurrent = streak.currentStreak + 1;
    } else {
      // Streak broken — reset
      newCurrent = 1;
    }

    const newLongest = Math.max(newCurrent, streak.longestStreak);
    const newDates = [...streak.completedDates, todayKey];

    await streakRef.set({
      currentStreak: newCurrent,
      longestStreak: newLongest,
      totalDaysCompleted: streak.totalDaysCompleted + 1,
      lastActivityDate: admin.firestore.Timestamp.fromDate(today),
      completedDates: newDates.slice(-365), // keep last 365 days
    });

    functions.logger.info(`Streak updated for ${userId}: ${newCurrent} days`);
    return null;
  });

// ─── 2. Auto-check and unlock achievements ────────────────────────────────────
export const checkAndUnlockAchievements = functions.firestore
  .document("users/{userId}/daily_activity/{dateKey}")
  .onWrite(async (change, context) => {
    if (!change.after.exists) return null;

    const userId = context.params.userId;
    const activity = change.after.data() as DailyActivity;

    // Gather lifetime stats
    const walksSnap = await db
      .collection("users")
      .doc(userId)
      .collection("walking_sessions")
      .get();
    const totalWalks = walksSnap.size;
    const totalDistanceKm = walksSnap.docs.reduce(
      (s, d) => s + ((d.data().distanceKm as number) || 0),
      0
    );

    const workoutsSnap = await db
      .collection("users")
      .doc(userId)
      .collection("workout_history")
      .where("isCompleted", "==", true)
      .get();
    const totalWorkouts = workoutsSnap.size;

    const streakSnap = await db
      .collection("users")
      .doc(userId)
      .collection("streak")
      .doc("data")
      .get();
    const streak = streakSnap.exists ? (streakSnap.data() as StreakData) : null;
    const currentStreak = streak?.currentStreak ?? 0;

    // Define achievement conditions
    const conditions: Record<string, boolean> = {
      firstWalk: totalWalks >= 1,
      firstWorkout: totalWorkouts >= 1,
      steps1k: activity.steps >= 1000,
      steps5k: activity.steps >= 5000,
      steps10k: activity.steps >= 10000,
      distance10km: totalDistanceKm >= 10,
      distance50km: totalDistanceKm >= 50,
      distance100km: totalDistanceKm >= 100,
      workouts10: totalWorkouts >= 10,
      workouts50: totalWorkouts >= 50,
      streak7: currentStreak >= 7,
      streak30: currentStreak >= 30,
      streak100: currentStreak >= 100,
      walks10: totalWalks >= 10,
      walks50: totalWalks >= 50,
      walks100: totalWalks >= 100,
    };

    const achievementsRef = db
      .collection("users")
      .doc(userId)
      .collection("achievements");

    const batch = db.batch();
    const newlyUnlocked: string[] = [];

    for (const [type, met] of Object.entries(conditions)) {
      if (!met) continue;
      const docRef = achievementsRef.doc(type);
      const snap = await docRef.get();
      if (!snap.exists || !snap.data()?.isUnlocked) {
        batch.set(docRef, {
          type,
          isUnlocked: true,
          unlockedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        newlyUnlocked.push(type);
      }
    }

    if (newlyUnlocked.length > 0) {
      await batch.commit();
      functions.logger.info(
        `Unlocked achievements for ${userId}: ${newlyUnlocked.join(", ")}`
      );
    }

    return null;
  });

// ─── 3. Update challenge progress ─────────────────────────────────────────────
export const updateChallengeProgress = functions.firestore
  .document("users/{userId}/daily_activity/{dateKey}")
  .onWrite(async (change, context) => {
    if (!change.after.exists) return null;

    const userId = context.params.userId;
    const activity = change.after.data() as DailyActivity;

    const challengesSnap = await db
      .collection("users")
      .doc(userId)
      .collection("challenges")
      .where("status", "in", ["notStarted", "inProgress"])
      .get();

    const batch = db.batch();

    for (const doc of challengesSnap.docs) {
      const challenge = doc.data();
      let currentValue = challenge.currentValue as number;
      const endDate = (challenge.endDate as admin.firestore.Timestamp).toDate();

      if (endDate < new Date()) {
        // Challenge expired
        batch.update(doc.ref, {
          status: currentValue >= challenge.targetValue ? "completed" : "failed",
        });
        continue;
      }

      // Determine progress from activity
      switch (challenge.unit) {
        case "steps":
          currentValue = activity.steps;
          break;
        case "km":
          // For weekly, accumulate — simplified here
          currentValue = Math.max(currentValue, activity.distanceKm);
          break;
        case "workouts":
          currentValue = Math.max(currentValue, activity.workoutCount);
          break;
      }

      const status =
        currentValue >= challenge.targetValue ? "completed" : "inProgress";
      batch.update(doc.ref, { currentValue, status });
    }

    await batch.commit();
    return null;
  });

// ─── 4. Daily AI summary (scheduled — runs at 10 PM daily) ───────────────────
export const sendDailyActivitySummary = functions.pubsub
  .schedule("0 22 * * *")
  .timeZone("Asia/Shanghai")
  .onRun(async () => {
    const todayKey = toDateKey(new Date());

    // Get all users with activity today
    const usersSnap = await db.collection("users").listDocuments();

    for (const userRef of usersSnap) {
      try {
        const activitySnap = await userRef
          .collection("daily_activity")
          .doc(todayKey)
          .get();

        if (!activitySnap.exists) continue;

        const activity = activitySnap.data() as DailyActivity;
        if (activity.steps === 0) continue;

        const profileSnap = await userRef
          .collection("profile")
          .doc("data")
          .get();

        if (!profileSnap.exists) continue;
        const profile = profileSnap.data() as UserProfile;
        const goalMet = isGoalMet(activity, profile);

        // Store summary notification in user's notifications subcollection
        await userRef.collection("notifications").add({
          type: "daily_summary",
          date: todayKey,
          steps: activity.steps,
          distanceKm: activity.distanceKm,
          walks: activity.walkCount,
          goalCompleted: goalMet,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          read: false,
        });
      } catch (err) {
        functions.logger.error(`Error processing user ${userRef.id}:`, err);
      }
    }

    functions.logger.info("Daily summaries sent for", new Date().toISOString());
    return null;
  });

// ─── 5. Clean up deleted user data ───────────────────────────────────────────
export const onUserDeleted = functions.auth.user().onDelete(async (user) => {
  const userId = user.uid;
  functions.logger.info(`Cleaning up data for deleted user: ${userId}`);

  const userRef = db.collection("users").doc(userId);

  // Delete sub-collections in batches
  const subcollections = [
    "profile",
    "settings",
    "streak",
    "daily_activity",
    "walking_sessions",
    "workout_history",
    "achievements",
    "challenges",
    "notifications",
  ];

  for (const col of subcollections) {
    const snap = await userRef.collection(col).limit(500).get();
    const batch = db.batch();
    snap.docs.forEach((d) => batch.delete(d.ref));
    await batch.commit();
  }

  await userRef.delete();
  functions.logger.info(`User data deleted for: ${userId}`);
});
