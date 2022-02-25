

import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerViewRoute extends CupertinoPageRoute<String> {
  QRCodeScannerViewRoute() : super(builder: (context) => const _QRCodeScannerView());
}

class _QRCodeScannerView extends StatefulWidget {
  const _QRCodeScannerView({Key? key}) : super(key: key);

  @override
  _QRCodeScannerViewState createState() => _QRCodeScannerViewState();
}

class _QRCodeScannerViewState extends State<_QRCodeScannerView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      Navigator.of(context).pop(scanData.code);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: QRView(
          key: qrKey,
          formatsAllowed: const [BarcodeFormat.qrcode],
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: AppColors.primary,
            borderWidth: 2,
          ),
        ),
      ),
      // Center(
      //   child: QrCamera(
      //     formats: const [BarcodeFormats.QR_CODE],
      //     onError: (context, error) => Center(
      //       child: Text(
      //         error.toString(),
      //         style: const TextStyle(color: AppColors.red),
      //       ),
      //     ),
      //     qrCodeCallback: (code) {
      //       QrMobileVision.stop();
      //       Navigator.of(context).pop(code);
      //     },
      //     child: Stack(children: [
      //       Center(
      //         child: Padding(
      //           padding: const EdgeInsets.all(24.0),
      //           child: AspectRatio(
      //             aspectRatio: 1,
      //             child: Container(
      //               decoration: BoxDecoration(
      //                   color: Colors.transparent,
      //                   border: Border.all(color: AppColors.primary, width: 2.0)),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ]),
      //   ),
      // ),
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                width: 36,
                height: 36,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gray10,
                ),
                child: Material(
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: AppColors.gray100,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
