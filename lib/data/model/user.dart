import 'package:ayron_crm/data/model/entity.dart';

class User implements WeakEntity {
  User({required this.username});

  String username;

  factory User.fromJson(Map<String, dynamic> json) =>
      User(username: json["username"]);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{'username': username};
    map.addEntries([]);
    return map;
  }
}
