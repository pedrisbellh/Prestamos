import 'package:equatable/equatable.dart';

abstract class CompanyState extends Equatable {
  @override
  List<Object> get props => [];
}

class CompanyInitial extends CompanyState {}

class CompanyLoading extends CompanyState {}

class CompanySuccess extends CompanyState {
  final String message;

  CompanySuccess(this.message);

  @override
  List<Object> get props => [message];
}

class CompanyError extends CompanyState {
  final String message;

  CompanyError(this.message);

  @override
  List<Object> get props => [message];
}
