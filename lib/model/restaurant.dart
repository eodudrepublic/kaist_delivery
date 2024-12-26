class Restaurant {
  final String name;
  final String address;
  final String phone;

  Restaurant({
    required this.name,
    required this.address,
    required this.phone,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['Name'] as String,
      address: json['Address'] as String,
      phone: json['Phone'] as String,
    );
  }
}
