import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenPage extends StatelessWidget {
  const FullScreenPage({super.key, required this.child});

  final Image child;

  @override
  Widget build(BuildContext context) {
    context.theme;
    return Scaffold(
      body: Container(
        constraints: BoxConstraints(minHeight: Get.height, minWidth: Get.width),
        child: Stack(
          children: [
            Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 333),
                  curve: Curves.fastOutSlowIn,
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 4,
                    child: child,
                  ),
                ),
              ],
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: MaterialButton(
                    padding: const EdgeInsets.all(15),
                    elevation: 0,
                    color: Get.isPlatformDarkMode
                        ? Colors.black12
                        : Colors.white70,
                    highlightElevation: 0,
                    minWidth: double.minPositive,
                    height: double.minPositive,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back, size: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
