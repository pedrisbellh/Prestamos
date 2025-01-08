class Company {
  final String name;
  final String address;
  final String phone;
  final String? rcn;
  final String userId;

  Company({
    required this.name,
    required this.address,
    required this.phone,
    this.rcn,
    required this.userId,
  });

  factory Company.fromMap(Map<String, dynamic> data) {
    return Company(
      name: data['name'],
      address: data['address'],
      phone: data['phone'],
      rcn: data['rcn'],
      userId: data['userId'],
    );
  }
}
