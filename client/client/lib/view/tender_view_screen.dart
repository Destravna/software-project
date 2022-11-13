import 'dart:io';

import 'package:client/controller/auth_controller.dart';
import 'package:client/main.dart';
import 'package:client/view/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class TenderViewScreen extends StatefulWidget {
  final String? tenderCreator;
  final String? budget;
  final String? description;
  final String? domain;
  final String? title;
  final String? tenderId;

  const TenderViewScreen(
      {super.key,
      this.tenderId,
      this.tenderCreator,
      this.budget,
      this.description,
      this.domain,
      this.title});

  @override
  State<TenderViewScreen> createState() => _TenderViewScreenState();
}

class _TenderViewScreenState extends State<TenderViewScreen> {
  FirebaseFirestore instance = FirebaseFirestore.instance;

  final TextEditingController tenderCost = TextEditingController();
  final TextEditingController descritpion = TextEditingController();
  final TextEditingController experience = TextEditingController();

  AuthController controller = Get.put(AuthController());
  bool isFilePicked = false;

  String fileName = "";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Project Name : ${widget.title!}",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 20),
                Text(
                  "Organization Member : ${widget.tenderCreator!}",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(
                  "Budget : ${widget.budget!}",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                Text(
                  "Description : ${widget.description!}",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () {
                      //add the bid
                      showDialog(
                        context: context,
                        builder: (ctx) => SizedBox(
                          child: AlertDialog(
                            content: StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  children: [
                                    CustomTextField(
                                      hintText: "Tender Cost",
                                      editingController: tenderCost,
                                      width: 300,
                                      hasSuffixIcon: false,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextField(
                                      hintText: "Experience",
                                      editingController: experience,
                                      width: 300,
                                      hasSuffixIcon: false,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextField(
                                      hintText: "Description",
                                      editingController: descritpion,
                                      width: 300,
                                      hasSuffixIcon: false,
                                    ),
                                    const SizedBox(height: 16),
                                    if (!isFilePicked)
                                      ElevatedButton(
                                          onPressed: () async {
                                            //pick file
                                            try {
                                              FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles();

                                              if (result != null) {
                                                setState(() {
                                                  isFilePicked = true;
                                                  fileName =
                                                      result.files.single.name;
                                                });
                                                File file = File(
                                                    result.files.single.path!);

                                                // Reference ref = FirebaseStorage.instance
                                                //     .ref()
                                                //     .child('tender')
                                                //     .child(widget.tenderId!)
                                                //     .child('documents');

                                                // ref.putFile(file);

                                                //now upload this file to firebase storage
                                              } else {
                                                // User canceled the picker
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Could not upload file "),
                                                  backgroundColor: Colors.red,
                                                ));
                                              }
                                            } catch (err) {}
                                          },
                                          child: Text("Upload Documents")),
                                    if (isFilePicked) Text(fileName),
                                    Spacer(),
                                    ElevatedButton(
                                        onPressed: () {
                                          instance
                                              .collection('tender')
                                              .doc(widget.tenderId)
                                              .collection('bidders')
                                              .doc(controller.emailid.value)
                                              .set({
                                            "fileName": fileName,
                                            "bidder": controller.emailid.value,
                                            "budget": tenderCost.text,
                                            "description": descritpion.text,
                                            "experience": experience.text,
                                            "acceptedBid": false,
                                            "tenderCreator":
                                                controller.emailid.value
                                          });

                                          Navigator.of(context).pop();

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text("Bid added successfully"),
                                            backgroundColor: Colors.green,
                                          ));
                                        },
                                        child: Text("Submit"))
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text("Bid"))
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "Bidders",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: instance
                          .collection('tender')
                          .doc(widget.tenderId!)
                          .collection('bidders')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (ctx, index) {
                                return Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${snapshot.data!.docs[index]['description']}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${snapshot.data!.docs[index]['bidder']}',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Budget : ₹${snapshot.data!.docs[index]['budget']}',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Experience : ₹${snapshot.data!.docs[index]['experience']}',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 8),
                                        if (widget.tenderCreator ==
                                            controller.emailid.value)
                                          ElevatedButton(
                                              onPressed: () {
                                                instance
                                                    .collection('tender')
                                                    .doc(widget.tenderId)
                                                    .collection('bidders')
                                                    .doc(snapshot.data!
                                                        .docs[index]['bidder'])
                                                    .update({
                                                  "acceptedBid": true,
                                                });
                                              },
                                              child: Text('Accept Offer')),
                                        if (widget.tenderCreator !=
                                                controller.emailid.value &&
                                            snapshot.data!.docs[index]
                                                ['acceptedBid'])
                                          ElevatedButton(
                                              onPressed: () {
                                                instance
                                                    .collection('tender')
                                                    .doc(widget.tenderId)
                                                    .collection('bidders')
                                                    .doc(snapshot.data!
                                                        .docs[index]['bidder'])
                                                    .update({
                                                  "acceptedBid": true,
                                                });
                                              },
                                              child: Text(
                                                  'Offer Accepted by Tender Organization')),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
