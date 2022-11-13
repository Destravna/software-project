import 'package:client/view/tender_view_screen.dart';
import 'package:client/view/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'dart:developer' as dev;

import 'package:get/get.dart';

import '../controller/auth_controller.dart';

class DashBoardView extends StatefulWidget {
  const DashBoardView({Key? key}) : super(key: key);

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  bool addTenderisPressed = false;
  List<String> skills = [];

  PageController scrollController = PageController();

  final Map<String, dynamic> map = {
    "title": TextEditingController(),
    "description": TextEditingController(),
    "budget": TextEditingController(),
    "projectDomain": TextEditingController()
  };

  FirebaseFirestore instance = FirebaseFirestore.instance;

  AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Row(children: [
            const Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black),
                backgroundColor: MaterialStateProperty.all(
                    !addTenderisPressed ? Colors.blue : Colors.white),
              ),
              onPressed: () {
                setState(() {
                  addTenderisPressed = false;
                });
                scrollController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.bounceOut);
              },
              child: Text("Explore Tenders"),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black),
                backgroundColor: MaterialStateProperty.all(
                    addTenderisPressed ? Colors.blue : Colors.white),
              ),
              onPressed: () {
                setState(() {
                  addTenderisPressed = true;
                });

                scrollController.nextPage(
                    duration: Duration(seconds: 1), curve: Curves.bounceInOut);
              },
              child: Text("Add Tender"),
            ),
            const Spacer()
          ]),
          const SizedBox(height: 16),
          Expanded(
            child: PageView(
              controller: scrollController,
              children: [
                SizedBox(
                  height: 500,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: instance.collection('tender').snapshots(),
                    builder: (ctx,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) {
                            return ListTile(
                              onTap: () {
                                //navigate to the view tender page

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => TenderViewScreen(
                                          tenderId:
                                              snapshot.data!.docs[index].id,
                                          title: snapshot.data!.docs[index]
                                              ["title"],
                                          budget: snapshot.data!.docs[index]
                                              ["budget"],
                                          description: snapshot
                                              .data!.docs[index]["description"],
                                          domain: snapshot.data!.docs[index]
                                              ["projectDomain"],
                                          tenderCreator: snapshot.data!
                                              .docs[index]["tenderCreator"],
                                        )));
                              },
                              tileColor: Colors.greenAccent,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${snapshot.data!.docs[index]["title"]}")
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (ctx, index) {
                            return const SizedBox(height: 16);
                          },
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),

                //this child shows how to add the tenders only and nothing else
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Add Tender ',
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        editingController: map["title"],
                        hasSuffixIcon: false,
                        hintText: "Title",
                        inputType: TextInputType.text,
                        width: 200,
                        textStyle: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        editingController: map["description"],
                        hasSuffixIcon: false,
                        hintText: "Description",
                        inputType: TextInputType.text,
                        width: 400,
                        multiLine: 5,
                        textStyle: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        editingController: map["budget"],
                        hasSuffixIcon: false,
                        hintText: "Budget",
                        inputType: TextInputType.text,
                        width: 200,
                        // multiLine: 5,
                        textStyle: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        editingController: map["projectDomain"],
                        hasSuffixIcon: false,
                        hintText: "Domain",
                        inputType: TextInputType.text,
                        width: 200,
                        // multiLine: 5,
                        textStyle: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          // if (map['title']!.text.length != 0) {
                          instance.collection("tender").add(
                            {
                              "tenderCreator": controller.emailid.value,
                              'title': map['title']!.text,
                              "description": map['description']!.text,
                              "budget": map['budget']!.text,
                              "projectDomain": map['projectDomain']!.text,
                            },
                          );
                          // }
                          dev.log("added", name: "TenderViewScreen");

                          //also show to messange
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Tender Has Been Added"),
                            backgroundColor: Colors.green,
                          ));
                        },
                        child: const Text('Add Tender'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
