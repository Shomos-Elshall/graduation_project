import 'AudioList.dart';
import 'AvailableLanguages.dart';
import 'VttList.dart';

class Videoresponse {
  Videoresponse({
      this.keywords, 
      this.input, 
      this.status, 
      this.type, 
      this.speakerGender, 
      this.id, 
      this.audioList, 
      this.vttList, 
      this.availableLanguages, 
      this.tenantId, 
      this.ownershipId, 
      this.title, 
      this.language, 
      this.url, 
      this.domainId, 
      this.contentType, 
      this.narration, 
      this.owner, 
      this.domainName, 
      this.subDomainId, 
      this.subDomainName,});

  Videoresponse.fromJson(dynamic json) {
    keywords = json['keywords'] != null ? json['keywords'].cast<String>() : [];
    input = json['input'];
    status = json['status'];
    type = json['type'];
    speakerGender = json['speakerGender'];
    id = json['_id'];
    if (json['audioList'] != null) {
      audioList = [];
      json['audioList'].forEach((v) {
        audioList?.add(AudioList.fromJson(v));
      });
    }
    if (json['vttList'] != null) {
      vttList = [];
      json['vttList'].forEach((v) {
        vttList?.add(VttList.fromJson(v));
      });
    }
    if (json['availableLanguages'] != null) {
      availableLanguages = [];
      json['availableLanguages'].forEach((v) {
        availableLanguages?.add(AvailableLanguages.fromJson(v));
      });
    }
    tenantId = json['tenantId'];
    ownershipId = json['ownershipId'];
    title = json['title'];
    language = json['language'];
    url = json['url'];
    domainId = json['domainId'];
    contentType = json['contentType'];
    if (json['narration'] != null) {
      narration = [];
      json['narration'].forEach((v) {
        narration?.add(Videoresponse.fromJson(v));
      });
    }
    owner = json['owner'];
    domainName = json['domainName'];
    subDomainId = json['subDomainId'];
    subDomainName = json['subDomainName'];
  }
  List<String>? keywords;
  String? input;
  String? status;
  String? type;
  String? speakerGender;
  String? id;
  List<AudioList>? audioList;
  List<VttList>? vttList;
  List<AvailableLanguages>? availableLanguages;
  String? tenantId;
  String? ownershipId;
  String? title;
  String? language;
  String? url;
  String? domainId;
  String? contentType;
  List<dynamic>? narration;
  String? owner;
  String? domainName;
  String? subDomainId;
  String? subDomainName;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['keywords'] = keywords;
  //   map['input'] = input;
  //   map['status'] = status;
  //   map['type'] = type;
  //   map['speakerGender'] = speakerGender;
  //   map['_id'] = id;
  //   if (audioList != null) {
  //     map['audioList'] = audioList?.map((v) => v.toJson()).toList();
  //   }
  //   if (vttList != null) {
  //     map['vttList'] = vttList?.map((v) => v.toJson()).toList();
  //   }
  //   if (availableLanguages != null) {
  //     map['availableLanguages'] = availableLanguages?.map((v) => v.toJson()).toList();
  //   }
  //   map['tenantId'] = tenantId;
  //   map['ownershipId'] = ownershipId;
  //   map['title'] = title;
  //   map['language'] = language;
  //   map['url'] = url;
  //   map['domainId'] = domainId;
  //   map['contentType'] = contentType;
  //   if (narration != null) {
  //     map['narration'] = narration.map((v) => v.toJson()).toList();
  //   }
  //   map['owner'] = owner;
  //   map['domainName'] = domainName;
  //   map['subDomainId'] = subDomainId;
  //   map['subDomainName'] = subDomainName;
  //   return map;
  // }

}