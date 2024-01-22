// ignore_for_file: must_be_immutable


import 'package:assignment/features/employee/data/entity_model/employee_entity.dart';
import 'package:assignment/resources/app_colors.dart';
import 'package:assignment/utils/app_service.dart';
import 'package:assignment/utils/date_formater.dart';
import 'package:assignment/utils/date_retreiver.dart';
import 'package:assignment/utils/next_date.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';


import '../../../../resources/app_strings.dart';
import '../../../../utils/constants.dart';
import '../../../calendar/bloc/calendar_bloc.dart';

import '../bloc/employee_bloc.dart';
import '../widgets/app_primary_btn.dart';
import '../widgets/app_secondary_btn.dart';
import '../widgets/app_text_field.dart';
import '../widgets/date_suggestor_card.dart';

class AddEmployeeView extends StatelessWidget {
  AddEmployeeView({this.employee, super.key}) {
    employeeNameCtrl = TextEditingController();
    selectRoleCtrl = TextEditingController();
    fromDateCtrl = TextEditingController();
    toDateCtrl = TextEditingController();
    if (employee != null) {
      isEditing = true;
      employeeNameCtrl.text = employee!.name!;
      selectRoleCtrl.text = employee!.role!;
      fromDateCtrl.text = employee!.fromDate!;
      toDateCtrl.text = employee!.toDate!;

      selectedFromDate = parser.parseDate(employee!.fromDate!);
      if (isSameDay(DateTime.now(), selectedFromDate)) {
        fromDate = AppStrings.todayText;
      } else {
        fromDate = formattor.formatDate(selectedFromDate);
      }
      if (employee!.toDate! != "0") {
        selectedToDate = parser.parseDate(employee!.toDate!);
        toDate = formattor.formatDate(selectedToDate!);
      } else {
        toDate = AppStrings.noDateText;
      }

      fromDateCtrl.text = fromDate;
      toDateCtrl.text = toDate;
    } else {
      employee = const Employee(id: "", isCurrentEmployee: true);
    }
  }
  Employee? employee;
  TextEditingController employeeNameCtrl = TextEditingController();
  TextEditingController selectRoleCtrl = TextEditingController();
  TextEditingController fromDateCtrl = TextEditingController();
  TextEditingController toDateCtrl = TextEditingController();

  final List<String> roles = [
    Roles.productDesigner,
    Roles.flutterDeveloper,
    Roles.qaTester,
    Roles.productOwner
  ];

  final List<DateSuggestor> fromDateSuggestor = [
    DateSuggestor(DateSuggestorConstants.today, AppStrings.todayText),
    DateSuggestor(DateSuggestorConstants.nextMonday, AppStrings.nextMonday),
    DateSuggestor(DateSuggestorConstants.nextTuesday, AppStrings.nextTuesday),
    DateSuggestor(DateSuggestorConstants.nextWeek, AppStrings.after1Week),
  ];

  final List<DateSuggestor> toDateSuggestor = [
    DateSuggestor(DateSuggestorConstants.noDate, AppStrings.noDateText),
    DateSuggestor(DateSuggestorConstants.today, AppStrings.todayText),
  ];

