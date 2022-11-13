import 'package:client/main.dart';
import 'package:client/view/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'dart:developer' as dev;

class TenderAddScreen extends StatefulWidget {
  const TenderAddScreen({Key? key}) : super(key: key);

  @override
  State<TenderAddScreen> createState() => _TenderAddScreenState();
}

class _TenderAddScreenState extends State<TenderAddScreen> {
  List<String> skills = [];

  final Map<String, dynamic> map = {
    "title": TextEditingController(),
    "description": TextEditingController(),
    "budget": TextEditingController(),
    "projectDomain": TextEditingController()
  };

  FirebaseFirestore instance = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                      'title': map['title']!.text,
                      "description": map['description']!.text,
                      "budget": map['budget']!.text,
                      "projectDomain": map['projectDomain']!.text,
                    },
                  );
                  // }
                  dev.log("added", name: "TenderViewScreen");
                },
                child: const Text('Add Tender'))
          ],
        ),
      ),
    );
  }
}
