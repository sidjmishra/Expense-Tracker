import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseDetails extends StatefulWidget {
  final Expense expense;
  const ExpenseDetails(this.expense, {Key? key}) : super(key: key);

  @override
  State<ExpenseDetails> createState() => _ExpenseDetailsState(this.expense);
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  DateTime dateTime = DateTime.now();
  String date = "";

  TextEditingController name = TextEditingController();
  TextEditingController expenses = TextEditingController();

  late Expense expense;
  DatabaseClass databaseClass = DatabaseClass();
  _ExpenseDetailsState(this.expense);

  final _formKey = GlobalKey<FormState>();

  Future formValidate() async {
    if (_formKey.currentState!.validate() && date != "") {
      try {
        int result;

        expense.name = name.text;
        expense.expense = expenses.text;
        expense.date = date;
        expense.timeStamp = DateTime.now().toString();

        result = await databaseClass.insertData(expense);

        if (result != 0) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Submitted Successfully"),
              duration: Duration(milliseconds: 300),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Value not properly entered!"),
              duration: Duration(milliseconds: 300),
            ),
          );
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  return value!.isEmpty ? 'Enter value' : null;
                },
                textCapitalization: TextCapitalization.words,
                controller: name,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * (0.025)),
              TextFormField(
                validator: (value) {
                  return value!.isEmpty || value.length > 3
                      ? 'Enter 3 digit value'
                      : null;
                },
                controller: expenses,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Amount',
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * (0.025)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  date == ""
                      ? Text(
                          "No Date Chosen",
                          style: TextStyle(color: Colors.grey[600]),
                        )
                      : Text(
                          date,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                  TextButton(
                    onPressed: () async {
                      final DateTime? selected = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1990),
                        lastDate: DateTime.now(),
                      );
                      setState(() {
                        dateTime = selected!;
                        date = DateFormat.yMMMMd().format(dateTime);
                      });
                      debugPrint(date);
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.purple)),
                    child: const Text("Choose Date"),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * (0.025)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      formValidate();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.purple),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    child: const Text("Add Transaction"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
