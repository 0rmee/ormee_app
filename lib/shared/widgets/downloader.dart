import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/utils/file_downloader.dart';

class Downloader extends StatelessWidget {
  final String fileName;
  final String url;

  const Downloader({super.key, required this.fileName, required this.url});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 160),
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
          color: OrmeeColor.white,
          border: Border.all(color: OrmeeColor.gray[30]!, width: 1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Label2Regular12(
                text: fileName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                FileDownloader.downloadFile(url, fileName: fileName);
              },
              child: SvgPicture.asset("assets/icons/download.svg")
            ),
          ],
        ),
      ),
    );
  }
}
