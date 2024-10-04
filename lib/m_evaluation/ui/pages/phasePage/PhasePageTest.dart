import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:odc_mobile_project/m_evaluation/ui/composants/AppSize.dart';
import '../../../../navigation/routers.dart';
import '../../composants/afficherMessageInfo.dart';
import 'PhaseCtrl.dart';

class PhasePageTest extends ConsumerStatefulWidget {
  const PhasePageTest({Key? key}) : super(key: key);

  @override
  ConsumerState<PhasePageTest> createState() => _PhasePageTestState();

}

class _PhasePageTestState extends ConsumerState<PhasePageTest> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var ctrl = ref.read(phaseCtrlProvider.notifier);
      ctrl.recupererPhase();

      var ctrl2 = ref.read(phaseCtrlProvider.notifier);
      ctrl2.recupererListPhase();
      var ctrl3 = ref.read(phaseCtrlProvider.notifier);
      ctrl3.bloquerStatus();
    });
  }
  @override
  Widget build(BuildContext context) {
    AppSize().init(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: TextButton(
                  onPressed: () {
                    var ctrl = ref.read(phaseCtrlProvider.notifier);
                    ctrl.disconnect();
                    context.goNamed(Urls.Intro.name);
                    afficherMessageInfo(
                        context, "Disconnected", Colors.red, true);
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.logout_outlined,
                        color: Colors.white,
                        size: 25,
                      ),
                    ],
                  )),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffFF7900),
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _contenuPrincipale(context, ref),
            // _chargement(context, ref),
            // _buttonAction(context,ref)
          ],
        ),
      ),
    );
  }
  _contenuPrincipale(BuildContext context, WidgetRef ref) {
    bool isDarkTheme = Theme
        .of(context)
        .brightness == Brightness.dark;
    Color loadingColor = isDarkTheme ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.1);
    var state = ref.watch(phaseCtrlProvider);
    var phase = state.phasename;
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  Container(
                    height: AppSize.screenHeight - 175,
                    width: AppSize.screenWidth ,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset("images/x.png"),
                    ),
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset("images/x.png"),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 250, left: 10, right: 10),
                      padding: EdgeInsets.all(10),
                      width: AppSize.screenWidth ,
                      decoration: BoxDecoration(
                        color: loadingColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                      Column(
                        children: [
                          Text("${phase?.phase?.nom}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  height: 1.1)
                          ),
                          const SizedBox(height: 16,),
                          Text("${phase?.phase?.description}",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16,),
                          Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                          ),
                                          onPressed: () {
                                            context.goNamed(Urls.intervenants.name,
                                              extra: phase,
                                              pathParameters: {
                                                "id": phase!.phase!.id.toString()
                                              },
                                            );
                                          },
                                          child: Text(
                                            "Commencer le vote ",
                                            style: TextStyle(fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        ),
                                  ),
                                ],
                              )
                          )
                        ],
                      )

                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  _buttonAction(BuildContext context, WidgetRef ref ) {
    var state = ref.watch(phaseCtrlProvider);
    var phase = state.phasename;
    return Container(
      child: SizedBox(
        height: 60,
        width: 250,
        child: Stack(
          children: [
            Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              context.goNamed(Urls.intervenants.name,
                                extra: phase,
                                pathParameters: {
                                  "id": phase!.phase!.id.toString()
                                },
                              );
                            },
                            child: Text(
                              "Start the Vote",
                              style: TextStyle(fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                          Icon(CupertinoIcons.arrow_right, color: Colors.white,),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffFF7900),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
