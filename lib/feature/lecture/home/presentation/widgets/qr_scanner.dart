import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading1SemiBold22(text: 'QR 코드 스캔'),
        centerTitle: true,
        backgroundColor: OrmeeColor.white,
        foregroundColor: OrmeeColor.gray[90],
        actions: [
          IconButton(
            icon: Icon(Icons.flash_on),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: Icon(Icons.flip_camera_ios),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (BarcodeCapture barcodeCapture) {
              if (!isScanned) {
                isScanned = true;
                final List<Barcode> barcodes = barcodeCapture.barcodes;
                print('바코드 $barcodes');

                if (barcodes.isNotEmpty) {
                  final String? qrData = barcodes.first.rawValue;
                  print('큐알 $qrData');

                  if (qrData != null) {
                    _handleQRData(qrData);
                  }
                }
              }
            },
          ),
          // 스캔 가이드 오버레이
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // 안내 텍스트
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Heading1Regular22(
                  text: 'QR 코드를 스캔하세요',
                  color: OrmeeColor.white,
                ),
              ),
            ),
          ),
        ],
      ),
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
