import 'package:applug/pages/main/main_binding.dart';
import 'package:applug/pages/main/main_page.dart';
import 'package:applug/pages/notFound/not_found_view.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.main;

  static final routes = [
    GetPage(
      name: AppRoutes.main,
      page: () => MainPage(),
      binding: MainBinding(),
    ),
  ];

  //
  static final unknown = GetPage(
    name: AppRoutes.notFound,
    page: () => NotFoundView(),
  );
}
