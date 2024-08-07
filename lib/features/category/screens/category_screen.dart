import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:stackfood_multivendor/features/search/screens/search_screen.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../enums/page_type.dart';

class CategoryScreen extends StatefulWidget {
  final PageType type;

  const CategoryScreen({super.key, required this.type});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late ScrollController scrollController;
  ScrollController leftScrollController = ScrollController();
  ScrollController rightScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    switch (widget.type) {
      case PageType.category:
        Get.find<CategoryController>().getCategoryList(false);
      case PageType.service:
        Get.find<CategoryController>().getServicesList(false);
      case PageType.not:
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSelectedCategory();
    });
  }

  void scrollToSelectedCategory() {
    if (mounted) {
      int selectedCategoryIndex = Get.find<CategoryController>().selectedCategoryIndex;
      if (selectedCategoryIndex >= 0) {
        double offset = selectedCategoryIndex * 100.0;
        scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    leftScrollController.dispose();
    rightScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBarWidget(title: 'categories'.tr),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
          child: AppBar(
            title: Container(
              height: 65,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Stack(
                  children: [
                    Positioned(
                      left: 10,
                      right: 10,
                      top: 8,
                      bottom: 5,
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchScreen(category: true)),
                        ),
                        child: Container(
                          transform: Matrix4.translationValues(0, -3, 0),
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                Images.searchIcon,
                                width: 25,
                                height: 25,
                              ),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                              Expanded(
                                child: Text(
                                  'are_you_search'.tr,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextButton(
                style: TextButton.styleFrom(
                  // backgroundColor: Color(0xFF54C836),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true)),
                child: const Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            shadowColor: Theme.of(context).disabledColor,
          ),
          // endDrawer: const MenuDrawerWidget(),
        ),
      ),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cột bên trái: ListView
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 100,
                  child: GetBuilder<CategoryController>(
                    builder: (catController) {
                      return widget.type == PageType.category
                          ? catController.categoryList != null
                              ? catController.categoryList!.isNotEmpty
                                  ? ListView.builder(
                                      controller: scrollController,
                                      scrollDirection: Axis.vertical,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: catController.categoryList!.length,
                                      itemBuilder: (context, index) {
                                        bool isSelected = index == catController.selectedCategoryIndex;

                                        return InkWell(
                                          onTap: () {
                                            Get.find<CategoryController>().getSubCategoryList(
                                              catController.categoryList![index].id.toString(),
                                            );
                                            Get.find<CategoryController>().setCategoryIndexAndTitle(
                                              catController.categoryList![index].id!,
                                              catController.categoryList![index].name!,
                                            );
                                            catController.setSelectedCategoryIndex(index);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Theme.of(context).cardColor,
                                            ),
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                                  child: CustomImageWidget(
                                                    height: 50,
                                                    width: 50,
                                                    fit: BoxFit.cover,
                                                    image: '${catController.categoryList![index].image}',
                                                  ),
                                                ),
                                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                                Text(
                                                  catController.categoryList![index].name!,
                                                  textAlign: TextAlign.center,
                                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
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
                              : const Center(child: CircularProgressIndicator())
                          : catController.servicesList != null
                              ? catController.servicesList!.isNotEmpty
                                  ? ListView.builder(
                                      controller: scrollController,
                                      scrollDirection: Axis.vertical,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: catController.servicesList!.length,
                                      itemBuilder: (context, index) {
                                        bool isSelected = index == catController.selectedCategoryIndex;

                                        return InkWell(
                                          onTap: () {
                                            Get.find<CategoryController>().getSubCategoryList(
                                              catController.servicesList![index].id.toString(),
                                            );
                                            Get.find<CategoryController>().setCategoryIndexAndTitle(
                                              catController.servicesList![index].id!,
                                              catController.servicesList![index].name!,
                                            );
                                            catController.setSelectedCategoryIndex(index);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Theme.of(context).cardColor,
                                            ),
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                                  child: CustomImageWidget(
                                                    height: 50,
                                                    width: 50,
                                                    fit: BoxFit.cover,
                                                    image: '${catController.servicesList![index].image}',
                                                  ),
                                                ),
                                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                                Text(
                                                  catController.servicesList![index].name!,
                                                  textAlign: TextAlign.center,
                                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
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
                              : const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),
            // Cột bên phải: GridView
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: GetBuilder<CategoryController>(
                  builder: (catController) {
                    if (catController.categoryList == null || catController.subCategoryList == null) {
                      return Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.8,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      );
                    } else if (catController.subCategoryList!.isEmpty) {
                      return NoDataScreen(title: 'no_category_found'.tr);
                    } else {
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isDesktop(context)
                              ? 6
                              : ResponsiveHelper.isTab(context)
                                  ? 3
                                  : 2,
                          childAspectRatio: (1 / 1),
                          mainAxisSpacing: Dimensions.paddingSizeSmall,
                          crossAxisSpacing: Dimensions.paddingSizeSmall,
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        itemCount: (catController.subCategoryList!.length - 1),
                        itemBuilder: (context, index) {
                          var subCategory = catController.subCategoryList![index + 1];
                          return InkWell(
                            onTap: () => {
                              Get.find<CategoryController>().setSubCategoryIndex(
                                index,
                                Get.find<CategoryController>().categoryIndex.toString(),
                              ),
                              Get.find<CategoryController>().getSubCategoryChildrenList(
                                Get.find<CategoryController>().subCategoryList![index].id.toString(),
                              ),
                              Get.toNamed(
                                RouteHelper.getCategoryProductRoute(
                                  Get.find<CategoryController>().categoryIndex,
                                  Get.find<CategoryController>().categoryTitle,
                                  index,
                                ),
                              ),
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    child: CustomImageWidget(
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                      image: '${subCategory.image}',
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                    subCategory.name!,
                                    textAlign: TextAlign.center,
                                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
//hiện thị hàng ngang
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: CustomAppBarWidget(title: 'categories'.tr),
//     endDrawer: const MenuDrawerWidget(),
//     endDrawerEnableOpenDragGesture: false,
//     body: SafeArea(
//       child: SingleChildScrollView(
//         controller: scrollController,
//         child: FooterViewWidget(
//           child: Column(
//             children: [
//               WebScreenTitleWidget(title: 'categories'.tr),
//               const SizedBox(height: Dimensions.paddingSizeDefault),
//               Center(
//                 child: SizedBox(
//                   width: Dimensions.webMaxWidth,
//                   child: GetBuilder<CategoryController>(
//                     builder: (catController) {
//                       return catController.categoryList != null
//                           ? catController.categoryList!.isNotEmpty
//                               ? SizedBox(
//                                   height: 100,
//                                   child: ListView.builder(
//                                     controller: scrollController,
//                                     scrollDirection: Axis.horizontal,
//                                     physics: const BouncingScrollPhysics(),
//                                     itemCount:
//                                         catController.categoryList!.length,
//                                     itemBuilder: (context, index) {
//                                       bool isSelected = index ==
//                                           catController.selectedCategoryIndex;

//                                       return InkWell(
//                                         onTap: () {
//                                           Get.find<CategoryController>()
//                                               .getSubCategoryList(
//                                                   catController
//                                                       .categoryList![index].id
//                                                       .toString());
//                                           Get.find<CategoryController>()
//                                               .setCategoryIndexAndTitle(
//                                             catController
//                                                 .categoryList![index].id!,
//                                             catController
//                                                 .categoryList![index].name!,
//                                           );
//                                           catController
//                                               .setSelectedCategoryIndex(
//                                                   index);
//                                         },
//                                         child: Container(
//                                           width: 100,
//                                           height: 100,
//                                           decoration: BoxDecoration(
//                                             color: isSelected
//                                                 ? Theme.of(context)
//                                                     .primaryColor
//                                                     .withOpacity(0.1)
//                                                 : Theme.of(context).cardColor,
//                                           ),
//                                           alignment: Alignment.center,
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         Dimensions
//                                                             .radiusSmall),
//                                                 child: CustomImageWidget(
//                                                   height: 50,
//                                                   width: 50,
//                                                   fit: BoxFit.cover,
//                                                   image:
//                                                       '${catController.categoryList![index].image}',
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                   height: Dimensions
//                                                       .paddingSizeExtraSmall),
//                                               Text(
//                                                 catController
//                                                     .categoryList![index]
//                                                     .name!,
//                                                 textAlign: TextAlign.center,
//                                                 style: robotoMedium.copyWith(
//                                                     fontSize: Dimensions
//                                                         .fontSizeSmall),
//                                                 maxLines: 2,
//                                                 overflow:
//                                                     TextOverflow.ellipsis,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 )
//                               : NoDataScreen(title: 'no_category_found'.tr)
//                           : const Center(child: CircularProgressIndicator());
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: Dimensions.paddingSizeDefault),
//               Center(
//                 child: SizedBox(
//                   width: Dimensions.webMaxWidth,
//                   child: GetBuilder<CategoryController>(
//                     builder: (catController) {
//                       return catController.categoryList != null
//                           ? catController.subCategoryList != null
//                               ? GridView.builder(
//                                   physics:
//                                       const NeverScrollableScrollPhysics(),
//                                   shrinkWrap: true,
//                                   gridDelegate:
//                                       SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount:
//                                         ResponsiveHelper.isDesktop(context)
//                                             ? 6
//                                             : ResponsiveHelper.isTab(context)
//                                                 ? 4
//                                                 : 3,
//                                     childAspectRatio: (1 / 1),
//                                     mainAxisSpacing:
//                                         Dimensions.paddingSizeSmall,
//                                     crossAxisSpacing:
//                                         Dimensions.paddingSizeSmall,
//                                   ),
//                                   padding: const EdgeInsets.all(
//                                       Dimensions.paddingSizeSmall),
//                                   itemCount:
//                                       catController.subCategoryList!.length,
//                                   itemBuilder: (context, index) {
//                                     var subCategory =
//                                         catController.subCategoryList![index];
//                                     return InkWell(
//                                       onTap: () => {
//                                         Get.find<CategoryController>()
//                                             .setSubCategoryIndex(
//                                                 index,
//                                                 Get.find<CategoryController>()
//                                                     .categoryIndex
//                                                     .toString()),
//                                         Get.find<CategoryController>()
//                                             .getSubCategoryChildrenList(
//                                                 Get.find<CategoryController>()
//                                                     .subCategoryList![index]
//                                                     .id
//                                                     .toString()),
//                                         Get.toNamed(
//                                           RouteHelper.getCategoryProductRoute(
//                                             Get.find<CategoryController>()
//                                                 .categoryIndex,
//                                             Get.find<CategoryController>()
//                                                 .categoryTitle,
//                                             index,
//                                           ),
//                                         ),
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: Theme.of(context).cardColor,
//                                           borderRadius: BorderRadius.circular(
//                                               Dimensions.radiusSmall),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.grey[
//                                                   Get.isDarkMode
//                                                       ? 800
//                                                       : 200]!,
//                                               blurRadius: 5,
//                                               spreadRadius: 1,
//                                             )
//                                           ],
//                                         ),
//                                         alignment: Alignment.center,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       Dimensions.radiusSmall),
//                                               child: CustomImageWidget(
//                                                 height: 50,
//                                                 width: 50,
//                                                 fit: BoxFit.cover,
//                                                 image: '${subCategory.image}',
//                                               ),
//                                             ),
//                                             const SizedBox(
//                                                 height: Dimensions
//                                                     .paddingSizeExtraSmall),
//                                             Text(
//                                               subCategory.name!,
//                                               textAlign: TextAlign.center,
//                                               style: robotoMedium.copyWith(
//                                                   fontSize: Dimensions
//                                                       .fontSizeSmall),
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 )
//                               : NoDataScreen(title: 'no_category_found'.tr)
//                           // : const Center(child: CircularProgressIndicator());
//                           : const SizedBox();
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
}

//hiện thị all cân đối cả màn hình và ko có subcategory
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
