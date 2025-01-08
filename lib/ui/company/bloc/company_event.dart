import 'package:equatable/equatable.dart';

abstract class CompanyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddCompany extends CompanyEvent {
  final String name;
  final String address;
  final String phone;
  final String? rcn;

  AddCompany(this.name, this.address, this.phone, this.rcn);

  @override
  List<Object> get props => [name, address, phone, rcn ?? ''];
}
