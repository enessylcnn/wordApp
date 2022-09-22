import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void veriOku() {
  DocumentReference veriOkumaYolu =
      //Veri Yolu ekle
      FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser?.uid);

//veriyi al alinan değere aktar
  veriOkumaYolu.get().then((alinanInfo) {
    print(FirebaseAuth.instance.currentUser?.uid);
    //çoklu veriyi mape aktar
    //Alinan değerdeki verileri alinan veri olarak mape aktar
    Map<String, dynamic>? alinanVeri =
        alinanInfo.data() as Map<String, dynamic>;
    //Alinan verideki alanlar tutuculara aktar
    String email = alinanVeri["email"];
    String name = alinanVeri["name"];
    String username = alinanVeri["username"];
    String password = alinanVeri["password"];

    //TUTUCULARI GÖSTER
    Fluttertoast.showToast(
        msg: "email" +
            email +
            " Ad:" +
            name +
            " Kullanıcı adı:" +
            username +
            " Şifre" +
            password);
  });
}

//firebase veri güncelleyecek
void veriGuncelle(String name, String username, String email, String password) {
  //Veri yolu
  DocumentReference veriGuncellemeYolu = FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser?.uid);

  //çoklu veri mapi

  Map<String, dynamic> guncellenecekVeri = {
    "username": username,
    "name": name,
    "email": email,
    "password": password,
  };

  //veriyi güncelle
  veriGuncellemeYolu.update(guncellenecekVeri).whenComplete(() {
    Fluttertoast.showToast(msg: "Verileriniz güncellendi..");
  });
}

//late String word, definition;
/*void wordAdd() {
//veri yolu ekleme
  DocumentReference veriYolu = FirebaseFirestore.instance
      .collection("Word")
      .doc(FirebaseAuth.instance.currentUser?.uid);
  //Çoklu veri için map
  Map<String, dynamic> words = {
    "Word": word,
    "Definition": definition,
    "uid": FirebaseAuth.instance.currentUser?.uid,
  };
  //Veriyi veri tabanına ekle
  veriYolu.set(words).whenComplete(() =>
      {Fluttertoast.showToast(msg: word + "Kullanıcıya wordlist eklendi")});
}
*/
var _formAnahtari = GlobalKey<FormState>();
Future<void> KelimeEkle() async {
  if (_formAnahtari.currentState!.validate()) {
    ((user) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({});

      // FirebaseFirestore.instance.collection("users").doc().set({
      //   "email": email,
      //   "username": username,
      //   "password": sifre,
      //   "name": name
      // });
    });
  }
}
