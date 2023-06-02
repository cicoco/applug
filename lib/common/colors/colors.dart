import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  // 登录
  static const Color loginFillColor = Color(0x0D131B38);

  // const 和 final的区别
  // 均表示不可被修改
  //
  // 相同点
  // 1、final、const必须初始化
  // 2、 final、const只能赋值一次
  //
  // 不同点
  // 1、 final可修饰实例变量、const不可以修饰实例变量
  // 2、访问类中const修饰的变量需要static修饰
  // 3、const修饰的List集合任意索引不可修改，final修饰的可以修改
  // 4、const 用来修饰变量 只能被赋值一次，在编译时赋值
  // final 用来修饰变量 只能被赋值一次，在运行时赋值
  // 5、final 只可用来修饰变量， const 关键字即可修饰变量也可用来修饰 常量构造函数
  //
  // 当const修饰类的构造函数时，它要求该类的所有成员都必须是final的。

  static const Color buttonEnableColor = Color(0xFF236CD8);

  // 这里用const就不得行
  static final Color buttonDisableColor = buttonEnableColor.withAlpha(80);

  static const Color titleTextColor = Color(0xCC131B38);
  static const Color titleStarTextColor = Colors.red;
  static final Color titleTipTextColor = titleTextColor.withOpacity(0.15);

  static const Color divisionColor = Color(0xFFEEEEEE);
// /// 主背景
// static const Color primaryBackground = Color(0xFFF4F6FA);
//
// /// 主文本
// static const Color primaryText = Color(0xFF2D3142);
//
// static const Color primaryGreyText = Color(0xFF9B9B9B);
//
// /// 主文本灰色
// static const Color primaryGreyText1 = Color(0xFFE0DDF5);

}
