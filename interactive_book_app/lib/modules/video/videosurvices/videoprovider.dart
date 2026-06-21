import 'package:flutter/material.dart';
import 'package:interactive_book_app/core/resources/ap_constants.dart';
import 'package:interactive_book_app/models/module_video_ref.dart';
import 'package:interactive_book_app/modules/video/models/Data.dart';
import 'package:interactive_book_app/modules/video/videoviewmodel.dart';


import '../models/AudioList.dart';
import '../models/AvailableLanguages.dart';
import '../models/Videoresponse.dart';
import '../models/VttList.dart';

class VideoProvider extends ChangeNotifier {
  List<String>? keywords = [];
  List<AudioList>? audioList = [];
  List<VttList>? vttList = [];
  String? url;

  List<AvailableLanguages>? availableLanguages = [];
  // List<Data>? data;
  List<String> languageCodes = [];
  // AvailableLanguages languages=AvailableLanguages();
  List<String>? subtitlelangcode = [];
  bool isLoading = false;
  String? selectedvalue;
  Data? selecteddata;
  String? subtitleurl;
  String? selectedLanguage = AppConstants.defult_language;
  List<String> audiolanguageCodes = [];
  String? selectedTitle;

  void setSelectedTitle(String title) {
    selectedTitle = title;
    notifyListeners();
  }

  void changeLanguage(String value) {
    selectedLanguage = value;

    for (int i = 0; i < availableLanguages!.length; i++) {
      if (value == availableLanguages![i].languageCode) {
        selectedata(i);
        break;
      }
    }

    notifyListeners();
  }

  String? defultseletedvalue() {
    String? defultseletedvalue;
    for (int i = 0; i < availableLanguages!.length; i++) {
      if (AppConstants.defult_language == availableLanguages![i].languageCode) {
        defultseletedvalue = availableLanguages?[i].data?.transcript;
        break;
      }
    }
    return defultseletedvalue;
  }

  Data? selectedata(int index) {
    selecteddata = availableLanguages![index].data;
    notifyListeners();
    return selecteddata;
  }

  void selected(String value) {
    if (value == "summary25") {
      selectedvalue = selecteddata!.summary25!;
      notifyListeners();
    } else if (value == "summary50") {
      selectedvalue = selecteddata!.summary50!;
      notifyListeners();
    } else if (value == "transcript") {
      selectedvalue = selecteddata!.transcript!;
    }
  }

  String? defultelanguage() {
    String defultlanguage = AppConstants.defult_language;
    notifyListeners();
    return defultlanguage;
  }

  Future<void> fetchvideodata() async {
    isLoading = true;
    notifyListeners();
    Videoresponse videoresponse = await videoviewModel.loadvediodetails(
      selectedTitle!,
    );
    _applyResponse(videoresponse);
  }

  Future<void> fetchFromRef(ModuleVideoRef ref) async {
    isLoading = true;
    notifyListeners();
    Videoresponse videoresponse = await videoviewModel.loadFromRef(ref);
    _applyResponse(videoresponse);
  }

  void _applyResponse(Videoresponse videoresponse) {
    isLoading = false;
    notifyListeners();
    url =
        videoresponse.url ??
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
    notifyListeners();
    keywords = videoresponse.keywords ?? [];
    audioList = videoresponse.audioList ?? [];
    vttList = videoresponse.vttList ?? [];
    availableLanguages = videoresponse.availableLanguages ?? [];
    notifyListeners();
    languageCodes =
        availableLanguages?.map((e) => e.languageCode.toString()).toList() ??
        [];
    subtitlelangcode =
        vttList?.map((e) => e.langCode.toString()).toList() ?? [];
    notifyListeners();
    audiolanguageCodes =
        audioList?.map((e) => e.langCode.toString()).toList() ?? [];
    notifyListeners();
  }
}
