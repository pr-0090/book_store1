import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';

class AddressForm extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController streetAddressController;
  final TextEditingController landmarkController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController countryController;
  final Map<String, dynamic>? savedAddress;

  const AddressForm({
    super.key,
    required this.fullNameController,
    required this.phoneController,
    required this.streetAddressController,
    required this.landmarkController,
    required this.cityController,
    required this.stateController,
    required this.countryController,
    this.savedAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppTheme.primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Delivery Address',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Full Name
          TextFormField(
            controller: fullNameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          
          SizedBox(height: 16.h),
          
          // Phone Number
          TextFormField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          
          SizedBox(height: 16.h),
          
          // Street Address
          TextFormField(
            controller: streetAddressController,
            decoration: InputDecoration(
              labelText: 'Street Address',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.home),
            ),
            maxLines: 2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your street address';
              }
              return null;
            },
          ),
          
          SizedBox(height: 16.h),
          
          // Landmark
          TextFormField(
            controller: landmarkController,
            decoration: InputDecoration(
              labelText: 'Landmark',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.place),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter landmark';
              }
              return null;
            },
          ),
          
          SizedBox(height: 16.h),
          
          // City and State Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter city';
                    }
                    return null;
                  },
                ),
              ),
              
              SizedBox(width: 16.w),
              
              Expanded(
                child: TextFormField(
                  controller: stateController,
                  decoration: InputDecoration(
                    labelText: 'State',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.map),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter state';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Country
          TextFormField(
            controller: countryController,
            decoration: InputDecoration(
              labelText: 'Country',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.public),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter country';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
} 