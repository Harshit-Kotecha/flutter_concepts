import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late RecorderController _recorderController;
  late PlayerController _playerController;
  String path = "";
  bool isRecording = false;
  bool isPlayerReady = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _recorderController = RecorderController();
    _playerController = PlayerController();
  }

  @override
  void dispose() {
    _recorderController.dispose();
    _playerController.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    setState(() {
      isPlayerReady = false;
    });
    await _recorderController.record();
  }

  Future<void> stopRecording() async {
    path = await _recorderController.stop() as String;
    setState(() {
      isPlayerReady = true;
    });
    print(path);
  }

  Future<void> startPlayer() async {
    setState(() {
      isPlaying = true;
    });
    await _playerController.preparePlayer(
      path: path,
      shouldExtractWaveform: true,
      noOfSamples: 100,
      volume: 1.0,
    );
    await _playerController.startPlayer(finishMode: FinishMode.loop);
  }

  Future<void> stopPlayer() async {
    setState(() {
      isPlaying = false;
    });
    await _playerController.stopPlayer();
  }

  void Function() getRecorderFn() {
    return _recorderController.isRecording ? stopRecording : startRecording;
  }

  void Function() getPlayerFn() {
    return _playerController.playerState.isPlaying ? stopPlayer : startPlayer;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Audio Record'),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          foregroundColor: Colors.white,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children: [
                if (isPlayerReady)
                  AudioFileWaveforms(
                    size: Size(MediaQuery.of(context).size.width, 200.0),
                    playerController: _playerController,
                    enableSeekGesture: true,
                    waveformType: WaveformType.long,
                    playerWaveStyle: const PlayerWaveStyle(
                      fixedWaveColor: Colors.white54,
                      liveWaveColor: Colors.blueAccent,
                      scaleFactor: 200,
                      spacing: 6,
                      showSeekLine: false,
                    ),
                  ),
                AudioWaveforms(
                  size: Size(
                    MediaQuery.of(context).size.width,
                    200.0,
                  ),
                  recorderController: _recorderController,
                  enableGesture: true,
                  waveStyle: WaveStyle(
                    spacing: 5.0,
                    extendWaveform: true,
                    showMiddleLine: false,
                    scaleFactor: 200,
                    gradient: ui.Gradient.linear(
                      const Offset(70, 70),
                      Offset(MediaQuery.of(context).size.width / 2, 0),
                      [
                        Colors.blue,
                        Colors.blueAccent,
                      ],
                    ),
                  ),
                ),
                if (isPlayerReady)
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        print('click');
                        setState(() {
                          getPlayerFn()();
                        });
                      },
                      iconSize: 100,
                      icon: isPlaying
                          ? const Icon(
                              Icons.pause_circle_outline,
                              color: Colors.white,
                            )
                          : const Icon(Icons.play_circle_outline),
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  getRecorderFn()();
                  isRecording = !isRecording;
                  // isPlayerReady = !_recorderController.isRecording;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: isRecording
                        ? const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.red,
                          )
                        : const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
