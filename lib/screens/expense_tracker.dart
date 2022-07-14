import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/screens/expense_detail.dart';
import 'package:expense_tracker/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({Key? key}) : super(key: key);

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  DatabaseClass databaseClass = DatabaseClass();
  List<Expense> expensesList = [];
  int count = 0;

  int mon = 0;
  int tue = 0;
  int wed = 0;
  int thur = 0;
  int fri = 0;
  int sat = 0;
  int sun = 0;

  void updateList() {
    final Future<Database> dbFuture = databaseClass.initializeDb();
    dbFuture.then((database) {
      var expenseList = databaseClass.getExpenses();
      expenseList.then((eList) {
        if (eList.isNotEmpty) {
          setState(() {
            for (var e = 0; e < eList.length; e++) {
              expensesList.add(Expense.withId(
                  eList[e]['id'],
                  eList[e]['name'],
                  eList[e]['date'],
                  eList[e]['expense'],
                  eList[e]['timeStamp']));

              if (DateFormat.EEEE().format(
                      DateFormat("yMMMMd").parse(expensesList[e].date!)) ==
                  "Monday") {
                mon += int.parse(expensesList[e].expense!);
              } else if (DateFormat.EEEE().format(
                      DateFormat("yMMMMd").parse(expensesList[e].date!)) ==
                  "Tuesday") {
                tue += int.parse(expensesList[e].expense!);
              } else if (DateFormat.EEEE().format(
                      DateFormat("yMMMMd").parse(expensesList[e].date!)) ==
                  "Wednesday") {
                wed += int.parse(expensesList[e].expense!);
              } else if (DateFormat.EEEE().format(
                      DateFormat("yMMMMd").parse(expensesList[e].date!)) ==
                  "Thursday") {
                thur += int.parse(expensesList[e].expense!);
              } else if (DateFormat.EEEE().format(
                      DateFormat("yMMMMd").parse(expensesList[e].date!)) ==
                  "Friday") {
                fri += int.parse(expensesList[e].expense!);
              } else if (DateFormat.EEEE().format(
                      DateFormat("yMMMMd").parse(expensesList[e].date!)) ==
                  "Saturday") {
                sat += int.parse(expensesList[e].expense!);
              } else {
                sun += int.parse(expensesList[e].expense!);
              }
            }
            debugPrint(expensesList[0].id.toString());
            count = expensesList.length;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (expensesList.isEmpty) {
      updateList();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Personal Expenses'),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       updateList();
        //     },
        //     icon: Icon(Icons.refresh),
        //     tooltip: "Refresh",
        //   ),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("Add Expenses");
          showModalBottomSheet<void>(
              context: context,
              builder: (context) {
                return ExpenseDetails(Expense('', '', '', ''));
              });
        },
        backgroundColor: Colors.yellow,
        tooltip: 'Add Expenses',
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        weekDayIndicator(sun, "Sunday"),
                        weekDayIndicator(mon, "Monday"),
                        weekDayIndicator(tue, "Tuesday"),
                        weekDayIndicator(wed, "Wednesday"),
                        weekDayIndicator(thur, "Thursday"),
                        weekDayIndicator(fri, "Friday"),
                        weekDayIndicator(sat, "Saturday"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: count == 0
                ? const Center(
                    child: Text("Add Data"),
                  )
                : ListView.builder(
                    itemCount: count,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        elevation: 2.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: MediaQuery.of(context).size.width * (0.1),
                            backgroundColor: Colors.purple[700],
                            foregroundColor: Colors.white,
                            child: Text("₹${expensesList[index].expense!}",
                                textAlign: TextAlign.center, maxLines: 2),
                          ),
                          title: Text(
                            expensesList[index].name!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(expensesList[index].date!),
                          trailing: GestureDetector(
                            child: const Icon(Icons.delete,
                                color: Colors.redAccent),
                            onTap: () async {
                              // delete(context, expensesList[index]);
                              int result = await databaseClass
                                  .deleteData(expensesList[index].id!);
                              setState(() {
                                if (DateFormat.EEEE().format(
                                        DateFormat("yMMMMd").parse(
                                            expensesList[index].date!)) ==
                                    "Monday") {
                                  mon -=
                                      int.parse(expensesList[index].expense!);
                                } else if (DateFormat.EEEE().format(
                                        DateFormat("yMMMMd").parse(
                                            expensesList[index].date!)) ==
                                    "Tuesday") {
                                  tue -=
                                      int.parse(expensesList[index].expense!);
                                } else if (DateFormat.EEEE().format(
                                        DateFormat("yMMMMd").parse(
                                            expensesList[index].date!)) ==
                                    "Wednesday") {
                                  wed -=
                                      int.parse(expensesList[index].expense!);
                                } else if (DateFormat.EEEE().format(
                                        DateFormat("yMMMMd").parse(
                                            expensesList[index].date!)) ==
                                    "Thursday") {
                                  thur -=
                                      int.parse(expensesList[index].expense!);
                                } else if (DateFormat.EEEE().format(
                                        DateFormat("yMMMMd").parse(
                                            expensesList[index].date!)) ==
                                    "Friday") {
                                  fri -=
                                      int.parse(expensesList[index].expense!);
                                } else if (DateFormat.EEEE().format(
                                        DateFormat("yMMMMd").parse(
                                            expensesList[index].date!)) ==
                                    "Saturday") {
                                  sat -=
                                      int.parse(expensesList[index].expense!);
                                } else {
                                  sun -=
                                      int.parse(expensesList[index].expense!);
                                }
                                expensesList.removeWhere((element) =>
                                    element.id == expensesList[index].id!);
                                count = expensesList.length;
                              });
                              // updateList();
                              if (result != 0) {
                                var snackBar = const SnackBar(
                                    content: Text('Data Deleted Successfully'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                          ),
                          onTap: () {
                            debugPrint("ListTile Tapped");
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget weekDayIndicator(int value, String day) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "₹$value",
          style:
              TextStyle(fontSize: MediaQuery.of(context).size.width * (0.025)),
        ),
        Container(
          height: MediaQuery.of(context).size.height * (0.1),
          width: MediaQuery.of(context).size.width * (0.05),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: value == 0
              ? Container()
              : FAProgressBar(
                  direction: Axis.vertical,
                  verticalDirection: VerticalDirection.down,
                  currentValue: value / 100,
                  progressColor: Colors.purple,
                  borderRadius: BorderRadius.circular(20.0),
                ),
        ),
        Text(
          day.substring(0, 1),
          style:
              TextStyle(fontSize: MediaQuery.of(context).size.width * (0.025)),
        ),
      ],
    );
  }
}
