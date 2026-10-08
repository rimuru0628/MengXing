/// All UI strings for MengXing in English and Chinese (Simplified).
/// Usage: context.s.signIn  OR  AppStrings.of(context).signIn
class AppStrings {
  final bool isChinese;
  const AppStrings({required this.isChinese});

  static AppStrings of(context) {
    // Accessed via provider — see locale_provider.dart
    throw UnimplementedError('Use ref.watch(stringsProvider) instead');
  }

  // ─── Auth ──────────────────────────────────────────────────────────────────
  String get appTagline =>
      isChinese ? '每日运动与步行追踪器' : 'Daily Exercise & Walking Tracker';
  String get welcomeBack => isChinese ? '欢迎回来！🖤' : 'Welcome back! 🖤';
  String get signInSubtitle =>
      isChinese ? '登录以继续您的旅程' : 'Sign in to continue your journey';
  String get email => isChinese ? '邮箱' : 'Email';
  String get password => isChinese ? '密码' : 'Password';
  String get forgotPassword => isChinese ? '忘记密码？' : 'Forgot password?';
  String get signIn => isChinese ? '登录' : 'Sign In';
  String get orContinueWith => isChinese ? '或者使用' : 'or';
  String get continueWithGoogle =>
      isChinese ? '使用谷歌继续' : 'Continue with Google';
  String get noAccount => isChinese ? '没有账户？' : "Don't have an account? ";
  String get signUp => isChinese ? '注册' : 'Sign Up';
  String get createAccount => isChinese ? '创建账户' : 'Create Account';
  String get joinMengXing => isChinese ? '加入梦行' : 'Join MengXing';
  String get startJourney =>
      isChinese ? '今天开始您的健身之旅 ✨' : 'Start your fitness journey today ✨';
  String get fullName => isChinese ? '全名' : 'Full Name';
  String get confirmPassword => isChinese ? '确认密码' : 'Confirm Password';
  String get termsNote =>
      isChinese ? '创建账户即表示您同意我们的服务条款和隐私政策。' : 'By creating an account, you agree to our Terms of Service and Privacy Policy.';
  String get resetPassword => isChinese ? '重置密码' : 'Reset Password';
  String get forgotSubtitle =>
      isChinese ? '输入您的邮箱，我们将发送重置链接。' : "Enter your email and we'll send you a reset link.";
  String get sendResetLink => isChinese ? '发送重置链接' : 'Send Reset Link';
  String get checkInbox => isChinese ? '查看收件箱！💌' : 'Check your inbox! 💌';
  String get backToLogin => isChinese ? '返回登录' : 'Back to Login';

  // ─── Validation ────────────────────────────────────────────────────────────
  String get emailRequired => isChinese ? '请输入邮箱' : 'Email is required';
  String get emailInvalid => isChinese ? '请输入有效邮箱' : 'Enter a valid email';
  String get passwordRequired => isChinese ? '请输入密码' : 'Password is required';
  String get passwordTooShort => isChinese ? '最少6个字符' : 'Minimum 6 characters';
  String get nameRequired => isChinese ? '请输入姓名' : 'Name is required';
  String get passwordsMismatch => isChinese ? '密码不匹配' : 'Passwords do not match';

  // ─── Onboarding ────────────────────────────────────────────────────────────
  String get skip => isChinese ? '跳过' : 'Skip';
  String get next => isChinese ? '下一步 →' : 'Next →';
  String get getStarted => isChinese ? '开始使用 ✨' : 'Get Started ✨';

  // ─── Home ─────────────────────────────────────────────────────────────────
  String get hey => isChinese ? '嗨，' : 'Hey, ';
  String get todayActivity => isChinese ? "今日活动" : "Today's Activity";
  String get dailyGoal => isChinese ? '每日目标' : 'Daily Goal';
  String get steps => isChinese ? '步数' : 'Steps';
  String get distance => isChinese ? '距离' : 'Distance';
  String get active => isChinese ? '活跃' : 'Active';
  String get walks => isChinese ? '步行' : 'Walks';
  String get calories => isChinese ? '卡路里' : 'Calories';
  String get startWalk => isChinese ? '开始步行 🚶‍♀️' : 'Start a Walk 🚶‍♀️';
  String get tapToBegin => isChinese ? '点击开始追踪' : 'Tap to begin tracking';
  String get todayWorkout => isChinese ? "今日训练 💪" : "Today's Workout 💪";
  String get viewAll => isChinese ? '查看全部' : 'View All';
  String get dailyGoals => isChinese ? '每日目标 🎯' : 'Daily Goals 🎯';
  String get edit => isChinese ? '编辑' : 'Edit';
  String get todayWalks => isChinese ? "今日步行 🚶" : "Today's Walks 🚶";
  String get history => isChinese ? '历史' : 'History';
  String get goalCompleted =>
      isChinese ? '每日目标完成！' : 'Daily goal completed!';
  String get keepMoving =>
      isChinese ? '继续前行，继续闪耀' : 'Keep moving, keep shining';
  String get dayStreak => isChinese ? '天连续' : ' Day Streak!';
  String get keepGoing => isChinese ? '继续加油！🖤' : "Keep the fire burning! 🖤";

