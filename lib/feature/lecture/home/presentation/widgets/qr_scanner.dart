import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:ormee_app/feature/lecture/home/bloc/lecture_bloc.dart';
import 'package:ormee_app/feature/lecture/home/bloc/lecture_event.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/button.dart';

class QRScannerPage extends StatefulWidget {
  final LectureHomeBloc? bloc; // BLoC 인스턴스를 받을 필드 추가

  const QRScannerPage({super.key, this.bloc});

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController controller = MobileScannerController();
  bool isScanned = false;
  bool flashOnOff = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // 스캐폴드 배경도 투명하게
      extendBodyBehindAppBar: true, // 바디가 앱바 뒤로 확장되도록
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: SvgPicture.asset(
            'assets/icons/chevron_left.svg',
            color: OrmeeColor.white,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              flashOnOff
                  ? 'assets/icons/flash_on.svg'
                  : 'assets/icons/flash_off.svg',
              color: OrmeeColor.white,
            ),
            onPressed: () {
              setState(() {
                flashOnOff = !flashOnOff; // 수정: setState로 상태 업데이트
              });
              controller.toggleTorch();
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/flip_camera.svg',
              color: OrmeeColor.white,
            ),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            overlayBuilder: _buildScannerOverlay,
            onDetect: (BarcodeCapture barcodeCapture) {
              if (!isScanned) {
                isScanned = true;
                final List<Barcode> barcodes = barcodeCapture.barcodes;
                if (barcodes.isNotEmpty) {
                  final String? qrData = barcodes.first.rawValue;
                  if (qrData != null) {
                    _handleQRData(qrData);
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }

  // 스캐너 오버레이 빌드 함수
  Widget _buildScannerOverlay(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    return QRScannerOverlay(
      overlayColour: const Color(0x9919191D), // #19191D · 60%
    );
  }

  // QR 데이터 처리 함수
  Future<void> _handleQRData(String qrData) async {
    try {
      int lectureId;

      if (qrData.startsWith('http')) {
        // URL인 경우: HTTP 요청으로 lectureId 가져오기
        _showLoadingDialog(context);

        final fetchedLectureId = await _fetchLectureIdFromUrl(qrData);

        // 로딩 다이얼로그 닫기
        if (mounted) context.pop();

        if (fetchedLectureId != null) {
          lectureId = fetchedLectureId;
        } else {
          throw Exception('URL에서 lectureId를 가져올 수 없습니다.');
        }
      } else {
        // 단순 숫자인 경우
        lectureId = int.parse(qrData);
      }

      // 스캐너 페이지 닫기
      if (mounted) context.pop();

      // widget.bloc을 사용하여 이벤트 전송
      if (mounted && widget.bloc != null) {
        widget.bloc!.add(ShowLectureDialog(lectureId));
      } else {
        // 백업: context.read 시도 (실패할 가능성 높음)
        try {
          if (mounted) {
            context.read<LectureHomeBloc>().add(ShowLectureDialog(lectureId));
          }
        } catch (e) {
          print('BLoC을 찾을 수 없습니다: $e');
        }
      }
    } catch (e) {
      print('QR 파싱 에러: $e');
      if (mounted) {
        _showErrorDialog(context, 'QR 코드 형식이 올바르지 않습니다.\n($qrData)');
      }
    }
  }

  // QR URL에서 lectureId 가져오기
  Future<int?> _fetchLectureIdFromUrl(String url) async {
    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: {'User-Agent': 'Mozilla/5.0 (compatible; OrmeeApp/1.0)'},
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseBody = response.body.trim();
        print('서버 응답: $responseBody');

        // 응답이 단순 숫자인 경우
        if (RegExp(r'^\d+$').hasMatch(responseBody)) {
          return int.parse(responseBody);
        }

        // JSON 응답인 경우 (필요시 사용)
        // try {
        //   final jsonData = json.decode(responseBody);
        //   return jsonData['lectureId'] as int;
        // } catch (e) {
        //   print('JSON 파싱 에러: $e');
        // }

        return null;
      } else {
        print('HTTP 에러: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('URL 요청 에러: $e');
      return null;
    }
  }

  // 로딩 다이얼로그
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: OrmeeColor.white,
        surfaceTintColor: Colors.transparent,
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: OrmeeColor.purple[50]),
              SizedBox(height: 16),
              Label1Regular14(
                text: '강의 정보를 가져오고 있습니다...',
                color: OrmeeColor.gray[90],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 에러 다이얼로그
  void _showErrorDialog(BuildContext context, String contentText) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: OrmeeColor.white,
        surfaceTintColor: Colors.transparent,
        title: Center(
          child: Heading2SemiBold20(text: '오류', color: OrmeeColor.gray[90]),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Label1Regular14(
                      text: contentText,
                      color: OrmeeColor.gray[90],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OrmeeButton(
                    trueAction: () {
                      context.pop(); // 다이얼로그 닫기
                      context.pop(); // QR 스캐너 페이지 닫기
                    },
                    text: '확인',
                    isTrue: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

// QR 스캐너 오버레이 위젯
class QRScannerOverlay extends StatelessWidget {
  const QRScannerOverlay({Key? key, required this.overlayColour})
    : super(key: key);

  final Color overlayColour;

  @override
  Widget build(BuildContext context) {
    // 디바이스 크기에 따른 스캔 영역 크기 조정
    double scanArea =
        (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 250.0; // 330에서 250으로 조정

    return Stack(
      children: [
        // 마스크 효과를 위한 ColorFiltered
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            overlayColour,
            BlendMode.srcOut,
          ), // 마법의 핵심
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  backgroundBlendMode: BlendMode.dstOut,
                ), // 배경 + 차이 처리
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: scanArea,
                  width: scanArea,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        // 흰색 모서리 테두리
        Align(
          alignment: Alignment.center,
          child: CustomPaint(
            foregroundPainter: BorderPainter(),
            child: SizedBox(width: scanArea + 8, height: scanArea + 8),
          ),
        ),
        // 스캔 안내 텍스트
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.3,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Headline1SemiBold18(
                text: 'QR 코드를 스캔하세요',
                color: OrmeeColor.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 흰색 테두리를 그리는 CustomPainter (라운드 선끝)
class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const width = 4.0;
    const radius = 20.0;
    const tRadius = 3 * radius;
    final rect = Rect.fromLTWH(
      width,
      width,
      size.width - 2 * width,
      size.height - 2 * width,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));
    const clippingRect0 = Rect.fromLTWH(0, 0, tRadius, tRadius);
    final clippingRect1 = Rect.fromLTWH(
      size.width - tRadius,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect2 = Rect.fromLTWH(
      0,
      size.height - tRadius,
      tRadius,
      tRadius,
    );
    final clippingRect3 = Rect.fromLTWH(
      size.width - tRadius,
      size.height - tRadius,
      tRadius,
      tRadius,
    );
    final path = Path()
      ..addRect(clippingRect0)
      ..addRect(clippingRect1)
      ..addRect(clippingRect2)
      ..addRect(clippingRect3);
    canvas.clipPath(path);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round, // 선끝을 라운드하게 설정
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
