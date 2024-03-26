import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/help.content.dart';

class HelpScreen extends StatefulWidget {
  static String routeName = "/help";

  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int currentPage = 0;
  List<Map<String, String>> helphData = [
    {
      "text": "Please call our customer service on\n+62 813 xxxx xxxx",
      "image": "assets/images/Hydai_Logo.png"
    },
    // {
    //   "text":
    //       "We help people conect with store \naround United State of America",
    //   "image": "assets/images/splash_2.png"
    // },
    // {
    //   "text": "We show the easy way to shop. \nJust stay at home with us",
    //   "image": "assets/images/splash_3.png"
    // },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: helphData.length,
                  itemBuilder: (context, index) => HelpContent(
                    image: helphData[index]["image"],
                    text: helphData[index]['text'],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          helphData.length,
                          (index) => AnimatedContainer(
                            duration: kAnimationDuration,
                            margin: const EdgeInsets.only(right: 5),
                            height: 6,
                            width: currentPage == index ? 20 : 6,
                            decoration: BoxDecoration(
                              color: currentPage == index
                                  ? kPrimaryColor
                                  : const Color(0xFFD8D8D8),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      // const Spacer(flex: 3),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.pushNamed(context, SignInScreen.routeName);
                      //   },
                      //   child: const Text("Continue"),
                      // ),
                      // const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
