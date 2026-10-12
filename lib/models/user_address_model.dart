class UserAddress {
  final String id;
  final String label; // e.g. Home, Office, Other
  final String houseNoBuilding;
  final String streetArea;
  final String city;
  final String pincode;
  final String landmark;
  final bool isDefault;

  const UserAddress({
    required this.id,
    required this.label,
    required this.houseNoBuilding,
    required this.streetArea,
    required this.city,
    required this.pincode,
    this.landmark = '',
    this.isDefault = false,
  });

  String get fullAddress =>
      '$houseNoBuilding, $streetArea, $city - $pincode${landmark.isNotEmpty ? ' (Near $landmark)' : ''}';

  UserAddress copyWith({
    String? id,
    String? label,
    String? houseNoBuilding,
    String? streetArea,
    String? city,
    String? pincode,
    String? landmark,
    bool? isDefault,
  }) {
    return UserAddress(
      id: id ?? this.id,
      label: label ?? this.label,
      houseNoBuilding: houseNoBuilding ?? this.houseNoBuilding,
      streetArea: streetArea ?? this.streetArea,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      landmark: landmark ?? this.landmark,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class ContactInfo {
  final String fullName;
  final String phone;
  final String email;
  final String instructions;

  const ContactInfo({
    required this.fullName,
    required this.phone,
    required this.email,
    this.instructions = '',
  });

  ContactInfo copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? instructions,
  }) {
    return ContactInfo(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      instructions: instructions ?? this.instructions,
    );
  }
}
