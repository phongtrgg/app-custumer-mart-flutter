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

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<ServiceScreen> {
  late ScrollController scrollController;
  ScrollController leftScrollController = ScrollController();
  ScrollController rightScrollController = ScrollController();

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
                //     Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Icon(
                //       Icons.home,
                //       color: Colors.white,
                //       size: 25,
                //     ),
                //     Text(
                //       'home page'.tr,
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: Dimensions.fontSizeExtraSmall,
                //       ),
                //     ),
                //   ],
                // ),
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
                      return catController.servicesList != null
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
                    return catController.servicesList != null
                        ? catController.subCategoryList != null
                            ? GridView.builder(
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
                                itemCount: catController.subCategoryList!.length,
                                itemBuilder: (context, index) {
                                  var subCategory = catController.subCategoryList![index];
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
                              )
                            : NoDataScreen(title: 'no_category_found'.tr)
                        : const SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
