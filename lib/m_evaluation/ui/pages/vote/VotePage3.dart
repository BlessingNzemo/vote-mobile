import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../composants/AppSize.dart';
import '../../composants/CustomSlider.dart';
import '../intervenantPage/intervenantCtrl.dart';
import 'VoteCtrl.dart';

class VotePage3 extends ConsumerStatefulWidget {
  final phaseId;
  final phaseIntervenantId;

  const VotePage3(
      {super.key, required this.phaseId, required this.phaseIntervenantId});

  @override
  ConsumerState createState() => _VotePageState3();
}

class _VotePageState3 extends ConsumerState<VotePage3> {
  var valeurSlider = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // action initiale de la page et appel d'un controleur
      var intervenantId = widget.phaseIntervenantId;
      print("intervenantId $intervenantId");
      var ctrl = ref.read(voteCtrlProvider.notifier);
      print("CRITERS AFFICHER ${widget.phaseId}");
      await ctrl.recupererCriteres(widget.phaseId);

      var intervenantCrt = ref.read(intervenantCtrlProvider);
      var candidat = intervenantCrt.intervenants
          .where((element) => element.intervenantId == intervenantId)
          .toList();
      print("candidat $candidat");
      if (candidat.length > 0) {
        var user = candidat[0];
        ctrl.setCandidat(user);
      }
      ctrl.checkVote(widget.phaseIntervenantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(voteCtrlProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${state.phaseVoteIntervenants?.email}",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        automaticallyImplyLeading: false,
        leading: Container(
          margin: EdgeInsets.only(left: 7, right: 0, top: 3, bottom: 2),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Color(0xffFF7900).withOpacity(0.8),
          ),
        ),
      ),
      body: SafeArea(
          child: Stack(
        children: [
          _contenuPrincipale(context, ref),
          _contenuSecondaire(context, ref),
          _listCriteres(context, ref),
          _chargement(context, ref),
          _SubmitButton(context, ref),
        ],
      )),
    );
  }

  _contenuPrincipale(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(30),
      height: AppSize.screenHeight,
      width: AppSize.screenWidth,
      decoration: BoxDecoration(
          image: DecorationImage(
        onError: (exception, stackTrace) => Image.asset("images/jm.png"),
        image: AssetImage("images/idea.png"),
        fit: BoxFit.cover,
      )),
    );
  }

  _contenuSecondaire(BuildContext context, WidgetRef ref) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    Color loadingColor = isDarkTheme
        ? Colors.white.withOpacity(0.9)
        : Colors.black.withOpacity(0.1);
    var state = ref.watch(voteCtrlProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: loadingColor),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.black,
                ),
              ],
            ), // Space between the icon and the email text
          ),
        ),
      ],
    );
  }

  _listCriteres(BuildContext context, WidgetRef ref) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    Color loadingColor = isDarkTheme
        ? Colors.white.withOpacity(0.9)
        : Colors.black.withOpacity(0.1);
    var state = ref.watch(voteCtrlProvider);
    var state2= ref.watch(intervenantCtrlProvider);
    return Center(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        height: AppSize.screenHeight / 1.7,
        decoration: BoxDecoration(
            color: loadingColor,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Center(
          child: ListView.builder(
              itemCount: state.criteres.length,
              itemBuilder: (BuildContext context, int index) {
                var critere = state.criteres[index].critere;
                var intervenant = state2.intervenants[index].isDone;
                print(critere.toJson());
                var savedValue = state.valeurs["${critere.id}"] ?? 0.0;
                bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
                Color loadingColor1 = isDarkTheme
                    ? Colors.white
                    : Colors.black;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        child: ListTile(
                          leading: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          title: Text(
                            state.criteres[index].critere.libelle,
                            style: TextStyle(fontSize: 20,
                            color: loadingColor1
                            ),
                          ),
                          trailing: Text(
                            "Ponderation : " +
                                state.criteres[index].critere.ponderation
                                    .toString(),
                            style: TextStyle(
                              fontSize: 15,
                              color: loadingColor1,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: CustomSlider(
                          title: '',
                          isEnabled: intervenant?false:true,
                          onSliderChanged: (value) {
                            var ctrl = ref.read(voteCtrlProvider.notifier);
                            ctrl.onSliderChanged(
                                critere.id, value, widget.phaseIntervenantId);
                            setState(() {
                              if (value > 0) {
                                var ctrl = ref.read(voteCtrlProvider.notifier);
                                ctrl.checkVote(widget.phaseIntervenantId);
                              }
                              savedValue = value;
                            });
                          },
                          value: savedValue,
                        ),
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                10, 30, 0, 10),
                            child: Text(
                              "Score : $savedValue",
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
  _chargement(BuildContext context, WidgetRef ref) {
    bool isDarkTheme = Theme
        .of(context)
        .brightness == Brightness.dark;
    Color loadingColor = isDarkTheme ? Colors.white : Colors.orange;
    var state = ref.watch(voteCtrlProvider);
    return Visibility(
        visible: state.isLoading,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black26,
          child: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: loadingColor, size: 50),
          ),
        ));
  }
  _SubmitButton(BuildContext context, WidgetRef ref) {
    var state = ref.watch(voteCtrlProvider);
    var state2 = ref.watch(intervenantCtrlProvider);
    bool allSlidersMoved = state.criteres.every((critere) => state.valeurs["${critere.critere.id}"] != null && state.valeurs["${critere.critere.id}"]! > 0);
    return Visibility(
      visible: !state2.isDone && allSlidersMoved,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            margin: EdgeInsets.only(bottom: 45),
            width: 200,
            height: 50,
            child: ElevatedButton(onPressed: () async {
              var res =await showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
              title: const Text(
              "Soumission de votre vote.",
              style: TextStyle(color: Colors.orange, fontSize: 30),
              ),
              content: const Text(
              "Êtes-vous sûr de vouloir soumettre votre vote ?",
              style: TextStyle(fontSize: 15),
              ),
              actions: <Widget>[
              TextButton(
              onPressed: () => Navigator.pop(context, "Annulez"),
              child: const Text(
              "Annulez",
              style: TextStyle(fontSize: 20),
              ),
              ),
              TextButton(
              onPressed: () async {
              Navigator.of(context).pop('Oui');
              },
              child: const Text(
              "Oui",
              style: TextStyle(fontSize: 20),
              ))
              ],
              ));
              if (res == "Oui") {
                setState(() {
                  state.isLoading = true;
                });
                await Future.delayed(Duration(seconds: 3));
                print(
                    "WiDGETINTERN ${widget.phaseIntervenantId}, phaseId ${widget.phaseId}");
                var ctrl = ref.read(voteCtrlProvider.notifier);
                await ctrl.sendVoteResulats(
                    widget.phaseIntervenantId, widget.phaseId);
                if (mounted) {
                  setState(() {
                    state.isLoading = false;
                  });
                  await _chargement(context, ref);
                  context.pop(true);
                }
              }
            }, child: Text("Valider",
            style: TextStyle(
              color: Colors.white,
            ),
            ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              )
            )
        ),
      ),
    );
  }
}
