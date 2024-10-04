import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:odc_mobile_project/m_evaluation/ui/pages/AuthPage/AuthCtrl.dart';
import '../../../../navigation/routers.dart';
import '../../composants/afficherMessageErreur.dart';
import '../ScanCouponPage/ScanCouponPage.dart';

class AuthPage3 extends ConsumerStatefulWidget {
  const AuthPage3({super.key});

  @override
  ConsumerState<AuthPage3> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage3> {
  var couponCtrl = TextEditingController();
  var emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme
        .of(context)
        .brightness == Brightness.dark;
    Color loadingColor = isDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: IconButton(
                onPressed: (){
                  context.goNamed(Urls.Intro.name);
                },
                icon: Icon(Icons.arrow_back_ios_rounded,
                ),
                iconSize: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xffFF7900).withOpacity(0.5),
              ),
            ),
          ),
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Text(
                        "Authentification",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15,),
                      Text(
                        "Veuillez remplir les champs ci-dessous",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                            color:loadingColor ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "pour acceder à votre évaluation",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                            color: loadingColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Image.asset(
                      "images/jm.png",
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _email(context),
                        const SizedBox(height: 20),
                        _coupon(context),
                        const SizedBox(height: 20),
                        _envoyer(context),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );

  }

  _logo(BuildContext context) {
    return Center(
        child: Icon(Icons.person,
          color: Color(0xFFFF7900),
          size: 100,
          weight: 100,)
      // Image.asset(
      //   'images/images.png',
      //   width: 100,
      //   height: 100,
      // ),
    );
  }

  _texte(context) {
    return Text("Authentification");
  }

  _email(BuildContext context) {
    bool isDarkTheme = Theme
        .of(context)
        .brightness == Brightness.dark;
    Color loadingColor = isDarkTheme ? Colors.white : Colors.black;
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(children: [
          Column(children: [
            TextFormField(
              style:TextStyle(
                  color: loadingColor
              ),
              controller: emailCtrl,
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.orange, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(width: 0.5, color: Colors.black),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                labelText: 'Entrez votre email',
                labelStyle: TextStyle(
                    color: loadingColor
                ),
                prefixIcon: Icon(Icons.email,color:loadingColor,),
              ),
              // border: OutlineInputBorder(),
            ),
          ]),
        ]));
  }

  _coupon(BuildContext Context) {
    bool isDarkTheme = Theme
        .of(context)
        .brightness == Brightness.dark;
    Color loadingColor = isDarkTheme ? Colors.white : Colors.black;
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(children: [
        Column(
          children: [
            TextFormField(
              style: TextStyle(color: loadingColor),
              controller: couponCtrl,
              decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.orange, width: 1),
                  ),
                  // border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(width: 0.5, color: Colors.black),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  labelText: 'Entrez le coupon',
                  labelStyle: TextStyle(
                      color: loadingColor
                  ),
                  suffixIcon: IconButton(
                      onPressed: () async {
                        var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ScanCouponPage(type: "evaluation")),
                        );
                        if (result != null) {
                          print("result dans login $result");
                          setState(() {
                            couponCtrl.text = result;
                          });
                        }
                      },
                      icon: Icon(Icons.camera_alt,color: loadingColor,))),
            ),
          ],
        ),
      ]),
    );
  }

  _envoyer(BuildContext Context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50))),
      child:
      SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF7900),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
            ),
            onPressed: () async {
              var ctrl = ref.read(authCtrlProvider.notifier);
              var result = await ctrl.soumettre(emailCtrl.text, couponCtrl.text);
              if (result == null) {
                context.goNamed(Urls.introEvaluation.name);
              } else {
                afficherMessageErreur(context, result);
              }
            },
            child: Text("Valider",
              style: TextStyle(
                  fontSize: 16
              ),),),
        ),
      ),
    );
  }
}
