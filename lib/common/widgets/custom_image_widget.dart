// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
// import 'package:stackfood_multivendor/util/images.dart';
// import 'package:flutter/material.dart';
//
// class CustomImageWidget extends StatelessWidget {
//   final String image;
//   final double? height;
//   final double? width;
//   final BoxFit? fit;
//   final String placeholder;
//   final Color? imageColor;
//   final bool isRestaurant;
//   final bool isFood;
//   const CustomImageWidget({super.key, required this.image, this.height, this.width, this.fit = BoxFit.cover, this.placeholder = '', this.imageColor,
//     this.isRestaurant = false, this.isFood = false});
//
//   @override
//   Widget build(BuildContext context) {
//     return CachedNetworkImage(
//       imageUrl: image, height: height, width: width, fit: fit,
//       placeholder: (context, url) => CustomAssetImageWidget(placeholder.isNotEmpty ? placeholder : isRestaurant ? Images.restaurantPlaceholder : isFood ? Images.foodPlaceholder : Images.placeholderPng,
//           height: height, width: width, fit: fit, color: imageColor),
//       errorWidget: (context, url, error) => CustomAssetImageWidget(placeholder.isNotEmpty ? placeholder : isRestaurant ? Images.restaurantPlaceholder : isFood ? Images.foodPlaceholder : Images.placeholderPng,
//           height: height, width: width, fit: fit, color: imageColor),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stackfood_multivendor/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;

class CustomImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String placeholder;
  final Color? imageColor;
  final bool isRestaurant;
  final bool isFood;
  final bool resize; // Thêm thuộc tính này
  final int minWidth; // Thêm thuộc tính này
  final int minHeight; // Thêm thuộc tính này
  final int quality; // Thêm thuộc tính này

  const CustomImageWidget({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.placeholder = '',
    this.imageColor,
    this.isRestaurant = false,
    this.isFood = false,
    this.resize = false, // Giá trị mặc định là false
    this.minWidth = 100, // Thiết lập giá trị mặc định
    this.minHeight = 100, // Thiết lập giá trị mặc định
    this.quality = 85, // Thiết lập giá trị mặc định
  });

  Future<Uint8List?> _compressImage(String imageUrl) async {
    var response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      var imageData = response.bodyBytes;
      var result = await FlutterImageCompress.compressWithList(
        imageData,
        minWidth: minWidth,
        minHeight: minHeight,
        quality: quality,
      );
      return result;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (resize) {
      return FutureBuilder<Uint8List?>(
        future: _compressImage(image),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomAssetImageWidget(
              placeholder.isNotEmpty
                  ? placeholder
                  : isRestaurant
                  ? Images.restaurantPlaceholder
                  : isFood
                  ? Images.foodPlaceholder
                  : Images.placeholderPng,
              height: height,
              width: width,
              fit: fit,
              color: imageColor,
            );
          } else if (snapshot.hasError || !snapshot.hasData) {
            return CustomAssetImageWidget(
              placeholder.isNotEmpty
                  ? placeholder
                  : isRestaurant
                  ? Images.restaurantPlaceholder
                  : isFood
                  ? Images.foodPlaceholder
                  : Images.placeholderPng,
              height: height,
              width: width,
              fit: fit,
              color: imageColor,
            );
          } else {
            return Image.memory(
              snapshot.data!,
              height: height,
              width: width,
              fit: fit,
              color: imageColor,
            );
          }
        },
      );
    } else {
      return CachedNetworkImage(
        imageUrl: image,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) => CustomAssetImageWidget(
          placeholder.isNotEmpty
              ? placeholder
              : isRestaurant
              ? Images.restaurantPlaceholder
              : isFood
              ? Images.foodPlaceholder
              : Images.placeholderPng,
          height: height,
          width: width,
          fit: fit,
          color: imageColor,
        ),
        errorWidget: (context, url, error) => CustomAssetImageWidget(
          placeholder.isNotEmpty
              ? placeholder
              : isRestaurant
              ? Images.restaurantPlaceholder
              : isFood
              ? Images.foodPlaceholder
              : Images.placeholderPng,
          height: height,
          width: width,
          fit: fit,
          color: imageColor,
        ),
      );
    }
  }
}

