import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PriceSummaryCard extends StatelessWidget {
  final double serviceBasePrice;
  final double addonsTotalPrice;
  final double platformFee;
  final double discountAmount;
  final double taxes;
  final double grandTotal;
  final String? appliedPromoCode;

  const PriceSummaryCard({
    super.key,
    required this.serviceBasePrice,
    required this.addonsTotalPrice,
    required this.platformFee,
    required this.discountAmount,
    required this.taxes,
    required this.grandTotal,
    this.appliedPromoCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Payment Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildRow('Item Total / Base Price', '₹${serviceBasePrice.toStringAsFixed(0)}'),
          if (addonsTotalPrice > 0) ...[
            const SizedBox(height: 8),
            _buildRow('Selected Add-ons', '₹${addonsTotalPrice.toStringAsFixed(0)}'),
          ],
          const SizedBox(height: 8),
          _buildRow('Platform Convenience Fee', '₹${platformFee.toStringAsFixed(0)}'),
          if (discountAmount > 0) ...[
            const SizedBox(height: 8),
            _buildRow(
              'Coupon Discount${appliedPromoCode != null ? ' ($appliedPromoCode)' : ''}',
              '- ₹${discountAmount.toStringAsFixed(0)}',
              isDiscount: true,
            ),
          ],
          const SizedBox(height: 8),
          _buildRow('Taxes & GST (5%)', '₹${taxes.toStringAsFixed(0)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppTheme.borderLight, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Payable',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '₹${grandTotal.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String amount, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isDiscount ? AppTheme.successColor : AppTheme.textSecondary,
            fontWeight: isDiscount ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDiscount ? AppTheme.successColor : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
