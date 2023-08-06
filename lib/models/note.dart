
class Note {
  int? _id;
  late String _title;
  late String? _description;
  late String _date;
  late int _priority;

  Note(this._title, this._date, this._priority, [this._description]);

  // Note.withId(this._id, this._title, this._date, this._priority, [this._description]);

  int? get id => _id;

  String get title => _title;

  String? get description => _description;

  // ignore: unnecessary_getters_setters
  String get date => _date;

  int get priority => _priority;


  set title(String newTitle) {
    if (newTitle.length <= 255 && newTitle.isNotEmpty) {
      _title = newTitle;
    }
  }

  set description(String? newDescription) {
    if (newDescription!.length <= 255) {
      _description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      _priority = newPriority;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

 Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if(id != null){
      map['id'] = _id;
    }

    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['priority'] = _priority;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map){
    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _priority = map['priority'];
    _date = map['date'];
  }

}