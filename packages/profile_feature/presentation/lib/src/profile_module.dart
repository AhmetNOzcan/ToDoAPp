import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profile_feature_data/profile_feature_data.dart';
import 'package:profile_feature_domain/profile_feature_domain.dart';
import 'package:profile_feature_navigation/profile_feature_navigation.dart';

import 'bloc/profile_bloc.dart';
import 'pages/profile_page.dart';

class ProfileModule extends FeatureModule {
  @override
  void registerDependencies(GetIt sl) {
    // Database (feature-owned)
    sl.registerLazySingleton<ProfileDatabase>(() => ProfileDatabase());

    // Data sources
    sl.registerLazySingleton<ProfileLocalDataSource>(
      () => ProfileLocalDataSourceImpl(db: sl()),
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
          path: ProfileRoutes.pathRoot,
          name: ProfileRoutes.nameRoot,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<ProfileBloc>(),
            child: const ProfilePage(),
          ),
        ),
      ];
}
