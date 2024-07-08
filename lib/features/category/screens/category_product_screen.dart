import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/cart_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/veg_filter_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/custom_image_widget.dart';

class CategoryProductScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  final int? subCategoryID;
  const CategoryProductScreen(
      {super.key, required this.categoryID, required this.categoryName, this.subCategoryID});

  @override
  CategoryProductScreenState createState() => CategoryProductScreenState();
}

class CategoryProductScreenState extends State<CategoryProductScreen>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController restaurantScrollController = ScrollController();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    // Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryProductList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          debugPrint('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryProductList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList![
                        Get.find<CategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
    restaurantScrollController.addListener(() {
      if (restaurantScrollController.position.pixels ==
              restaurantScrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryRestaurantList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize =
            (Get.find<CategoryController>().restaurantPageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          debugPrint('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryRestaurantList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList![
                        Get.find<CategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (catController) {
      List<Product>? products;
      List<Restaurant>? restaurants;
      if (catController.categoryProductList != null &&
          catController.searchProductList != null) {
        products = [];
        if (catController.isSearching) {
          products.addAll(catController.searchProductList!);
        } else {
          products.addAll(catController.categoryProductList!);
        }
      }
      if (catController.categoryRestaurantList != null &&
          catController.searchRestaurantList != null) {
        restaurants = [];
        if (catController.isSearching) {
          restaurants.addAll(catController.searchRestaurantList!);
        } else {
          restaurants.addAll(catController.categoryRestaurantList!);
        }
      }

      return PopScope(
        canPop: Navigator.canPop(context),
        onPopInvoked: (val) async {
          if (catController.isSearching) {
            catController.toggleSearch();
          } else {}
        },
        child: Scaffold(
          appBar: ResponsiveHelper.isDesktop(context)
              ? const WebMenuBar()
              : AppBar(
                  title: catController.isSearching
                      ? TextField(
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge),
                          onSubmitted: (String query) =>
                              catController.searchData(
                            query,
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList![
                                        catController.subCategoryIndex]
                                    .id
                                    .toString(),
                            catController.type,
                          ),
                        )
                      : Text(widget.categoryName,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          )),
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    onPressed: () {
                      if (catController.isSearching) {
                        catController.toggleSearch();
                      } else {
                        Get.back();
                      }
                    },
                  ),
                  backgroundColor: Theme.of(context).cardColor,
                  elevation: 0,
                  actions: [
                    IconButton(
                      onPressed: () => catController.toggleSearch(),
                      icon: Icon(
                        catController.isSearching
                            ? Icons.close_sharp
                            : Icons.search,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                      icon: CartWidget(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          size: 25),
                    ),
                    VegFilterWidget(
                        type: catController.type,
                        fromAppBar: true,
                        onSelected: (String type) {
                          if (catController.isSearching) {
                            catController.searchData(
                              catController.subCategoryIndex == 0
                                  ? widget.categoryID
                                  : catController
                                      .subCategoryList![
                                          catController.subCategoryIndex]
                                      .id
                                      .toString(),
                              '1',
                              type,
                            );
                          } else {
                            if (catController.isRestaurant) {
                              catController.getCategoryRestaurantList(
                                catController.subCategoryIndex == 0
                                    ? widget.categoryID
                                    : catController
                                        .subCategoryList![
                                            catController.subCategoryIndex]
                                        .id
                                        .toString(),
                                1,
                                type,
                                true,
                              );
                            } else {
                              catController.getCategoryProductList(
                                catController.subCategoryIndex == 0
                                    ? widget.categoryID
                                    : catController
                                        .subCategoryList![
                                            catController.subCategoryIndex]
                                        .id
                                        .toString(),
                                1,
                                type,
                                true,
                              );
                            }
                          }
                        }),
                  ],
                ),
          endDrawer: const MenuDrawerWidget(),
          endDrawerEnableOpenDragGesture: false,
          body: Column(children: [
            const SizedBox(height:Dimensions.paddingSizeExtraSmall),
            (catController.subCategoryList != null &&
                    !catController.isSearching)
                ?
            // sub category
                  Center(
                    child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: GetBuilder<CategoryController>(
                        builder: (catController) {
                          return SizedBox(
                            height: 80,
                            child: ListView.builder(
                              controller: scrollController,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: catController.subCategoryList!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    catController.setSubCategoryIndex(index, widget.categoryID);
                                    Get.find<CategoryController>()
                                        .setSubCategoryChildrenIndex(
                                        index,
                                        Get.find<CategoryController>()
                                            .selectedCategoryIndex
                                            .toString());
                                    if(index==0){
                                      catController.setSelectedCategoryChildrenIndex(0);
                                    }
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                     color: index == catController.subCategoryIndex
                                             ? Theme.of(context).primaryColor.withOpacity(0.1)
                                             : Theme.of(context).cardColor
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusSmall),
                                          child: CustomImageWidget(
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                            image: '${catController.subCategoryList![index].image}',
                                          ),
                                        ),
                                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                        Text(
                                          catController.subCategoryList![index].name!,
                                          textAlign: TextAlign.center,
                                          style: robotoMedium.copyWith(
                                              fontSize: Dimensions.fontSizeExtraSmall),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height:Dimensions.paddingSizeExtraSmall),
            // sub category children
             (catController.subCategoryChildrenList != null &&
                !catController.isSearching && catController.subCategoryChildrenList!.length >1&& catController
                 .subCategoryIndex!=0 )
                ?
            Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: GetBuilder<CategoryController>(
                  builder: (catController) {
                    return SizedBox(
                      height: 80,
                      child: ListView.builder(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: catController.subCategoryChildrenList!.length,
                        itemBuilder: (context, index) {
                          bool isSelected =
                              index == catController.selectedCategoryChildrenIndex;

                          return  index !=0 ? InkWell(
                            onTap: () {
                              catController.setSubCategoryChildrenIndex(index, widget.categoryID);
                              catController.setSelectedCategoryChildrenIndex(index);
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                                      : Theme.of(context).cardColor
                              ),
                              alignment: Alignment.center,
                              child:

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                    child: CustomImageWidget(
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.cover,
                                      image: '${catController.subCategoryChildrenList![index].image}',
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                    catController.subCategoryChildrenList![index].name!,
                                    textAlign: TextAlign.center,
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ):const SizedBox();
                        },
                      ),
                    );
                  },
                ),
              ),
            )
                : const SizedBox(),
            const SizedBox(height:Dimensions.paddingSizeExtraSmall),
            Center(
                child: Container(
              width: Dimensions.webMaxWidth,
              color: Theme.of(context).cardColor,
              child: Align(
                alignment: ResponsiveHelper.isDesktop(context)
                    ? Alignment.centerLeft
                    : Alignment.center,
                child: Container(
                  width: ResponsiveHelper.isDesktop(context)
                      ? 350
                      : Dimensions.webMaxWidth,
                  color: ResponsiveHelper.isDesktop(context)
                      ? Colors.transparent
                      : Theme.of(context).cardColor,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Theme.of(context).primaryColor,
                    indicatorWeight: 3,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Theme.of(context).disabledColor,
                    unselectedLabelStyle: robotoRegular.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontSize: Dimensions.fontSizeSmall),
                    labelStyle: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).primaryColor),
                    tabs: [
                      Tab(text: 'food'.tr),
                      Tab(text: 'restaurants'.tr),
                    ],
                  ),
                ),
              ),
            )),
            Expanded(
                child: NotificationListener(
              onNotification: (dynamic scrollNotification) {
                if (scrollNotification is ScrollEndNotification) {
                  if ((_tabController!.index == 1 &&
                          !catController.isRestaurant) ||
                      _tabController!.index == 0 &&
                          catController.isRestaurant) {
                    catController.setRestaurant(_tabController!.index == 1);
                    if (catController.isSearching) {
                      catController.searchData(
                        catController.searchText,
                        catController.subCategoryIndex == 0
                            ? widget.categoryID
                            : catController
                                .subCategoryList![
                                    catController.subCategoryIndex]
                                .id
                                .toString(),
                        catController.type,
                      );
                    } else {
                      if (_tabController!.index == 1) {
                        catController.getCategoryRestaurantList(
                          catController.subCategoryIndex == 0
                              ? widget.categoryID
                              : catController
                                  .subCategoryList![
                                      catController.subCategoryIndex]
                                  .id
                                  .toString(),
                          1,
                          catController.type,
                          false,
                        );
                      } else {
                        catController.getCategoryProductList(
                          catController.subCategoryIndex == 0
                              ? widget.categoryID
                              : catController
                                  .subCategoryList![
                                      catController.subCategoryIndex]
                                  .id
                                  .toString(),
                          1,
                          catController.type,
                          false,
                        );
                      }
                    }
                  }
                }
                return false;
              },
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    child: FooterViewWidget(
                      child: Center(
                        child: SizedBox(
                          width: Dimensions.webMaxWidth,
                          child: Column(
                            children: [
                              ProductViewWidget(
                                isRestaurant: false,
                                products: products,
                                restaurants: null,
                                noDataText: 'no_category_food_found'.tr,
                              ),
                              catController.isLoading
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeSmall),
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Theme.of(context)
                                                        .primaryColor)),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    controller: restaurantScrollController,
                    child: FooterViewWidget(
                      child: Center(
                        child: SizedBox(
                          width: Dimensions.webMaxWidth,
                          child: Column(
                            children: [
                              ProductViewWidget(
                                isRestaurant: true,
                                products: null,
                                restaurants: restaurants,
                                noDataText: 'no_category_restaurant_found'.tr,
                              ),
                              catController.isLoading
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeSmall),
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Theme.of(context)
                                                        .primaryColor)),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ]),
        ),
      );
    });
  }
}