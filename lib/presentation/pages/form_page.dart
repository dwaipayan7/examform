import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Alias the form_bloc to avoid conflict with Flutter's FormState
import '../../bloc/form_bloc.dart' as formBloc;
import '../../domain/entities/form_entity.dart';
import '../widget/custom_text_form_field.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  final _formKey = GlobalKey<FormState>();
  late String _name, _email, _phone, _examCourse;
  late DateTime _dob;

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
                      SizedBox(height: 15,),
                      // Submit button
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            final form = FormEntity(
                              name: _name,
                              email: _email,
                              phone: _phone,
                              examCourse: _examCourse,
                              dob: DateTime.now(),
                            );
                            context.read<formBloc.FormBloc>().add(formBloc.SubmitFormEvent(form));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.blue[300], // Text color
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Padding inside the button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0), // Rounded corners
                          ),
                          elevation: 8, // Button shadow
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 18, // Text size
                            fontWeight: FontWeight.bold, // Text boldness
                            letterSpacing: 1.2, // Slight space between letters for a modern look
                          ),
                        ),
                      ),

                      // Get Forms button
                      // ElevatedButton(
                      //   onPressed: () {
                      //     context.read<formBloc.FormBloc>().add(formBloc.GetFormsEvent());
                      //   },
                      //   // child: Text('Get Forms'),
                      // ),
                      // Skeletonizer for loading forms
                      if (state is formBloc.FormLoading)
                        _buildSkeletonLoader(), // Skeleton loader widget here
                  
                      // Display fetched forms
                      if (state is formBloc.FormLoadSuccess)
                        ...state.forms.map((form) {
                          return ListTile(
                            title: Text(form.name),
                            subtitle: Text(form.email),
                          );
                        }).toList(),
                  
                      // Error handling
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
      children: List.generate(3, (index) => Padding(
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
      )),
    );
  }
}
