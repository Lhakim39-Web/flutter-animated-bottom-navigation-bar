import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  Color selectedBgColor = Colors.brown;
  late SMIBool searchTrigger;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedBgColor,
      bottomNavigationBar: SafeArea(
        child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                    bottomNavs.length,
                    (index) => GestureDetector(
                          onTap: () {
                            bottomNavs[index].input!.change(true);
                            setState(() {
                              selectedIndex = index;
                            });
                            switch (selectedIndex) {
                              case 0:
                                selectedBgColor = Colors.brown;
                                break;
                              case 1:
                                selectedBgColor = Colors.blue;
                                break;
                              case 2:
                                selectedBgColor = Colors.pink;
                                break;
                              case 3:
                                selectedBgColor = Colors.purple;
                                break;
                              case 4:
                                selectedBgColor = Colors.orange;
                                break;
                              default:
                                selectedBgColor = Colors.brown;
                            }
                            Future.delayed(Duration(seconds: 1), () {
                              bottomNavs[index].input!.change(false);
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            child: Opacity(
                              opacity: index == selectedIndex ? 1 : 0.5,
                              child: RiveAnimation.asset(
                                bottomNavs.first.src,
                                artboard: bottomNavs[index].artboard,
                                onInit: (artboard) {
                                  StateMachineController controller =
                                      RiveUtils.getRiveController(artboard,
                                          stateMachineName: bottomNavs[index]
                                              .stateMachineName);
                                  bottomNavs[index].input =
                                      controller.findSMI('active') as SMIBool;
                                },
                              ),
                            ),
                          ),
                        ))
              ],
            )),
      ),
    );
  }
}

List<RiveAsset> bottomNavs = [
  RiveAsset(
    "assets/rive/web-icons-pack.riv",
    artboard: "www",
    stateMachineName: "www_interactivity",
    title: "www",
  ),
  RiveAsset(
    "assets/rive/web-icons-pack.riv",
    artboard: "download",
    stateMachineName: "download_interactivity",
    title: "download",
  ),
  RiveAsset(
    "assets/rive/web-icons-pack.riv",
    artboard: "refresh",
    stateMachineName: "refresh_interactivity",
    title: "refresh",
  ),
  RiveAsset(
    "assets/rive/web-icons-pack.riv",
    artboard: "lock",
    stateMachineName: "lock_interactivity",
    title: "lock",
  ),
  RiveAsset(
    "assets/rive/web-icons-pack.riv",
    artboard: "email",
    stateMachineName: "email_interactivity",
    title: "email",
  ),
];

class RiveAsset {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;

  RiveAsset(this.src,
      {required this.artboard,
      required this.stateMachineName,
      required this.title,
      this.input});

  set setInput(SMIBool status) {
    input = status;
  }
}

class RiveUtils {
  static StateMachineController getRiveController(Artboard artboard,
      {stateMachineName = "State Machine 1"}) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, stateMachineName);
    artboard.addController(controller!);
    return controller;
  }
}