  // ─── Walk ─────────────────────────────────────────────────────────────────
  String get walking => isChinese ? '步行 🚶‍♀️' : 'Walking 🚶‍♀️';
  String get readyToWalk => isChinese ? '准备好步行了吗？' : 'Ready to Walk?';
  String get trackSteps =>
      isChinese ? '追踪您的步数、距离和配速' : 'Track your steps, distance, and pace';
  String get startWalkBtn => isChinese ? '开始步行' : 'START WALK';
  String get duration => isChinese ? '时长' : 'Duration';
  String get pace => isChinese ? '配速' : 'Pace';
  String get pauseWalk => isChinese ? '暂停' : 'Pause';
  String get resumeWalk => isChinese ? '继续' : 'Resume';
  String get stopWalk => isChinese ? '停止步行' : 'STOP WALK';
  String get walkComplete => isChinese ? '步行完成！🖤' : 'Walk Complete! 🖤';
  String get saveWalk => isChinese ? '保存步行 🖤' : 'Save Walk 🖤';
  String get discard => isChinese ? '放弃' : 'Discard';
  String get everyStepCounts =>
      isChinese ? '每一步都算数！' : 'Every step counts!';
  String get walkHistory => isChinese ? '步行历史 🗂' : 'Walk History 🗂';
  String get today => isChinese ? '今天' : 'Today';
  String get thisWeek => isChinese ? '本周' : 'This Week';
  String get thisMonth => isChinese ? '本月' : 'This Month';
  String get noWalksToday =>
      isChinese ? '今天还没有步行记录\n点击开始步行！🌟' : 'No walks yet today\nHit START WALK above! 🌟';
  String get noWalksInPeriod =>
      isChinese ? '此时段没有步行记录' : 'No walks in this period';
  String get walksToday => isChinese ? '今日步行次数' : 'Walks Today';
  String get totalDist => isChinese ? '总距离' : 'Total Dist.';
  String get stopWalkQ => isChinese ? '停止步行？' : 'Stop Walk?';
  String get progressLost =>
      isChinese ? '当前步行进度将丢失。' : 'Your current walk progress will be lost.';
  String get keepWalking => isChinese ? '继续步行' : 'Keep Walking';
  String get safetyNote =>
      isChinese ? '⚠️ 如感到疼痛、头晕或不适，请立即停止。' : '⚠️ Stop if you feel pain, dizziness, or unusual symptoms.';

  // ─── Exercise ─────────────────────────────────────────────────────────────
  String get exercise => isChinese ? '运动 💪' : 'Exercise 💪';
  String get workoutComplete => isChinese ? '训练完成！🎉' : 'Workout Complete! 🎉';
  String get todayWorkoutTitle => isChinese ? '今日训练' : "Today's Workout";
  String get exerciseCategories =>
      isChinese ? '运动分类 🏋️' : 'Exercise Categories 🏋️';
  String get browseAll => isChinese ? '浏览全部' : 'Browse All';
  String get startWorkout => isChinese ? '开始训练' : 'START WORKOUT';
  String get doItAgain => isChinese ? '再来一次' : 'Do It Again';
  String get workoutCompleteTitle =>
      isChinese ? '训练完成！🏆' : 'Workout Complete! 🏆';
  String get workoutCompleteMsg =>
      isChinese ? '你做到了！这就是梦行的方式。🖤' : "You crushed it! That's the Kuromi way. 🖤";
  String get backToExercise => isChinese ? '返回运动' : 'Back to Exercise';
  String get viewHistory => isChinese ? '查看历史' : 'View History';
  String get restRecoverRepeat =>
      isChinese ? '休息，恢复，重复 🖤' : 'Rest, recover, repeat 🖤';
  String get warmup => isChinese ? '🤸 热身' : '🤸 Warm-up';
  String get mainWorkout => isChinese ? '🏋️ 主要训练' : '🏋️ Main';
  String get cooldown => isChinese ? '😌 放松' : '😌 Cool-down';
  String get exerciseLibrary => isChinese ? '运动库' : 'Exercise Library';
  String get searchExercises => isChinese ? '搜索运动...' : 'Search exercises...';
  String get howToPerform => isChinese ? '如何做：' : 'How to do it:';
  String get targetMuscles => isChinese ? '目标肌群' : 'Target Muscles';
  String get workoutDetails => isChinese ? '训练详情' : 'Workout Details';
  String get sets => isChinese ? '组数' : 'Sets';
  String get reps => isChinese ? '次数' : 'Reps';
  String get rest => isChinese ? '休息' : 'Rest';
  String get safetyWorkout =>
      isChinese ? '如感到疼痛或不适，请立即停止。专业人士建议。' : 'Stop immediately if you feel pain. Consult a professional if unsure.';
  String get resting => isChinese ? '休息中...' : 'Resting...';
  String get timerRunning => isChinese ? '计时中...' : 'Timer Running...';
  String get done => isChinese ? '完成' : 'DONE';
  String get workoutHistory => isChinese ? '训练历史' : 'Workout History';
  String get noWorkoutsThisMonth =>
      isChinese ? '本月暂无训练记录' : 'No workouts this month';

