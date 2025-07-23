import 'package:flutter/material.dart';
import 'package:ormee_app/feature/notice/detail/data/model.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/downloader.dart';

class AttachmentsSection extends StatelessWidget {
  final List<NoticeFile> attachmentFiles;

  const AttachmentsSection({super.key, required this.attachmentFiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: OrmeeColor.gray[10],
        borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Label2Regular12(text: '첨부파일', color: OrmeeColor.gray[50]),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: attachmentFiles.map((file) {
                return Downloader(fileName: file.name, url: file.url);
              }).toList(),
            ),
          ),
        ],
      ),
    );

  }
}
