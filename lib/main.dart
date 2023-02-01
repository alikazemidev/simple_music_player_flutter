import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration? duration;
  Timer? timer;

  @override
  void initState() {
    audioPlayer.setAsset('assets/music.mp3').then((value) {
      duration = value;
      audioPlayer.play();
      timer = Timer.periodic(
        const Duration(milliseconds: 200),
        (timer) {
          setState(() {});
        },
      );
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.asset('assets/cover.jpg').image,
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 35,
                  sigmaY: 35,
                ),
                child: Container(
                  color: Colors.black26,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: Image.asset('assets/cover.jpg').image,
                        radius: 40,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'david jackson',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '@david_jackson',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.heart,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/cover.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'power fairy living in the moors',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'power moors',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (duration != null)
                    Slider(
                      inactiveColor: Colors.white.withOpacity(.5),
                      activeColor: Colors.white,
                      value: audioPlayer.position.inMilliseconds.toDouble(),
                      max: duration!.inMilliseconds.toDouble(),
                      onChangeStart: (value) {
                        audioPlayer.pause();
                      },
                      onChangeEnd: (value) {
                        audioPlayer.play();
                      },
                      onChanged: (value) {
                        audioPlayer.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DurationEx(audioPlayer.position),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          DurationEx(duration!),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        iconSize: 36,
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.backward_fill,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (audioPlayer.playing) {
                            audioPlayer.pause();
                          } else {
                            audioPlayer.play();
                          }
                        },
                        child: Container(
                          width: 76,
                          height: 76,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xff74ff7e),
                                Color(0xff73c679),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x4474ff7e),
                                blurRadius: 20,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          child: Icon(
                            audioPlayer.playing
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        iconSize: 36,
                        icon: const Icon(
                          CupertinoIcons.forward_fill,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// extension DurationExtensions on Duration {
//   String toMinutesSecond() {
//     String twoDigiMinutes = intMinutes.reminder(60);
//     String twoDigiSeconds = _toTwoDigits(intSeconds.reminder(60));
//     return "$twoDigiMinutes:$twoDigiSeconds";
//   }
// }
String DurationEx(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}
