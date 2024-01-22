import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'features/calendar/bloc/calendar_bloc.dart';
import 'features/employee/data/local/shared_prefs.dart';
import 'features/employee/presentation/bloc/employee_bloc.dart';
import 'features/employee/presentation/ui/display_employee_view.dart';
import 'utils/app_service.dart';

GetIt locator = GetIt.instance;
void setUpLocator() {
  locator.registerLazySingleton(() => AppService());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.initSharedPref();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  EmployeeBloc()..add(const FetchEmployeeEvent())),
          BlocProvider(create: (context) => CalendarBloc())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Employee App',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const DisplayEmployeeView(),
        ));
  }
}
