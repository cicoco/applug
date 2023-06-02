import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'en_US.dart';
import 'zh_CN.dart';

class TranslationService extends Translations {
  static Locale? get locale => Get.deviceLocale;

  // static final fallbackLocale = Locale('en', 'US');
  static final fallbackLocale = Locale('en');

  @override
  Map<String, Map<String, String>> get keys => {
        // 'en_US': en_US,
        'zh_Hans': zh_CN,
      };
}
