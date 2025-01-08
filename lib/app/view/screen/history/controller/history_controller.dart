import 'package:get/get.dart';

import '../../../../component/toast/app_toast.dart';
import '../../../../core/app_string.dart';
import '../../../../model/emi_result_model.dart';
import '../../../../utils/local_store/sql_helper.dart';

class HistoryController extends GetxController {
  var advanceEmi = <CalculateResult>[].obs;
  final dbHelper = DbHelper.instance;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    await getLoanData();
  }

  Future<void> getLoanData() async {
    try {
      final List<Map<String, dynamic>>? loanData =
          await dbHelper.queryAll(SqlTableString.advanceEmiTable);
      if (loanData != null) {
        advanceEmi.assignAll(
            loanData.map((data) => CalculateResult.fromJson(data)).toList());
        update();
      }
    } catch (e) {
      showToast("Error fetching loan data: $e");
    }
  }

  Future<void> deleteAllData() async {
    await dbHelper.deleteAllData(SqlTableString.advanceEmiTable);
    await fetchData();
  }

  Future<void> deleteData(int id) async {
    await dbHelper.deleteQuery(
        SqlTableString.advanceEmiTable, id, SqlTableString.dbId);
    await fetchData();
  }
}
