import 'package:assignment/resources/app_colors.dart';
import 'package:assignment/utils/date_formater.dart';
import 'package:assignment/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/app_images.dart';
import '../../../../resources/app_strings.dart';

import '../../data/entity_model/employee_entity.dart';

import '../bloc/employee_bloc.dart';
import 'add_employee_view.dart';

class DisplayEmployeeView extends StatelessWidget {
  const DisplayEmployeeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bkgColor,
      appBar: AppBar(
        backgroundColor: AppColors.blueColor,
        title: const Text(
          AppStrings.displayEmployeeTitle,
        ),
      ),
      body: BlocConsumer<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is DeleteEmployeeState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text(AppStrings.employeeDeletedText),
              action: SnackBarAction(
                  label: AppStrings.undo,
                  onPressed: () {
                    context
                        .read<EmployeeBloc>()
                        .add(const UndoEmployeeDeleteEvent());
                  }),
            ));
          }
        },
        builder: (context, state) {
          if (state is EmployeeLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is EmployeeLoadedState) {
            if (state.employeeList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppImages.noDataFoundImage,
                      width: 261,
                      height: 218,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text("No employee records found",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        AppStrings.currentEmpTitle,
                        style: TextStyle(
                            color: AppColors.blueColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                          List.generate(state.employeeList.length, (index) {
                        return state.employeeList[index].isCurrentEmployee!
                            ? employeeCard(
                                employee: state.employeeList[index],
                                context: context)
                            : Container();
                      }),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(AppStrings.previousEmpTitle,
                          style: TextStyle(
                              color: AppColors.blueColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                          List.generate(state.employeeList.length, (index) {
                        return !state.employeeList[index].isCurrentEmployee!
                            ? employeeCard(
                                employee: state.employeeList[index],
                                context: context)
                            : Container();
                      }),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppStrings.swipeToDeleteText,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: AppColors.lightGray),
                      ),
                    )
                  ],
                ),
              );
            }
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEmployeeView(),
              ));
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              8.0), // Set the circular radius to 0.0 for a square shape
        ),
        elevation: 0.0,
        child: const Icon(
          Icons.add,
          color: AppColors.whiteColor,
        ),
      ),
    );
  }

  Widget employeeCard(
      {required Employee employee, required BuildContext context}) {
    return Dismissible(
      key: Key(employee.id.toString()),
      background: Container(
        decoration: const BoxDecoration(
          color: AppColors.redColor,
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.delete_outline_outlined,
                color: AppColors.whiteColor,
              ),
            )
          ],
        ),
      ),
      onDismissed: (direction) {
        context
            .read<EmployeeBloc>()
            .add(DeleteEmployeeEvent(employee: employee));
      },
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEmployeeView(employee: employee),
                ));
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(color: AppColors.whiteColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Text(
                      employee.name.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Text(
                      employee.role.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.lightGray),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Text(
                      getDateText(employee),
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: AppColors.lightGray),
                    )),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  String getDateText(Employee employee) {
    return StringValidator(employee.toDate).isValid() && employee.toDate == "0"
        ? "From ${DMMMYYYYDateFormator().formatDate(MicroSecSinceEpochParser().parseDate(employee.fromDate!))}"
        : "${DMMMYYYYDateFormator().formatDate(MicroSecSinceEpochParser().parseDate(employee.fromDate!))} - ${DMMMYYYYDateFormator().formatDate(MicroSecSinceEpochParser().parseDate(employee.toDate!))}";
  }
}
