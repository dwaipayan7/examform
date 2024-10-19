import 'dart:convert';

import 'package:examform/data/model/form_model.dart';
import 'package:http/http.dart' as http;

class FormRepository{
  final String baseURL = "https://exam-form-registration-nodejs.onrender.com";

  Future<void> submitForm(FormModel form) async{
    final response = await http.post(
      Uri.parse('${baseURL}/register'),
      headers: {
        'Content-Type' : 'application/json'
      },
      body: jsonEncode(form.toJson())
    );

    if(response.statusCode != 201){
      throw Exception('Failed to submit form');
    }

  }

  //Method to fetch submitted data
  Future<List<FormModel>> getForms() async {
    final response = await http.get(Uri.parse('$baseURL/forms'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((form) => FormModel.fromJson(form)).toList();
    } else {
      throw Exception('Failed to fetch forms');
    }
  }

}