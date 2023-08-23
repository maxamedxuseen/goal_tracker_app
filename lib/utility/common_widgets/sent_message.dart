import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/dimens_constants.dart';
import '../constants/string_constants.dart';
import '../helper/common_helper.dart';
import 'triangle_widget.dart';

class SentMessage extends StatelessWidget {
  final String? message;

  const SentMessage({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String>? urlList = CommonHelper.getLinkFromMessage(
      message: message.toString(),
    );
    String trimmedMessage = message ?? "";
    urlList?.forEach(
      (e) => trimmedMessage = trimmedMessage.replaceAll(e, " *link* "),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _messageWidget(message: trimmedMessage),
        _linkWidget(urlList: urlList),
      ],
    );
  }

  Widget _messageWidget({required String message}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: Get.width / 1.5),
            padding: const EdgeInsets.all(DimenConstants.mixPadding),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Get.theme.primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(DimenConstants.chatCornerRadius),
                bottomLeft: Radius.circular(DimenConstants.chatCornerRadius),
                bottomRight: Radius.circular(DimenConstants.chatCornerRadius),
              ),
            ),
            child: Text(
              message,
              style:  TextStyle(color: Get.theme.colorScheme.onPrimary),
            ),
          ),
        ),
        CustomPaint(painter: Triangle(Get.theme.primaryColor)),
      ],
    );
  }

  Widget _linkWidget({List<String>? urlList}) {
    List<Widget> linkWidgetList = [];
    if (urlList != null && urlList.isNotEmpty) {
      for (String url in urlList) {
        linkWidgetList.add(
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: DimenConstants.contentPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: Get.width / 1.5),
                    padding: const EdgeInsets.all(DimenConstants.smallPadding),
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(
                          DimenConstants.chatCornerRadius,
                        ),
                        bottomLeft: Radius.circular(
                          DimenConstants.chatCornerRadius,
                        ),
                        bottomRight: Radius.circular(
                          DimenConstants.chatCornerRadius,
                        ),
                      ),
                    ),
                    child: AnyLinkPreview(
                      link: url,
                      displayDirection: UIDirection.uiDirectionVertical,
                      borderRadius: DimenConstants.chatCornerRadius,
                      cache: const Duration(hours: 1),
                      errorWidget: const Text(
                        'Oops! Failed to load suggested link',
                        textAlign: TextAlign.start,
                      ),
                      errorImage: StringConstants.error404,
                    ),
                  ),
                ),
                CustomPaint(painter: Triangle(Get.theme.primaryColor)),
              ],
            ),
          ),
        );
      }
      return Column(children: linkWidgetList);
    } else {
      return Container();
    }
  }
}
