import 'package:flutter/material.dart';
import '../models/user_address_model.dart';
import '../theme/app_theme.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

class AddAddressDialog extends StatefulWidget {
  const AddAddressDialog({super.key});

  @override
  State<AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  final _formKey = GlobalKey<FormState>();

  final _houseController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController(text: 'Bengaluru');
  final _pincodeController = TextEditingController();
  final _landmarkController = TextEditingController();

  String _selectedLabel = 'Home';

  @override
  void dispose() {
    _houseController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final newAddress = UserAddress(
        id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
        label: _selectedLabel,
        houseNoBuilding: _houseController.text.trim(),
        streetArea: _streetController.text.trim(),
        city: _cityController.text.trim(),
        pincode: _pincodeController.text.trim(),
        landmark: _landmarkController.text.trim(),
      );

      Navigator.of(context).pop(newAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppTheme.surfaceColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add New Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Label Chips
                Row(
                  children: ['Home', 'Office', 'Other'].map((label) {
                    final isSelected = _selectedLabel == label;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(label),
                        selectedColor: AppTheme.primaryLight,
                        checkmarkColor: AppTheme.primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedLabel = label);
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _houseController,
                  label: 'Flat / House No / Building Name',
                  hint: 'e.g., Flat 301, Emerald Heights',
                  validator: (val) =>
                      (val == null || val.trim().isEmpty) ? 'Please enter house/building details' : null,
                ),
                const SizedBox(height: 12),

                CustomTextField(
                  controller: _streetController,
                  label: 'Street / Area / Locality',
                  hint: 'e.g., 5th Main, HSR Layout',
                  validator: (val) =>
                      (val == null || val.trim().isEmpty) ? 'Please enter street/area details' : null,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _cityController,
                        label: 'City',
                        hint: 'Bengaluru',
                        validator: (val) =>
                            (val == null || val.trim().isEmpty) ? 'Enter city' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: _pincodeController,
                        label: 'Pincode',
                        hint: '560102',
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Enter pincode';
                          if (val.trim().length != 6) return '6 digits required';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                CustomTextField(
                  controller: _landmarkController,
                  label: 'Landmark (Optional)',
                  hint: 'e.g. Near Apollo Pharmacy',
                ),
                const SizedBox(height: 20),

                CustomButton(
                  text: 'Save & Use Address',
                  onPressed: _saveAddress,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
