/*import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interactive_book_app/constants.dart';
import 'package:interactive_book_app/modules/video/videosurvices/videoprovider.dart';
import 'package:interactive_book_app/screens/book_select_page.dart';
import 'package:interactive_book_app/Services/book_service.dart';
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
  await dotenv.load(fileName: ".env");

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
  // حمل كل الكتب إلى Hive قبل تشغيل الواجهة حتى تظهر جميعها فور الفتح
  await BookService.loadAllBooks();

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

  @override
  Widget build(BuildContext context) {


    return ScreenUtilInit(
      designSize: Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,

      builder:
          (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            home:
       const Selectedbook(),
          ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'; // 1. ضفنا الـ Import ده هنا
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interactive_book_app/constants.dart';
import 'package:interactive_book_app/modules/video/videosurvices/videoprovider.dart';
import 'package:interactive_book_app/screens/book_select_page.dart';
import 'package:interactive_book_app/Services/book_service.dart';
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
  // 2. تعديل السطر ده عشان نربطه بالـ Native Splash ونثبت الشاشة لحد ما كل حاجة تحت تلوّد
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Hive.initFlutter();
  await dotenv.load(fileName: ".env");

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
  await Future.wait([
    Hive.openBox<BookModel>(bookBox),
    Hive.openBox<TocModel>('bookmarks_box'),
    Hive.openBox('highlights'),
    Hive.openBox('notes_box'),
  ]); //note box

  // (ملاحظة: شيلنا السطر المتكرر اللي كان هنا بتاع WidgetsFlutterBinding)
  MediaKit.ensureInitialized(); //create

  // حمل كل الكتب إلى Hive قبل تشغيل الواجهة حتى تظهر جميعها فور الفتح
  await BookService.loadAllBooks();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        // باقي الـ providers
      ],
      child: const InteractiveBookApp(),
    ),
  );
}

class InteractiveBookApp extends StatelessWidget {
  const InteractiveBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. هنا بمجرد ما أول فريم فلوتر يترسم والكتب تكون جاهزة، بنأمر الـ Splash تختفي بسلاسة
    FlutterNativeSplash.remove();

    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, child) => const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Selectedbook(),
          ),
    );
  }
}
