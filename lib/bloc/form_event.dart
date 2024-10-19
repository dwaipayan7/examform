part of 'form_bloc.dart';

@immutable
sealed class FormEvent {}

class SubmitFormEvent extends FormEvent{
  final FormEntity form;
  SubmitFormEvent(this.form);
}

class GetFormsEvent extends FormEvent{}
