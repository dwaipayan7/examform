import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Alias the form_bloc to avoid conflict with Flutter's FormState

import '../../domain/entities/form_entity.dart';
import '../bloc/form_bloc.dart' as formBloc;
import '../widget/custom_text_form_field.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _email, _phone, _examCourse, _location;

  // Example locations for the dropdown
  final List<String> _locations = [
    'Kolkata',
    'Howrah',
    'Kalyani',
    'Bethuadahari',
    'Krishnanagar'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exam Form Submission',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Colors.blue[200],
      ),
      backgroundColor: Colors.blue[100],
      body: BlocListener<formBloc.FormBloc, formBloc.FormState>(
        listener: (context, state) {
          if (state is formBloc.FormSubmitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Form Submitted Successfully!')),
            );
          } else if (state is formBloc.FormSubmitFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: BlocBuilder<formBloc.FormBloc, formBloc.FormState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/file.png',
                        fit: BoxFit.contain,
                        width: double.infinity, // Set desired width
                        height: 180, // Set desired height
                      ),

                      // Name field
                      CustomTextFormField(
                        labelText: 'Name',
                        onSaved: (value) => _name = value!,
                      ),
                      CustomTextFormField(
                        labelText: 'Email',
                        onSaved: (value) => _email = value!,
                        inputType: TextInputType.emailAddress,
                      ),
                      CustomTextFormField(
                        labelText: 'Phone',
                        onSaved: (value) => _phone = value!,
                        inputType: TextInputType.phone,
                      ),
                      CustomTextFormField(
                        labelText: 'Exam Course',
                        onSaved: (value) => _examCourse = value!,
                      ),

                      // Dropdown for selecting location
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        items: _locations.map((location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _location = value!;
                          });
                        },
                        validator: (value) =>
                        value == null ? 'Please select a location' : null,
                        onSaved: (value) => _location = value!,
                      ),

                      SizedBox(height: 15),

                      // Submit button
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            final form = FormEntity(
                              name: _name,
                              email: _email,
                              phone: _phone,
                              subject: _examCourse,
                              examDate: DateTime.now(),
                              location: _location, // Add location to the form
                            );
                            context.read<formBloc.FormBloc>().add(
                              formBloc.SubmitFormEvent(form),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue[300], // Text color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16), // Padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0), // Rounded corners
                          ),
                          elevation: 8, // Button shadow
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 18, // Text size
                            fontWeight: FontWeight.bold, // Text boldness
                            letterSpacing: 1.2, // Slight space between letters
                          ),
                        ),
                      ),

                      if (state is formBloc.FormLoading) _buildSkeletonLoader(),
                      if (state is formBloc.FormLoadSuccess)
                        ...state.forms.map((form) {
                          return ListTile(
                            title: Text(form.name),
                            subtitle: Text(form.email),
                          );
                        }).toList(),
                      if (state is formBloc.FormLoadFailure)
                        Text('Error: ${state.error}'),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Skeleton loader widget
  Widget _buildSkeletonLoader() {
    return Column(
      children: List.generate(
        3,
            (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16.0,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 8.0),
                    Container(
                      width: 150.0,
                      height: 16.0,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


