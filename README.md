# Avoura App – Final Features

Framework: Flutter
Architecture: BLoC + MVVM
Backend: Firebase (Firestore + Auth)

Authentication
Login using email and password

Sign up using email and password

Login/Sign up using Google

Logout functionality

Architecture & File Structure
MVVM (Model-View-ViewModel) pattern

BLoC state management throughout

Organized folder structure:

core/ – shared services and utilities

models/ – data models

viewmodels/ – BLoC logic and events/states

views/ – UI: screens and widgets

Firestore Features
Create data (e.g., contact, note, entry)

Read data (using Firestore stream)

Update data

Delete data

Search functionality using Firestore query filtering

Form Validation
Login and Sign Up form validation

Field-level validation (e.g., email format, password length)

Error messages for invalid inputs

Phone Call Integration
Uses flutter_phone_direct_caller to directly call phone numbers

Permission handling via permission_handler

Requests Permission.phone at runtime before calling

Additional UX Features
Snackbar for success and error messages

Loading indicators for async operations

Responsive UI layout

Clean, user-friendly design
