import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreIslemleri extends StatelessWidget {
  FireStoreIslemleri({super.key});
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore'),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                veriEklemeAdd();
              },
              child: Text("Veri Ekle Add")),
        ],
      )),
    );
  }

  void veriEklemeAdd() async {
    Map<String, dynamic> _eklenecekUser = <String, dynamic>{};
    _eklenecekUser['isim'] = 'yakup';
    _eklenecekUser['yas'] = 16;
    _eklenecekUser['ogrenciMi'] = false;
    _eklenecekUser['adres'] = {'il': 'Antep', 'ilce': 'Merkez'};
    _eklenecekUser['hobiler'] =
        FieldValue.arrayUnion(['Soytarılık', 'Densizlik']);
    _eklenecekUser['olusmaTarihi'] = FieldValue.serverTimestamp();

    await firestore.collection('users').add(_eklenecekUser);

    final city = <String, String>{
      "name": "Los Angeles",
      "state": "CA",
      "country": "USA"
    };

    await firestore
        .collection("cities")
        .doc("LA")
        .set(city)
        .onError((e, _) => debugPrint("Error writing document: $e"));

    final data = {"capital": true};

    await firestore
        .collection("cities")
        .doc("LA")
        .set(data, SetOptions(merge: true));

    final docData = {
      "stringExample": "Hello world!",
      "booleanExample": true,
      "numberExample": 3.14159265,
      "dateExample": Timestamp.now(),
      "listExample": [1, 2, 3],
      "nullExample": null
    };

    final nestedData = {
      "a": 5,
      "b": true,
    };

    docData["objectExample"] = nestedData;

    await firestore
        .collection("data")
        .doc("dataTipleri")
        .set(docData)
        .onError((e, _) => debugPrint("Error writing document: $e"));
  }
}
