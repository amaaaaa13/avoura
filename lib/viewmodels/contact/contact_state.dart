import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class ContactsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<QueryDocumentSnapshot> contacts;

  ContactsLoaded(this.contacts);

  @override
  List<Object?> get props => [contacts];
}

class ContactsError extends ContactsState {
  final String message;

  ContactsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ContactActionSuccess extends ContactsState {
  final String message;

  ContactActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}