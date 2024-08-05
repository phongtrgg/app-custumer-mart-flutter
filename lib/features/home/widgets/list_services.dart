import 'package:stackfood_multivendor/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ListServicesWidget extends StatefulWidget {
  const ListServicesWidget({super.key});

  @override
  State<ListServicesWidget> createState() => _ListServicesWidgetState();
}

class _ListServicesWidgetState extends State<ListServicesWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.only(
            top: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeOverLarge,
            left: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeExtraSmall : 0,
            right: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeExtraSmall,
            bottom: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeOverLarge,
          ),
          child: ResponsiveHelper.isDesktop(context)
              ? Text('services vtmart'.tr,
                  style: robotoMedium.copyWith(
                      // color: Theme.of(context).secondaryHeaderColor,
                      fontSize: Dimensions.fontSizeLarge,
                      fontWeight: FontWeight.w600))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'services vtmart'.tr,
                      style: robotoBold.copyWith(
                        // color: Theme.of(context).secondaryHeaderColor,
                        fontSize: Dimensions.fontSizeLarge,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    Padding(
                      padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                      child: ArrowIconButtonWidget(
                          onTap: () => {
                                categoryController.getSubCategoryList(categoryController.servicesList![0].id.toString()),
                                categoryController.setCategoryIndexAndTitle(categoryController.servicesList![0].id!, categoryController.servicesList![0].name!),
                                categoryController.setSelectedCategoryIndex(0),
                                Get.toNamed(RouteHelper.getCategoryRoute('service')),
                              }),
                    )
                  ],
                ),
        ),
        SizedBox(
          height: ResponsiveHelper.isMobile(context) ? 120 : 170,
          child: categoryController.servicesList != null
              ? ListView.builder(
                  physics: ResponsiveHelper.isMobile(context) ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                  itemCount: categoryController.servicesList!.length > 10 ? 10 : categoryController.servicesList!.length,
                  itemBuilder: (context, index) {
                    if (index == 9) {
                      return ResponsiveHelper.isDesktop(context)
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeSmall),
                              child: Container(
                                width: 70,
                                padding: const EdgeInsets.only(
                                    left: Dimensions.paddingSizeExtraSmall, right: Dimensions.paddingSizeExtraSmall, top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    hoverColor: Colors.transparent,
                                    onTap: () => {
                                      categoryController.getSubCategoryList(categoryController.servicesList![0].id.toString()),
                                      categoryController.setCategoryIndexAndTitle(categoryController.servicesList![0].id!, categoryController.servicesList![0].name!),
                                      categoryController.setSelectedCategoryIndex(0),
                                      Get.toNamed(RouteHelper.getCategoryRoute('service')),
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).cardColor,
                                        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                                      ),
                                      child: Icon(Icons.arrow_forward, color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeDefault),
                      child: Container(
                        width: ResponsiveHelper.isMobile(context) ? 70 : 100,
                        height: ResponsiveHelper.isMobile(context) ? 70 : 100,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                        child: CustomInkWellWidget(
                          onTap: () => {
                            categoryController.getSubCategoryList(categoryController.servicesList![index].id.toString()),
                            categoryController.setCategoryIndexAndTitle(categoryController.servicesList![index].id!, categoryController.servicesList![index].name!),
                            categoryController.setSelectedCategoryIndex(index),
                            Get.toNamed(RouteHelper.getCategoryRoute('service')),
                          },
                          radius: Dimensions.radiusSmall,
                          child: Column(children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: Theme.of(context).disabledColor.withOpacity(0.2),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                child: CustomImageWidget(
                                  image: '${categoryController.servicesList![index].image}',
                                  height: ResponsiveHelper.isMobile(context) ? 70 : 100,
                                  width: ResponsiveHelper.isMobile(context) ? 70 : 100,
                                  // resize: ResponsiveHelper.isMobile(context)
                                  //     ? true
                                  //     : false,
                                  // minHeight: 70,
                                  // minWidth: 70,
                                  // quality: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge),
                            Expanded(
                                child: Text(
                              categoryController.servicesList![index].name!,
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            )),
                          ]),
                        ),
                      ),
                    );
                  },
                )
              : WebWhatOnYourMindViewShimmer(categoryController: categoryController),
        ),
      ]);
    });
  }
}

class WebWhatOnYourMindViewShimmer extends StatelessWidget {
  final CategoryController categoryController;

  const WebWhatOnYourMindViewShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.isMobile(context) ? 120 : 170,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeSmall),
            child: Container(
              width: ResponsiveHelper.isMobile(context) ? 70 : 108,
              height: ResponsiveHelper.isMobile(context) ? 70 : 100,
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              margin: EdgeInsets.only(top: ResponsiveHelper.isMobile(context) ? 0 : Dimensions.paddingSizeSmall),
              child: Shimmer(
                duration: const Duration(seconds: 2),
                enabled: categoryController.servicesList == null,
                child: Column(children: [
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.grey[300]),
                    height: ResponsiveHelper.isMobile(context) ? 70 : 80,
                    width: 70,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Container(height: ResponsiveHelper.isMobile(context) ? 10 : 15, width: 150, color: Colors.grey[300]),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
