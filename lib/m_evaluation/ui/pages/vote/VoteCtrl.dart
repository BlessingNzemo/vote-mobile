import 'package:odc_mobile_project/m_evaluation/business/model/Vote/createVoteRequest.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../business/interactor/EvaluationInteractor.dart';
import '../../../business/model/intervenants.dart';
import 'VoteState.dart';

part "VoteCtrl.g.dart";

@riverpod
class VoteCtrl extends _$VoteCtrl {
  @override
  VoteState build() {
    return VoteState();
  }

  recupererCriteres(int phaseId) async {
    state = state.copywith(isLoading: true);
    var usecase = ref
        .watch(evaluationInteractorProvider)
        .getCritereListByPhaseNetworkUseCase;
    var res = await usecase.run(phaseId);
    if (res != null) {
      state = state.copywith();
      Map<String, double> criteresValues = {};
      for (var critere in res) {
        criteresValues[critere.critere.id.toString()] = 0.0;
      }
      print("criteresValues $criteresValues");
      state = state.copywith(valeurs: criteresValues, criteres: res);
    }
    state = state.copywith(isLoading: false);
  }

  void onSliderChanged(int critereId, double value, int intervenantId) async {
    // print("state.valeurs ${state.valeurs}");
    var valeurs = state.valeurs;
    // print("valeurs 0 $valeurs");
    valeurs["$critereId"] = value;
    // print("$critereId : valeur $value");
    // print(value.runtimeType);
    print("intervenantID: $intervenantId ===> valeurs 1 $valeurs");
    state = state.copywith(valeurs: valeurs, criteres: state.criteres);
    var useCase = ref
        .watch(evaluationInteractorProvider)
        .saveVoteLocalUseCase;
    useCase.run(intervenantId, valeurs);
  }

  void setCandidat(Intervenants intervenant) {
    state = state.copywith(phaseVoteIntervenants: intervenant);
    print("CANDIDAT: ${state.phaseVoteIntervenants?.id}");
  }

  void checkVote(int intervenantId) async {
    var useCase = ref
        .watch(evaluationInteractorProvider)
        .getVoteByIntervenantLocalUseCase;
    var res = await useCase.run(intervenantId);
    if (res != null) {
      print("valeurs updated for $intervenantId ==> $res");
      state = state.copywith(valeurs: res);
    }
  }

   resetVoteValue() async {
    var useCase = ref.watch(evaluationInteractorProvider).resetVoteValueLocalUseCase;
    useCase.run();
  }

   sendVoteResulats(int intervenantId,int phaseId ) async {
    var getJuryLocalUseCase = ref.watch(evaluationInteractorProvider).getJuryLocalUseCase;
    var juryLocal=await getJuryLocalUseCase.run();
    var useCase = ref.watch(evaluationInteractorProvider).sendVoteByCandidatNetworkUseCase;
    var cotes = state.valeurs.entries
        .map((entry) => {"critere_id": int.parse(entry.key) , "valeur":entry.value})
        .toList();
    var store = {
      "intervenant_id": intervenantId,
      "phase_id": phaseId,
      "nombre_user": juryLocal?.nombre_user?? 0,
      "cote": cotes,
    };
    var data = CreateVoteRequest.fromJson(store) ;
    print("data ${data.toJson()}");
    var res = await useCase.run(data);
    print("res $res");
    state = state.copywith(isVoteSend: true);
    print(res);
  }
}
