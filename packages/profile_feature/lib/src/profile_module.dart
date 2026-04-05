import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'data/datasources/profile_local_data_source.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/usecases/get_profile.dart';
import 'domain/usecases/update_profile.dart';
import 'domain/usecases/update_profile_photo.dart';
import 'presentation/bloc/profile_bloc.dart';
import 'presentation/pages/profile_page.dart';

class ProfileModule extends FeatureModule {
  @override
  void registerDependencies(GetIt sl) {
    // Data sources
    sl.registerLazySingleton<ProfileLocalDataSource>(
      () => ProfileLocalDataSourceImpl(database: sl()),
    );

    // Repositories
    sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(
        localDataSource: sl(),
        appDocumentsPath: sl<String>(instanceName: 'appDocumentsPath'),
      ),
    );

    // Use cases
    sl.registerFactory(() => GetProfile(sl()));
    sl.registerFactory(() => UpdateProfile(sl()));
    sl.registerFactory(() => UpdateProfilePhoto(sl()));

    // Image picker
    sl.registerLazySingleton(() => ImagePicker());

    // BLoC
    sl.registerFactory(
      () => ProfileBloc(
        getProfile: sl(),
        updateProfile: sl(),
        updateProfilePhoto: sl(),
        todoStatsProvider: sl(),
        imagePicker: sl(),
      ),
    );
  }

  @override
  List<RouteBase> get routes => [
        GoRoute(
          path: '/profile',
          builder: (context, state) => BlocProvider(
            create: (_) => sl<ProfileBloc>(),
            child: const ProfilePage(),
          ),
        ),
      ];
}
