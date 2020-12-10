import 'dart:convert';

import 'package:dictionary/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

class Settings {
  static final BucketSettings bucketSettings = sl<BucketSettings>();
  static final SearchSettings searchSettings = sl<SearchSettings>();
}

abstract class SettingsConfig {
  static final _key = "settings_";
  String childKey;
  final SharedPreferences sharedPreferences;
  SettingsConfig(this.childKey, this.sharedPreferences);

  T cast<T>(x) => x is T ? x : null;

  Map _toStringJson();
  _fromStringJson(String strJson);

  _update() async {
    sharedPreferences.setString(childKey, json.encode(_toStringJson()));
  }

  _retrieve() async {
    String str = "";
    try {
      if (sharedPreferences.containsKey(childKey)) {
        str = sharedPreferences.getString(childKey);
      }
      try {
        _fromStringJson(str);
      } on Exception {}
    } on Exception {}
  }
}

class BucketSettings extends SettingsConfig {
  List<int> _delays;
  static BucketSettings _instance;

  BucketSettings._(SharedPreferences sharedPreferences)
      : super(SettingsConfig._key + "bucket", sharedPreferences) {
    init();
  }

  factory BucketSettings.getInstance(
      {@required SharedPreferences sharedPreferences}) {
    if (_instance == null) _instance = BucketSettings._(sharedPreferences);
    return _instance;
  }

  init() async {
    await _retrieve();
  }

  int getDelay(int bucketNumber) {
    if (bucketNumber < _delays.length)
      return _delays[bucketNumber];
    else
      return -1;
  }

  int getBucketCount() {
    return _delays.length;
  }

  setDelay(int bucketNumber, int dayCount) {
    _delays[bucketNumber] = dayCount;
    _update();
  }

  @override
  Map _toStringJson() {
    return {"delays": _delays};
  }

  @override
  _fromStringJson(String strJson) {
    if (strJson == "") {
      _delays = [0, 1, 2, 3, 5];
      _update();
    } else {
      _delays = [];
      Map<String, dynamic> _json = json.decode(strJson);
      List dynamicDelay = _json["delays"];
      dynamicDelay.forEach(
        (element) {
          _delays.add(cast<int>(element));
        },
      );
      // _delays = cast<List<int>>(dynamicDelay);
    }
  }
}

class SearchSettings extends SettingsConfig {
  int _suggestionCount;
  static SearchSettings _instance;

  SearchSettings._(SharedPreferences sharedPreferences)
      : super(SettingsConfig._key + "search", sharedPreferences) {
    init();
  }

  factory SearchSettings.getInstance(
      {@required SharedPreferences sharedPreferences}) {
    if (_instance == null) _instance = SearchSettings._(sharedPreferences);
    return _instance;
  }

  init() async {
    await _retrieve();
  }

  int getSuggestionCount() {
    return _suggestionCount;
  }

  setDelay(int suggestionCount) {
    _suggestionCount = suggestionCount;
    _update();
  }

  @override
  Map _toStringJson() {
    return {"suggestionCount": _suggestionCount};
  }

  @override
  _fromStringJson(String strJson) {
    if (strJson == "") {
      _suggestionCount = 2;
      _update();
    } else {
      Map<String, dynamic> _json = json.decode(strJson);
      _suggestionCount = cast<int>(_json["suggestionCount"]);
    }
  }
}
