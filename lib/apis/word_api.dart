import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/word.dart';

Future<List<Word>> createWords(List<String> wordList) async {
  List<Word> words = [];
  List<Map> willLearn = [];
  List<Map> learnedWords = [];

  for (int i = 0; i < wordList.length; i++) {
    //willLearn.add(wordList[i].)
    Word word = await fetchData(wordList[i]);
    Word newWord =
        Word(definition: word.definition, word: word.word, index: i + 1);

    words.add(newWord);
    willLearn.add(newWord.toMap());

    //debugPrint(wordList[i]);
  }
  addFirebase(willLearn, learnedWords);
  return words;
}

Future<void> addFirebase(List<Map> willLearn, List<Map> learnedWords) async {
  await FirebaseFirestore.instance
      .doc("willLearn/${FirebaseAuth.instance.currentUser?.uid}")
      .set({"willLearn": willLearn}, SetOptions(merge: true));

  await FirebaseFirestore.instance
      .doc("willLearn/${FirebaseAuth.instance.currentUser?.uid}")
      .set({"learnedWords": learnedWords}, SetOptions(merge: true));
}

Future<Word> fetchData(String data) async {
  Word word = Word(index: 0);
  /* for (var i = 0; i < 30; i++) {
    int sayi1 = i;
  }*/

  /* List<String?> gelenKelime = [];
  List<String?> gelenAciklama = [];
  List<int?> gelenSayi = [];*/
  var url = "https://api.dictionaryapi.dev/api/v2/entries/en/$data";
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    word.word = jsonDecode(response.body)[0]['word'].toString();
    word.definition = jsonDecode(response.body)[0]['meanings'][0]['definitions']
        [0]['definition'];
    [word.word];

    /* gelenKelime.add(word.word);
    gelenAciklama.add(word.definition);
    gelenSayi.add(word.index);

    List<Map> allOfthem = [];

    Map<String, dynamic> kelime2 = <String, dynamic>{};
    kelime2['definition'] = gelenAciklama;
    kelime2['word'] = gelenKelime;
    kelime2['id'] = gelenSayi;

    Map<String, dynamic> learnedWords = <String, dynamic>{};
    Map<String, dynamic> worddefMap = <String, dynamic>{
      "index": 1,
      "GelenKelime": gelenKelime,
      "GelenAciklama": gelenAciklama,
    };
    allOfthem.add(worddefMap);
    await FirebaseFirestore.instance
        .doc("willLearn/${FirebaseAuth.instance.currentUser?.uid}")
        .set({"willLearn": learnedWords}, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .doc("willLearn/${FirebaseAuth.instance.currentUser?.uid}")
        .set({"learnedWords": allOfthem}, SetOptions(merge: true));*/

    // print(listWord[0]);
    // print(listDefinition[0]);
    //  print(worddefMap);

    return word;
  } else {
    return Word(index: 0);
  }
}
