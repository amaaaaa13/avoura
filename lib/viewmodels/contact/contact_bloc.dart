import 'package:avoura/core/services/crud_services.dart';
import 'package:avoura/viewmodels/contact/contact_event.dart';
import 'package:avoura/viewmodels/contact/contact_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final CRUDService crudService;

  ContactsBloc(this.crudService) : super(ContactsInitial()) {
    on<FetchContacts>(_onFetchContacts);
    on<SearchContacts>(_onSearchContacts);
    on<AddContactEvent>(_onAddContact);
    on<UpdateContactEvent>(_onUpdateContact);
    on<DeleteContactEvent>(_onDeleteContact);
  }

  // Fetch all contacts
  Future<void> _onFetchContacts(
      FetchContacts event, Emitter<ContactsState> emit) async {
    emit(ContactsLoading());
    try {
      final stream = crudService.getContacts();
      await emit.forEach(
        stream,
        onData: (snapshot) => ContactsLoaded(snapshot.docs),
        onError: (error, stackTrace) =>
            ContactsError("Failed to fetch contacts: $error"),
      );
    } catch (e) {
      emit(ContactsError("Failed to fetch contacts"));
    }
  }

  // Search contacts based on query
  Future<void> _onSearchContacts(
      SearchContacts event, Emitter<ContactsState> emit) async {
    emit(ContactsLoading());
    try {
      // Pass the search query to the CRUDService
      final stream = crudService.getContacts(searchQuery: event.query);
      await emit.forEach(
        stream,
        onData: (snapshot) =>
            ContactsLoaded(snapshot.docs), // Emit filtered contacts
        onError: (error, stackTrace) =>
            ContactsError("Failed to search contacts: $error"),
      );
    } catch (e) {
      emit(ContactsError("Failed to search contacts"));
    }
  }

  // Add a new contact
  Future<void> _onAddContact(
      AddContactEvent event, Emitter<ContactsState> emit) async {
    try {
      await crudService.addNewContacts(event.name, event.phone, event.email);
      emit(ContactActionSuccess("Contact added successfully"));
    } catch (e) {
      emit(ContactsError("Failed to add contact"));
    }
  }

  // Update an existing contact
  Future<void> _onUpdateContact(
      UpdateContactEvent event, Emitter<ContactsState> emit) async {
    try {
      await crudService.updateContact(
          event.name, event.phone, event.email, event.docID);
      emit(ContactActionSuccess("Contact updated successfully"));
    } catch (e) {
      emit(ContactsError("Failed to update contact"));
    }
  }

  // Delete a contact
  Future<void> _onDeleteContact(
      DeleteContactEvent event, Emitter<ContactsState> emit) async {
    try {
      await crudService.deleteContact(event.docID);
      emit(ContactActionSuccess("Contact deleted successfully"));
    } catch (e) {
      emit(ContactsError("Failed to delete contact"));
    }
  }
}
