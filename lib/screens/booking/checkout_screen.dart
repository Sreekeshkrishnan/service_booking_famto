import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/price_summary_card.dart';
import 'booking_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _instructionsController;
  final TextEditingController _promoController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    _nameController = TextEditingController(text: bookingProvider.contactName);
    _phoneController = TextEditingController(text: bookingProvider.contactPhone);
    _emailController = TextEditingController(text: bookingProvider.contactEmail);
    _instructionsController = TextEditingController(text: bookingProvider.instructions);
    
    if (bookingProvider.appliedPromo != null) {
      _promoController.text = bookingProvider.appliedPromo!.code;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _instructionsController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  void _onConfirmAndBook() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct validation errors before proceeding.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    // Save contact info
    bookingProvider.setContactInfo(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      instructions: _instructionsController.text.trim(),
    );

    // Simulate network delay for booking creation
    await Future.delayed(const Duration(milliseconds: 1000));

    final newBooking = bookingProvider.placeBooking();

    setState(() => _isSubmitting = false);

    if (newBooking != null && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => BookingConfirmationScreen(booking: newBooking),
        ),
        (route) => route.isFirst,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        final service = bookingProvider.draftService;
        final slot = bookingProvider.selectedTimeSlot;
        final address = bookingProvider.selectedAddress;

        if (service == null || slot == null || address == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Checkout')),
            body: const Center(
              child: Text('Incomplete booking details. Please start over.'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Review & Pay'),
            elevation: 0,
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service & Schedule Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Booking Summary',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(service.icon, size: 24, color: AppTheme.primaryColor),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${DateFormat('EEEE, d MMMM yyyy').format(bookingProvider.selectedDate)} • ${slot.timeText}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (bookingProvider.selectedAddons.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(color: AppTheme.borderLight, height: 1),
                          ),
                          const Text(
                            'Add-ons:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...bookingProvider.selectedAddons.map(
                            (a) => Text(
                              '• ${a.title} (+₹${a.price.toStringAsFixed(0)})',
                              style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Delivery Address Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_rounded, color: AppTheme.primaryColor, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Address (${address.label})',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                address.fullAddress,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Contact Information Form
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contact Details (For Professional Visit)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 14),

                        CustomTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          hint: 'Rahul Sharma',
                          prefixIcon: Icons.person_outline_rounded,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Please enter full name';
                            if (val.trim().length < 3) return 'Name must be at least 3 chars';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        CustomTextField(
                          controller: _phoneController,
                          label: 'Mobile Number',
                          hint: '9876543210',
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Please enter mobile number';
                            final cleaned = val.trim().replaceAll(RegExp(r'[^\d]'), '');
                            if (cleaned.length != 10) return 'Must be a valid 10-digit number';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        CustomTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          hint: 'rahul@example.com',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Please enter email';
                            final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(val.trim())) return 'Please enter a valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        CustomTextField(
                          controller: _instructionsController,
                          label: 'Special Instructions (Optional)',
                          hint: 'e.g., Gate password, call before entering',
                          prefixIcon: Icons.note_alt_outlined,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Coupon Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Promo Code / Coupon',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _promoController,
                                textCapitalization: TextCapitalization.characters,
                                decoration: const InputDecoration(
                                  hintText: 'Enter code (e.g. FAMTO20)',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (bookingProvider.appliedPromo == null)
                              ElevatedButton(
                                onPressed: () {
                                  bookingProvider.applyPromoCode(_promoController.text);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                ),
                                child: const Text('Apply'),
                              )
                            else
                              OutlinedButton(
                                onPressed: () {
                                  bookingProvider.removePromoCode();
                                  _promoController.clear();
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.errorColor,
                                  side: const BorderSide(color: AppTheme.errorColor),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                ),
                                child: const Text('Remove'),
                              ),
                          ],
                        ),

                        if (bookingProvider.promoError.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            bookingProvider.promoError,
                            style: const TextStyle(
                              color: AppTheme.errorColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],

                        if (bookingProvider.appliedPromo != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.stars_rounded, color: AppTheme.successColor, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Applied ${bookingProvider.appliedPromo!.code}: Saved ₹${bookingProvider.discountAmount.toStringAsFixed(0)}!',
                                  style: const TextStyle(
                                    color: AppTheme.successColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Payment Method Selector
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payment Method',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),

                        RadioListTile<String>(
                          value: 'UPI / Online Payment',
                          groupValue: bookingProvider.selectedPaymentMethod,
                          activeColor: AppTheme.primaryColor,
                          title: const Text('UPI / Credit & Debit Cards', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          subtitle: const Text('Instant confirmation & secure checkout', style: TextStyle(fontSize: 12)),
                          secondary: const Icon(Icons.payment_rounded, color: AppTheme.primaryColor),
                          onChanged: (val) {
                            if (val != null) bookingProvider.setPaymentMethod(val);
                          },
                        ),
                        const Divider(height: 1, color: AppTheme.borderLight),
                        RadioListTile<String>(
                          value: 'Cash on Delivery',
                          groupValue: bookingProvider.selectedPaymentMethod,
                          activeColor: AppTheme.primaryColor,
                          title: const Text('Pay After Service (Cash / UPI)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          subtitle: const Text('Pay directly to service partner after work completion', style: TextStyle(fontSize: 12)),
                          secondary: const Icon(Icons.payments_rounded, color: AppTheme.secondaryColor),
                          onChanged: (val) {
                            if (val != null) bookingProvider.setPaymentMethod(val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Price Summary Breakdown
                  PriceSummaryCard(
                    serviceBasePrice: bookingProvider.serviceBasePrice,
                    addonsTotalPrice: bookingProvider.addonsTotalPrice,
                    platformFee: BookingProvider.platformFee,
                    discountAmount: bookingProvider.discountAmount,
                    taxes: bookingProvider.taxesAmount,
                    grandTotal: bookingProvider.grandTotal,
                    appliedPromoCode: bookingProvider.appliedPromo?.code,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // Bottom CTA
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceColor,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
              ],
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Amount', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    Text(
                      '₹${bookingProvider.grandTotal.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomButton(
                    text: 'Confirm & Book Service',
                    icon: Icons.check_circle_rounded,
                    isLoading: _isSubmitting,
                    onPressed: _onConfirmAndBook,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
