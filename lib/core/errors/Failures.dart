import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}

class WordNotFoundFailure extends Failure {}
class FileNotFoundFailure extends Failure {}

// class CacheFailure extends Failure {}
