import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  var emailid = ''.obs;
}
