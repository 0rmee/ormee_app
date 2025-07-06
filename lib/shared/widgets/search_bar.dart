import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

/* 
SearchBar(
  controller: _controller,
  focusNode: _focusNode,
  onChanged: (text) {
    print('Search text changed: $text');
  },
  onSearch: () {
    print('Search submitted: ${_controller.text}');
  },
),
*/

class SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearch;

  const SearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    this.hintText = '검색어를 입력하세요',
    this.onChanged,
    this.onSearch,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: OrmeeColor.gray[20]!,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: OrmeeColor.gray[100], // 또는 원하는 색상
              ),
              controller: widget.controller,
              focusNode: widget.focusNode,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: OrmeeColor.gray[50],
                ),
              ),
              onChanged: widget.onChanged,
              onSubmitted: (_) {
                widget.onSearch?.call();
              },
            ),
          ),
          SizedBox(width: 28),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              widget.onSearch?.call();
            },
            child: SvgPicture.asset("assets/icons/search.svg"),
          ),
        ],
      ),
    );
  }
}
