import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/routes.dart';

class Navigation {
  Navigation(this.context);
  final BuildContext context;

  goToRegistration() {
    context.goNamed(Routes.register);
  }

  goToLogin() {
    context.goNamed(Routes.login);
  }

  backToProductList() {
    context.goNamed(Routes.productList);
  }

  goToEditProduct() {
    context.goNamed(Routes.editProduct);
  }

  goToAddProduct() {
    context.goNamed(Routes.addProduct);
  }
}
