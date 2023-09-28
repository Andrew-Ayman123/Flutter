import 'package:asdt_app/classes/event.dart';
import 'package:asdt_app/classes/user_att.dart';
import 'package:asdt_app/helpers/firebase_firestore.dart';
import 'package:asdt_app/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatelessWidget {
  static const String routeName = '/QRScanner';

  final cameraController = MobileScannerController();

  QRScanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qrBoxWidth = MediaQuery.of(context).size.width * .75;
    final Event event = ModalRoute.of(context)!.settings.arguments as Event;
    return CustomScaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            allowDuplicates: false,
            controller: cameraController,
            onDetect: (barcode, args) {
              final code = barcode.rawValue;
              if (code != null) {
                FirebaseFirestoreHelper.addUserToEventAtt(
                    AppUserAttendance(
                      email: code,
                      eventId: event.id!,
                      date: DateTime.now(),
                    ),
                    context);
              }
            },
          ),
          Center(
            child: Container(
              width: qrBoxWidth,
              height: qrBoxWidth,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.5),
                border: Border.all(
                  color: Colors.redAccent.withOpacity(.75),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
