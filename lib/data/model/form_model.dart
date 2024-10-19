class FormModel {
  final String name;
  final String email;
  final String phone;
  final String examCourse;
  final DateTime dob;

  FormModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.examCourse,
    required this.dob,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'examCourse': examCourse,
      'dob': dob.toIso8601String(),
    };
  }

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      examCourse: json['examCourse'],
      dob: DateTime.parse(json['dob']),
    );
  }
}
