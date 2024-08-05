import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/order/widgets/guest_track_order_input_view_widget.dart';
import 'package:stackfood_multivendor/features/order/widgets/order_view_widget.dart';
import 'package:stackfood_multivendor/helper/auth_helper.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/app_constants.dart';

class OrderScreen extends StatefulWidget {
  final String? status;
  final String? titlePage;

  const OrderScreen({super.key, this.status, this.titlePage});

  @override
  OrderScreenState createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    initCall();
  }

  void initCall() {
    if (AuthHelper.isLoggedIn()) {
      Get.find<OrderController>().getRunningOrders(1, notify: false);
      Get.find<OrderController>().getRunningSubscriptionOrders(1, notify: false);
      Get.find<OrderController>().getHistoryOrders(1, notify: false);
      // Get.find<OrderController>().getSubscriptions(1, notify: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthHelper.isLoggedIn();
    bool showTabs = widget.status == null;

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: widget.status != null ? widget.titlePage!.tr : 'my_orders'.tr,
        isBackButtonExist: true,
        // isBackButtonExist: ResponsiveHelper.isDesktop(context)
      ),
      endDrawer: const MenuDrawerWidget(),
      endDrawerEnableOpenDragGesture: false,
      body: isLoggedIn
          ? Column(
              children: [
                if (showTabs)
                  Container(
                    color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
                    child: Column(
                      children: [
                        ResponsiveHelper.isDesktop(context)
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                                  child: Text(widget.titlePage != null ? widget.titlePage!.tr : 'my_orders'.tr, style: robotoMedium),
                                ),
                              )
                            : const SizedBox(),
                        Center(
                          child: SizedBox(
                            width: Dimensions.webMaxWidth,
                            child: Align(
                              alignment: ResponsiveHelper.isDesktop(context) ? Alignment.centerLeft : Alignment.center,
                              child: Container(
                                width: ResponsiveHelper.isDesktop(context) ? 350 : Dimensions.webMaxWidth,
                                color: ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).cardColor,
                                child: TabBar(
                                  controller: _tabController,
                                  indicatorColor: Theme.of(context).primaryColor,
                                  indicatorWeight: 3,
                                  labelColor: Theme.of(context).primaryColor,
                                  unselectedLabelColor: Theme.of(context).disabledColor,
                                  unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                                  labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                                  tabs: [
                                    Tab(text: 'running'.tr),
                                    Tab(text: 'subscription'.tr),
                                    Tab(text: 'history'.tr),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (showTabs)
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        OrderViewWidget(isRunning: true),
                        OrderViewWidget(isRunning: false, isSubscription: true),
                        OrderViewWidget(isRunning: false),
                      ],
                    ),
                  )
                else
                  Expanded(
                      child: widget.status == AppConstants.delivered || widget.status == AppConstants.cancelled || widget.status == AppConstants.refundRequested
                          ? OrderViewWidget(
                              isRunning: false,
                              status: widget.status,
                            )
                          : OrderViewWidget(
                              isRunning: true,
                              status: widget.status,
                            )),
              ],
            )
          : const GuestTrackOrderInputViewWidget(),
    );
  }
}
