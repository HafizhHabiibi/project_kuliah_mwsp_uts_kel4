import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel? currentUser;

  const EditProfilePage({super.key, this.currentUser});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _photoUrlController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill form dengan data user saat ini jika ada
    if (widget.currentUser != null) {
      _nameController.text = widget.currentUser!.username;
      _addressController.text = widget.currentUser!.alamat ?? '';
      _photoUrlController.text = widget.currentUser!.gambarUrl ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService().updateProfile(
        username: _nameController.text.trim(),
        alamat: _addressController.text.trim().isNotEmpty
            ? _addressController.text.trim()
            : null,
        gambarUrl: _photoUrlController.text.trim().isNotEmpty
            ? _photoUrlController.text.trim()
            : null,
      );

      if (!mounted) return;

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Kembalikan updated user ke halaman sebelumnya
        Navigator.pop(context, result['user']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(74, 55, 73, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(74, 55, 73, 1),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ===== PREVIEW FOTO PROFIL =====
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromRGBO(226, 201, 150, 1),
                      width: 4,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _photoUrlController.text.isNotEmpty
                      ? NetworkImage(_photoUrlController.text)
                      : null,
                  child: _photoUrlController.text.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ===== FORM SECTION =====
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Update Your Profile",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // NAME FIELD
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        }
                        if (value.trim().length < 4) {
                          return 'Name must be at least 4 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // ADDRESS FIELD
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address (City, Country)',
                        hintText: 'e.g. London, England',
                        prefixIcon: const Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 16),

                    // PHOTO URL FIELD
                    TextFormField(
                      controller: _photoUrlController,
                      decoration: InputDecoration(
                        labelText: 'Profile Photo URL',
                        hintText: 'https://example.com/photo.jpg',
                        prefixIcon: const Icon(Icons.image),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.url,
                      onChanged: (value) {
                        // Update preview saat user mengetik
                        setState(() {});
                      },
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          // Validasi URL sederhana
                          if (!value.startsWith('http://') &&
                              !value.startsWith('https://')) {
                            return 'Please enter a valid URL (must start with http:// or https://)';
                          }
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // INFO TEXT
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue[700],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'You can use image URL from services like Imgur, Google Drive, or any direct image link.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // SAVE BUTTON
                    ElevatedButton(
                      onPressed: _isLoading ? null : _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(74, 55, 73, 1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),

                    const SizedBox(height: 12),

                    // CANCEL BUTTON
                    OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color.fromRGBO(74, 55, 73, 1),
                        side: const BorderSide(
                          color: Color.fromRGBO(74, 55, 73, 1),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
