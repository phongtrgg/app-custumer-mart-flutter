import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortionWidget extends StatelessWidget {
  final String icon;
  final String title;
  final bool hideDivider;
  final String route;
  final String? suffix;
  final Function()? onTap;
  final bool? isImage;

  PortionWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
    this.hideDivider = false,
    this.suffix,
    this.onTap,
    this.isImage = true,
  });

  Map<String, IconData> iconMap = {
    'shopping_bag': Icons.shopping_bag,
    'home': Icons.home,
    'favourite': Icons.favorite_border,
  };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => Get.toNamed(route),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Column(children: [
          Row(children: [
            isImage!
                ? Image.asset(
                    icon,
                    height: 16,
                    width: 16,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  )
                : Icon(
                    iconMap[icon] ?? Icons.help,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                    size: 16,
                  ),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(child: Text(title, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault))),
            suffix != null
                ? Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
                    child: Text(suffix!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white)),
                  )
                : const SizedBox(),
          ]),
          hideDivider ? const SizedBox() : const Divider()
        ]),
      ),
    );
  }
}
