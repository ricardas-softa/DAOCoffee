import 'package:cdao/routes/route_const.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/farms/losHornos/losHornos.dart';
import '../screens/orderFormScreen.dart';
import '../screens/receiptScreen.dart';

class CDAORouter {
  static GoRouter returnRouter() {
    GoRouter router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          name: CDAOConstants.losHornosRoute,
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const LosHornosScreen();
          },
        ),
        GoRoute(
          name: CDAOConstants.orderRoute,
          path: '/order/:nftm',
          builder: (BuildContext context, GoRouterState state) => 
          OrderFormScreen(nftm: state.params ["nftm"] as String)
        ),
        GoRoute(
          name: CDAOConstants.receiptRoute,
          path: '/receipt/:data',
          builder: (BuildContext context, GoRouterState state) => 
          ReceiptScreen(
              data: state.params["data"] as String
            ),
        ),
      ],
    );
    return router;
  }
}