  // ─── Progress ─────────────────────────────────────────────────────────────
  String get progress => isChinese ? '进度 📊' : 'Progress 📊';
  String get dayStreak2 => isChinese ? '天连续' : ' Day Streak';
  String get best => isChinese ? '最佳' : 'best';
  String get total => isChinese ? '总计' : 'total';
  String get totalSteps => isChinese ? '总步数' : 'Total Steps';
  String get totalWalks => isChinese ? '总步行次数' : 'Total Walks';
  String get workouts => isChinese ? '训练次数' : 'Workouts';
  String get avgPerDay => isChinese ? '日均步数' : 'Avg/Day';
  String get activeMin => isChinese ? '活跃分钟' : 'Active Min';
  String get stepsThisWeek => isChinese ? '本周步数' : 'Steps This Week';
  String get thisMonthTitle => isChinese ? '本月' : 'This Month';
  String get goalDays => isChinese ? '达标天数' : 'Goal Days';
  String get activeDays => isChinese ? '活跃天数' : 'Active Days';
  String get activityCalendar =>
      isChinese ? '活动日历' : 'Activity Calendar';
  String get achievements => isChinese ? '成就' : 'Achievements';

  // ─── Profile ──────────────────────────────────────────────────────────────
  String get profile => isChinese ? '个人资料 🖤' : 'Profile 🖤';
  String get settings => isChinese ? '设置' : 'Settings';
  String get personalInfo => isChinese ? '个人信息 🌸' : 'Personal Info 🌸';
  String get dailyGoalsTitle => isChinese ? '每日目标 🎯' : 'Daily Goals 🎯';
  String get more => isChinese ? '更多 ✨' : 'More ✨';
  String get age => isChinese ? '年龄' : 'Age';
  String get height => isChinese ? '身高' : 'Height';
  String get weight => isChinese ? '体重' : 'Weight';
  String get bmi => isChinese ? 'BMI' : 'BMI';
  String get gender => isChinese ? '性别' : 'Gender';
  String get stepsGoal => isChinese ? '步数目标' : 'Steps Goal';
  String get distanceGoal => isChinese ? '距离目标' : 'Distance';
  String get activeMinutesGoal => isChinese ? '活跃分钟目标' : 'Active Minutes';
  String get walksGoal => isChinese ? '步行次数目标' : 'Walks';
  String get aiAssistant => isChinese ? 'AI助手' : 'AI Assistant';
  String get signOut => isChinese ? '退出登录' : 'Sign Out';
  String get signOutQ => isChinese ? '退出登录？' : 'Sign Out?';
  String get signOutMsg =>
      isChinese ? '您需要重新登录。' : "You'll need to sign in again.";
  String get cancel => isChinese ? '取消' : 'Cancel';
  String get profileNotSetUp =>
      isChinese ? '个人资料未设置' : 'Profile not set up yet';
  String get setUpProfile => isChinese ? '设置个人资料' : 'Set Up Profile';
  String get keepMovingShining =>
      isChinese ? '继续前行，继续闪耀 🖤' : 'Keep moving, keep shining 🖤';
  String get stepsToday => isChinese ? '今日步数' : 'Steps Today';
  String get editProfile => isChinese ? '编辑资料' : 'Edit Profile';

