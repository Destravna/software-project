import 'dart:html';
import 'dart:math';

import 'package:client/controller/auth_controller.dart';
import 'package:client/utils.dart';
import 'package:client/view/dashboard.dart';
import 'package:client/view/tender_add_screen.dart';
import 'package:client/view/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:developer' as dev;

import 'package:get/get.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Map<String, TextEditingController> mapper = {};

  

  List<String> controllers = [
    "emailController",
    "passwordController",
    "firstNameController",
    "lastNameController"
  ];

  double len = 200;
  bool loginButtonPressed = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthController controller = Get.put(AuthController());
  bool loginProcessing = false;

  void editingControllerSetup() {
    for (var element in controllers) {
      mapper[element] = TextEditingController();
    }
  }

  String showAccountText() {
    return loginButtonPressed ? "Login to your account" : "Create new account";
  }

  @override
  void initState() {
    super.initState();
    editingControllerSetup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                    height: 40,
                    width: 40,
                    child: Image.network(
                        "https://i.ibb.co/L9mKFjW/iconscout-logo-1024x1024.png")),
                const SizedBox(width: 16),
                const Text("Tender Software",
                    style: TextStyle(fontSize: 20, color: Colors.white))
              ],
            ),
            const SizedBox(height: 80),
            const Text(
              "Start bidding on projects",
              style: TextStyle(color: Colors.white, letterSpacing: 1.2),
            ),
            const SizedBox(height: 16),
            Text(
              showAccountText(),
              style:
                  TextStyle(color: niceWhite, letterSpacing: 1.2, fontSize: 34),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  loginButtonPressed
                      ? "Sign up for a new account"
                      : "Already a member ?",
                  style: TextStyle(color: niceWhite),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        loginButtonPressed = !loginButtonPressed;
                      });
                    },
                    child: Text(loginButtonPressed ? "Sign Up" : "Login"))
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              // decoration: BoxDecoration(color: Colors.red),
              width: 600,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!loginButtonPressed)
                    Row(
                      children: [
                        CustomTextField(
                          textStyle: TextStyle(color: Colors.white),
                          hasSuffixIcon: false,
                          width: 200,
                          editingController: mapper["firstNameController"],
                          hintText: "First name",
                          prefixIcon: const Icon(
                            Icons.contacts,
                            color: niceWhite,
                          ),
                        ),
                        const SizedBox(width: 40),
                        CustomTextField(
                          textStyle: TextStyle(color: Colors.white),
                          hasSuffixIcon: false,
                          prefixIcon: const Icon(
                            Icons.contacts,
                            color: niceWhite,
                          ),
                          width: 200,
                          editingController: mapper["lastNameController"],
                          hintText: "Last name",
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    textStyle: TextStyle(color: Colors.white),
                    hasSuffixIcon: false,
                    prefixIcon: const Icon(
                      Icons.alternate_email_outlined,
                      color: niceWhite,
                    ),
                    width: 440,
                    editingController: mapper["emailController"],
                    hintText: "Email id",
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    textStyle: TextStyle(color: Colors.white),
                    multiLine: 1,
                    hasSuffixIcon: true,
                    prefixIcon: const Icon(
                      Icons.password,
                      color: niceWhite,
                    ),
                    width: 440,
                    editingController: mapper["passwordController"],
                    hintText: "Password",
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 40,
                    width: 440,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16))),
                        onPressed: () async {
                          if (loginButtonPressed) {
                            await loginProcess(
                                context,
                                mapper['emailController']!.text,
                                mapper['passwordController']!.text);
                          } else {
                            await signUpProcess(
                              context: context,
                            );
                          }
                        },
                        child: !loginProcessing
                            ? Text(
                                loginButtonPressed ? "Log in" : "Sign Up",
                                style: TextStyle(fontSize: 20),
                              )
                            : CircularProgressIndicator()),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> signUpProcess(
      {BuildContext? context,
      String? emailId,
      String? password,
      String? firstName,
      String? lastName}) async {
    try {
      firestore.collection('users').doc(mapper['emailController']!.text).set({
        'emailId': mapper['emailController']!.text,
        "password": mapper['passwordController']!.text,
        "firstName": mapper['firstNameController']!.text,
        "lastName": mapper['lastNameController']!.text
      });

      controller.emailid.value = mapper['emailController']!.text;

      Navigator.of(context!)
          .push(MaterialPageRoute(builder: (context) => DashBoardView()));
    } catch (err) {
      dev.log(err.toString(), name: "errorAuth");

      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          content: Text("Error creating user account")));
    }
  }

  Future<void> loginProcess(
      BuildContext context, String emailId, String password) async {
    try {
      setState(() {
        loginProcessing = true;
      });

      DocumentSnapshot<Map<String, dynamic>> docShot =
          await firestore.collection("users").doc(emailId).get();

      if (docShot.data()!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            content: Text("UserId Doesn't exist")));
      }

      Map<String, dynamic>? data = docShot.data();

      //check if email is correct
      if (data!['emailId'] != mapper['emailController']!.text ||
          data["password"] != mapper['passwordController']!.text) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            content: Text("Failed Login")));

        setState(() {
          loginProcessing = false;
        });
      } else {
        controller.emailid.value = mapper['emailController']!.text;

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DashBoardView()));
      }
      setState(() {
        loginProcessing = false;
      });
    } catch (err) {
      dev.log(err.toString(), name: "errorAuth");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          content: Text("User Id Doesn't exist")));
    }
  }
}
