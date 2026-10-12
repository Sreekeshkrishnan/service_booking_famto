import 'service_model.dart';
import 'user_address_model.dart';

enum BookingStatus {
  confirmed,
  inProgress,
  completed,
  cancelled,
}

extension BookingStatusExtension on BookingStatus {
  String get displayName {
    switch (this) {
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class TimeSlot {
  final String id;
  final String timeText; // e.g., "10:00 AM - 11:00 AM"
  final String period; // Morning, Afternoon, Evening
  final bool isAvailable;

  const TimeSlot({
    required this.id,
    required this.timeText,
    required this.period,
    this.isAvailable = true,
  });
}

class PromoCode {
  final String code;
  final String description;
  final double discountPercentage; // e.g. 20 for 20%
  final double maxDiscountAmount;
  final double minOrderAmount;

  const PromoCode({
    required this.code,
    required this.description,
    required this.discountPercentage,
    required this.maxDiscountAmount,
    required this.minOrderAmount,
  });

  double calculateDiscount(double subtotal) {
    if (subtotal < minOrderAmount) return 0.0;
    double calculated = subtotal * (discountPercentage / 100);
    return calculated > maxDiscountAmount ? maxDiscountAmount : calculated;
  }
}

class BookingModel {
  final String id;
  final ServiceItem service;
  final List<ServiceAddon> selectedAddons;
  final DateTime bookingDate;
  final TimeSlot selectedSlot;
  final UserAddress deliveryAddress;
  final ContactInfo contactInfo;
  final String paymentMethod;
  final double serviceBasePrice;
  final double addonsTotalPrice;
  final double platformFee;
  final double discountAmount;
  final double taxes;
  final double grandTotal;
  final BookingStatus status;
  final DateTime createdAt;
  final String? appliedPromoCode;

  const BookingModel({
    required this.id,
    required this.service,
    required this.selectedAddons,
    required this.bookingDate,
    required this.selectedSlot,
    required this.deliveryAddress,
    required this.contactInfo,
    required this.paymentMethod,
    required this.serviceBasePrice,
    required this.addonsTotalPrice,
    required this.platformFee,
    required this.discountAmount,
    required this.taxes,
    required this.grandTotal,
    required this.status,
    required this.createdAt,
    this.appliedPromoCode,
  });

  BookingModel copyWith({
    BookingStatus? status,
  }) {
    return BookingModel(
      id: id,
      service: service,
      selectedAddons: selectedAddons,
      bookingDate: bookingDate,
      selectedSlot: selectedSlot,
      deliveryAddress: deliveryAddress,
      contactInfo: contactInfo,
      paymentMethod: paymentMethod,
      serviceBasePrice: serviceBasePrice,
      addonsTotalPrice: addonsTotalPrice,
      platformFee: platformFee,
      discountAmount: discountAmount,
      taxes: taxes,
      grandTotal: grandTotal,
      status: status ?? this.status,
      createdAt: createdAt,
      appliedPromoCode: appliedPromoCode,
    );
  }
}
