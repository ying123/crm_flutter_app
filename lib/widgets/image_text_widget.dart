import 'package:cached_network_image/cached_network_image.dart';
import 'package:crm_flutter_app/utils/screen_fit_util.dart';
import 'package:flutter/material.dart';

import 'package:crm_flutter_app/config/crm_style.dart';
import 'package:crm_flutter_app/widgets/hero_photo_view_wrapper_widget.dart';

Widget imageTextWidget(
    {String src,
    String text,
    String tag,
    BuildContext context,
    double width,
    double height,
    bool hasText = true,
    bool hasGap = true}) {
  bool hasError = false;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      GestureDetector(
        onTap: () {
          if (src != '' && !hasError) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HeroPhotoViewWrapper(
                    imageProvider: NetworkImage(src ?? ''),
                  ),
                ));
          }
        },
        child: Hero(
          tag: tag,
          child: CachedNetworkImage(
              width: ScreenFit.width(width ?? 120),
              height: ScreenFit.width(height ?? 120),
              imageUrl: src ?? '',
              placeholder: (context, url) => SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(),
                  ),
              errorWidget: (context, url, error) {
                hasError = true;
                return Image.asset('assets/images/image_error.png',
                    width: ScreenFit.width(width ?? 120),
                    height: ScreenFit.width(height ?? 120));
              }),
        ),
      ),
      hasGap
          ? SizedBox(
              height: CRMGaps.gap_dp10,
            )
          : Container(),
      hasText
          ? Text(
              text ?? '',
              style: CRMText.smallText,
            )
          : Container()
    ],
  );
}
