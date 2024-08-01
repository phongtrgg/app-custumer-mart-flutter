import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../util/dimensions.dart';
import '../controllers/localization_controller.dart';
import 'language_bottom_sheet_widget.dart';
import 'language_card_widget.dart';

class LanguageSelector extends StatefulWidget {
  final bool? isHomePage;

  LanguageSelector({this.isHomePage = false});

  @override
  _LanguageSelectorState createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  // void _showLanguagePopup() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return LanguagePopup();
  //     },
  //     isScrollControlled: true,
  //   );
  // }

  _manageLanguageFunctionality() {
    Get.find<LocalizationController>().saveCacheLanguage(null);
    Get.find<LocalizationController>().searchSelectedLanguage();

    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      context: Get.context!,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: const LanguageBottomSheetWidget(),
        );
      },
    ).then((value) => Get.find<LocalizationController>().setLanguage(Get.find<LocalizationController>().getCacheLocaleFromSharedPref()));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(builder: (localizationController) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 60,
          color: widget.isHomePage != false ? Colors.white : Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 3, bottom: 3),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _manageLanguageFunctionality,
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          localizationController.languages[localizationController.selectedLanguageIndex].imageUrl!,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: widget.isHomePage != false ? Colors.grey : Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

// class LanguagePopup extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<LocalizationController>(builder: (localizationController) {
//       return Container(
//         height: MediaQuery.of(context).size.height * 0.5,
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     'language'.tr,
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Spacer(),
//                 IconButton(
//                   icon: Icon(Icons.close),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: localizationController.languages.length,
//                 shrinkWrap: true,
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 itemBuilder: (context, index) {
//                   return LanguageCardWidget(
//                     languageModel: localizationController.languages[index],
//                     localizationController: localizationController,
//                     index: index,
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
