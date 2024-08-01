import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import '../../../util/images.dart';
import '../../order/screens/order_screen.dart';
import '../../splash/controllers/theme_controller.dart';

class MenuOrderGrid extends StatelessWidget {
  const MenuOrderGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {'image': Images.trackOrderPlace, 'title': 'new_order', 'status': 'pending'},
      {'image': Images.trackOrderAccept, 'title': 'processing', 'status': 'processing'},
      {'image': Images.trackOrderPreparing, 'title': 'Pending delivery', 'status': 'delivered'},
      {'image': Images.trackOrderDelivered, 'title': 'Successful order', 'status': 'order_history'},
      {'image': Images.warning, 'title': 'order_cancelled', 'status': 'order_cancelled'},
      {'image': Images.digitalPayment, 'title': 'refunded', 'status': 'refunded'},
    ];

    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GridView.builder(
          padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: Dimensions.paddingSizeDefault,
            mainAxisSpacing: Dimensions.paddingSizeDefault,
            childAspectRatio: 1.0,
          ),
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => OrderScreen(
                      status: item['status'],
                    ));
              },
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeController.darkTheme ? const Color(0xFF30313C) : Colors.white,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              child: Padding(
                                padding: const EdgeInsets.all(Dimensions.radiusLarge),
                                child: Image.asset(
                                  item['image']!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Center(
                    child: Text(
                      item['title']!.tr,
                      style: TextStyle(fontSize: Dimensions.fontSizeExtraSmall),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