  // ─── Settings ─────────────────────────────────────────────────────────────
  String get account => isChinese ? '账户' : 'Account';
  String get app => isChinese ? '应用' : 'App';
  String get language => isChinese ? '语言' : 'Language';
  String get notifications => isChinese ? '通知' : 'Notifications';
  String get healthPermissions => isChinese ? '健康权限' : 'Health Permissions';
  String get locationPermission => isChinese ? '位置权限' : 'Location';
  String get dataPrivacy => isChinese ? '数据与隐私' : 'Data & Privacy';
  String get syncData => isChinese ? '同步数据' : 'Sync Data';
  String get privacyPolicy => isChinese ? '隐私政策' : 'Privacy Policy';
  String get accountActions => isChinese ? '账户操作' : 'Account Actions';
  String get deleteAccount => isChinese ? '删除账户' : 'Delete Account';
  String get deleteAccountSub =>
      isChinese ? '永久删除您的账户和所有数据' : 'Permanently delete your account and all data';
  String get manageNotifications =>
      isChinese ? '管理提醒设置' : 'Manage reminder settings';
  String get manageHealth =>
      isChinese ? '管理健康与活动权限' : 'Manage health & activity access';
  String get locationSub =>
      isChinese ? '仅用于GPS步行追踪' : 'Used only for GPS walk tracking';
  String get syncSub =>
      isChinese ? '手动同步活动到云端' : 'Manually sync activity to cloud';

  // ─── Navigation tabs ──────────────────────────────────────────────────────
  String get navHome => isChinese ? '首页' : 'Home';
  String get navWalk => isChinese ? '步行' : 'Walk';
  String get navExercise => isChinese ? '运动' : 'Exercise';
  String get navProgress => isChinese ? '进度' : 'Progress';
  String get navProfile => isChinese ? '我的' : 'Profile';

  // ─── Onboarding pages ─────────────────────────────────────────────────────
  String get ob1Title => isChinese ? '追踪每日活动' : 'Track Daily Activity';
  String get ob1Sub =>
      isChinese ? '每天监控您的步数、距离和活跃分钟。掌握您的健身之旅。' : 'Monitor your steps, distance, and active minutes every day.';
  String get ob2Title => isChinese ? '自动计步' : 'Count Your Steps';
  String get ob2Sub =>
      isChinese ? '手机自动使用传感器和健康数据计步。无需额外设备。' : 'Your phone automatically counts steps using built-in sensors.';
  String get ob3Title => isChinese ? '追踪步行' : 'Track Your Walks';
  String get ob3Sub =>
      isChinese ? '记录每次步行的时长、距离和配速。可选GPS路线。' : 'Log every walk with duration, distance, and pace.';
  String get ob4Title => isChinese ? '每日运动' : 'Daily Exercises';
  String get ob4Sub =>
      isChinese ? '跟随个性化每日训练，包括热身、主要运动和放松。' : 'Follow personalized daily workouts with warm-up and cool-down.';
  String get ob5Title => isChinese ? '设置个人目标' : 'Set Personal Goals';
  String get ob5Sub =>
      isChinese ? '设定每日步数、步行距离、活跃分钟和训练目标。' : 'Define your daily step goal, walking distance, and workout targets.';
  String get ob6Title => isChinese ? '监控进度' : 'Monitor Progress';
  String get ob6Sub =>
      isChinese ? '查看每日、每周和每月进度，包括图表和成就徽章。' : 'View daily, weekly, and monthly progress with charts and achievements.';

  // ─── AI assistant ─────────────────────────────────────────────────────────
  String get aiTitle => isChinese ? 'AI助手' : 'AI Assistant';
  String get aiSubtitle => isChinese ? '梦行健身教练' : 'MengXing Fitness Coach';
  String get aiDisclaimer =>
      isChinese ? '非医疗建议。如有不适请停止运动。如有健康问题请咨询专业人士。' : 'Not medical advice. Stop if you feel pain. Consult a professional for medical concerns.';
  String get aiPlaceholder =>
      isChinese ? '询问健身、训练或目标相关问题...' : 'Ask about fitness, workouts, or goals...';
  String get aiGreeting =>
      isChinese ? '你好！我是你的梦行健身助手 🌟 有任何训练、步行目标或健身问题，随时来问我！' : "Hi! I'm your MengXing fitness assistant 🌟 Ask me anything about your workouts, walking goals, or fitness tips!";
  String get clearChat => isChinese ? '清除聊天' : 'Clear chat';
  String get motivateMe => isChinese ? '激励我！' : 'Motivate me!';
  String get workoutTips => isChinese ? '训练技巧' : 'Workout tips';
  String get walkingGoals => isChinese ? '步行目标' : 'Walking goals';
  String get restDay => isChinese ? '要休息吗？' : 'Rest day?';

  // ─── Misc ─────────────────────────────────────────────────────────────────
  String get stayMagical =>
      isChinese ? '保持活跃，保持神奇 ✨' : 'Stay active, stay magical';
  String get youGotThis => isChinese ? '你可以的！' : "You've got this!";
  String get couldNotLoad =>
      isChinese ? '无法加载数据' : 'Could not load data';
  String get noDataYet => isChinese ? '暂无数据' : 'No data yet';
  String get minPerKm => isChinese ? '分/公里' : 'min/km';
  String get kcal => isChinese ? '千卡' : 'kcal';
  String get km => isChinese ? '公里' : 'km';
  String get min => isChinese ? '分钟' : 'min';
  String get years => isChinese ? '岁' : 'years';
  String get challenges => isChinese ? '挑战' : 'Challenges';

