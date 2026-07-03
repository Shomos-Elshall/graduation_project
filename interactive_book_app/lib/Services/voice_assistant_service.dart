import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:html/parser.dart';

class VoiceAssistantService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  bool _isListening = false;
  bool get isListening => _isListening;

  Future<bool> initAssistant() async {
    bool available = await _speech.initialize(
      onError: (val) => print('STT Error: $val'),
      onStatus: (val) => print('STT Status: $val'),
    );

    // إجبار أندرويد على استخدام محرك جوجل الصوتي لتجنب مشكلة الصمت
    try {
      await _tts.setEngine('com.google.android.tts');
    } catch (e) {
      print("TTS Engine setting error: $e");
    }

    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    return available;
  }

  Future<void> listenAndProcess({
    required Function(String command) onCommandRecognized,
    required String languageCode,
  }) async {
    if (!_isListening) {
      _isListening = true;
      await _speech.listen(
        localeId: languageCode == 'ar' ? 'ar_EG' : 'en_US',
        onResult: (val) {
          if (val.finalResult) {
            _isListening = false;
            onCommandRecognized(val.recognizedWords.toLowerCase());
          }
        },
      );
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      await _speech.stop();
      _isListening = false;
    }
  }

  Future<void> speak(String text, String languageCode) async {
    await _tts.stop();
    // تنظيف النص من وسوم الـ HTML لو النص جاي من الكتاب مباشرة
    String cleanText = parse(text).body?.text ?? text;

    await _tts.setLanguage(languageCode == 'ar' ? 'ar' : 'en');
    await _tts.speak(cleanText);
  }

  Future<void> stopSpeaking() async {
    await _tts.stop();
  }
}