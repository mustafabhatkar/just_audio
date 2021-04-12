import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await AudioService.connect();
    AudioService.start(
      backgroundTaskEntrypoint: _loadNatureSound,
    );
  }

  @override
  void dispose() async {
    await AudioService.stop();
    await AudioService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.play_arrow, size: 50.0),
                    onPressed: () => AudioService.play()),
                IconButton(
                    icon: Icon(Icons.stop, size: 50.0),
                    onPressed: () => AudioService.pause())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _loadNatureSound() async {
  AudioServiceBackground.run(() => BgNatureSoundTask());
}

class BgNatureSoundTask extends BackgroundAudioTask {
  //Just Audio for nature sound
  final natureSoundPlayer = AudioPlayer();

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    natureSoundPlayer.setAsset("audio/River.mp3");
    natureSoundPlayer.setLoopMode(LoopMode.one);
  }

  @override
  Future<void> onPlay() => natureSoundPlayer.play();

  @override
  Future<void> onPause() => natureSoundPlayer.stop();

  @override
  Future<void> onStop() async {
    natureSoundPlayer.stop();
    natureSoundPlayer.dispose();
    await super.onStop();
  }
}
