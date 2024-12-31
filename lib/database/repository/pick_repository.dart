import '../dao/pick_dao.dart';
import '../model/pick_model.dart';

class PickRepository {
  final PickDao _dao = PickDao();

  // CREATE
  Future<int> insertPick(PickModel pick) async {
    return await _dao.insertPick(pick);
  }

  // READ (전체)
  Future<List<PickModel>> getAllPicks() async {
    return await _dao.getAllPicks();
  }

  // READ (단일)
  Future<PickModel?> getPickById(int id) async {
    return await _dao.getPickById(id);
  }

  // UPDATE
  Future<int> updatePick(PickModel pick) async {
    return await _dao.updatePick(pick);
  }

  // DELETE (단일)
  Future<int> deletePick(int id) async {
    return await _dao.deletePick(id);
  }

  // DELETE (전체)
  Future<int> deleteAllPicks() async {
    return await _dao.deleteAllPicks();
  }

  // 특정 이름으로 삭제
  Future<int> deletePickByName(String name) async {
    return await _dao.deleteByName(name);
  }

  // 특정 이름을 새 이름으로 업데이트
  Future<int> updatePickName(String oldName, String newName) async {
    return await _dao.updateName(oldName, newName);
  }
}