  // ─── Home hardcoded strings ────────────────────────────────────────────────
  String get todayActivityTitle => isChinese ? '今日活动' : "Today's Activity";
  String get stepsLabel => isChinese ? '步数' : 'steps';
  String get dailyGoalPct => isChinese ? '每日目标' : 'daily goal';
  String get startAWalk => isChinese ? '开始步行 🚶‍♀️' : 'Start a Walk 🚶‍♀️';
  String get tapToBeginTracking => isChinese ? '点击开始追踪' : 'Tap to begin tracking';
  String get dailyWorkoutCard => isChinese ? '今日训练 💪' : 'Today\'s Workout 💪';
  String get exercises => isChinese ? '项运动' : 'exercises';
  String get approx30Min => isChinese ? '约30分钟' : '~30 min';
  String get workoutCompletedCard => isChinese ? '训练完成！🎉' : 'Workout Complete! 🎉';
  String get amazingJobToday => isChinese ? '今天表现很棒！' : 'Amazing job today!';
  String get noWalksYetHome => isChinese ? '今天还没有步行记录' : 'No walks yet today';
  String get tapStartWalk => isChinese ? '点击"开始步行"开始' : 'Tap "Start a Walk" to begin';
  String get distanceLabel => isChinese ? '距离' : 'Distance';
  String get activeLabel => isChinese ? '活跃' : 'Active';
  String get walksLabel => isChinese ? '步行' : 'Walks';
  String get kcalLabel => isChinese ? '千卡' : 'kcal';

  // ─── Walk hardcoded strings ────────────────────────────────────────────────
  String get readyToWalkTitle => isChinese ? '准备好步行了吗？' : 'Ready to Walk?';
  String get trackStepsSubtitle => isChinese ? '追踪您的步数、距离和配速' : 'Track your steps, distance, and pace';
  String get startWalkButton => isChinese ? '开始步行' : 'START WALK';
  String get todayWalksSection => isChinese ? '今日步行记录' : "Today's Walks";
  String get noWalksYetWalk => isChinese ? '今天还没有步行记录\n点击上方开始步行！🌟' : 'No walks yet today\nHit START WALK above! 🌟';
  String get walksToday2 => isChinese ? '今日步行次数' : 'Walks Today';
  String get totalDist2 => isChinese ? '总距离' : 'Total Dist.';
  String get stepsCount => isChinese ? '步数' : 'Steps';
  String get walkNumber => isChinese ? '步行' : 'Walk';
  String get walkSessionTitle => isChinese ? '步行中...' : 'Walking...';
  String get walkPausedTitle => isChinese ? '已暂停' : 'Walk Paused';
  String get stopWalkQuestion => isChinese ? '停止步行？' : 'Stop Walk?';
  String get walkProgressLost => isChinese ? '当前步行进度将丢失。' : 'Your current walk progress will be lost.';
  String get keepWalkingBtn => isChinese ? '继续步行' : 'Keep Walking';
  String get discardBtn => isChinese ? '放弃' : 'Discard';
  String get durationLabel => isChinese ? '时长' : 'Duration';
  String get paceLabel => isChinese ? '配速' : 'Pace';
  String get safetyNoteWalk => isChinese ? '⚠️ 如感到疼痛或头晕，请立即停止。' : '⚠️ Stop if you feel pain, dizziness, or unusual symptoms.';
  String get walkCompleteTitle => isChinese ? '步行完成！🖤' : 'Walk Complete! 🖤';
  String get saveWalkBtn => isChinese ? '保存步行 🖤' : 'Save Walk 🖤';
  String get discardWalkBtn => isChinese ? '放弃' : 'Discard';
  String get everyStepCountsMsg => isChinese ? '每一步都算数！' : 'Every step counts!';
  String get method => isChinese ? '方式' : 'Method';
  String get noWalksInPeriod2 => isChinese ? '此时段没有步行记录' : 'No walks in this period';
  String get walkHistoryTitle => isChinese ? '步行历史 🗂' : 'Walk History 🗂';

