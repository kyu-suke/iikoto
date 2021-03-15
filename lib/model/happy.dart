import "package:intl/intl.dart";

class Happy {
  final int id;
  final String text;
  final DateTime createdAt;

  Happy({this.id, this.text, this.createdAt});

  String get createdAtHis {
    return new DateFormat('HH:mm:ss').format(createdAt);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.toString(),
    };
  }
}

class CountHappyByDate {
  final int count;
  final DateTime createdAt;

  CountHappyByDate({this.count, this.createdAt});
}
