import 'package:get_it/get_it.dart';
import 'package:zakir/src/services/storage_service.dart';
import 'src/providers/app_state_provider.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //Providers
  locator.registerLazySingleton(() => AppStateProvider());

  //Services
  locator.registerLazySingleton(() => StorageService());
}
