import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageUtils {
  static String wrapImage(String url) {
    return "assets/images/" + url;
  }

  static String wrapSvg(String url) {
    return "assets/svgs/" + url;
  }

  static String wrap(String url) {
    if (url.endsWith(".svg")) {
      return wrapSvg(url);
    } else {
      return wrapImage(url);
    }
  }

  static Widget placeHolder({double? width, double? height}) {
    return SizedBox(
        width: width, height: height, child: CupertinoActivityIndicator(radius: min(10.0, (width ?? 30) / 3)));
  }

  static Widget error({double? width, double? height, double? size}) {
    return SizedBox(
        width: width,
        height: height,
        child: Icon(
          Icons.error_outline,
          size: size,
        ));
  }
}
