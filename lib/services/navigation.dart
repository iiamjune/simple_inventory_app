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

  backToHome() {
    context.goNamed(Routes.home);
  }

  goToProduct() {
    context.goNamed(Routes.product);
  }

  goToAddProduct() {
    context.goNamed(Routes.addProduct);
  }
}
