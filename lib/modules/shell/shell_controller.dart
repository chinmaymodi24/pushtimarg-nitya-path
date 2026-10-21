import 'package:get/get.dart';

class ShellController extends GetxController {
  final index = 0.obs;
  void go(int i) => index.value = i;
}
