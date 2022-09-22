import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/models/word.dart';
import 'package:firebase_authentication/models/word_list_model.dart';
import 'package:firebase_authentication/pages/word_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../apis/word_api.dart';
import '../fake-data/word_list.dart';
import 'editeprofile.dart';
import 'girisekrani.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _LearnedWords();
}

class _LearnedWords extends State<MainPage> {
  List<Word> words = [];

  List<dynamic> willLearnMapList = [];
  List<dynamic> learnedWordsMapList = [];
  List<Word> willLearn = [];
  List<Word> learnedWords = [];
  bool isProgress = true;
  bool sayacControl = false;
  int index = 0;
  int sayi = 0;
  int sayac = 0;

  Future<void> _init() async {
    try {
      await FirebaseFirestore.instance
          .collection('willLearn')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((alinanDeger) {
        Map<String, dynamic>? alinanVeri = alinanDeger.data();

        //  wordList = WordListModel.fromMap(alinanVeri!['willLearn']);
        willLearnMapList = alinanVeri!['willLearn'];
        learnedWordsMapList = alinanVeri['learnedWords'];
      }).catchError((error) {
        debugPrint(error.toString());
      }).then((value) {
        for (int i = 0; i < willLearnMapList.length; i++) {
          willLearn.add(Word.fromMap(willLearnMapList[i]));
        }
        for (int i = 0; i < learnedWordsMapList.length; i++) {
          learnedWords.add(Word.fromMap(learnedWordsMapList[i]));
        }
      });
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((alinanVeri) async {
        sayac = alinanVeri["sayac"];
      });
      // ignore: empty_catches
    } catch (e) {
    } finally {
      setState(() {
        isProgress = false;
      });
    }
  }

  @override
  void didChangeDependencies() async {
    await _init();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("MainPage"),
          centerTitle: true,

          /*IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
          icon: const Icon(Icons.account_circle),
        ), */
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((user) {
                  //Çıkış yaptıktan sonra giriş sayfasına git
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => GirisEkrani()),
                      (route) => false);
                });
              },
              icon: const Icon(Icons.exit_to_app),
            )
          ],
        ),
        drawer: Drawer(
          child: Container(
            width: 50,
            color: Color.fromARGB(255, 15, 175, 255),
            child: ListView(
              children: [
                const DrawerHeader(
                  child: Center(
                    child: Text(
                      "Home",
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                ListTile(
                    leading: Icon(Icons.account_circle),
                    title: const Text(
                      "Profile",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfilePage()));
                    }),
                ListTile(
                    leading: Icon(Icons.account_circle),
                    title: const Text(
                      "Learned Words",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => WordListView()));
                    })
              ],
            ),
          ),
        ),
        body: isProgress
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /*Text(
                  willLearn[sayi].index.toString(),
                  // Expanded(child: listViewAera(index)),
                ),*/
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                    child: Card(
                      color: Color.fromARGB(255, 220, 231, 255),
                      child: SizedBox(
                        width: 350,
                        height: 400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(100.0),
                              child: Text(
                                willLearn[sayi].word.toString(),
                                style: TextStyle(
                                    fontSize: 40, color: Colors.black),
                                // Expanded(child: listViewAera(index)),
                              ),
                            ),
                            Text(
                              willLearn[sayi].definition.toString(),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black),
                              // Expanded(child: listViewAera(index)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 140, 0),
                        child: ElevatedButton(
                            style: ButtonStyle(),
                            onPressed: () {
                              _init();

                              if (sayac > 0) {
                                if (willLearn[sayi].index! >= 30) {
                                  sayi = 0;
                                }
                                setState(() {
                                  if (sayac > 0) {
                                    sayi++;
                                    SayacDusur();
                                  }
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Hakkınız Bitmiştir!!.");
                              }
                            },
                            child: Text("Remind me later")),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (sayac > 0) {
                              SayacDusur();
                              if (willLearn[sayi].index! >= 30) {
                                sayi = 0;
                              }
                              learnedWords.add(willLearn[sayi]);
                              willLearn.remove(willLearn[sayi]);
                              addFirebase(willLearn, learnedWords);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Hakkınız Bitmiştir!!.");
                            }
                          },
                          child: const Text("Learned")),
                    ],
                  ),
                ],
              ));
  }

  Future<void> addFirebase(
      List<Word> willLearn, List<Word> learnedWords) async {
    List<Word> x = willLearn;
    List<Word> y = learnedWords;
    List<Map> willLearnMapList = [];
    List<Map> learnedWordsMapList = [];
    for (int i = 0; i < x.length; i++) {
      willLearnMapList.add(x[i].toMap());
    }
    for (int i = 0; i < y.length; i++) {
      learnedWordsMapList.add(y[i].toMap());
    }
    FirebaseFirestore.instance
        .doc("willLearn/${FirebaseAuth.instance.currentUser?.uid}")
        .update({"willLearn": willLearnMapList});

    FirebaseFirestore.instance
        .doc("willLearn/${FirebaseAuth.instance.currentUser?.uid}")
        .update({"learnedWords": learnedWordsMapList});
  }

  Future<void> SayacDusur() async {
    setState(() {
      sayacControl = true;
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((alinanVeri) async {
      var sayac = alinanVeri["sayac"];
      print("sayac:$sayac");
      int newSayac = sayac - 1;
      await FirebaseFirestore.instance
          .doc("Users/${FirebaseAuth.instance.currentUser?.uid}")
          .set({"sayac": newSayac}, SetOptions(merge: true))
          .catchError((value) {})
          .then((value) {
            setState(() {
              newSayac == 0 ? null : sayacControl = false;
            });
          });
    });
  }
}
