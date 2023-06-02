import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../router/app_pages.dart';

class NotFoundView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('routerNotFoundTitle'.tr),
        ),
        body: InkWell(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              'routerNotFound'.tr,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          onTap: () => Get.offAllNamed(AppRoutes.main),
        ),
      ),
    );
  }
}
