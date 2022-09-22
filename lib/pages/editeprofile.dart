import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/pages/anasayfa.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../apis/word_api.dart';
import '../fake-data/word_list.dart';
import '../firebase_islemleri/firenbase_islemleri.dart';
import '../models/word.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  String username = "";
  String email = "";
  String password = "";
  String newName = "";
  String newUsername = "";
  String newEmail = "";
  String newPassword = "";

  Future<void> veriOku() async {
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
      setState(() {
        email = alinanVeri["email"];
        name = alinanVeri["name"];
        username = alinanVeri["username"];
        password = alinanVeri["password"];
      });

      //TUTUCULARI GÖSTER
      Fluttertoast.showToast(
          msg: "email:" +
              email +
              " Ad:" +
              name +
              " Kullanıcı adı:" +
              username +
              " Şifre:" +
              password);
    });
  }

  nameAl(nameTutucu) {
    this.name = nameTutucu;
  }

  usernameAl(usernameTutucu) {
    this.username = username;
  }

  emailAl(String emailTutucu) {
    this.email = emailTutucu;
  }

  passwordAl(passwordTutucu) {
    this.password = passwordTutucu;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    veriOku();
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 30,
                          letterSpacing: 1.5,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width / 5,
                        height: MediaQuery.of(context).size.width / 5,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('images/indir.png'),
                            )),
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            StreamBuilder<Object>(
                stream:
                    FirebaseFirestore.instance.collection("Users").snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return TextFormField(
                      onChanged: (newusername) async {
                        newUsername = newusername;
                      },
                      controller: TextEditingController(text: username),

                      autofocus: true,
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(),
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
            StreamBuilder<Object>(
                stream:
                    FirebaseFirestore.instance.collection("Users").snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return TextFormField(
                      onChanged: (newname) async {
                        newName = newname;
                      },
                      controller: TextEditingController(text: name),
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
            StreamBuilder<Object>(
                stream:
                    FirebaseFirestore.instance.collection("Users").snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return TextFormField(
                      onChanged: (newemail) async {
                        newEmail = newemail;
                      },
                      controller: TextEditingController(text: email),
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
            StreamBuilder<Object>(
                stream:
                    FirebaseFirestore.instance.collection("Users").snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return TextFormField(
                      onChanged: (newpassword) async {
                        newPassword = newpassword;
                      },

                      obscureText: false,
                      controller: TextEditingController(text: password),
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        labelText: "password",
                        border: OutlineInputBorder(),
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                Update();
                veriOku();
              },
              child: const Text("Güncelle"),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
                shadowColor: Colors.redAccent,
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

/*
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
    print("asdasdsas");
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
*/

  Future<void> Update() async {
    await FirebaseFirestore.instance
        .doc("Users/${FirebaseAuth.instance.currentUser?.uid}")
        .set({
      "username": newUsername,
      "name": newName,
      "email": newEmail,
      "password": newPassword,
    }, SetOptions(merge: true));
  }

//     //veriyi güncelle
//     VeriGuncellemeYolu.update(guncellenecelVeri).whenComplete(() {
//       Fluttertoast.showToast(msg: email + "emailli kullanıcı değiştirildi.");
//     });
//   }
}
/*
Future<void> learnedWords() async {
  FirebaseAuth.instance.currentUser;
  Word kelime = Word();
  FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .set({
    "dailyUsage": 10,
    "uid": FirebaseAuth.instance.currentUser?.uid,
    "name": "name",
    "willLearn": "Kelimeler",
    "word": kelime.word,
    "definition": kelime.definition,
  }, SetOptions(merge: true));
}
*/

