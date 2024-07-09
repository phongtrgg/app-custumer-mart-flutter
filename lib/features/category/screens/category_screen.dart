import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}
class _CategoryScreenState extends State<CategoryScreen> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    Get.find<CategoryController>().getCategoryList(false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSelectedCategory();
    });
  }

  void scrollToSelectedCategory() {
    if (mounted) {
      int selectedCategoryIndex =
          Get.find<CategoryController>().selectedCategoryIndex;
      if (selectedCategoryIndex >= 0) {
        double offset = selectedCategoryIndex * 100.0; // Assuming item width is 100
        scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'categories'.tr),
      endDrawer: const MenuDrawerWidget(),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: FooterViewWidget(
            child: Column(
              children: [
                WebScreenTitleWidget(title: 'categories'.tr),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Center(
                  child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: GetBuilder<CategoryController>(
                      builder: (catController) {
                        return catController.categoryList != null
                            ? catController.categoryList!.isNotEmpty
                            ? SizedBox(
                          height: 100,
                          child: ListView.builder(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                            catController.categoryList!.length,
                            itemBuilder: (context, index) {
                              bool isSelected =
                                  index ==
                                      catController
                                          .selectedCategoryIndex;

                              return InkWell(
                                onTap: () {
                                  Get.find<CategoryController>()
                                      .getSubCategoryList(
                                      catController
                                          .categoryList![
                                      index]
                                          .id
                                          .toString());
                                  Get.find<CategoryController>()
                                      .setCategoryIndexAndTitle(
                                    catController
                                        .categoryList![index].id!,
                                    catController.categoryList![
                                    index].name!,
                                  );
                                  catController
                                      .setSelectedCategoryIndex(
                                      index);
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1)
                                        : Theme.of(context)
                                        .cardColor,
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(
                                            Dimensions
                                                .radiusSmall),
                                        child: CustomImageWidget(
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                          image:
                                          '${catController.categoryList![index].image}',
                                        ),
                                      ),
                                      const SizedBox(
                                          height: Dimensions
                                              .paddingSizeExtraSmall),
                                      Text(
                                        catController
                                            .categoryList![index]
                                            .name!,
                                        textAlign: TextAlign.center,
                                        style: robotoMedium.copyWith(
                                            fontSize: Dimensions
                                                .fontSizeSmall),
                                        maxLines: 2,
                                        overflow:
                                        TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                            : NoDataScreen(title: 'no_category_found'.tr)
                            : const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Center(
                  child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: GetBuilder<CategoryController>(

                      builder: (catController) {
                        return catController.categoryList != null
                            ? catController.subCategoryList != null
                            ? GridView.builder(
                            physics:
                            const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                              ResponsiveHelper.isDesktop(context)
                                  ? 6
                                  : ResponsiveHelper.isTab(context)
                                  ? 4
                                  : 3,
                              childAspectRatio: (1 / 1),
                              mainAxisSpacing:
                              Dimensions.paddingSizeSmall,
                              crossAxisSpacing:
                              Dimensions.paddingSizeSmall,
                            ),
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeSmall),
                            itemCount:
                            catController.subCategoryList!.length,
                            itemBuilder: (context, index) {
                              var subCategory =
                              catController.subCategoryList![
                              index];
                              return InkWell(
                                onTap: () => {
                                  Get.find<CategoryController>()
                                      .setSubCategoryIndex(
                                      index,
                                      Get.find<CategoryController>()
                                          .categoryIndex
                                          .toString()),
                                  Get.find<CategoryController>().getSubCategoryChildrenList(Get.find<CategoryController>().subCategoryList![index].id.toString()),
                                  Get.toNamed(
                                    RouteHelper.getCategoryProductRoute(
                                      Get.find<CategoryController>()
                                          .categoryIndex,
                                      Get.find<CategoryController>()
                                          .categoryTitle,
                                      index,
                                    ),
                                  ),
                                },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[
                                      Get.isDarkMode ? 800 : 200]!,
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(
                                          Dimensions.radiusSmall),
                                      child: CustomImageWidget(
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                        image: '${subCategory.image}',
                                      ),
                                    ),
                                    const SizedBox(
                                        height: Dimensions
                                            .paddingSizeExtraSmall),
                                    Text(
                                      subCategory.name!,
                                      textAlign: TextAlign.center,
                                      style: robotoMedium.copyWith(
                                          fontSize: Dimensions
                                              .fontSizeSmall),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                            : NoDataScreen(title: 'no_category_found'.tr)
                            // : const Center(child: CircularProgressIndicator());
                            : const SizedBox();
                      },
                    ),
                  ),
                ),
                // Center(
              //     child: SizedBox(
              //   width: Dimensions.webMaxWidth,
              //   child: GetBuilder<CategoryController>(builder: (catController) {
              //     return catController.categoryList != null
              //         ? catController.categoryList!.isNotEmpty
              //             ? GridView.builder(
              //                 physics: const NeverScrollableScrollPhysics(),
              //                 shrinkWrap: true,
              //                 gridDelegate:
              //                     SliverGridDelegateWithFixedCrossAxisCount(
              //                   crossAxisCount:
              //                       ResponsiveHelper.isDesktop(context)
              //                           ? 6
              //                           : ResponsiveHelper.isTab(context)
              //                               ? 4
              //                               : 3,
              //                   childAspectRatio: (1 / 1),
              //                   mainAxisSpacing: Dimensions.paddingSizeSmall,
              //                   crossAxisSpacing: Dimensions.paddingSizeSmall,
              //                 ),
              //                 padding: const EdgeInsets.all(
              //                     Dimensions.paddingSizeSmall),
              //                 itemCount: catController.categoryList!.length,
              //                 itemBuilder: (context, index) {
              //                   return InkWell(
              //                     onTap: () => Get.toNamed(
              //                         RouteHelper.getCategoryProductRoute(
              //                       catController.categoryList![index].id,
              //                       catController.categoryList![index].name!,
              //                     )),
              //                     child: Container(
              //                       decoration: BoxDecoration(
              //                         color: Theme.of(context).cardColor,
              //                         borderRadius: BorderRadius.circular(
              //                             Dimensions.radiusSmall),
              //                         boxShadow: [
              //                           BoxShadow(
              //                               color: Colors.grey[
              //                                   Get.isDarkMode ? 800 : 200]!,
              //                               blurRadius: 5,
              //                               spreadRadius: 1)
              //                         ],
              //                       ),
              //                       alignment: Alignment.center,
              //                       child: Column(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.center,
              //                           children: [
              //                             ClipRRect(
              //                               borderRadius: BorderRadius.circular(
              //                                   Dimensions.radiusSmall),
              //                               child: CustomImageWidget(
              //                                 height: 50,
              //                                 width: 50,
              //                                 fit: BoxFit.cover,
              //                                 image:
              //                                     '${catController.categoryList![index].image}',
              //                               ),
              //                             ),
              //                             const SizedBox(
              //                                 height: Dimensions
              //                                     .paddingSizeExtraSmall),
              //                             Text(
              //                               catController
              //                                   .categoryList![index].name!,
              //                               textAlign: TextAlign.center,
              //                               style: robotoMedium.copyWith(
              //                                   fontSize:
              //                                       Dimensions.fontSizeSmall),
              //                               maxLines: 2,
              //                               overflow: TextOverflow.ellipsis,
              //                             ),
              //                           ]),
              //                     ),
              //                   );
              //                 },
              //               )
              //             : NoDataScreen(title: 'no_category_found'.tr)
              //         : const Center(child: CircularProgressIndicator());
              //   }),
              // )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

