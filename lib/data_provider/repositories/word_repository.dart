import 'dart:typed_data';

import 'package:dictionary/core/errors/exceptions.dart';
import 'package:dictionary/core/network/network_checker.dart';
import 'package:dictionary/data_provider/datasources/datasources.dart';
import 'package:dictionary/domain/entities/word.dart';
import 'package:dictionary/core/errors/Failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

abstract class WordRepository {
  Future<Either<Failure, Word>> getWord(String word);
  Future<Either<Failure, Uint8List>> getPhonetic(String audioFile);
  Future<List<String>> getWordsLike(String string);
  Future<void> addWordToCards(String word, int level);
  Future<List<String>> getWordsOfLevel(int level);
}

class WordRepositoryImpl implements WordRepository {
  final WordLocalDatasource localDatasource;
  final WordRemoteDatasource remoteDatasource;
  final NetworkChecker networkChecker;

  WordRepositoryImpl({
    @required this.localDatasource,
    @required this.remoteDatasource,
    @required this.networkChecker,
  });

  @override
  Future<Either<Failure, Word>> getWord(String word) async {
    try {
      final localWord = await localDatasource.getWord(word);
      return Right(localWord);
    } on StoreException {}
    try {
      final remoteWord = await remoteDatasource.getWord(word);
      localDatasource.storeWord(remoteWord);
      localDatasource.addWordToCards(word, remoteWord.cardLevel);
      return Right(remoteWord);
    } on ServiceException {
      return Left(ServerFailure());
    } on WordNotFoundException {
      return Left(WordNotFoundFailure());
    }
  }

  @override
  Future<Either<Failure, Uint8List>> getPhonetic(String audioFile) async {
    try {
      final localAudioFile = await localDatasource.getPhonetic(audioFile);
      return Right(localAudioFile);
    } on StoreException {}
    try {
      final remotePhonetic = await remoteDatasource.getPhonetic(audioFile);
      localDatasource.storePhonetic(remotePhonetic, audioFile);
      return Right(remotePhonetic);
    } on ServiceException {
      return Left(ServerFailure());
    } on WordNotFoundException {
      return Left(FileNotFoundFailure());
    }
  }

  @override
  Future<List<String>> getWordsLike(String string) async {
    var stringToLowerCase = string.toLowerCase();
    List<String> result = [];
    var set = await localDatasource.getWordTitleList();
    set.forEach((word) {
      if (word.toLowerCase().startsWith(stringToLowerCase)) result.add(word);
    });
    return result;
  }

  @override
  Future<void> addWordToCards(String word, int level) async {
    localDatasource.addWordToCards(word, level);
  }

  @override
  Future<List<String>> getWordsOfLevel(int level) async {
    return await localDatasource.getWordsOfLevel(level);
  }
}
