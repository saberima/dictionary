import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';

class PlayPhonetic {
  static final PlayPhonetic instance = PlayPhonetic._();
  FlutterSoundPlayer _player;

  PlayPhonetic._() {
    _init();
  }

  void _init() async {
    _player = FlutterSoundPlayer();
    await _player.openAudioSession();
  }

  Future<void> play(Uint8List data) async {
    if (_player.isInited != Initialized.fullyInitialized) return;
    if (data != null) {
      _player.startPlayer(
        fromDataBuffer: data,
        whenFinished: () => null,
      );
    }
  }
}
