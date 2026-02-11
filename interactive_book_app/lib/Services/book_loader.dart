import 'dart:convert';
import 'package:flutter/services.dart';

Future<Map<String, dynamic>> loadRawBookJson() async {
  final data = await rootBundle.loadString('assets/data/data.json');
  return json.decode(data);
}
