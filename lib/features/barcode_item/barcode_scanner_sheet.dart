import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/theme.dart';

Future<String?> showBarcodeScannerSheet(BuildContext context) {
  final scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [
      BarcodeFormat.ean8,
      BarcodeFormat.ean13,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
      BarcodeFormat.itf14,
    ],
  );

  final barcodeAlreadyReturned = ValueNotifier<bool>(false);

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.black,
    builder: (_) {
      return BarcodeScannerSheet(
        scannerController: scannerController,
        barcodeAlreadyReturned: barcodeAlreadyReturned,
      );
    },
  ).whenComplete(() async {
    await scannerController.dispose();
    barcodeAlreadyReturned.dispose();
  });
}

class BarcodeScannerSheet extends StatelessWidget {
  const BarcodeScannerSheet({
    super.key,
    required this.scannerController,
    required this.barcodeAlreadyReturned,
  });

  final MobileScannerController scannerController;
  final ValueNotifier<bool> barcodeAlreadyReturned;

  void _handleDetect(
    BuildContext context,
    BarcodeCapture capture,
  ) {
    if (barcodeAlreadyReturned.value) {
      return;
    }

    for (final barcode in capture.barcodes) {
      final rawValue = barcode.rawValue?.trim();

      if (rawValue == null || rawValue.isEmpty) {
        continue;
      }

      barcodeAlreadyReturned.value = true;
      unawaited(scannerController.stop());

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pop(rawValue);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.sizeOf(context).height * 0.86;

    return SizedBox(
      height: sheetHeight,
      child: Stack(
        children: [
          MobileScanner(
            controller: scannerController,
            onDetect: (capture) => _handleDetect(context, capture),
            errorBuilder: (context, error) {
              return _ScannerErrorView(
                message: 'Não foi possível iniciar a câmera.',
                technicalMessage: error.toString(),
              );
            },
          ),
          const _ScannerFrameOverlay(),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.54),
              ),
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 32,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.64),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Aponte a câmera para o código de barras do produto.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerFrameOverlay extends StatelessWidget {
  const _ScannerFrameOverlay();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.82,
        height: 180,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class _ScannerErrorView extends StatelessWidget {
  const _ScannerErrorView({
    required this.message,
    required this.technicalMessage,
  });

  final String message;
  final String technicalMessage;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.no_photography_outlined,
                color: Colors.white,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                technicalMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}