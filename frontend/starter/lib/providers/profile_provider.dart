import 'package:flutter/foundation.dart';
import 'package:starter/models/profile_model.dart';

class ProfileDataProvider with ChangeNotifier {
  ProfileModel _profileData = ProfileModel();
  ProfileModel get profileData => _profileData;

  void initProfileData(
    String firstName,
    String middleInitial,
    String lastName,
    String mobileNumber,
    String address,
  ) {
    _profileData = ProfileModel(
      firstName: firstName,
      middleInitial: middleInitial,
      lastName: lastName,
      mobileNumber: mobileNumber,
      address: address,
    );
    notifyListeners();
  }

  void editProfileData(String mobileNumber, String address) {
    _profileData = ProfileModel(mobileNumber: mobileNumber, address: address);
  }
}
