import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/book_model.dart';
import '../models/content_model.dart';
import '../models/toc_model.dart';
import '../models/voice_command_result.dart';
import '../services/voice_assistant_service.dart';
import '../services/voice_command_processor.dart';
import 'book_content_page.dart';

class ReadingScreen extends StatefulWidget {
  final BookModel book;
  final List<ContentModel> sections;
  final int initialIndex;
  final bool isArabic;

  const ReadingScreen({
    super.key,
    required this.book,
    required this.sections,
    required this.isArabic,
    this.initialIndex = 0,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  late PageController _pageController;
  late int currentIndex;

  final VoiceAssistantService _voiceService = VoiceAssistantService();
  final stt.SpeechToText _speechPlugin = stt.SpeechToText();

  bool _isAssistantReady = false;
  bool _isListeningLocal = false;
  bool _isAiProcessing = false;
  bool _showMicButton = true;
  String _lastWords = '';

  Timer? _silenceTimer;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
    _initVoiceAssistant();
  }

  Future<void> _initVoiceAssistant() async {
    bool ready = await _speechPlugin.initialize(
      onError: (val) {
        print('STT Error Local: ${val.errorMsg}');
        setState(() { _isListeningLocal = false; });
      },
      onStatus: (val) {
        if (val == 'notListening' || val == 'done') {
          setState(() { _isListeningLocal = false; });
        }
      },
    );
    await _voiceService.initAssistant();
    setState(() { _isAssistantReady = ready; });
  }

  Future<void> _startListening() async {
    await _voiceService.stopSpeaking();
    _lastWords = '';
    _silenceTimer?.cancel();
    setState(() { _isListeningLocal = true; });

    await _speechPlugin.listen(
      localeId: widget.isArabic ? 'ar_EG' : 'en_US',
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 4),  // الإغلاق بعد 4 ثواني تلقائياً لو لم يبدأ التحدث
      onResult: (val) {
        setState(() { _lastWords = val.recognizedWords; });

        if (_lastWords.trim().isNotEmpty) {
          _silenceTimer?.cancel();
          // الإغلاق الفوري بعد ثانية واحدة (1) من انتهاء جملة المستخدم وبدء المعالجة
          _silenceTimer = Timer(const Duration(seconds: 1), () async {
            if (_isListeningLocal) {
              await _stopListening();
              _showFeedbackSnackbar('تم التقاط الأمر، جاري التنفيذ...', Colors.black87);
              _handleVoiceInput(_lastWords);
            }
          });
        }
      },
    );
  }

  Future<void> _stopListening() async {
    _silenceTimer?.cancel();
    await _speechPlugin.stop();
    setState(() { _isListeningLocal = false; });
  }

  /// إرسال المدخلات لمعالج الأوامر المنفصل وتشغيل النتيجة
  Future<void> _handleVoiceInput(String spokenText) async {
    final cleanText = spokenText.toLowerCase().trim();

    // الاستجابة الفورية لكلمة وقف / اسكت محلياً
    if (cleanText.contains('وقف') || cleanText.contains('stop') || cleanText.contains('اسكت') || cleanText.contains('اصمت')) {
      await _voiceService.stopSpeaking();
      _showFeedbackSnackbar('تم إيقاف القراءة فوراً', Colors.blueGrey);
      return;
    }

    setState(() { _isAiProcessing = true; });

    List<String> chapterNames = widget.sections.map((s) => s.name).toList();
    String fullBookContext = widget.sections.map((s) => s.textAr ?? s.textEn ?? '').join('\n');

    // استدعاء ملف الـ Processor المنفصل ونقل ثقل الذكاء الاصطناعي إليه
    VoiceCommandResult result = await VoiceCommandProcessor.process(
      spokenText: spokenText,
      chapterNames: chapterNames,
      fullBookContext: fullBookContext,
    );

    setState(() { _isAiProcessing = false; });
    _executeAction(result);
  }

