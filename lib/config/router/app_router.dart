import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/products/products.dart';

final goRouterProvider = Provider((ref) {
  final goRouteNotifier = ref.read(goRouteNotifierProvider);

  return GoRouter(
      initialLocation: '/login',
      refreshListenable: goRouteNotifier,
      routes: [
        ///* Auth Routes
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: "/splash",
          builder: (context, state) => const CheckStatusScreen(),
        ),

        ///* Product Routes
        GoRoute(
          path: '/',
          builder: (context, state) => const ProductsScreen(),
        ),
      ],
      redirect: (context, state) {
        print(state.subloc);

        // return "/login";
        return null;
      });
});

//final appRouter =
