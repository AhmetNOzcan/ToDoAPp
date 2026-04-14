import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profile_feature_navigation/profile_feature_navigation.dart';

import 'bloc/profile_bloc.dart';
import 'pages/profile_page.dart';

@LazySingleton(as: NavGraph)
@Named("Profile")
class ProfileNavGraph implements NavGraph {
  @override
  List<RouteBase> build() => [
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
