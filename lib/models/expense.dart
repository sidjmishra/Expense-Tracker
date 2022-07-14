class Expense {
  int? _id;
  String? _name;
  String? _expense;
  String? _date;
  String? _timeStamp;

  Expense(
    this._name,
    this._expense,
    this._date,
    this._timeStamp,
  );

  Expense.withId(
    this._id,
    this._name,
    this._date,
    this._expense,
    this._timeStamp,
  );

  int? get id => _id;
  String? get name => _name;
  String? get expense => _expense;
  String? get date => _date;
  String? get timeStamp => _timeStamp;

  set name(String? newName) {
    if (newName!.length <= 255) {
      _name = newName;
    }
  }

  set expense(String? newExpense) {
    if (newExpense!.length <= 255) {
      _expense = newExpense;
    }
  }

  set date(String? newDate) {
    _date = newDate;
  }

  set timeStamp(String? newStamp) {
    _timeStamp = newStamp;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (_id != null) {
      map['id'] = _id;
    }

    map['name'] = _name;
    map['expense'] = _expense;
    map['date'] = _date;
    map['timeStamp'] = _timeStamp;

    return map;
  }

  Expense.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _name = map['name'];
    _expense = map['expense'];
    _date = map['date'];
    _timeStamp = map['timeStamp'];
  }
}
