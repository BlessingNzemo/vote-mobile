import 'package:device_info_plus/device_info_plus.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:odc_mobile_project/navigation/routers.dart';
import '../../../business/interactor/EvaluationInteractor.dart';
import '../../composants/afficherMessageErreur.dart';
import '../ScanCouponPage/ScanCouponPage.dart';
import 'IntroCtrl.dart';

class IntroPage3 extends ConsumerStatefulWidget {
  const IntroPage3({super.key});

  @override
  ConsumerState createState() => _IntroPageState();
}

class _IntroPageState extends ConsumerState<IntroPage3> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("init intro page");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // action initiale de la page et appel d'un controleur
      var ctrl = ref.read(introCtrlProvider.notifier);
      // _getDeviceImei();
      ctrl.getDeviceIdentifier();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme
        .of(context)
        .brightness == Brightness.dark;
    Color loadingColor = isDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
        appBar: AppBar(
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
                  flex: 2,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Text(
                         "Bievenue sur Votepad",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Cliquez sur l'un des boutons ci-dessous",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                            color: loadingColor),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "pour voter ou passer une évaluation",
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
                       "images/cd.png",
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ElevatedButton(
                      //   onPressed: () {
                      //   },
                      //   child: Text( "Voter"),
                      //   style: ElevatedButton.styleFrom(
                      //     minimumSize: Size(double.infinity, 45),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(5),
                      //     ),
                      //     textStyle: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //     elevation: 0,
                      //   ),
                      // ),
                      _boutonVote(),
                      SizedBox(
                        height: 2,
                      ),
                      // ElevatedButton(
                      //   onPressed: () {},

                      _boutonEvaluation()
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  _getDeviceImei() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("androidInfo ${androidInfo.id}");
    var imei = androidInfo.id;
  }

  _contenuPrincipale(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 270,
            left: 8,
            right: 8,
            child: Card(
              color: Colors.black.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Bienvenue sur VotePad!',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15.0,),
                    Text(
                      "Cliquez sur l'un des boutons ci-dessous",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "pour voter ou passer une évaluation",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 70),
                    _boutonVote(),
                    const SizedBox(height: 18),
                    _boutonEvaluation(),
                    SizedBox(height: 18.0,),
                    Center(
                      child: Text("Orange est là",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 8,
                        ),),)
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }


  _boutonVote() {
    final evaluationInteractor = ref.watch(evaluationInteractorProvider);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF7900),
                // backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              onPressed: () async {
                var usecase = evaluationInteractor.getJuryLocalUseCase;
                var res = await usecase.run();
                if (res!=null && res.token != "") {
                  context.pushNamed(Urls.phases.name);
                  return;
                }
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScanCouponPage(type: "vote")),
                );
                if (result != null) {
                  //print("result dans login $result");
                  var ctrl = ref.read(introCtrlProvider.notifier);
                  var res = await ctrl.soumettre(result);
                  if (res == null) {
                    context.pushNamed(Urls.phases.name);
                  } else {
                    afficherMessageErreur(context, "Coupon invalide");
                  }
                }
              },
              child: Text("Voter",
                style: TextStyle(
                    fontSize: 16
                ),),
            ),
          ),

        ],
      ),
    );
  }

  _boutonEvaluation() {
    final evaluationInteractor = ref.watch(evaluationInteractorProvider);
    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor: Colors.orange);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child:
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
          ),
          onPressed: () async {
            var usecase = evaluationInteractor.getIntervenantLocalUseCase;
            var res = await usecase.run();
            print(res?.token);
            if (res?.token == null) {
              context.pushNamed(Urls.evaluationAuth.name);
              return;
            }
            context.goNamed(Urls.introEvaluation.name);
          },
          child: Text("Passer une évaluation",
            style: TextStyle(
                fontSize: 16
            ),),
        ),
      ),

    );
  }

  _chargement(BuildContext context) {
    var state = ref.watch(introCtrlProvider);
    return Visibility(
        visible: state.isLoading, child: CircularProgressIndicator());
  }
}
