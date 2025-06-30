import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';

/// 폰트 굵기 매핑
/// Bold = w700, SemiBold = w600, Medium = w500, Regular = w400

// --- Display 1 (56px) ---
class Display1Bold56 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Display1Bold56({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w700,
      fontSize: 56,
      height: 1.4,
      letterSpacing: -0.02 * 56,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Display1SemiBold56 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Display1SemiBold56({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w600,
      fontSize: 56,
      height: 1.4,
      letterSpacing: -0.02 * 56,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Display1Regular56 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Display1Regular56({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 56,
      height: 1.4,
      letterSpacing: -0.02 * 56,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

// --- Display 2 (40px) ---
class Display2Bold40 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Display2Bold40({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w700,
      fontSize: 40,
      height: 1.4,
      letterSpacing: -0.02 * 40,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Display2SemiBold40 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Display2SemiBold40({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w600,
      fontSize: 40,
      height: 1.4,
      letterSpacing: -0.02 * 40,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Display2Regular40 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Display2Regular40({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 40,
      height: 1.4,
      letterSpacing: -0.02 * 40,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

// --- Title 1 (28px) ---
class Title1Bold28 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Title1Bold28({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w700,
      fontSize: 28,
      height: 1.4,
      letterSpacing: -0.02 * 28,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Title1SemiBold28 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Title1SemiBold28({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w600,
      fontSize: 28,
      height: 1.4,
      letterSpacing: -0.02 * 28,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Title1Regular28 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Title1Regular28({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 28,
      height: 1.4,
      letterSpacing: -0.02 * 28,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

// --- Title 2 (26px) ---
class Title2Bold26 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Title2Bold26({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w700,
      fontSize: 26,
      height: 1.4,
      letterSpacing: -0.02 * 26,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Title2SemiBold26 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Title2SemiBold26({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w600,
      fontSize: 26,
      height: 1.4,
      letterSpacing: -0.02 * 26,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Title2Regular26 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Title2Regular26({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 26,
      height: 1.4,
      letterSpacing: -0.02 * 26,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

// --- Title 3 (24px) ---
class Title3Bold24 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Title3Bold24({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w700,
      fontSize: 24,
      height: 1.4,
      letterSpacing: -0.02 * 24,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Title3SemiBold24 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Title3SemiBold24({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w600,
      fontSize: 24,
      height: 1.4,
      letterSpacing: -0.02 * 24,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Title3Regular24 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Title3Regular24({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 24,
      height: 1.4,
      letterSpacing: -0.02 * 24,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

// --- Heading 1 (22px) ---
class Heading1Bold22 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Heading1Bold22({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w700,
      fontSize: 22,
      height: 1.4,
      letterSpacing: -0.02 * 22,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Heading1SemiBold22 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Heading1SemiBold22({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w600,
      fontSize: 22,
      height: 1.4,
      letterSpacing: -0.02 * 22,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Heading1Regular22 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Heading1Regular22({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 22,
      height: 1.4,
      letterSpacing: -0.02 * 22,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

// --- Heading 2 (20px) ---
class Heading2Bold20 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Heading2Bold20({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w700,
      fontSize: 20,
      height: 1.4,
      letterSpacing: -0.02 * 20,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Heading2SemiBold20 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Heading2SemiBold20({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w600,
      fontSize: 20,
      height: 1.4,
      letterSpacing: -0.02 * 20,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Heading2Regular20 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Heading2Regular20({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 20,
      height: 1.4,
      letterSpacing: -0.02 * 20,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

// --- Headline 1 (18px) ---
class Headline1Bold18 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Headline1Bold18({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w700,
      fontSize: 18,
      height: 1.4,
      letterSpacing: -0.02 * 18,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Headline1SemiBold18 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Headline1SemiBold18({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w600,
      fontSize: 18,
      height: 1.4,
      letterSpacing: -0.02 * 18,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Headline1Regular18 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Headline1Regular18({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 18,
      height: 1.4,
      letterSpacing: -0.02 * 18,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

// --- Headline 2 (16px) ---
class Headline2Bold16 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Headline2Bold16({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w700,
      fontSize: 16,
      height: 1.4,
      letterSpacing: -0.02 * 16,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Headline2SemiBold16 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Headline2SemiBold16({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w600,
      fontSize: 16,
      height: 1.4,
      letterSpacing: -0.02 * 16,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

class Headline2Regular16 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Headline2Regular16({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1.4,
      letterSpacing: -0.02 * 16,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

// --- Body 1 ---
// Regular normal 16px
class Body1RegularNormal16 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Body1RegularNormal16({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1.4,
      letterSpacing: -0.02 * 16,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

// Regular reading 16px (lineHeight 155%)
class Body1RegularReading16 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Body1RegularReading16({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1.55,
      letterSpacing: -0.02 * 16,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

// --- Body 2 ---
// Regular normal 14px
class Body2RegularNormal14 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Body2RegularNormal14({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 1.4,
      letterSpacing: -0.02 * 14,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

// Regular reading 14px (lineHeight 150%)
class Body2RegularReading14 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Body2RegularReading14({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 1.5,
      letterSpacing: -0.02 * 14,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

// --- Label 1 (Medium 14px) ---
class Label1Medium14 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Label1Medium14({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w500, // Medium
      fontSize: 14,
      height: 1.4,
      letterSpacing: -0.02 * 14,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

// --- Label 2 (Regular 12px) ---
class Label2Regular12 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Label2Regular12({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 12,
      height: 1.4,
      letterSpacing: -0.02 * 12,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

// Regular reading 12px
class Label2RegularReading12 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Label2RegularReading12({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 12,
      height: 1.4,
      letterSpacing: -0.02 * 12,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

// --- Caption 1 (11px) ---
class Caption1Regular11 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Caption1Regular11({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 11,
      height: 1.4,
      letterSpacing: -0.02 * 11,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}

// --- Caption 2 (10px) ---
class Caption2Regular10 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;

  const Caption2Regular10({
    super.key,
    required this.text,
    this.color,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      fontSize: 10,
      height: 1.4,
      letterSpacing: -0.02 * 10,
      color: color ?? OrmeeColor.black,
    ),
    overflow: overflow ?? TextOverflow.clip,
  );
}
