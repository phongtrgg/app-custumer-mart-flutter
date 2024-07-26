import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/features/country/controller/countryController.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';

class CountryListWidget extends StatelessWidget {
  final CountryController countryController;

  const CountryListWidget({
    Key? key,
    required this.countryController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CountryController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: (controller.country.length / 2).ceil(),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          itemBuilder: (context, rowIndex) {
            final int firstIndex = rowIndex * 2;
            final int secondIndex = firstIndex + 1;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (firstIndex < controller.country.length)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.setSelectCountryIndex(firstIndex);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          border: Border.all(
                            color: controller.selectedCountryIndex == firstIndex ? Theme.of(context).primaryColor.withOpacity(1) : Colors.grey.withOpacity(0.3),
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Image.network(
                              controller.country[firstIndex].imageUrl!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.error,
                                  size: 80,
                                );
                              },
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Text(
                              '${controller.country[firstIndex].regionName!}'.tr,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 30),
                if (secondIndex < controller.country.length)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.setSelectCountryIndex(secondIndex);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          border: Border.all(
                            color: controller.selectedCountryIndex == secondIndex ? Theme.of(context).primaryColor.withOpacity(1) : Colors.grey.withOpacity(0.3),
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Image.network(
                              controller.country[secondIndex].imageUrl!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.error,
                                  size: 80,
                                );
                              },
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Text(
                              '${controller.country[secondIndex].regionName!}'.tr,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
