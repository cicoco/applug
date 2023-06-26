import 'dart:io';

import 'package:applug/router/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import 'common/langs/translation_service.dart';
import 'common/theme/themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 横向设置
  // if (Platform.isAndroid || Platform.isIOS) {
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.landscapeRight,
  //   ]);
  // }
  _initScreenUtils();
  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

_initScreenUtils() async {
  await ScreenUtil.ensureScreenSize();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          // 默认选中的路由页面
          initialRoute: AppPages.initial,
          // 路由找不到显示的页面
          unknownRoute: AppPages.unknown,
          // 路由表配置
          getPages: AppPages.routes,
          // 路由默认动画
          defaultTransition: Transition.cupertino,

          enableLog: true,
          theme: AppTheme.appLight,

          navigatorObservers: [FlutterSmartDialog.observer],
          builder: FlutterSmartDialog.init(),

          // 国际化
          locale: TranslationService.locale,
          translations: TranslationService(),
          fallbackLocale: TranslationService.fallbackLocale,
        );
      },
      // child: const HomePage(title: 'First Method'),
    );
  }
}
