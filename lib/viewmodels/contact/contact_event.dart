import 'package:equatable/equatable.dart';

abstract class ContactsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchContacts extends ContactsEvent {}

class AddContactEvent extends ContactsEvent {
  final String name;
  final String phone;
  final String email;

  AddContactEvent(this.name, this.phone, this.email);

  @override
  List<Object?> get props => [name, phone, email];
}

class UpdateContactEvent extends ContactsEvent {
  final String docID;
  final String name;
  final String phone;
  final String email;

  UpdateContactEvent(this.docID, this.name, this.phone, this.email);

  @override
  List<Object?> get props => [docID, name, phone, email];
}

class DeleteContactEvent extends ContactsEvent {
  final String docID;

  DeleteContactEvent(this.docID);

  @override
  List<Object?> get props => [docID];
}

class SearchContacts extends ContactsEvent {
  final String query;

  SearchContacts(this.query);

  @override
  List<Object?> get props => [query];
}