  /// دالة الاستجابة لنتائج الأوامر المفسرة
  void _executeAction(VoiceCommandResult result) {
    final currentLang = widget.isArabic ? 'ar' : 'en';

    switch (result.action) {
      case VoiceAction.read:
        _readCurrentPage(
          forceArabic: result.answer == 'ar',
          forceEnglish: result.answer == 'en',
        );
        break;

      case VoiceAction.next:
        if (currentIndex < widget.sections.length - 1) {
          _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          _showFeedbackSnackbar('الشابتر التالي', Colors.blue);
        }
        break;

      case VoiceAction.previous:
        if (currentIndex > 0) {
          _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          _showFeedbackSnackbar('تم الرجوع للشابتر السابق', Colors.blue);
        }
        break;

      case VoiceAction.navigate:
        if (result.target != null) {
          int targetIndex = widget.sections.indexWhere((s) => s.name.toLowerCase() == result.target!.toLowerCase());
          if (targetIndex != -1) {
            setState(() { currentIndex = targetIndex; });
            _pageController.jumpToPage(targetIndex);

            if (result.readAfterNavigate) {
              _showFeedbackSnackbar('تم الانتقال، جاري بدء القراءة التلقائية...', Colors.purple);
              Future.delayed(const Duration(milliseconds: 500), () => _readCurrentPage());
            } else {
              _voiceService.speak(widget.isArabic ? 'انتقلت إلى ${result.target}' : 'Moved to ${result.target}', currentLang);
            }
          }
        }
        break;

      case VoiceAction.chat:
        if (result.answer != null) {
          bool isAnswerArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(result.answer!);
          _voiceService.speak(result.answer!, isAnswerArabic ? 'ar' : 'en');
          _showFeedbackSnackbar(result.answer!, Colors.deepPurple);
        }
        break;

      default:
        _showFeedbackSnackbar('لم أفهم الأمر الصوتي، حاول مجدداً', Colors.red);
    }
  }

  void _readCurrentPage({bool forceArabic = false, bool forceEnglish = false}) {
    final currentSection = widget.sections[currentIndex];
    String? textToRead;
    String finalLangCode = 'en';

    if (forceArabic) {
      textToRead = currentSection.textAr ?? currentSection.textEn;
      finalLangCode = 'ar';
    } else if (forceEnglish) {
      textToRead = currentSection.textEn ?? currentSection.textAr;
      finalLangCode = 'en';
    } else {
      textToRead = widget.isArabic ? (currentSection.textAr ?? currentSection.textEn) : (currentSection.textEn ?? currentSection.textAr);
      bool isTextArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(textToRead ?? '');
      finalLangCode = isTextArabic ? 'ar' : 'en';
    }

    if (textToRead != null && textToRead.isNotEmpty) {
      _voiceService.speak(textToRead, finalLangCode);
      _showFeedbackSnackbar(finalLangCode == 'ar' ? 'جاري القراءة بالعربية...' : 'Reading in English...', Colors.green);
    }
  }

  _showFeedbackSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _silenceTimer?.cancel();
    _voiceService.stopSpeaking();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.sections.length,
            onPageChanged: (index) {
              setState(() { currentIndex = index; });
              _voiceService.stopSpeaking();
            },
            itemBuilder: (context, index) {
              final tempChapter = TocModel(id: widget.sections[index].id, name: widget.sections[index].name, depth: 0, children: []);
              return BookContentPage(book: widget.book, currentChapter: tempChapter);
            },
          ),

          if (_isAssistantReady && _showMicButton)
            Positioned(
              bottom: 110,
              right: 16,
              child: AvatarGlowWrapper(
                isListening: _isListeningLocal,
                child: FloatingActionButton(
                  heroTag: 'voice_mic_fab',
                  backgroundColor: _isListeningLocal ? Colors.red : const Color(0xFF1A0054),
                  onPressed: () async {
                    if (_isListeningLocal) { await _stopListening(); } else { await _startListening(); }
                  },
                  child: Icon(_isListeningLocal ? Icons.mic : Icons.mic_none, color: Colors.white, size: 30),
                ),
              ),
            ),

          if (_isAiProcessing)
            const Positioned(
              top: 100, left: 0, right: 0,
              child: Center(
                child: Card(
                  color: Colors.black87,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(width: 16),
                        Text('جاري معالجة الأمر ذكياً...', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0, top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A0054)),
                  onPressed: currentIndex > 0 ? () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut) : null,
                ),
                const SizedBox(width: 12),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text('${currentIndex + 1} / ${widget.sections.length}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A0054), fontSize: 18)),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF1A0054)),
                  onPressed: currentIndex < widget.sections.length - 1 ? () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut) : null,
                ),
              ],
            ),
          ),

          IconButton(
            icon: Icon(
              _showMicButton ? Icons.record_voice_over : Icons.voice_over_off,
              color: _showMicButton ? const Color(0xFF1A0054) : Colors.grey,
              size: 26,
            ),
            onPressed: () => setState(() { _showMicButton = !_showMicButton; }),
          ),
        ],
      ),
    );
  }
}

class AvatarGlowWrapper extends StatelessWidget {
  final Widget child;
  final bool isListening;
  const AvatarGlowWrapper({super.key, required this.child, required this.isListening});

  @override
  Widget build(BuildContext context) {
    if (!isListening) return child;
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.withOpacity(0.2)),
      padding: const EdgeInsets.all(8),
      child: child,
    );
  }
}