import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interactive_book_app/constants.dart';
import 'package:interactive_book_app/modules/cotent/titlepage.dart';
import 'package:interactive_book_app/modules/video/videosurvices/videoprovider.dart';
import 'package:interactive_book_app/screens/book_select_page.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'models/book_model.dart';
import 'models/book_objects_model.dart';
import 'models/content_model.dart';
import 'models/glossary_model.dart';
import 'models/keyword_model.dart';
import 'models/module_video_ref.dart';
import 'models/text_content.dart';
import 'models/toc_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // register adapters
  Hive.registerAdapter(BookModelAdapter());
  Hive.registerAdapter(TocModelAdapter());
  Hive.registerAdapter(ContentModelAdapter());
  Hive.registerAdapter(GlossaryModelAdapter());
  Hive.registerAdapter(BookObjectsAdapter());
  Hive.registerAdapter(KeywordModelAdapter());
  Hive.registerAdapter(TextContentAdapter());
  Hive.registerAdapter(ModuleVideoRefAdapter());

  // open boxes
  await Hive.openBox<BookModel>(bookBox);

  // bookMark box
  await Hive.openBox<TocModel>('bookmarks_box');

  //highlight box
  await Hive.openBox('highlights');

  //note box
  await Hive.openBox('notes_box');

  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized(); //create

  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => VideoProvider()),

      // باقي الـ providers
    ],
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoProvider()),

        // باقي الـ providers
      ],
      child: InteractiveBookApp(),
    ),
  );
}

class InteractiveBookApp extends StatelessWidget {
  const InteractiveBookApp({super.key});

  Future<String> loadJsonData() async {
    return await rootBundle.loadString('assets/data/data.json');
  }

  Future<void> loadDataIntoHive() async {
    final String jsonData = await loadJsonData();
    var data = jsonDecode(jsonData);
    BookModel book = BookModel.fromJson(data);

    // storing data in hive — clear first so the new schema (ModuleVideoRef)
    // replaces any cached copy from an older build.
    final box = Hive.box<BookModel>(bookBox);
    await box.clear();
    await box.put('book2', book);
  }

  @override
  Widget build(BuildContext context) {
    loadDataIntoHive();

    return ScreenUtilInit(
      designSize: Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,

      builder:
          (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            home:
            // TitlePage(),


            const Selectedbook(),
          ),
    );
  }
}