  // ─── Exercise hardcoded strings ───────────────────────────────────────────
  String get exerciseTitle => isChinese ? '运动 💪' : 'Exercise 💪';
  String get todayWorkoutTitle2 => isChinese ? '今日训练' : "Today's Workout";
  String get workoutCompletedTitle => isChinese ? '训练完成！🎉' : 'Workout Complete! 🎉';
  String get exercisesCount => isChinese ? '项运动' : 'exercises';
  String get warmupLabel => isChinese ? '🤸 热身' : '🤸 Warm-up';
  String get mainLabel => isChinese ? '🏋️ 主要' : '🏋️ Main';
  String get cooldownLabel => isChinese ? '😌 放松' : '😌 Cool-down';
  String get startWorkoutBtn => isChinese ? '开始训练' : 'START WORKOUT';
  String get doItAgainBtn => isChinese ? '再来一次' : 'Do It Again';
  String get exerciseCategoriesTitle => isChinese ? '运动分类 🏋️' : 'Exercise Categories 🏋️';
  String get browseAllBtn => isChinese ? '浏览全部' : 'Browse All';
  String get fullBodyCat => isChinese ? '全身' : 'Full Body';
  String get coreCat => isChinese ? '核心' : 'Core';
  String get legsCat => isChinese ? '腿部' : 'Legs';
  String get chestCat => isChinese ? '胸部' : 'Chest';
  String get backCat => isChinese ? '背部' : 'Back';
  String get cardioCat => isChinese ? '有氧' : 'Cardio';
  String get stretchingCat => isChinese ? '拉伸' : 'Stretching';
  String get recoveryCat => isChinese ? '恢复' : 'Recovery';
  String get shouldersCat => isChinese ? '肩部' : 'Shoulders';
  String get armsCat => isChinese ? '手臂' : 'Arms';
  String get backToExerciseBtn => isChinese ? '返回运动' : 'Back to Exercise';
  String get viewHistoryBtn => isChinese ? '查看历史' : 'View History';
  String get restRecoverMsg => isChinese ? '休息，恢复，重复 🖤' : 'Rest, recover, repeat 🖤';
  String get restingLabel => isChinese ? '休息中...' : 'Resting...';
  String get timerRunningLabel => isChinese ? '计时中...' : 'Timer Running...';
  String get doneBtn => isChinese ? '完成' : 'DONE';
  String get noWorkoutsMsg => isChinese ? '本月暂无训练记录' : 'No workouts this month';
  String get workoutHistoryTitle => isChinese ? '训练历史' : 'Workout History';
  String get setLabel => isChinese ? '组' : 'Set';
  String get repsLabel => isChinese ? '次' : 'Reps';
  String get restLabel => isChinese ? '休息' : 'Rest';
  String get howToLabel => isChinese ? '如何做：' : 'How to do it:';
  String get targetMusclesLabel => isChinese ? '目标肌群' : 'Target Muscles';
  String get workoutDetailsLabel => isChinese ? '训练详情' : 'Workout Details';
  String get safetyWorkoutMsg => isChinese ? '如感到疼痛请立即停止。' : 'Stop immediately if you feel pain.';
  String get searchExercisesHint => isChinese ? '搜索运动...' : 'Search exercises...';
  String get allFilter => isChinese ? '全部' : 'All';
  String get noExercisesFound => isChinese ? '未找到运动' : 'No exercises found';

  // ─── Progress hardcoded strings ───────────────────────────────────────────
  String get progressTitle => isChinese ? '进度 📊' : 'Progress 📊';
  String get todayTab => isChinese ? '今天' : 'Today';
  String get weekTab => isChinese ? '本周' : 'Week';
  String get monthTab => isChinese ? '本月' : 'Month';
  String get stepsStatLabel => isChinese ? '步数' : 'Steps';
  String get distanceStatLabel => isChinese ? '距离' : 'Distance';
  String get activeMinLabel => isChinese ? '活跃分钟' : 'Active Min';
  String get caloriesLabel => isChinese ? '卡路里' : 'Calories';
  String get walksStatLabel => isChinese ? '步行次数' : 'Walks';
  String get workoutStatLabel => isChinese ? '训练' : 'Workout';
  String get pendingLabel => isChinese ? '待完成' : 'Pending';
  String get doneLabel => isChinese ? '已完成 ✓' : 'Done ✓';
  String get todayDateLabel => isChinese ? '今天' : 'Today';
  String get stepsThisWeekLabel => isChinese ? '本周步数' : 'Steps This Week';
  String get thisMonthLabel => isChinese ? '本月' : 'This Month';
  String get totalStepsLabel => isChinese ? '总步数' : 'Total Steps';
  String get totalWalksLabel => isChinese ? '总步行次数' : 'Total Walks';
  String get workoutsLabel => isChinese ? '训练次数' : 'Workouts';
  String get avgPerDayLabel => isChinese ? '日均步数' : 'Avg/Day';
  String get activeMinStatLabel => isChinese ? '活跃分钟' : 'Active Min';
  String get goalDaysLabel => isChinese ? '达标天数' : 'Goal Days';
  String get activeDaysLabel => isChinese ? '活跃天数' : 'Active Days';
  String get noDataLabel => isChinese ? '暂无数据' : 'No data yet';
  String get couldNotLoadLabel => isChinese ? '无法加载' : 'Could not load';
  String get keepFireBurning => isChinese ? '继续加油！🖤' : "Keep the fire burning! 🖤";
  String get bestLabel => isChinese ? '最佳' : 'best';
  String get totalLabel => isChinese ? '总计' : 'total';
  String get activityCalendarTitle => isChinese ? '活动日历' : 'Activity Calendar';
  String get achievementsTitle => isChinese ? '成就' : 'Achievements';

