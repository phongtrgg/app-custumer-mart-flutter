import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart';
import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get/get_connect.dart';
import '../model/country_model.dart';
import 'country_repository_interface.dart';

class CountryRepository implements CountryRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  CountryRepository({required this.apiClient, required this.sharedPreferences});

  @override
  AddressModel? getAddressFormSharedPref() {
    AddressModel? addressModel;
    try {
      addressModel = AddressModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!));
    } catch (e) {
      debugPrint('Did not get shared Preferences address . Note: $e');
    }
    return addressModel;
  }

  @override
  void createOrUpdateDevice(CountryModel country) {
    int? countryID = sharedPreferences.getInt(AppConstants.countryServiceID);
    String? languageCode = sharedPreferences.getString(AppConstants.languageCode);
    String? deviceId = sharedPreferences.getString(AppConstants.deviceId);
    final body = {
      'region_id': countryID,
      'device_id': deviceId,
      "language_code": languageCode,
    };
    apiClient.postData(AppConstants.deviceSettingsUri, body);
  }

  @override
  void saveCountry(CountryModel country) {
    sharedPreferences.setInt(AppConstants.countryServiceID, country.regionID!);
  }

  @override
  Future<List<CountryModel>> getCountry() async {
    List<CountryModel> countryModel = [];
    final response = await apiClient.getData(AppConstants.getCountryUri);

    if (response.statusCode == 200) {
      countryModel = (response.body as List).map((json) => CountryModel.fromJson(json)).toList();
    }

    return countryModel;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }
}
