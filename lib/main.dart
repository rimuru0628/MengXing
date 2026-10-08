import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'core/router/app_router.dart';
import 'core/theme/kuromi_material_theme.dart';
import 'core/l10n/locale_provider.dart';
import 'shared/providers/services_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait on mobile only
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Container for DI
  final container = ProviderContainer();

  // Init local storage
  await container.read(localStorageProvider).init();

  // Init notifications
  await container.read(notificationServiceProvider).init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MengXingApp(),
    ),
  );
}

class MengXingApp extends ConsumerWidget {
  const MengXingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'MengXing 梦行',
      debugShowCheckedModeBanner: false,

      // Always Kuromi dark
      theme: KuroMaterialTheme.theme(),
      darkTheme: KuroMaterialTheme.theme(),
      themeMode: ThemeMode.dark,

      // Localization
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('zh'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      routerConfig: router,
      builder: (context, child) {
        final scale = MediaQuery.of(context).textScaler;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler:
                scale.clamp(minScaleFactor: 0.85, maxScaleFactor: 1.25),
          ),
          child: child!,
        );
      },
    );
  }
}
