import 'package:examform/bloc/form_bloc.dart';
import 'package:examform/data/repository/form_repository.dart';
import 'package:examform/presentation/pages/form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final formRepository = FormRepository();
  runApp( MyApp(formRepository: formRepository,));
}

class MyApp extends StatelessWidget {

  final FormRepository formRepository;

   MyApp({super.key, required this.formRepository});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FormBloc(formRepository)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Exam Form Submission',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FormScreen(),
      ),
    );
  }
}

