import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:odc_mobile_project/m_evaluation/ui/composants/CircularWidget.dart';

import '../../../../navigation/routers.dart';
import '../../composants/ListeVide.dart';
import 'intervenantCtrl.dart';

class IntervenantPage2 extends ConsumerStatefulWidget {
  final int phaseId;

  const IntervenantPage2({super.key, required this.phaseId});

  @override
  ConsumerState<IntervenantPage2> createState() => _IntervenantState2();
}

class _IntervenantState2 extends ConsumerState<IntervenantPage2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var ctrl = ref.read(intervenantCtrlProvider.notifier);
      ctrl.recupererListIntervenant(widget.phaseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(intervenantCtrlProvider);
    var phaseId = widget.phaseId;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Stack(children: [
          if (state.intervenantsOrigin.isEmpty && !state.isLoading)
            ListeVide(context, () {
              var ctrl = ref.read(intervenantCtrlProvider.notifier);
              ctrl.recupererListIntervenant(phaseId);
            })
          else
            _contenuPrincipale(context, ref),
          _chargement(context, ref),
        ])),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(
          margin: EdgeInsets.only(left: 7, right: 0, top: 3, bottom: 2),
          child: IconButton(
            onPressed: () {
              context.goNamed(Urls.phases.name);
            },
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Color(0xffFF7900).withOpacity(0.8),
          ),
        ),
        title: Text("Progression"),
        centerTitle: true,
      ),
    );
  }

  _contenuPrincipale(BuildContext context, WidgetRef ref) {
    var state = ref.watch(intervenantCtrlProvider);
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(135, 0, 0, 0),
                    width: 300,
                    height: 200,
                    child: Center(
                      child: Image.asset(
                        "images/x.png",
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 300, 0, 0),
                    width: 300,
                    height: 200,
                    child: Center(
                      child: Image.asset(
                        "images/x.png",
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(135, 700, 0, 0),
                    width: 300,
                    height: 200,
                    child: Center(
                      child: Image.asset(
                        "images/x.png",
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 2,
                        sigmaY: 2,
                      ),
                      child: SizedBox(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    width: double.infinity,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              suffixIcon: Icon(Icons.search),
                              hintText: 'Enter Email',
                            ),
                            onChanged: (value) {
                              var ctrl =
                                  ref.read(intervenantCtrlProvider.notifier);
                              ctrl.rechercherIntervenant(value);
                              print(value);
                            },
                          ),
                        ]),
                  ),
                  Container(
                    height: 200,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 70),
                    child: Row(
                      children: [
                        CircularWidget(onValueChanged: (double newValue ) {
                        }, value: 0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffFF7900).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 150,
                          height: 40,
                          margin: EdgeInsets.fromLTRB(30, 0, 0, 80),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${state.intervenants.length} candidates",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 620,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 220),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Center(
                        child: ListView.separated(
                      separatorBuilder: (ctx, index) {
                        return Divider(
                          thickness: 1,
                        );
                      },
                      itemCount: state.intervenants.length,
                      itemBuilder: (context, index) {
                        var intervenant = state.intervenants[index];

                        return SingleChildScrollView(
                          child: Card(
                            child: ListTile(
                              leading: Icon(Icons.person),
                              trailing: intervenant.isDone
                                  ? Icon(Icons.check, color: Colors.green)
                                  : Icon(Icons.check_box_outline_blank),
                              onTap: () async {
                                var res = await context
                                    .pushNamed<bool>(Urls.vote.name, pathParameters: {
                                  "phaseId": widget.phaseId.toString(),
                                  "intervenantId":
                                      intervenant.intervenantId.toString()
                                });

                                if(res != null){
                                  var ctrl=ref.read(intervenantCtrlProvider.notifier);
                                  ctrl.updateIntervenantStatus(intervenant.intervenantId, res);
                                }
                              },
                              title: Text(intervenant.email),
                            ),
                          ),
                        );
                      },
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _chargement(BuildContext context, WidgetRef ref) {
    var state = ref.watch(intervenantCtrlProvider);
    return Visibility(
        visible: state.isLoading,
        child: Center(child: CircularProgressIndicator()));
  }


}
