import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/constants.dart';
import 'features/notes/data/models/note_model.dart';
import 'features/notes/presentation/pages/home_page.dart';
import 'features/notes/presentation/providers/notes_provider.dart';
import 'features/notes/presentation/providers/theme_provider.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();
  Hive.registerAdapter(NoteModelAdapter());
  await Hive.openBox<NoteModel>(AppConstants.hiveBoxName);

  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<NotesProvider>(
          create: (_) => AppDependencies.buildNotesProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, themeProvider, __) {
          return MaterialApp(
            title:                     'Notes',
            debugShowCheckedModeBanner: false,
            theme:                     AppTheme.light(),
            darkTheme:                 AppTheme.dark(),
            themeMode:                 themeProvider.themeMode,
            home:                      const HomePage(),
            builder: (context, child) {
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  statusBarColor:          Colors.transparent,
                  statusBarIconBrightness: themeProvider.isDark
                      ? Brightness.light
                      : Brightness.dark,
                  statusBarBrightness: themeProvider.isDark
                      ? Brightness.dark
                      : Brightness.light,
                ),
              );
              return child!;
            },
          );
        },
      ),
    );
  }
}
