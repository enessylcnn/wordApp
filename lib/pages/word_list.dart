import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/models/word.dart';
import 'package:firebase_authentication/models/word_list_model.dart';
import 'package:flutter/material.dart';

class WordListView extends StatefulWidget {
  @override
  State<WordListView> createState() => _LearnedWords();
}

class _LearnedWords extends State<WordListView> {
  List<dynamic> willLearnMapList = [];
  List<dynamic> learnedWordsMapList = [];
  List<Word> willLearn = [];
  List<Word> learnedWords = [];
  bool isProgress = true;

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
        for (int i = 0; i < willLearnMapList.length; i++) {
          willLearn.add(Word.fromMap(willLearnMapList[i]));
        }
        for (int i = 0; i < learnedWordsMapList.length; i++) {
          learnedWords.add(Word.fromMap(learnedWordsMapList[i]));
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isProgress = false;
      });
    }
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    await _init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LEARNED WORLDS'),
        centerTitle: true,
      ),
      body: isProgress
          ? const Center(child: CircularProgressIndicator())
          : listViewAera(),
    );
  }

  ListView listViewAera() {
    return ListView.builder(
        itemCount: learnedWords.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              /* onTap: () {
                setState(() {
                  learnedWords.add(willLearn[index]);
                  willLearn.remove(willLearn[index]);
                });
                addFirebase(willLearn, learnedWords);
              },*/
              title: Text(learnedWords[index].word.toString()),
              subtitle: Text(learnedWords[index].definition.toString()),
            ),
          );
        });
  }

  /* Future<void> addFirebase(
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
    await FirebaseFirestore.instance
        .doc("willLearn/${FirebaseAuth.instance.currentUser?.uid}")
        .set({"willLearn": willLearnMapList}, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .doc("willLearn/${FirebaseAuth.instance.currentUser?.uid}")
        .set({"learnedWords": learnedWordsMapList}, SetOptions(merge: true));
  } */
}
