// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_authentication/apis/word_api.dart';
import 'package:firebase_authentication/pages/editeprofile.dart';

class Word {
  int? index;
  String? word;
  String? definition;
  Word({
    this.index,
    this.word,
    this.definition,
  });

  Word copyWith({
    int? index,
    String? word,
    String? definition,
  }) {
    return Word(
      index: index ?? this.index,
      word: word ?? this.word,
      definition: definition ?? this.definition,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'index': index,
      'word': word,
      'definition': definition,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      index: map['index'] != null ? map['index'] as int : null,
      word: map['word'] != null ? map['word'] as String : null,
      definition:
          map['definition'] != null ? map['definition'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Word.fromJson(String source) =>
      Word.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Word(index: $index, word: $word, definition: $definition)';

  @override
  bool operator ==(covariant Word other) {
    if (identical(this, other)) return true;

    return other.index == index &&
        other.word == word &&
        other.definition == definition;
  }

  @override
  int get hashCode => index.hashCode ^ word.hashCode ^ definition.hashCode;
}
