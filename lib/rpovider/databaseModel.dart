class DatabaseModel {
  int? id;
  String? name;
  String? email;

  DatabaseModel({this.id, this.name, this.email});

  DatabaseModel.fromMap(Map<String, dynamic> model)
      : id = model['id'],
        name = model['name'],
        email = model['email'];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'email': email};
  }
}
