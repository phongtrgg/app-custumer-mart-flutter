import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/features/country/controller/country_controller.dart';
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
        return Container(
          height: 150,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: controller.country.length > 2 ? 2 : controller.country.length,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            itemBuilder: (context, index) {
              final country = controller.country[index];

              bool isSelected = controller.selectedCountryIndex == index;

              return GestureDetector(
                onTap: () {
                  controller.setSelectCountryIndex(index);
                },
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    border: Border.all(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.3),
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (country.imageUrl != null)
                        Image.network(
                          country.imageUrl!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.error,
                              size: 80,
                            );
                          },
                        )
                      else
                        const Icon(
                          Icons.error,
                          size: 80,
                        ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      controller.selectedCountryIndex != index
                          ? Text(
                              '${country.regionName ?? 'No Name'}'.tr,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
