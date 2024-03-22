import 'package:rive_animation/animation_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Artboard? riveArtboard;

  late RiveAnimationController idleController;
  late RiveAnimationController handsUpController;
  late RiveAnimationController handsDownController;
  late RiveAnimationController successController;
  late RiveAnimationController failController;
  late RiveAnimationController lookDownRightController;
  late RiveAnimationController lookDownLeftController;
  late RiveAnimationController lookIdleController;

  final key = GlobalKey<FormState>();
  String testEmail = 'marwa@gmail.com';
  String testPassword = 'marwa_dev';

  final passwordFocusNode = FocusNode();

  bool isLookingLeft = false;
  bool isLookingRight = false;

  void removeAllControllers() {
    riveArtboard?.artboard.removeController(idleController);
    riveArtboard?.artboard.removeController(handsUpController);
    riveArtboard?.artboard.removeController(handsDownController);
    riveArtboard?.artboard.removeController(successController);
    riveArtboard?.artboard.removeController(failController);
    riveArtboard?.artboard.removeController(lookDownRightController);
    riveArtboard?.artboard.removeController(lookDownLeftController);
    riveArtboard?.artboard.removeController(lookIdleController);
    isLookingLeft = false;
    isLookingRight = false;
  }

  void addIdleController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(idleController);
    debugPrint('Idle');
  }

  void addHandsUpController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(handsUpController);
    debugPrint('Hands Up');
  }

  void addHandsDownController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(handsDownController);
    debugPrint('Hands Down');
  }

  void addSuccessController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(successController);
    debugPrint('Success');
  }

  void addFailController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(failController);
    debugPrint('Fail');
  }

  void addLookDownRightController() {
    removeAllControllers();
    isLookingRight = true;
    riveArtboard?.artboard.addController(lookDownRightController);
    debugPrint('Look Down Right');
  }

  void addLookDownLeftController() {
    removeAllControllers();
    isLookingLeft = true;
    riveArtboard?.artboard.addController(lookDownLeftController);
    debugPrint('Look Down Left');
  }

  void addLookIdleController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(lookIdleController);
    debugPrint('Look Idle');
  }

  void checkForPasswordFocusNodeToChangeAnimationState() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        addHandsUpController();
      } else if (!passwordFocusNode.hasFocus) {
        addHandsDownController();
      }
    });
  }

  void validatePasswordAndEmail() {
    passwordFocusNode.unfocus();
    // sleep(Duration(seconds: 1));
    Future.delayed(const Duration(seconds: 1), () {
      if (key.currentState!.validate()) {
        addSuccessController();
      } else {
        addFailController();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    idleController = SimpleAnimation(AnimationEnum.Idle.name);
    handsUpController = SimpleAnimation(AnimationEnum.Hands_up.name);
    handsDownController = SimpleAnimation(AnimationEnum.hands_down.name);
    successController = SimpleAnimation(AnimationEnum.success.name);
    failController = SimpleAnimation(AnimationEnum.fail.name);
    lookDownRightController = SimpleAnimation(AnimationEnum.Look_down_right.name);
    lookDownLeftController = SimpleAnimation(AnimationEnum.Look_down_left.name);
    lookIdleController = SimpleAnimation(AnimationEnum.look_idle.name);
    rootBundle.load("assets/animation_login.riv").then((data) {
      final RiveFile file = RiveFile.import(data);

      final artboard = file.mainArtboard;
      artboard.addController(idleController);
      setState(() {
        riveArtboard = artboard;
      });
    });

    checkForPasswordFocusNodeToChangeAnimationState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Animated Login'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: riveArtboard == null
                  ? const SizedBox.shrink()
                  : Rive(
                      artboard: riveArtboard!,
                    ),
            ),
            Form(
              key: key,
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      if (value.isNotEmpty && value.length < 16 && !isLookingLeft) {
                        addLookDownLeftController();
                      }
                      if (value.isNotEmpty && value.length > 16 && !isLookingRight) {
                        addLookDownRightController();
                      }
                    },
                    validator: (value) => value != testEmail ? "wrong email" : null,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  TextFormField(
                    validator: (value) => value != testPassword ? "wrong password" : null,
                    obscureText: true,
                    focusNode: passwordFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 18,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: validatePasswordAndEmail,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 24),
              ),
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    super.dispose();
  }
}
