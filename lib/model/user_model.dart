// class UserModel {
//   String? image;
//   String? name;
//   String? rollno;
//   String? semester;
//   String? department;

//   UserModel(this.image, this.name, this.rollno, this.semester, this.department);

//   UserModel.fromJson(Map<String, dynamic> json) {
//     image = json['image'];
//     name = json['name'];
//     rollno = json['roll no'];
//     semester = json['semester'];
//     department = json['department'];
//   }

//   set value(UserModel value) {}
// }

class UserModel {
  final String name;
  final int phone;
  final String email;
  final String password;

  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.password});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] ?? '',
        phone: map['phone'] ?? "",
        email: map['email'] ?? '',
        password: map['password'] ?? '');
  }
}
