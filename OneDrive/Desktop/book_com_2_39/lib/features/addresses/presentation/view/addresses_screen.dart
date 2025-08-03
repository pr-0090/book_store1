import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/hive_service.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  Map<String, dynamic>? _savedAddress;
  bool _isLoading = true;
  bool _isEditing = false;
  
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await ApiService().getAddress();
      if (mounted && response.statusCode == 200) {
        final address = response.data['address'];
        if (address != null) {
          setState(() {
            _savedAddress = address;
            _fullNameController.text = address['fullName'] ?? '';
            _phoneController.text = address['phoneNumber'] ?? '';
            _streetAddressController.text = address['streetAddress'] ?? '';
            _landmarkController.text = address['landmark'] ?? '';
            _cityController.text = address['city'] ?? '';
            _stateController.text = address['state'] ?? '';
            _countryController.text = address['country'] ?? '';
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      await ApiService().createAddress({
        'fullName': _fullNameController.text,
        'phoneNumber': _phoneController.text,
        'streetAddress': _streetAddressController.text,
        'landmark': _landmarkController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'country': _countryController.text,
      });

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isEditing = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address saved successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        
        _loadAddress(); // Reload to get updated data
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save address: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _deleteAddress() async {
    try {
      await ApiService().deleteAddress();
      
      if (mounted) {
        setState(() {
          _savedAddress = null;
          _fullNameController.clear();
          _phoneController.clear();
          _streetAddressController.clear();
          _landmarkController.clear();
          _cityController.clear();
          _stateController.clear();
          _countryController.clear();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address deleted successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete address: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _streetAddressController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Saved Addresses',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          if (_savedAddress != null && !_isEditing)
            IconButton(
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              icon: const Icon(Icons.edit, color: Colors.white),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _savedAddress == null || _isEditing
              ? _buildAddressForm()
              : _buildAddressCard(),
    );
  }

  Widget _buildAddressForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _savedAddress == null ? 'Add New Address' : 'Edit Address',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Full Name
            TextFormField(
              controller: _fullNameController,
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
              controller: _phoneController,
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
              controller: _streetAddressController,
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
              controller: _landmarkController,
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
                    controller: _cityController,
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
                    controller: _stateController,
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
              controller: _countryController,
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
            
            SizedBox(height: 32.h),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save Address',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            if (_isEditing) ...[
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textSecondaryColor,
                    side: BorderSide(color: AppTheme.textSecondaryColor),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saved Address',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          Container(
            padding: EdgeInsets.all(20.w),
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
                      _savedAddress!['fullName'] ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24.h),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: BorderSide(color: AppTheme.primaryColor),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Edit Address',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: 16.w),
              
              Expanded(
                child: ElevatedButton(
                  onPressed: _deleteAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressLine(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: AppTheme.textSecondaryColor,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
} 