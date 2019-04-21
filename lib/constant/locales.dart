import 'package:flutter/material.dart';

enum Locales {
  followSystem,
  zh_CN,
  en,
}

const LocaleMap = const {
  Locales.zh_CN: const Locale('zh', 'ZN'),
  Locales.en: const Locale('en', ''),
};

const LocaleNameMap = const {
  Locales.zh_CN: '简体中文',
  Locales.en: 'English',
};

Locales getLocalesFromString(String statusAsString) {
  for (Locales element in Locales.values) {
    if (element.toString() == statusAsString) {
      return element;
    }
  }
  return null;
}
