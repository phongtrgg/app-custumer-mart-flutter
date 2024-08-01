import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:stackfood_multivendor/features/home/screens/home_screen.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:get/get.dart';
import '../../../helper/route_helper.dart';
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
    try {
      final List<CountryModel> countryResponse = await countryServiceInterface.getCountry();
      _country = countryResponse;
      // _country = [
      //   CountryModel(
      //     imageUrl: 'https://images.baodantoc.vn/uploads/2022/Th%C3%A1ng%208/Ng%C3%A0y_31/Nga/quockyvietnam-copy-7814.jpg',
      //     regionID: 1,
      //     regionName: 'Region 1',
      //     regionCode: 'R1',
      //   ),
      //   CountryModel(
      //     imageUrl: 'https://images.baodantoc.vn/uploads/2022/Th%C3%A1ng%208/Ng%C3%A0y_31/Nga/quockyvietnam-copy-7814.jpg',
      //     regionID: 2,
      //     regionName: 'Region 2',
      //     regionCode: 'R2',
      //   ),
      //   CountryModel(
      //     imageUrl: 'https://example.com/image3.jpg',
      //     regionID: 3,
      //     regionName: 'Region 3',
      //     regionCode: 'R3',
      //   ),
      // ];
      update();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.offNamed(RouteHelper.getOnBoardingRoute());
    }
  }
}
