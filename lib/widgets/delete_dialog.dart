import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteDialog {
  final String deleteMessage;
  final VoidCallback onDeletePressed;

  DeleteDialog({
    Key? key,
    required this.deleteMessage,
    required this.onDeletePressed,
  });

  showDeleteDialog() {
    return showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      context: Get.context!,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 251,
            margin: const EdgeInsets.only(bottom: 20, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Container(
              width: Get.width,
              height: Get.height,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(17)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.04),
                      offset: Offset(0, -4),
                      blurRadius: 12)
                ],
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 20),
                    child: Center(
                        child: // Figma Flutter Generator Ellipse17Widget - ELLIPSE
                            Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color.fromRGBO(216, 0, 0, 1),
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(54))),
                      child: const Image(
                        image: ExactAssetImage('assets/img/delete20.png'),
                      ),
                    ))),
                Center(
                    child: SizedBox(
                        width: 270,
                        height: 70,
                        child: Text(
                          deleteMessage,
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                            color: Color(
                              0xff4a4a4a,
                            ),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Lato",
                            letterSpacing: 0,
                          ),
                          textAlign: TextAlign.center,
                        ))),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 38, right: 38, top: 20, bottom: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: // Figma Flutter Generator Rectangle22Widget - RECTANGLE
                              Container(
                            width: 120,
                            height: 42,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              border: Border.all(
                                color: const Color.fromRGBO(221, 221, 221, 1),
                                width: 1,
                              ),
                            ),
                            child: const Center(
                                child: Text(
                              'Cancel',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Lato",
                                  decoration: TextDecoration.none),
                            )),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => onDeletePressed(),
                          child: Container(
                            width: 120,
                            height: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
                            child: const Center(
                                child: Text(
                              'Delete',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontFamily: "Lato",
                                  decoration: TextDecoration.none),
                            )),
                          ),
                        )
                      ],
                    ))
              ]), //
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }
}
