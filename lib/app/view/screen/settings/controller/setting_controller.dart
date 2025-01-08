import 'package:get/get.dart';

class SettingsController extends GetxController {
  var numberFormat = 'Automatic'.obs;
  var decimalPlaces = '123'.obs;

  void updateNumberFormat(String format) {
    numberFormat.value = format;
  }

  void updateDecimalPlaces(String places) {
    decimalPlaces.value = places;
  }
}
