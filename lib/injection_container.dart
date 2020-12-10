import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dictionary/core/network/network_checker.dart';
import 'package:dictionary/core/setting/setting.dart';
import 'package:dictionary/data_provider/datasources/datasources.dart';
import 'package:dictionary/data_provider/repositories/repositories.dart';
import 'package:dictionary/domain/usecases/flashcard/flashcard_bloc.dart';
import 'package:dictionary/domain/usecases/search/play_phonetic.dart';
import 'package:dictionary/domain/usecases/search/search.dart';
import 'package:dictionary/presentation/pages/pages.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // Pages
  sl.registerFactory<SearchPage>(() => SearchPage());
  sl.registerFactory<FlashcardPage>(() => FlashcardPage());

  // Domain

  // -- Search
  sl.registerLazySingleton<PlayPhonetic>(() => PlayPhonetic.instance);
  sl.registerFactory<SearchBloc>(
    () => SearchBloc(
      wordRepository: sl(),
      flashcardRepository: sl(),
    ),
  );

  // -- Flashcard
  sl.registerFactory<FlashcardBloc>(
      () => FlashcardBloc(flashcardRepository: sl()));

  // Repositories
  sl.registerLazySingleton<WordRepository>(
    () => WordRepositoryImpl(
      localDatasource: sl(),
      remoteDatasource: sl(),
      networkChecker: sl(),
      flashcardDatasource: sl(),
    ),
  );
  sl.registerLazySingleton<FlashcardRepository>(
    () => FlashcardRepositoryImpl(
      flashcardDatasource: sl(),
      localDatasource: sl(),
    ),
  );

  // Datasources
  sl.registerLazySingleton<WordLocalDatasource>(
    () => WordLocalDatasourceImpl(
      sharedPreferences: sl(),
    ),
  );
  sl.registerLazySingleton<FlashcardDatasource>(
    () => FlashcardLocalDatasourceImpl(
      sharedPreferences: sl(),
    ),
  );
  sl.registerLazySingleton<WordRemoteDatasource>(
    () => WordRemoteDatasourceImpl(client: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkChecker>(
    () => NetworkCheckerImpl(sl()),
  );
  sl.registerLazySingleton<BucketSettings>(
    () => BucketSettings.getInstance(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<SearchSettings>(
    () => SearchSettings.getInstance(sharedPreferences: sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  // await sharedPreferences.clear(); // ???????????????????
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
