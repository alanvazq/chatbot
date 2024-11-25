import 'package:chatbot/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends ConsumerWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    final MobileScannerController controller = MobileScannerController();
    void showToast(String message) {
      Fluttertoast.showToast(
        msg: message,
        backgroundColor: colors.primary.withOpacity(0.1),
        textColor: colors.primary,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Escanear QR")),
      body: MobileScanner(
        controller: controller,
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            controller.stop();
            Navigator.pop(context);
            ref.read(chatProvider.notifier).newConversation();
            showToast('Se ha iniciado una nueva conversación');
          }
        },
      ),
    );
  }
}
