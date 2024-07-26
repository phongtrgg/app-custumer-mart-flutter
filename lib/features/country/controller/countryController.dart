import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:stackfood_multivendor/features/home/screens/home_screen.dart';
import 'package:stackfood_multivendor/features/language/domain/models/language_model.dart';
import 'package:stackfood_multivendor/features/language/domain/service/language_service_interface.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../domain/model/country_model.dart';
import '../domain/services/country_service_interface.dart';

class CountryController extends GetxController implements GetxService {
  final CountryServiceInterface countryServiceInterface;

  CountryController({required this.countryServiceInterface}) {
    getCountry();
  }

  List<CountryModel> _country = [];

  List<CountryModel> get country => _country;

  int _selectedCountryIndex = 0;

  int get selectedCountryIndex => _selectedCountryIndex;

  void setCountry({bool fromBottomSheet = false}) {
    saveCountry(_country[_selectedCountryIndex]);
    countryServiceInterface.createOrUpdateDevice(_country[_selectedCountryIndex]);
    if (AddressHelper.getAddressFromSharedPref() != null && !fromBottomSheet) {
      HomeScreen.loadData(true);
    }
    update();
  }

  void saveCountry(CountryModel country) async {
    countryServiceInterface.saveCountry(country);
  }

  void setSelectCountryIndex(int index) {
    _selectedCountryIndex = index;
    update();
  }

  void searchSelectedCountry() {
    for (var country in _country) {
      _selectedCountryIndex = _country.indexOf(country);
    }
  }

  void getCountry() async {
    final List<CountryModel> countryResponse = await countryServiceInterface.getCountry();
    _country = countryResponse;
    update();
  }
}
