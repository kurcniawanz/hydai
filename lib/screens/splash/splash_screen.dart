import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import 'components/splash_content.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.instance
      ..backgroundColor = Colors.black
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..progressColor = Colors.white;
    Future.delayed(const Duration(milliseconds: 5000), _ceklogin);
    super.initState();
  }

  Future<void> _ceklogin() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (localStorage.getString('id_user') != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/sign_in', (Route<dynamic> route) => false);
    }
  }

  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Hydai, Let’s shop!",
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
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => SplashContent(
                    image: splashData[index]["image"],
                    text: splashData[index]['text'],
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
                          splashData.length,
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
