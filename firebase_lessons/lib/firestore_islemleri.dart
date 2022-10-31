import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_lessons/user_information.dart';
import 'package:flutter/material.dart';

class FireStoreIslemleri extends StatelessWidget {
  FireStoreIslemleri({super.key});
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription? _userSubscribe;

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
          ElevatedButton(
              onPressed: () {
                veriGuncelleme();
              },
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: Text("Veri Güncelleme")),
          ElevatedButton(
              onPressed: () {
                veriSilme();
              },
              style: ElevatedButton.styleFrom(primary: Colors.orange),
              child: Text("Veri Silme")),
          ElevatedButton(
              onPressed: () {
                veriOkuOneTime();
              },
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              child: Text("Veri Okuma One Time")),
          ElevatedButton(
              onPressed: () {
                veriOkuRealTime();
              },
              style: ElevatedButton.styleFrom(primary: Colors.pink),
              child: Text("Veri Okuma Real Time")),
          ElevatedButton(
              onPressed: () {
                dinlemeyiDurdur();
              },
              style: ElevatedButton.styleFrom(primary: Colors.cyanAccent),
              child: Text("Dinlemeyi Durdur")),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UserInformation()));
              },
              style: ElevatedButton.styleFrom(primary: Colors.amberAccent),
              child: Text("Veriyi Arayüzde Getir")),
          ElevatedButton(
              onPressed: () {
                batchKavrami();
              },
              style: ElevatedButton.styleFrom(primary: Colors.indigo),
              child: Text("Batch Kavramı")),
          ElevatedButton(
              onPressed: () {
                transactionKavrami();
              },
              style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
              child: Text("Transaction Kavramı")),
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

  void veriGuncelleme() async {
    await firestore
        .doc('users/WHvdTgIV6mMka9GmTi7r')
        .update({'adres.il': 'Antep'});

    await firestore
        .collection('cities')
        .doc('LA')
        .update({'country': 'Türkiye'});
  }

  void veriSilme() async {
    await firestore.doc('users/XeMOL8yIcPD8SXo1ve2t').delete();

    await firestore
        .doc('users/sQbDxGXmJcSmrdhYY409')
        .update({'isim': FieldValue.delete()});
  }

  void veriOkuOneTime() async {
    var _userDocuments = await firestore.collection('users').get();
    debugPrint(_userDocuments.size.toString());
    debugPrint(_userDocuments.docs.length.toString());
    for (var eleman in _userDocuments.docs) {
      debugPrint("Döküman id ${eleman.id}");
      Map userMap = eleman.data();
      debugPrint(userMap['isim']);
      debugPrint(userMap['ogrenciMi'].toString());
      debugPrint(userMap['yas'].toString());
    }
  }

  void veriOkuRealTime() {
    var _userDocStream =
        firestore.doc('users/WHvdTgIV6mMka9GmTi7r').snapshots();
    _userSubscribe = _userDocStream.listen((event) {
      debugPrint(event.data().toString());
    });
  }

  Future<void> dinlemeyiDurdur() async {
    await _userSubscribe?.cancel();
  }

  Future<void> batchKavrami() async {
    WriteBatch _batch = firestore.batch();
    CollectionReference _counterColRef = firestore.collection('counter');

    //Batch ile Ekleme İşlemleri

    // for (int i = 0; i < 100; i++) {
    //   var _yeniDoc = _counterColRef.doc();
    //   _batch.set(_yeniDoc, {'sayac': ++i, 'id': _yeniDoc.id});
    // }

    //Batch ile Toplu Güncelleme İşlemleri

    // var _counterDocs = await _counterColRef.get();
    // _counterDocs.docs.forEach((element) {
    //   _batch.update(
    //       element.reference, {'createdAt': FieldValue.serverTimestamp()});
    // });

    //Batch ile Toplu Silme İşlemleri

    // var _counterDocs = await _counterColRef.get();
    // _counterDocs.docs.forEach((element) {
    //   _batch.delete(element.reference);
    // });

    await _batch.commit();
  }

  transactionKavrami() async {
    firestore.runTransaction((transaction) async {
      //ayhanın bakiyesini öğrenelim
      //ayhandan 100 lira düşelim(WHvdTgIV6mMka9GmTi7)
      //selim e 100 lira ekleyelim (fbpkmfgX1hQDO9jvHpIX)

      DocumentReference<Map<String, dynamic>> ayhanRef =
          firestore.doc('bakiye/ayhan');

      DocumentReference<Map<String, dynamic>> selimRef =
          firestore.doc('bakiye/selim');

      var ayhanSnapshot = await transaction.get(ayhanRef);
      //var selimSnapshot = await transaction.get(selimRef);
      var _ayhanBakiye = ayhanSnapshot.data()!['para'];
      debugPrint(_ayhanBakiye);
      if (_ayhanBakiye > 100) {
        var _ayhanYeniBakiye = _ayhanBakiye - 100;
        transaction.update(ayhanRef, {'para': _ayhanYeniBakiye});
        transaction.update(selimRef, {'para': FieldValue.increment(100)});
      }
    });
  }
}
