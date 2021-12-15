import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:metrkoin/screens/authentication/sign_up_page.dart';
import 'package:metrkoin/screens/homepage/homepage.dart';
import 'package:metrkoin/utils/buttons.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/constants.dart';
import 'package:metrkoin/utils/metrkoin_logo.dart';

class OnboardingPage extends StatefulWidget {

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {


  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  double _textSize = 15.0;

  String _message1 = "  immerse yourself in fun, easy games\n ";
  String _message2 = "  earn MTRK for every challenge you complete\n ";
  String _message3 = "  withdraw coin into any wallet of your choice\n ";


  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(backgroundColor: colorWhite)
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: colorGreyBg,
        child: Column(
          children: [
            SizedBox(height: 5.0,),
            Row(
              children: [
                SizedBox(width: 10.0,),
                MetrKoinLogo(70.0, 70.0),
                Spacer(flex: 1,),
              ],
            ),
            Spacer(flex: 1),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.45,
              child: PageView(
                  allowImplicitScrolling: true,
                  physics: ClampingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() => _currentPage = page);
                  },
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Stack(
                          children: [
                            SizedBox(
                                height: MediaQuery.of(context).size.height * 0.45,
                                width: MediaQuery.of(context).size.width,
                                child: Image.asset("assets/images/slider3.png", fit: BoxFit.fill,)),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(_message1, style: TextStyle(fontSize: _textSize, color: colorWhite),))
                          ],
                        )),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Stack(
                          children: [
                            SizedBox(
                                height: MediaQuery.of(context).size.height * 0.45,
                                width: MediaQuery.of(context).size.width,
                                child: Image.asset("assets/images/slider2.jpg", fit: BoxFit.fill,)),
                            Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(_message2, style: TextStyle(fontSize: _textSize, color: colorWhite),))
                          ],
                        )),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Stack(
                          children: [
                            SizedBox(
                                height: MediaQuery.of(context).size.height * 0.45,
                                width: MediaQuery.of(context).size.width,
                                child: Image.asset("assets/images/slider1.jpeg", fit: BoxFit.fill,)),
                            Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(_message3, style: TextStyle(fontSize: _textSize, color: colorWhite),))
                          ],
                        )),
                  ]),
            ),
            SizedBox(height: 8.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
            Spacer(flex: 2,),
            DefaultButtonPurple('Get Started', () {
              Get.to(
                SignUpPage(),
                transition: Transition.rightToLeft,
                duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
              );
            }),
            SizedBox(height: 20.0,),
            signInButton(),
            SizedBox(height: 20.0,)
          ],
        ),
      ),
    );
  }


  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      height: 10.0,
      width:  10.0,
      decoration: BoxDecoration(
          color: isActive ? colorPurpleLMain : colorGrey,
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
    );
  }



  Widget signInButton() {
    return Container(
      height: 44.0,
      width: MediaQuery.of(context).size.width*0.9,
      child: ElevatedButton(
        child: Center(child: Text('Sgn In', style: TextStyle(
            color: colorPurpleLMain, fontSize: 15.0))
        ),
        style: ElevatedButton.styleFrom(
          primary: colorWhite,
          onSurface: Colors.purple,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          side: BorderSide(color: colorPurpleLMain, width: 1),
          elevation: 2,
        ),
        onPressed: () async {
          Get.to(
            HomePage(),
            transition: Transition.rightToLeft,
            duration: Duration(milliseconds: PAGE_TRANSITION_DURATION),
          );
        },
      ),
    );
  }


}
