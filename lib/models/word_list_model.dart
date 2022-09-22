// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:firebase_authentication/models/word.dart';

class WordListModel {
  List<Word>? wordListModel;
  WordListModel({
    this.wordListModel,
  });

  WordListModel copyWith({
    List<Word>? wordListModel,
  }) {
    return WordListModel(
      wordListModel: wordListModel ?? this.wordListModel,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'wordListModel': wordListModel!.map((x) => x.toMap()).toList(),
    };
  }

  factory WordListModel.fromMap(Map<String, dynamic> map) {
    return WordListModel(
      wordListModel: map['wordListModel'] != null ? List<Word>.from((map['wordListModel'] as List<int>).map<Word?>((x) => Word.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WordListModel.fromJson(String source) => WordListModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'WordListModel(wordListModel: $wordListModel)';

  @override
  bool operator ==(covariant WordListModel other) {
    if (identical(this, other)) return true;
  
    return 
      listEquals(other.wordListModel, wordListModel);
  }

  @override
  int get hashCode => wordListModel.hashCode;
}