  int selectediIndex = -1;
  String fromDate = AppStrings.todayText;
  String toDate = AppStrings.noDateText;
  DateTime selectedFromDate = DateTime.now();
  DateTime? selectedToDate;
  MyDateFormator formattor = DMMMYYYYDateFormator();
  late GetDate thisDay;
  late DateRetreiver dateRetreiver;
  MyDateParser parser = MicroSecSinceEpochParser();
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.blueColor,
      title: Text(
        isEditing
            ? AppStrings.updateEmployeeDetailsTitle
            : AppStrings.addEmployeeDetailsTitle,
      ),
      actions: [
        isEditing
            ? Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    context
                        .read<EmployeeBloc>()
                        .add(DeleteEmployeeEvent(employee: employee!));
                  },
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.whiteColor,
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  BlocListener<EmployeeBloc, EmployeeState> _buildBody(BuildContext context) {
    return BlocListener<EmployeeBloc, EmployeeState>(
      listener: (context, state) {
        if (state is InvalidEmployeeState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AppStrings.employeeAddErrorMsg)));
        }
        if (state is NewEmployAddedState) {
          Navigator.of(context).pop();
        }
        if (state is UpdateEmployAddedState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AppStrings.employeeUpdated)));
          Navigator.of(context).pop();
        }

        if (state is DeleteEmployeeState) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(getContext()).showSnackBar(SnackBar(
            content: const Text(AppStrings.employeeDeletedText),
            action: SnackBarAction(
                label: AppStrings.undo,
                onPressed: () {
                  getContext()
                      .read<EmployeeBloc>()
                      .add(const UndoEmployeeDeleteEvent());
                }),
          ));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 23, horizontal: 16),
        child: Column(
          children: [
            AppTextField(
              employeeNameCtrl: employeeNameCtrl,
              hint: AppStrings.employeeNameHint,
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(
              height: 23,
            ),
            AppTextField(
              employeeNameCtrl: selectRoleCtrl,
              hint: AppStrings.selectEmployeeHint,
              prefixIcon: Icons.work_outline,
              suffixIcon: Icons.arrow_drop_down_rounded,
              readOnly: true,
              onTap: () {
                showRolesSheet(context: context);
              },
            ),
            const SizedBox(
              height: 23,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: AppTextField(
                    employeeNameCtrl: fromDateCtrl,
                    prefixIcon: Icons.calendar_today_outlined,
                    hint: AppStrings.selectDate,
                    readOnly: true,
                    onTap: () {
                      datePickerDialog(context, type: DateType.fromDate);
                    },
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: AppColors.blueColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: AppTextField(
                    employeeNameCtrl: toDateCtrl,
                    prefixIcon: Icons.calendar_today_outlined,
                    hint: AppStrings.selectDate,
                    readOnly: true,
                    onTap: () {
                      datePickerDialog(context, type: DateType.toDate);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> datePickerDialog(BuildContext context,
      {int type = DateType.fromDate}) {
    return showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<CalendarBloc, CalendarState>(
          builder: (context, state) {
            return Dialog(
              backgroundColor: AppColors.whiteColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.25, horizontal: 16.25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.whiteColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      direction: Axis.horizontal,
                      children: type == DateType.fromDate
                          ? List.generate(fromDateSuggestor.length, (index) {
                              return DateSuggestionCard(
                                onTap: () {
                                  selectediIndex =
                                      fromDateSuggestor[index].index!;
                                  dateRetreiver = FromDateRetriever();
                                  selectedFromDate = dateRetreiver.retreiveDate(
                                      selectediIndex, selectedFromDate);
                                  fromDate =
                                      formattor.formatDate(selectedFromDate);
                                  //fromDateCtrl.text = fromDate;
                                  context.read<CalendarBloc>().add(
                                      OnSuggestionChangeEvent(
                                          suggestion: selectediIndex));
                                },
                                index: fromDateSuggestor[index].index!,
                                text: fromDateSuggestor[index].text.toString(),
                                bkgColor: selectediIndex ==
                                        fromDateSuggestor[index].index
                                    ? AppColors.blueColor.value
                                    : AppColors.lightBlueColor.value,
                                textColor: selectediIndex !=
                                        fromDateSuggestor[index].index
                                    ? AppColors.blueColor.value
                                    : AppColors.whiteColor.value,
                              );
                            })
                          : List.generate(toDateSuggestor.length, (index) {
                              return DateSuggestionCard(
                                onTap: () {
                                  selectediIndex =
                                      toDateSuggestor[index].index!;
                                  dateRetreiver = ToDateRetriever();

                                  selectedToDate = dateRetreiver.retreiveDate(
                                      selectediIndex,
                                      selectedToDate ?? DateTime.now());
                                  if (selectedToDate!.year == 1900) {
                                    toDate = AppStrings.noDateText;
                                    selectedToDate = null;
                                  } else {
                                    toDate =
                                        formattor.formatDate(selectedToDate!);
                                  }

                                  // toDateCtrl.text = toDate;
                                  context.read<CalendarBloc>().add(
                                      OnSuggestionChangeEvent(
                                          suggestion: selectediIndex));
                                },
                                index: toDateSuggestor[index].index!,
                                text: toDateSuggestor[index].text.toString(),
                                bkgColor: selectediIndex ==
                                        toDateSuggestor[index].index
                                    ? AppColors.blueColor.value
                                    : AppColors.lightBlueColor.value,
                                textColor: selectediIndex !=
                                        toDateSuggestor[index].index
                                    ? AppColors.blueColor.value
                                    : AppColors.whiteColor.value,
                              );
                            }),
                    ),
                    TableCalendar(
                      focusedDay: type == DateType.fromDate
                          ? selectedFromDate
                          : selectedToDate ?? DateTime.now(),
                      firstDay: type == DateType.toDate
                          ? DateTime.now()
                          : DateTime(2000, 1, 1),
                      lastDay: DateTime(3000, 1, 1),
                      rowHeight: 32,
                      selectedDayPredicate: (day) => isSameDay(
                          day,
                          type == DateType.fromDate
                              ? selectedFromDate
                              : selectedToDate),
                      onDaySelected: (selectedDay, focusedDay) {
                        if (type == DateType.fromDate) {
                          selectedFromDate = selectedDay;
                          fromDate = formattor.formatDate(selectedFromDate);
                        } else {
                          selectedToDate = selectedDay;
                          selectediIndex = -1;
                          toDate = formattor.formatDate(selectedToDate!);
                        }
                        context.read<CalendarBloc>().add(
                            OnDaySelectedEvent(onSelectedDate: selectedDay));
                      },
                      calendarStyle: CalendarStyle(
                          cellMargin: const EdgeInsets.all(3),
                          selectedDecoration: const BoxDecoration(
                              color: AppColors.blueColor,
                              shape: BoxShape.circle),
                          outsideDaysVisible: false,
                          todayTextStyle: const TextStyle(
                            color: AppColors.blueColor,
                            fontSize: 16.0,
                          ),
                          todayDecoration: BoxDecoration(
                              border: Border.all(color: AppColors.blueColor),
                              color: AppColors.whiteColor,
                              shape: BoxShape.circle)),
                      headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          leftChevronIcon: RotatedBox(
                            quarterTurns: 1,
                            child: Icon(
                              Icons.arrow_drop_down_rounded,
                              color: Colors.grey,
                            ),
                          ),
                          rightChevronIcon: RotatedBox(
                            quarterTurns: 3,
                            child: Icon(
                              Icons.arrow_drop_down_rounded,
                              color: Colors.grey,
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    const Divider(
                      color: AppColors.bkgColor,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              color: AppColors.blueColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(type == DateType.fromDate ? fromDate : toDate)
                          ],
                        ),
                        Row(
                          children: [
                            AppSecondaryButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                text: AppStrings.cancelBtnText),
                            const SizedBox(
                              width: 16,
                            ),
                            AppPrimaryButton(
                                onPressed: () {
                                  if (type == DateType.fromDate) {
                                    if (selectedToDate != null &&
                                        selectedFromDate
                                            .isAfter(selectedToDate!)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(AppStrings
                                                  .fromDateValidationText)));
                                      return;
                                    }
                                    if (isSameDay(
                                        DateTime.now(), selectedFromDate)) {
                                      fromDate = AppStrings.todayText;
                                    }
                                    fromDateCtrl.text = fromDate;

                                    employee = employee!.copyWith(
                                        fromDate: selectedFromDate
                                            .microsecondsSinceEpoch
                                            .toString());
                                  } else {
                                    if (selectedToDate != null &&
                                        selectedToDate!
                                            .isBefore(selectedFromDate)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(AppStrings
                                                  .toDateValidationText)));
                                      return;
                                    }
                                    toDateCtrl.text = toDate;
                                    employee = employee!.copyWith(
                                        toDate: selectedToDate == null
                                            ? "0"
                                            : selectedToDate!
                                                .microsecondsSinceEpoch
                                                .toString());
                                  }
                                  context.read<CalendarBloc>().add(
                                      OnSuggestionChangeEvent(
                                          suggestion: selectediIndex));
                                  Navigator.of(context).pop();
                                },
                                text: AppStrings.saveBtnText),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.bkgColor, width: 3))),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppSecondaryButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            text: AppStrings.cancelBtnText,
          ),
          const SizedBox(width: 16),
          AppPrimaryButton(
              onPressed: () {
                employee = employee!.copyWith(
                  name: employeeNameCtrl.text.trim(),
                  role: selectRoleCtrl.text.trim(),
                  isCurrentEmployee:
                      employee!.toDate != null && employee!.toDate != "0"
                          ? false
                          : true,
                );
                if (employee!.id.toString().trim().isEmpty) {
                  context
                      .read<EmployeeBloc>()
                      .add(AddEmployeeEvent(employee: employee!));
                } else {
                  context
                      .read<EmployeeBloc>()
                      .add(UpdateEmployeeEvent(employee: employee!));
                }
              },
              text: AppStrings.saveBtnText)
        ],
      ),
    );
  }

  Future<dynamic> showRolesSheet({required context}) {
    return showFlexibleBottomSheet(
      initHeight: 0.22,
      minHeight: 0,
      maxHeight: 0.23,
      bottomSheetColor: Colors.transparent,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36), topRight: Radius.circular(36)),
        color: Colors.transparent,
      ),
      context: context,
      builder: (ctx, scrollCtrl, value) {
        return Container(
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: ListView.builder(
              controller: scrollCtrl,
              itemCount: roles.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    selectRoleCtrl.text = roles[index];
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColors.bkgColor))),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      roles[index],
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ));
      },
      anchors: [0, 0.22, 0.23],
      isSafeArea: true,
    );
  }
}



