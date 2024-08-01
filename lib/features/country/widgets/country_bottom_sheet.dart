import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/language/widgets/language_card_widget.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

import '../controller/country_controller.dart';

class CountryBottomSheetWidget extends StatefulWidget {
  const CountryBottomSheetWidget({super.key});

  @override
  State<CountryBottomSheetWidget> createState() => _CountryBottomSheetWidgetState();
}

class _CountryBottomSheetWidgetState extends State<CountryBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CountryController>(builder: (countryController) {
      return Container(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            height: 5,
            width: 35,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text('choose a country'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Text('country wishing to use the service'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
          ]),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
          Flexible(
            child: SingleChildScrollView(
              child: ListView.builder(
                itemCount: countryController.country.length > 2 ? 2 : countryController.country.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                itemBuilder: (context, index) {
                  return LanguageCardWidget(
                    languageModel: countryController.country[index],
                    localizationController: countryController,
                    index: index,
                    fromBottomSheet: true,
                    country: true,
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeExtraLarge),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10, spreadRadius: 0)],
            ),
            margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
            child: CustomButtonWidget(
              buttonText: 'update'.tr,
              onPressed: () {
                if (countryController.country.isNotEmpty && countryController.selectedCountryIndex != -1) {
                  countryController.setCountry();
                }
                Get.back();
              },
            ),
          ),
        ]),
      );
    });
  }
}
