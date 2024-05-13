import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:winter_wolf/screens/drawing_app_main_screen.dart';
import 'package:winter_wolf/utils/utils.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  Animation<Offset>? homingAnimation;
  Animation<Offset>? homingAnimation2;
  late AnimationController controller;
  GlobalKey sourceKey = GlobalKey();
  GlobalKey sourceKey2 = GlobalKey();
  GlobalKey destinationKey = GlobalKey();

  Offset sourceOffset = const Offset(0, 0);
  Offset sourceOffset2 = const Offset(0, 0);
  Offset destinationOffset = const Offset(0, 0);

  int milestone = 2;
  late AnimationController receiveController;
  late AnimationController finishController;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    receiveController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    finishController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        sourceOffset = sourceKey.globalPaintBounds!;
        sourceOffset2 = sourceKey2.globalPaintBounds!;
        final sourceBox =
            sourceKey.currentContext!.findRenderObject() as RenderBox;
        final sourceBox2 =
            sourceKey.currentContext!.findRenderObject() as RenderBox;

        destinationOffset = destinationKey.globalPaintBounds!;
        final endOffset = Offset(
          (destinationOffset.dx - sourceOffset.dx) /
              (sourceBox.size.width * 0.3),
          (destinationOffset.dy - sourceOffset.dy - 24) /
              (sourceBox.size.height * 0.3),
        );
        final endOffset2 = Offset(
          (destinationOffset.dx - sourceOffset2.dx) /
              (sourceBox2.size.width * 0.3),
          (destinationOffset.dy - sourceOffset2.dy - 24) /
              (sourceBox2.size.height * 0.3),
        );

        homingAnimation =
            Tween<Offset>(begin: const Offset(0, 0), end: endOffset)
                .animate(controller);
        homingAnimation2 =
            Tween<Offset>(begin: const Offset(0, 0), end: endOffset2)
                .animate(controller);
        controller.forward();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                ).createShader(
                  Rect.fromLTRB(0, 0, rect.width, rect.height),
                );
              },
              blendMode: BlendMode.dstIn,
              child: Container(
                height: 400,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/tall_image.jpg"),
                    fit: BoxFit.cover,
                    alignment: FractionalOffset.bottomCenter,
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 1000.ms),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  const Spacer(),
                  Row(
                    children: [
                      MyTextButton(
                        text: "Intro Page",
                        onPressed: () {},
                      ),
                      const Spacer(),
                      MyTextButton(text: "Design 4", onPressed: () {}),
                    ],
                  )
                      .animate()
                      .fadeIn(
                        delay: 800.ms,
                        duration: 400.ms,
                      )
                      .slide(
                        delay: 800.ms,
                        duration: 400.ms,
                        begin: const Offset(0, 0.4),
                      ),
                  const SizedBox(height: 48),
                  const Text(
                    "Fantastic Progress!",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate(controller: finishController, autoPlay: false)
                      .fadeIn(
                        delay: 800.ms,
                        duration: 400.ms,
                      )
                      .slide(
                        delay: 800.ms,
                        duration: 400.ms,
                        begin: const Offset(0, 0.4),
                      ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildHeartMove(
                            globalKey: sourceKey,
                            homingAnimation: homingAnimation,
                            delay: 0.ms),
                        buildHeartMove(
                            globalKey: sourceKey2,
                            homingAnimation: homingAnimation2,
                            delay: 200.ms),
                        Icon(
                          Icons.favorite,
                          color: Colors.deepPurpleAccent.withOpacity(0.4),
                          size: 72,
                        )
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(
                        delay: 1000.ms,
                        duration: 400.ms,
                      )
                      .slide(
                        delay: 1000.ms,
                        duration: 400.ms,
                        begin: const Offset(0, 0.4),
                      ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "NEXT MILESTONE",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    key: destinationKey,
                                    Icons.favorite,
                                    color: Colors.deepPurpleAccent.shade200,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '$milestone/10',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 8,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: LinearProgressIndicator(
                                    color: Colors.deepPurpleAccent.shade100,
                                    backgroundColor: Colors.deepPurple[50],
                                    value: milestone / 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.card_giftcard,
                          color: Colors.pink[200],
                          size: 48,
                        ),
                      ],
                    )
                        .animate(
                            controller: receiveController,
                            autoPlay: false,
                            onComplete: (controller) {
                              finishController.forward();
                            })
                        .scale(end: const Offset(0.95, 0.95))
                        .then()
                        .scale(
                            begin: const Offset(0.95, 0.95),
                            end: const Offset(1, 1)),
                  )
                      .animate()
                      .fadeIn(
                        delay: 1200.ms,
                        duration: 400.ms,
                      )
                      .slide(
                        delay: 1200.ms,
                        duration: 400.ms,
                        begin: const Offset(0, 0.4),
                      ),
                  const SizedBox(height: 32),
                  Expanded(
                          child: Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share),
                      ),
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.location_pin)
                                  .animate(
                                      onPlay: (controller) =>
                                          controller.repeat())
                                  .slideY(
                                      begin: 0,
                                      end: 0.7,
                                      delay: 100.ms,
                                      duration: 700.ms)
                                  .then()
                                  .slideY(end: -0.7, duration: 700.ms),
                              MyTextButton(
                                  text: "back",
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            ],
                          ),
                          const Spacer(),
                          MyTextButton(text: "continue", onPressed: () {}),
                        ],
                      ),
                    ],
                  ))
                      .animate(controller: finishController, autoPlay: false)
                      .fadeIn(
                        delay: 800.ms,
                        duration: 800.ms,
                      ),
                  const SizedBox(height: 32),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildHeartMove({
    double? size,
    GlobalKey? globalKey,
    Animation? homingAnimation,
    required Duration delay,
  }) {
    return Stack(children: [
      Icon(
        key: globalKey,
        Icons.favorite,
        color: Colors.deepPurpleAccent.withOpacity(0.4),
        size: size ?? 72,
      ).animate(delay: 4000.ms).then(delay: delay).fadeIn(
            duration: 100.ms,
          ),
      if (homingAnimation != null)
        AnimatedBuilder(
          animation: homingAnimation as Listenable,
          builder: (context, child) {
            return Icon(
              Icons.favorite,
              color: Colors.deepPurpleAccent.shade200,
              size: size ?? 72,
            )
                .animate(
                    autoPlay: false,
                    controller: controller,
                    onComplete: (controller) {
                      setState(() {
                        milestone++;
                      });
                      receiveController.forward();
                    })
                .then(delay: delay)
                .fadeIn(
                  delay: 1200.ms,
                  duration: 200.ms,
                )
                .then()
                .scale(
                  end: const Offset(0.8, 0.8),
                  duration: 200.ms,
                )
                .then()
                .scale(
                  end: const Offset(1.25, 1.25),
                  duration: 200.ms,
                )
                .then(delay: 100.ms)
                .fade(
                  begin: 0.5,
                  end: 1,
                  duration: 100.ms,
                )
                .scale(
                  end: const Offset(1.25, 1.25),
                  duration: 200.ms,
                )
                .rotate(
                  end: 0.01,
                  duration: 200.ms,
                )
                .then()
                .scale(
                  end: const Offset(0.8, 0.8),
                  duration: 200.ms,
                )
                .rotate(
                  end: -0.01,
                  duration: 200.ms,
                )
                .then(delay: 200.ms)
                .scale(
                  end: const Offset(1.25, 1.25),
                  duration: 200.ms,
                )
                .rotate(
                  end: -0.03,
                  duration: 200.ms,
                )
                .scale(
                  end: const Offset(0.8, 0.8),
                  duration: 200.ms,
                )
                .then()
                .slide(
                  duration: 150.ms,
                  end: homingAnimation.value,
                )
                .scale(
                  duration: 150.ms,
                  end: const Offset(0.3, 0.3),
                )
                .rotate(
                  end: 0.03,
                  duration: 150.ms,
                )
                .then()
                .fadeOut();
          },
        ),
    ]);
  }
}
