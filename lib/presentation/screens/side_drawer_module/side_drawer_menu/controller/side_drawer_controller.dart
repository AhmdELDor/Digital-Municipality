import 'package:get/get.dart';
class SideDrawerController extends GetxController{
  var selectedDrawerIndex=0.obs;
  void drawerSelection(int index){
    selectedDrawerIndex.value=index;
  }

}