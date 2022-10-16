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
  }
}
