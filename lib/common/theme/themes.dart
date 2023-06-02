import 'package:flutter/material.dart';

class AppTheme {
  /// 暗夜
  static final ThemeData appDark = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.red,
      // 主要部分背景颜色（导航和tabBar等）
      scaffoldBackgroundColor: Colors.red,
      //Scaffold的背景颜色。典型Material应用程序或应用程序内页面的背景颜色
      textTheme: TextTheme(headline1: TextStyle(color: Colors.yellow, fontSize: 15)),
      appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.yellow)));

  // // 明亮
  // static final ThemeData appLightThemeData = ThemeData(
  //     brightness: Brightness.light,
  //     primaryColor: Colors.white,
  //     // 主要部分背景颜色（导航和tabBar等）
  //     scaffoldBackgroundColor: Colors.white,
  //     //Scaffold的背景颜色。典型Material应用程序或应用程序内页面的背景颜色
  //     textTheme: TextTheme(headline1: TextStyle(color: Colors.blue, fontSize: 15)),
  //     appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.black)));

  // 背景底色：backgroundColor 和 saffordBackgroundColor
  // 按钮1背景色：，前景色：，按下颜色：禁用色：
  // 按钮2背景色：，前景色：，按下颜色：禁用色：
  // 输入框底色：，输入内容颜色：提示颜色：错误颜色：，选中颜色：禁用颜色：
  // 标题背景色：primaryColor

  static final ThemeData appLight = ThemeData(
    brightness: Brightness.light,
    // 浅色
    scaffoldBackgroundColor: Color(0xFFEAECF3),
    // 底色
    backgroundColor: Colors.cyan,
    // 背景色
    // backgroundColor: Color(0x0D131B38), // 背景色
    dialogBackgroundColor: Colors.white,
    //  /对话框背景颜色
    primaryColor: Colors.white,
    //应用程序主要部分的背景颜色
    hintColor: Color(0x66131B38),
    dividerColor: Color(0x66131B38),
    errorColor: Color(0xFFE33333),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Color(0xFF3388FF), // 文本框中文本选择的颜色
      cursorColor: Color(0xFF3388FF), // 文本框中光标的颜色
    ),
  );
}
