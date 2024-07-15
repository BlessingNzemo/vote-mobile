import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:odc_mobile_project/m_evaluation/ui/pages/AuthPage/AuthCtrl.dart';
import 'package:odc_mobile_project/m_evaluation/ui/pages/evaluation/EvaluationCtrl.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

import '../../../../navigation/routers.dart';

class EvaluationPage extends ConsumerStatefulWidget {
  const EvaluationPage({super.key});

  @override
  ConsumerState createState() => _EvaluationPage();
}

class _EvaluationPage extends ConsumerState<EvaluationPage> {
  var key = "RESPONSES";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // action initiale de la page et appel d'un controleur
      var ctrl = ref.read(evaluationCtrlProvider.notifier);
      var authCtrl = ref.read(authCtrlProvider);
      ctrl.getReponses();
      ctrl.getQuestions(authCtrl.phaseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                )),
          ),
        ],
        toolbarHeight: 70.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        title: Text(
          'Evaluation',
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _mainContent(),
          SizedBox(
            height: 20,
          ),
          //,
        ],
      ),
    );
  }

  _myProgressBar() {
    var state = ref.watch(evaluationCtrlProvider);
    //var ctrl = ref.read(evaluationCtrlProvider.notifier);
    return LinearProgressBar(
      maxSteps: state.questions.length,
      //questions.length,
      progressType: LinearProgressBar.progressTypeLinear,
      currentStep: state.currentIndex,
      progressColor: Colors.green,
      backgroundColor: Colors.grey.shade300,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      semanticsLabel: "Label",
      semanticsValue: "Value",
      minHeight: 8,
    );
  }

  _mainContent() {
    var state = ref.watch(evaluationCtrlProvider);
    var ctrl = ref.read(evaluationCtrlProvider.notifier);
    var question = state.maQuestion;
    var selectedValue = state.reponsesChoices?[state.maQuestion?.id] ?? -1;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(
          //   height: 73.0,
          // ),
          _myProgressBar(),

          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12, top: 8.0),
              child: Text(
                  "${state.currentIndex}/${state.questions.length}"),
            ),
          ),

          SizedBox(
            height: 40.0,
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                question?.libelle ?? "",
                style: TextStyle(
                  fontSize: 18,
                  //fontWeight: FontWeight.w200,
                ),
              ),
            ),
          ),
          //_separateurOu(),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  shrinkWrap: true,
                  itemCount: state.assertions.length,
                  itemBuilder: (ctx, index) {
                    var myAssertion = state.assertions[index].id;
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(5.0))),
                      child: RadioListTile(
                          controlAffinity: ListTileControlAffinity.trailing,
                          activeColor: Colors.orange,
                          title: Text("${index + 1}." +
                              " ${state.assertions[index].libelle}",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),),
                          value: myAssertion,
                          groupValue: selectedValue,
                          onChanged: (value) {
                            ctrl.selectAnswer(value!);
                            print("valeur selectionnée $value");
                          }),
                    );
                  }),
            ),
          ),
          _myButton(),
        ]);
  } // end main content

  _myButton() {
    //var state=ref.watch(evaluationCtrlProvider);
    var state = ref.watch(evaluationCtrlProvider);
    var ctrl = ref.read(evaluationCtrlProvider.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 6.0, bottom: 8.0),
          child: Visibility(
            visible: state.backButtonVsible,
            child: FloatingActionButton.extended(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              onPressed: () => ctrl.nextPreviousQuestion(-1),
              label: Text('retour',
                style: TextStyle(
                  fontSize: 12,
                ),),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6.0, bottom: 8.0),
          child: Visibility(
            visible: state.submitVisible,
            child: FloatingActionButton.extended(
              heroTag: "btn1",
              icon: Icon(
                Icons.check_circle_outlined,
            color: Colors.white,
              ),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              onPressed: () {
                // Fin du quiz
                ctrl.postAnswers();
                context.pushNamed(Urls.EvaluationFinalStep.name);
                // showDialog(
                //   context: context,
                //   builder: (context) => AlertDialog(
                //     title: Text("Fin de l'évaluation"),
                //     content:
                //         Text("Merci pour votre participation\n à la prochaine"),
                //     actions: [
                //       ElevatedButton(
                //         onPressed: () {
                //
                //           //ctrl.postAnswers();
                //         },
                //         child: Text('Quitter'),
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: Colors.green,
                //           foregroundColor: Colors.white,
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(4.0)),
                //         ),
                //       ),
                //     ],
                //   ),
                // );

              },
              label: Text('soumettre les résultats',
              style: TextStyle(
                fontSize: 12,
              ),),

            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6.0, bottom: 8.0),
          child: Visibility(
            visible: state.nextButtonVisible,
            child: FloatingActionButton.extended(
              heroTag: "btn2",
              icon: Icon(Icons.arrow_forward,
                color: Colors.white,),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              onPressed: (){
                ctrl.nextPreviousQuestion(1);
              },
              label: Text('suivant',
    style: TextStyle(
    fontSize: 12,
    ),),),
          ),
        ),
      ],
    );
  }



  _separateurOu() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10,),
          Expanded(
            child: Divider(
              color: Colors.grey,
              thickness: 1,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }



  _chargement(BuildContext context) {
    var state = ref.watch(evaluationCtrlProvider);
    return Visibility(
        visible: state.isLoading, child: CircularProgressIndicator());
  }
}