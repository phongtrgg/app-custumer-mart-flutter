import 'package:stackfood_multivendor/features/language/domain/models/language_model.dart';
import 'package:flutter/material.dart';

import '../model/country_model.dart';

abstract class CountryServiceInterface {
  bool setLTR(Locale locale);

  createOrUpdateDevice(CountryModel country);

  setSelectedCountryIndex(List<CountryModel> country, Locale locale);

  void saveCountry(CountryModel country);

  Future<List<CountryModel>> getCountry();
}
