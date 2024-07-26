import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:flutter/material.dart';

import '../../../language/domain/models/language_model.dart';
import '../model/country_model.dart';
import '../repositories/country_repository_interface.dart';
import 'country_service_interface.dart';

class CountryService implements CountryServiceInterface {
  final CountryRepositoryInterface countryRepositoryInterface;

  CountryService({required this.countryRepositoryInterface});

  @override
  bool setLTR(Locale locale) {
    bool isLtr = true;
    if (locale.countryCode == 'ar') {
      isLtr = false;
    } else {
      isLtr = true;
    }
    return isLtr;
  }

  @override
  createOrUpdateDevice(CountryModel country) {
    countryRepositoryInterface.createOrUpdateDevice(country);
  }

  @override
  setSelectedCountryIndex(List<CountryModel> country, Locale locale) {
    int selectedCountryIndex = 0;
    for (int index = 0; index < country.length; index++) {
      if (country[index].regionCode == locale.countryCode) {
        selectedCountryIndex = index;
        break;
      }
    }
    return selectedCountryIndex;
  }

  @override
  void saveCountry(CountryModel country) {
    countryRepositoryInterface.saveCountry(country);
  }

  @override
  Future<List<CountryModel>> getCountry() async {
    return await countryRepositoryInterface.getCountry();
  }
}
