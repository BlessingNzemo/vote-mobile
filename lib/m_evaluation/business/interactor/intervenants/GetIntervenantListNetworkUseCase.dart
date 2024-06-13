import '../../model/Vote/intervenants.dart';
import '../../services/evaluationLocalService.dart';
import '../../services/evaluationNetworkService.dart';

class GetIntervenantListNetworkUseCase{

  EvaluationNetworkService network;
  EvaluationLocalService local;

  GetIntervenantListNetworkUseCase(this.network, this.local);

  Future<List<Intervenants>?> run(int phaseId) async {
    var res = await network.getIntervenantList(phaseId);
    if(res != null){
      local.getIntervenantList();
    }
    return res;
  }
}