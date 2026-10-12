import 'dart:math';
import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../models/booking_model.dart';
import '../models/user_address_model.dart';
import '../data/mock_data.dart';

class BookingProvider with ChangeNotifier {
  // Saved addresses
  final List<UserAddress> _addresses = List.from(MockData.initialAddresses);
  
  // Booking history
  final List<BookingModel> _bookingHistory = List.from(MockData.sampleInitialBookings);

  // Draft booking state (being built)
  ServiceItem? _draftService;
  List<ServiceAddon> _selectedAddons = [];
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeSlot? _selectedTimeSlot = MockData.timeSlots.first;
  UserAddress? _selectedAddress;
  
  // Contact details
  String _contactName = 'Rahul Sharma';
  String _contactPhone = '9876543210';
  String _contactEmail = 'rahul.sharma@example.com';
  String _instructions = '';

  // Promo code state
  PromoCode? _appliedPromo;
  String _promoError = '';

  // Payment method
  String _selectedPaymentMethod = 'UPI / Online Payment';

  // Fee constants
  static const double platformFee = 29.0;
  static const double taxRate = 0.05; // 5% GST

  BookingProvider() {
    if (_addresses.isNotEmpty) {
      _selectedAddress = _addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => _addresses.first,
      );
    }
  }

  // Getters
  List<UserAddress> get addresses => _addresses;
  List<BookingModel> get bookingHistory => List.unmodifiable(_bookingHistory);
  List<TimeSlot> get timeSlots => MockData.timeSlots;
  
  ServiceItem? get draftService => _draftService;
  List<ServiceAddon> get selectedAddons => _selectedAddons;
  DateTime get selectedDate => _selectedDate;
  TimeSlot? get selectedTimeSlot => _selectedTimeSlot;
  UserAddress? get selectedAddress => _selectedAddress;

  String get contactName => _contactName;
  String get contactPhone => _contactPhone;
  String get contactEmail => _contactEmail;
  String get instructions => _instructions;

  PromoCode? get appliedPromo => _appliedPromo;
  String get promoError => _promoError;
  String get selectedPaymentMethod => _selectedPaymentMethod;

  // Price Calculations
  double get serviceBasePrice => _draftService?.price ?? 0.0;

  double get addonsTotalPrice {
    return _selectedAddons.fold(0.0, (sum, addon) => sum + addon.price);
  }

  double get subtotal => serviceBasePrice + addonsTotalPrice;

  double get discountAmount {
    if (_appliedPromo == null) return 0.0;
    return _appliedPromo!.calculateDiscount(subtotal);
  }

  double get netAmountAfterDiscount {
    double net = subtotal - discountAmount;
    return net < 0 ? 0 : net;
  }

  double get taxesAmount {
    return netAmountAfterDiscount * taxRate;
  }

  double get grandTotal {
    return netAmountAfterDiscount + platformFee + taxesAmount;
  }

  // Active vs Past Bookings
  List<BookingModel> get activeBookings {
    return _bookingHistory.where((b) =>
      b.status == BookingStatus.confirmed || b.status == BookingStatus.inProgress
    ).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<BookingModel> get pastBookings {
    return _bookingHistory.where((b) =>
      b.status == BookingStatus.completed || b.status == BookingStatus.cancelled
    ).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Draft Mutations
  void initDraftBooking(ServiceItem service) {
    _draftService = service;
    _selectedAddons = [];
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    _selectedTimeSlot = MockData.timeSlots.first;
    _appliedPromo = null;
    _promoError = '';
    notifyListeners();
  }

  void toggleAddon(ServiceAddon addon) {
    if (_selectedAddons.any((a) => a.id == addon.id)) {
      _selectedAddons.removeWhere((a) => a.id == addon.id);
    } else {
      _selectedAddons.add(addon);
    }
    // Re-verify promo if applicable
    if (_appliedPromo != null) {
      if (subtotal < _appliedPromo!.minOrderAmount) {
        _appliedPromo = null;
        _promoError = 'Promo code removed: Order minimum not met.';
      }
    }
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedTimeSlot(TimeSlot slot) {
    _selectedTimeSlot = slot;
    notifyListeners();
  }

  void setSelectedAddress(UserAddress address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void addNewAddress(UserAddress newAddr) {
    _addresses.add(newAddr);
    _selectedAddress = newAddr;
    notifyListeners();
  }

  void setContactInfo({
    required String name,
    required String phone,
    required String email,
    String? instructions,
  }) {
    _contactName = name;
    _contactPhone = phone;
    _contactEmail = email;
    if (instructions != null) {
      _instructions = instructions;
    }
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  // Promo Code Actions
  bool applyPromoCode(String inputCode) {
    _promoError = '';
    final code = inputCode.trim().toUpperCase();
    
    if (code.isEmpty) {
      _promoError = 'Please enter a valid coupon code.';
      notifyListeners();
      return false;
    }

    final match = MockData.availablePromos.firstWhere(
      (p) => p.code == code,
      orElse: () => const PromoCode(
        code: '',
        description: '',
        discountPercentage: 0,
        maxDiscountAmount: 0,
        minOrderAmount: 0,
      ),
    );

    if (match.code.isEmpty) {
      _promoError = 'Invalid promo code. Try FAMTO20 or WELCOME50.';
      notifyListeners();
      return false;
    }

    if (subtotal < match.minOrderAmount) {
      _promoError = 'Minimum order of ₹${match.minOrderAmount.toInt()} required for ${match.code}.';
      notifyListeners();
      return false;
    }

    _appliedPromo = match;
    _promoError = '';
    notifyListeners();
    return true;
  }

  void removePromoCode() {
    _appliedPromo = null;
    _promoError = '';
    notifyListeners();
  }

  // Confirm and Place Booking
  BookingModel? placeBooking() {
    if (_draftService == null || _selectedTimeSlot == null || _selectedAddress == null) {
      return null;
    }

    final randomNum = Random().nextInt(89999) + 10000;
    final bookingId = 'FAMTO-$randomNum';

    final newBooking = BookingModel(
      id: bookingId,
      service: _draftService!,
      selectedAddons: List.from(_selectedAddons),
      bookingDate: _selectedDate,
      selectedSlot: _selectedTimeSlot!,
      deliveryAddress: _selectedAddress!,
      contactInfo: ContactInfo(
        fullName: _contactName,
        phone: _contactPhone,
        email: _contactEmail,
        instructions: _instructions,
      ),
      paymentMethod: _selectedPaymentMethod,
      serviceBasePrice: serviceBasePrice,
      addonsTotalPrice: addonsTotalPrice,
      platformFee: platformFee,
      discountAmount: discountAmount,
      taxes: taxesAmount,
      grandTotal: grandTotal,
      status: BookingStatus.confirmed,
      createdAt: DateTime.now(),
      appliedPromoCode: _appliedPromo?.code,
    );

    _bookingHistory.insert(0, newBooking);

    // Reset draft
    _draftService = null;
    _selectedAddons = [];
    _appliedPromo = null;
    _promoError = '';
    
    notifyListeners();
    return newBooking;
  }

  void cancelBooking(String bookingId) {
    final index = _bookingHistory.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookingHistory[index] = _bookingHistory[index].copyWith(
        status: BookingStatus.cancelled,
      );
      notifyListeners();
    }
  }
}
