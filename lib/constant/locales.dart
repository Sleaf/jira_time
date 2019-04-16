import 'package:flutter/material.dart';

enum Locales {
  en,
  zh_CN,
}

const LocaleMap = const {
  Locales.en: const Locale('en', ''),
  Locales.zh_CN: const Locale('zh', 'ZN'),
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
