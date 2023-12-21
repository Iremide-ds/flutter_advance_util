import 'package:flutter/material.dart';
import 'package:flutter_advance_util/flutter_advance_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Advance',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Advance Animations"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          SolidButton(
            text: "Petal Menu Animation",
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => PetalMenu(
                      // behavior: HitTestBehavior.opaque,
                      initialIndex: 1,
                      petals: [
                        Petal(Colors.blue,
                            child: const CircularProgressIndicator()),
                        Petal(Colors.amber, child: const Placeholder()),
                        Petal(Colors.purple,
                            child: Container(
                                color: Colors.grey,
                                child: const Placeholder())),
                        Petal(Colors.red, child: const Placeholder()),
                        Petal(Colors.yellow,
                            child: const CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.red)),
                        Petal(Colors.indigo, child: const Placeholder())
                      ],
                    ))),
          ),
          const SizedBox(height: 20),
          SolidButton(
            text: "Rainbow Stick Animation",
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => Scaffold(
                        body: RainbowSticksPage(
                            animationController: AnimationController(
                                vsync: this,
                                upperBound: 0.6,
                                duration: const Duration(seconds: 2)),
                            size: MediaQuery.of(context).size),
                      )),
            ),
          ),
          const SizedBox(height: 20),
          SolidButton(
              text: "Animated Lock",
              onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                          backgroundColor: Colors.black26,
                          body: AnimatedLock(
                            size: MediaQuery.sizeOf(context),
                            controller: AnimationController(
                              vsync: this,
                              upperBound: 0.6,
                              duration: const Duration(milliseconds: 500),
                            ),
                            lockedColor: Colors.blueGrey,
                            unlockedColor: Colors.green,
                            overlayColor: Colors.black,
                            showSwitch: true,
                          )),
                    ),
                  )),
          const SizedBox(height: 20),
          SolidButton(
            text: "Animated Progress Bar",
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Scaffold(
                body: AnimatedProgressBar(
                    size: MediaQuery.sizeOf(context),
                    colors: const [Colors.blue, Colors.red]),
              ),
            )),
          ),
          const SizedBox(height: 20),
          SolidButton(
            text: "Animated Card",
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => Scaffold(
                  body: AnimatedCard(
                      actionText: 'Learn more',
                      activeColor: Colors.red,
                      detail: 'A simple animated card.',
                      icon: const Icon(Icons.abc),
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.9)),
            )),
          ),
          const SizedBox(height: 20),
          SolidButton(
            text: "Onboarding Animation",
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => OnboardingAnimationPage(pages: [
                Onboarding(
                    title: "Let's Get Started!",
                    content:
                        "Buckle up, we're about to embark on a thrilling digital journey with App. Swipe, tap, and let's dive into the awesomeness!",
                    imagePath: 'assets/images/feature1.png',
                    backgroundColor: const Color(0xFFFFFFFF),
                    color: const Color(0xFF6BF6FF)),
                Onboarding(
                    title: 'Stay in the Loop, Have a Scoop',
                    content:
                        'No more FOMO! Get real-time updates and stay in the loop, all while sipping your morning coffee.',
                    imagePath: 'assets/images/feature2.png',
                    backgroundColor: const Color(0xFF6BF6FF),
                    color: const Color(0xFFFFD952)),
                Onboarding(
                    title: 'Discover the Magic',
                    content:
                        "It's like opening a treasure chest of features! Customize your experience, discover hidden gems, and get ready to be amazed.",
                    imagePath: 'assets/images/feature3.png',
                    backgroundColor: const Color(0xFFFFD952),
                    color: const Color(0xffffffff))
              ]),
            )),
          ),
          const SizedBox(height: 20),
          SolidButton(
              text: "Water Wave Animation",
              onPressed: () =>
                  Navigator.of(context).push(WaterWaveAnimationPage.route())),
        ],
      ),
    );
  }
}

class SolidButton extends StatelessWidget {
  const SolidButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.sizeOf(context).width, 60)),
      child: Text(text),
    );
  }
}
