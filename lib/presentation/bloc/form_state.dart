part of 'form_bloc.dart';

@immutable
sealed class FormState {}

final class FormInitial extends FormState {}

class FormSubmitting extends FormState{} //loading State

class FormSubmitSuccess extends FormState{} // success state

class FormSubmitFailure extends FormState{
  final String error;

  FormSubmitFailure({required this.error});

}

//Load States
class FormLoading extends FormState{}

class FormLoadSuccess extends FormState{
  final List<FormModel> forms;

  FormLoadSuccess( this.forms);
}

class FormLoadFailure extends FormState{
  final String error;

  FormLoadFailure({required this.error});
}
