import 'package:rive_animation/animation_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';
import 'package:just_audio/just_audio.dart';

class StoryAnimation extends StatefulWidget {
  const StoryAnimation({super.key});

  @override
  State<StoryAnimation> createState() => _StoryAnimationState();
}

class _StoryAnimationState extends State<StoryAnimation> {
  Artboard? riveArtboard;

  late RiveAnimationController waterController;
  late RiveAnimationController cow2Controller;
  late RiveAnimationController grassController;
  late RiveAnimationController growController;

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    player.setAsset("assets/cow_song.mp3");
    waterController = SimpleAnimation(CowAnimationEnum.water.name);
    cow2Controller = SimpleAnimation(CowAnimationEnum.cow2.name);
    grassController = SimpleAnimation(CowAnimationEnum.grass.name);
    growController = SimpleAnimation(CowAnimationEnum.grow.name);
    rootBundle.load("assets/cow.riv").then((data) {
      final RiveFile file = RiveFile.import(data);

      final artboard = file.mainArtboard;
      artboard.addController(waterController);
      setState(() {
        riveArtboard = artboard;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (riveArtboard != null) player.play();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Story'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height / 20),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: riveArtboard == null
                  ? const SizedBox.shrink()
                  : Rive(
                      artboard: riveArtboard!,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
