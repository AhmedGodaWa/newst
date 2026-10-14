import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newst/features/auth/data/auth_service.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/storage/profile_local_storage.dart';

class ProfileController extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  final ProfileLocalStorage _localStorage = ProfileLocalStorage();
  final AuthService _authService = AuthService();

  String? _userName;
  String? get userName => _userName;

  String? get userEmail => _authService.currentUser?.email;

  File? _profileImage;
  File? get profileImage => _profileImage;

  bool _isLoggingOut = false;
  bool get isLoggingOut => _isLoggingOut;

  String? _country;
  String? get country => _country;

  Future<void> initialize() async {
    await loadUserProfile();
    await loadProfileImage();
    await loadCountry();
  }

  Future<void> loadUserProfile() async {
    final user = _authService.currentUser;

    if (user == null) return;

    _userName = user.userMetadata?['name'] as String?;

    notifyListeners();
  }

  Future<void> updateUserName(String name) async {
    final updatedUser = await _authService.updateUserName(name);

    _userName = updatedUser.user?.userMetadata?['name'] as String?;

    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggingOut = true;
    notifyListeners();

    try {
      await _authService.signOut();

      final imagePath = await _localStorage.getImagePath();

      if (imagePath != null) {
        final imageFile = File(imagePath);

        if (await imageFile.exists()) {
          await imageFile.delete();
        }
      }

      await _localStorage.clearImagePath();
      await _localStorage.clearCountry();

      _profileImage = null;
      _userName = null;
      _country = null;
    } finally {
      _isLoggingOut = false;
      notifyListeners();
    }
  }

  Future<void> pickProfileImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(source: source);
    if (image == null) return;

    final oldImagePath = await _localStorage.getImagePath();

    final appDirectory = await getApplicationDocumentsDirectory();

    final fileName =
        'profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final savedImage = await File(
      image.path,
    ).copy('${appDirectory.path}/$fileName');

    _profileImage = savedImage;

    notifyListeners();

    await _localStorage.saveImagePath(savedImage.path);

    if (oldImagePath != null) {
      final oldImage = File(oldImagePath);

      if (await oldImage.exists()) {
        await oldImage.delete();
      }
    }
  }

  Future<void> loadProfileImage() async {
    final imagePath = await _localStorage.getImagePath();

    if (imagePath == null) return;

    final imageFile = File(imagePath);

    if (!await imageFile.exists()) {
      await _localStorage.clearImagePath();
      return;
    }

    _profileImage = imageFile;
    notifyListeners();
  }

  Future<void> loadCountry() async {
    _country = await _localStorage.getCountry();
    notifyListeners();
  }

  Future<void> selectCountry(Country country) async {
    _country = country.name;

    await _localStorage.saveCountry(country.name);

    notifyListeners();
  }
}
