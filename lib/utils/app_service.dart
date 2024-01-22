import 'package:flutter/material.dart';

import '../main.dart';

class AppService{
final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();}

BuildContext getContext() {
  return locator<AppService>().navKey.currentContext!;
}
