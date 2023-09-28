class Task {
  late bool _isChecked;
  late String _text;

  late int _id;
  Task(this._isChecked, this._text, this._id);
  bool get isChecked => _isChecked;
  String get text => _text;

  int get id => _id;

  void setIsChecked(bool check) => _isChecked = check;
  void setText(String text) => _text = text;
  void setId(int id) => _id = id;
}

enum TaskType { task, habit }
