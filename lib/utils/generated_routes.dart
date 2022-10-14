import 'package:flutter_application_1/screens/product/add_product_screen.dart';
import 'package:flutter_application_1/screens/product/product_list_screen.dart';
import 'package:flutter_application_1/screens/product/edit_product_screen.dart';
import 'package:flutter_application_1/screens/auth/registration_screen.dart';
import 'package:go_router/go_router.dart';

import '../constants/routes.dart';
import '../screens/auth/login_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/success_screen.dart';

class RouteGenerate {
  final GoRouter router = GoRouter(
      urlPathStrategy: UrlPathStrategy.path,
      debugLogDiagnostics: true,
      routes: <GoRoute>[
        GoRoute(
          name: Routes.splash,
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          name: Routes.register,
          path: '/register',
          builder: (context, state) => const RegistrationScreen(),
        ),
        GoRoute(
          name: Routes.login,
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          name: Routes.success,
          path: '/success',
          builder: (context, state) => const SuccessScreen(),
        ),
        GoRoute(
          name: Routes.productList,
          path: '/product_list',
          builder: (context, state) => const ProductListScreen(),
        ),
        GoRoute(
          name: Routes.editProduct,
          path: '/edit_product',
          builder: (context, state) => const EditProductScreen(),
        ),
        GoRoute(
          name: Routes.addProduct,
          path: '/add_product',
          builder: (context, state) => const AddProductScreen(),
        )
      ]);
}
