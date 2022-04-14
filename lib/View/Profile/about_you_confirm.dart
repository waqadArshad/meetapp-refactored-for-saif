import 'package:flutter/material.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar.dart';
import 'package:meeter/Widgets/TextWidgets/poppins_text.dart';
import 'package:provider/provider.dart';
import 'package:meeter/Widgets/GradientButton/GradientButton.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'about_you_setup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './love.dart';

class AboutYouConfirm extends StatefulWidget {
  List<String> choices;
  AboutYouConfirm({required this.choices});
  _AboutYouConfirmState createState() => _AboutYouConfirmState();
}

class _AboutYouConfirmState extends State<AboutYouConfirm> {
  late UserController _currentUser;

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<UserController>(context);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 180,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: PoppinsText(
                      text: "Confirm Your Choices",
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      clr: Colors.grey,
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.choices.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 15),
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color(0xff00AEFF),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: PoppinsText(
                                text: widget.choices[index],
                                clr: Color(0xff00AEFF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              height: 50,
                              child: GradientButton(
                                title: "Yes",
                                clrs: [Color(0xff00AEFF), Color(0xff00AEFF)],
                                fontSize: 16,
                                letterSpacing: 0,
                                onpressed: () {
                                  FirebaseFirestore.instance
                                      .collection("userAbouts")
                                      .doc(_currentUser.getCurrentUser.uid)
                                      .set({
                                    "abouts": widget.choices,
                                    "uid": _currentUser.getCurrentUser.uid,
                                  }, SetOptions(merge: true));

                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeIn,
                                      child: LoveSetup(),
                                    ),
                                  );

                                  AchievementView(
                                    context,
                                    color: Colors.green,
                                    icon: Icon(
                                      FontAwesomeIcons.check,
                                      color: Colors.white,
                                    ),
                                    title: "Confirmed !",
                                    elevation: 20,
                                    subTitle:
                                        "Your choices have been confirmed",
                                    isCircle: true,
                                  ).show();
                                },
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              height: 50,
                              child: GradientButton(
                                fontSize: 16,
                                letterSpacing: 0,
                                title: "No",
                                textClr: Color(0xff00AEFF),
                                clrs: [Colors.white, Colors.white],
                                border: Border.all(color: Colors.blueAccent),
                                onpressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeIn,
                                      child: YouSetup(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          MeeterAppbar(
            title: "Confirm About you",
            icon: Icons.arrow_back_rounded,
          ),
        ],
      ),
    );
  }
}
