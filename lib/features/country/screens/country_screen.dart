import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/features/country/controller/country_controller.dart';
import 'package:stackfood_multivendor/features/country/widgets/country_list_widget.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';

import '../../../util/app_constants.dart';
import '../../language/widgets/language_selector.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GetBuilder<CountryController>(builder: (countryController) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Content for the screen
                Text(
                  'choose a country'.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'country wishing to use the service'.tr,
                  style: TextStyle(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                CountryListWidget(
                  countryController: countryController,
                ),
              ],
            );
          }),
          Positioned(
            top: Dimensions.paddingSizeExtraOverLarge,
            right: Dimensions.paddingSizeLarge,
            child: LanguageSelector(),
          ),
          Positioned(
            top: Dimensions.paddingSizeExtraOverLarge,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'language'.tr,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: GetBuilder<CountryController>(builder: (countryController) {
        final isButtonEnabled = countryController.selectedCountryIndex != -1;

        return FloatingActionButton(
          onPressed: isButtonEnabled
              ? () {
                  countryController.getCountry();
                  countryController.setCountry();
                  Get.offNamed(RouteHelper.getOnBoardingRoute());
                }
              : null,
          backgroundColor: isButtonEnabled ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.3),
          child: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 30,
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
