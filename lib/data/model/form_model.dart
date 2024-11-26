import '../../domain/entities/form_entity.dart';

class FormModel extends FormEntity {
  FormModel({
    required super.name,
    required super.email,
    required super.phone,
    required super.subject,
    required super.location,
    required super.examDate, // Include dob if part of FormEntity
  });

  /// Converts the FormModel instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'subject': subject,
      'location': location,
      'examDate': examDate.toIso8601String(), // Ensure DateTime is serialized correctly
    };
  }

  /// Creates a FormModel instance from a JSON map.
  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      name: json['name'] ?? '', // Provide default values if needed
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      subject: json['subject'] ?? '',
      location: json['location'] ?? '',
      examDate: json['examDate'] != null
          ? DateTime.parse(json['examDate']) // Parse DateTime if available
          : DateTime.now(), // Default to current time if dob is null
    );
  }
}