  // ─── Profile hardcoded strings ────────────────────────────────────────────
  String get profileTitle => isChinese ? '个人资料 🖤' : 'Profile 🖤';
  String get setUpProfileBtn => isChinese ? '设置个人资料' : 'Set Up Profile';
  String get stepsTodayLabel => isChinese ? '今日步数' : 'Steps Today';
  String get personalInfoTitle => isChinese ? '个人信息 🌸' : 'Personal Info 🌸';
  String get dailyGoalsCardTitle => isChinese ? '每日目标 🎯' : 'Daily Goals 🎯';
  String get moreTitle => isChinese ? '更多 ✨' : 'More ✨';
  String get ageLabel => isChinese ? '年龄' : 'Age';
  String get heightLabel => isChinese ? '身高' : 'Height';
  String get weightLabel => isChinese ? '体重' : 'Weight';
  String get bmiLabel => isChinese ? 'BMI' : 'BMI';
  String get genderLabel => isChinese ? '性别' : 'Gender';
  String get stepsGoalLabel => isChinese ? '步数目标' : 'Steps Goal';
  String get distanceGoalLabel => isChinese ? '距离目标' : 'Distance';
  String get activeMinGoalLabel => isChinese ? '活跃分钟目标' : 'Active Minutes';
  String get walksGoalLabel => isChinese ? '步行次数' : 'Walks';
  String get aiAssistantLabel => isChinese ? 'AI助手' : 'AI Assistant';
  String get signOutLabel => isChinese ? '退出登录' : 'Sign Out';
  String get signOutQuestion => isChinese ? '退出登录？' : 'Sign Out?';
  String get signOutMessage => isChinese ? '您需要重新登录。' : "You'll need to sign in again.";
  String get cancelBtn => isChinese ? '取消' : 'Cancel';
  String get editProfileBtn => isChinese ? '编辑资料' : 'Edit Profile';

  // ─── Profile Setup hardcoded strings ─────────────────────────────────────
  String get setUpYourProfile => isChinese ? '设置您的资料' : 'Set Up Your Profile';
  String get tellUsAboutYou => isChinese ? '告诉我们关于您的信息' : 'Tell us about yourself';
  String get helpPersonalize => isChinese ? '这有助于我们个性化您的体验，随时可更改。' : 'This helps us personalize your experience. You can update this anytime.';
  String get yourNameHint => isChinese ? '您的姓名' : 'Your Name';
  String get ageHint => isChinese ? '年龄' : 'Age';
  String get heightHint => isChinese ? '身高（厘米）' : 'Height (cm)';
  String get weightHint => isChinese ? '体重（千克）' : 'Weight (kg)';
  String get fitnessLevelTitle => isChinese ? '健身水平' : 'Fitness Level';
  String get beginnerLabel => isChinese ? '🌱 初学者' : '🌱 Beginner';
  String get beginnerSub => isChinese ? '刚刚开始' : 'Just starting out';
  String get intermediateLabel => isChinese ? '🏃 中级' : '🏃 Intermediate';
  String get intermediateSub => isChinese ? '每周活动几次' : 'Active a few times a week';
  String get advancedLabel => isChinese ? '🏆 高级' : '🏆 Advanced';
  String get advancedSub => isChinese ? '非常活跃，高强度' : 'Very active, high intensity';
  String get myPrimaryGoal => isChinese ? '我的主要目标' : 'My Primary Goal';
  String get stayActiveGoal => isChinese ? '保持活跃' : 'Stay Active';
  String get loseWeightGoal => isChinese ? '减轻体重' : 'Lose Weight';
  String get buildEnduranceGoal => isChinese ? '增强耐力' : 'Build Endurance';
  String get buildStrengthGoal => isChinese ? '增强力量' : 'Build Strength';
  String get improveHealthGoal => isChinese ? '改善健康' : 'Improve Health';
  String get runFasterGoal => isChinese ? '跑得更快' : 'Run Faster';
  String get nextSetGoals => isChinese ? '下一步：设置目标' : 'Next: Set Goals';
  String get genderHint => isChinese ? '性别' : 'Gender';
  String get maleLabel => isChinese ? '男' : 'Male';
  String get femaleLabel => isChinese ? '女' : 'Female';
  String get nonBinaryLabel => isChinese ? '非二元' : 'Non-binary';
  String get preferNotToSayLabel => isChinese ? '不愿透露' : 'Prefer not to say';

