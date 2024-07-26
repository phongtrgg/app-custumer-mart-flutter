import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/interface/repository_interface.dart';
import 'package:flutter/material.dart';

import '../../../language/domain/models/language_model.dart';
import '../model/country_model.dart';

abstract class CountryRepositoryInterface extends RepositoryInterface {
  AddressModel? getAddressFormSharedPref();

  // void updateHeader(AddressModel? addressModel, Locale locale);
  void createOrUpdateDevice(CountryModel country);

  void saveCountry(CountryModel country);

  Future<List<CountryModel>> getCountry();
}
