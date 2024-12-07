class Client {
  final String id; // ID del documento en Firestore
  final String name;
  final String phone;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String address; // Nuevo campo
  final String identityCard; // Nuevo campo

  Client(this.id, this.name, this.phone, this.emergencyContactName, this.emergencyContactPhone, this.address, this.identityCard);

  @override
  String toString() {
    return 'Client{name: $name, phone: $phone, emergencyContactName: $emergencyContactName, emergencyContactPhone: $emergencyContactPhone, address: $address, identityCard: $identityCard}';
  }
}