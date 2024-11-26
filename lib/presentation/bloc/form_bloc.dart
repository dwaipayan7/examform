import 'package:bloc/bloc.dart';
import 'package:examform/data/model/form_model.dart';
import 'package:examform/data/repository/form_repository.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/form_entity.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  final FormRepository repository;

  FormBloc(this.repository) : super(FormInitial()) {
    on<SubmitFormEvent>(_onFormSubmitForm);
    on<GetFormsEvent>(_onGetForms);
  }

  // Method to handle form submission
  Future<void> _onFormSubmitForm(
      SubmitFormEvent event, Emitter<FormState> emit) async {
    emit(FormSubmitting());

    try {
      final formModel = FormModel(
          name: event.form.name,
          email: event.form.email,
          phone: event.form.phone,
          subject: event.form.subject,
          location: event.form.location,
          examDate: event.form.examDate);
      await repository.submitForm(formModel);
      emit(FormSubmitSuccess());
    } catch (e) {
      emit(FormSubmitFailure(error: e.toString()));
    }
  }

  // Method to handle fetching the forms
  Future<void> _onGetForms(GetFormsEvent event, Emitter<FormState> emit) async {
    emit(FormLoading());

    try {
      final forms = await repository.getForms();
      emit(FormLoadSuccess(forms));
    } catch (e) {
      emit(FormLoadFailure(error: e.toString()));
    }
  }
}
