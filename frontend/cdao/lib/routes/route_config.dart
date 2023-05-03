import 'package:cdao/routes/route_const.dart';
// import 'package:cdao/screens/earlySignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import '../screens/aboutScreen.dart';
import '../screens/farms/losHornos/losHornos.dart';
// import '../screens/contactScreen.dart';
// import '../screens/farms/test/testFarm.dart';
// import '../screens/homeScreen.dart';

class CDAORouter {
  static GoRouter returnRouter() {
    GoRouter router = GoRouter(
      routes: <RouteBase>[
        // GoRoute(
        //   name: CDAOConstants.homeRoute,
        //   path: '/home',
        //   pageBuilder: (context, state) {
        //     return const MaterialPage(child: HomeScreen());
        //   },
        // ),
        // GoRoute(
        //   name: CDAOConstants.earlySignUpRoute,
        //   path: '/',
        //   pageBuilder: (context, state) {
        //     return const MaterialPage(child: EarlySignUpScreen());
        //   },
        // ),
        // GoRoute(
        //   name: CDAOConstants.aboutRoute,
        //   path: '/about',
        //   pageBuilder: (context, state) {
        //     return const MaterialPage(child: AboutScreen());
        //   },
        // ),
        // GoRoute(
        //   name: CDAOConstants.contactUsRoute,
        //   path: '/contact_us',
        //   pageBuilder: (context, state) {
        //     return const MaterialPage(child: ContactScreen());
        //   },
        // ),
        GoRoute(
          name: CDAOConstants.losHornosRoute,
          path: '/', // '/profile/:farmname/:offerings/:coffees/;coffee',
          pageBuilder: (context, state) {
            return const MaterialPage(child: LosHornosScreen());
          },
        ),
        // GoRoute(
        //   name: CDAOConstants.testFarmRoute,
        //   path: '/testfarm', // '/profile/:farmname/:offerings/:coffees/;coffee',
        //   pageBuilder: (context, state) {
        //     return const MaterialPage(child: TestFarmScreen());
        //   },
        // ),
      ],
      // redirect: (context, state) {
      //   if (state.location.length == 1) {
      //     return context.namedLocation(CDAOConstants.earlySignUpRoute);
      //   } else {
      //     return null;
      //   }
      // },
    );
    return router;
  }
}