  // ─── Goals Setup hardcoded strings ────────────────────────────────────────
  String get setDailyGoalsTitle => isChinese ? '设置每日目标' : 'Set Your Daily Goals';
  String get goalsAdjustable => isChinese ? '您可以随时在个人资料设置中调整。' : 'These can be adjusted anytime in your profile settings.';
  String get dailyStepsGoal => isChinese ? '每日步数' : 'Daily Steps';
  String get walkingDistanceGoal => isChinese ? '步行距离' : 'Walking Distance';
  String get numberOfWalksGoal => isChinese ? '步行次数' : 'Number of Walks';
  String get nextPermissions => isChinese ? '下一步：权限' : 'Next: Permissions';
  String get stepsUnit => isChinese ? '步' : 'steps';
  String get walksUnit => isChinese ? '次' : 'walks';

  // ─── Settings hardcoded strings ───────────────────────────────────────────
  String get settingsTitle => isChinese ? '设置' : 'Settings';
  String get accountSection => isChinese ? '账户' : 'Account';
  String get appSection => isChinese ? '应用' : 'App';
  String get languageLabel2 => isChinese ? '语言' : 'Language';
  String get notificationsLabel => isChinese ? '通知' : 'Notifications';
  String get healthPermLabel => isChinese ? '健康权限' : 'Health Permissions';
  String get locationLabel => isChinese ? '位置权限' : 'Location';
  String get dataPrivacySection => isChinese ? '数据与隐私' : 'Data & Privacy';
  String get syncDataLabel => isChinese ? '同步数据' : 'Sync Data';
  String get privacyPolicyLabel => isChinese ? '隐私政策' : 'Privacy Policy';
  String get accountActionsSection => isChinese ? '账户操作' : 'Account Actions';
  String get deleteAccountLabel => isChinese ? '删除账户' : 'Delete Account';
  String get manageNotifSub => isChinese ? '管理提醒设置' : 'Manage reminder settings';
  String get manageHealthSub => isChinese ? '管理健康与活动权限' : 'Manage health & activity access';
  String get locationSub2 => isChinese ? '仅用于GPS步行追踪' : 'Used only for GPS walk tracking';
  String get syncSub2 => isChinese ? '手动同步活动到云端' : 'Manually sync activity to cloud';

  // ─── Streak / achievements hardcoded ─────────────────────────────────────
  String get currentStreakLabel => isChinese ? '天连续记录！🖤' : ' Day Streak! 🖤';
  String get keepGoingMsg => isChinese ? '继续加油！' : "Keep going — you're on fire!";
  String get unlockedCount => isChinese ? '已解锁' : 'Unlocked';
  String get keepGoingUnlock => isChinese ? '继续解锁更多！' : 'Keep going to unlock more!';

  // ─── AI assistant hardcoded ───────────────────────────────────────────────
  String get aiTitle2 => isChinese ? 'AI助手' : 'AI Assistant';
  String get aiCoachLabel => isChinese ? '梦行健身教练' : 'MengXing Fitness Coach';
  String get aiDisclaimerMsg => isChinese ? '非医疗建议。如有不适请停止运动。' : 'Not medical advice. Stop if you feel pain.';
  String get aiInputHint => isChinese ? '询问健身、训练或目标相关问题...' : 'Ask about fitness, workouts, or goals...';
  String get clearChatLabel => isChinese ? '清除聊天' : 'Clear chat';
  String get motivateMeBtn => isChinese ? '激励我！' : 'Motivate me!';
  String get workoutTipsBtn => isChinese ? '训练技巧' : 'Workout tips';
  String get walkingGoalsBtn => isChinese ? '步行目标' : 'Walking goals';
  String get restDayBtn => isChinese ? '需要休息？' : 'Rest day?';

  // ─── Onboarding hardcoded ─────────────────────────────────────────────────
  String get skipBtn => isChinese ? '跳过' : 'Skip';
  String get nextBtn => isChinese ? '下一步 →' : 'Next →';
  String get getStartedBtn => isChinese ? '开始使用 ✨' : 'Get Started ✨';
  String get permissionsTitle => isChinese ? '应用权限' : 'App Permissions';
  String get permissionsSubtitle => isChinese ? '梦行需要一些权限才能正常工作。所有权限都是可选的。' : 'MengXing needs a few permissions to work best. All are optional.';
  String get grantPermissionsBtn => isChinese ? '授予权限' : 'Grant Permissions';
  String get continueWithoutBtn => isChinese ? '不授权继续' : 'Continue Without Permissions';
}
