import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class ImagesSection extends StatefulWidget {
  final List<String> imageUrls;

  const ImagesSection({super.key, required this.imageUrls});

  @override
  State<ImagesSection> createState() => _ImagesSectionState();
}

class _ImagesSectionState extends State<ImagesSection> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.imageUrls[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 14,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: OrmeeColor.gray[80]!.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Label2Regular12(
                    text: '${currentPage + 1} / ',
                    color: OrmeeColor.white,
                  ),
                  Label2Regular12(text: '${widget.imageUrls.length}', color: OrmeeColor.white!.withOpacity(0.6),)
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}
