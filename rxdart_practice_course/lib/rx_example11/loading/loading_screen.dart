import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rxdart_practice_course/rx_example11/loading/loadingscreen_controller.dart';

class LoadingScreen{
  LoadingScreen._sharedInstance();
  static final  LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen() => _shared;

  LoadingScreenController? controller;

  LoadingScreenController _showOverlay({required BuildContext context, required String text}){
    final streamText = StreamController<String>();
    streamText.sink.add(text);

    //Get a reference of the overlay withing the nearest BuildContext
    final state = Overlay.of(context);
    //find the renderObject associated with the element of the overlay and return it as a RenderBox
    final renderBox = context.findRenderObject() as RenderBox;
    //get the size of the renderBox
    final size = renderBox.size;
    //create an overlay entry to be inserted into  and managed by the overlay stack
    final overlay = OverlayEntry(
      builder: (_) => Material(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.8, minWidth: size.width * 0.5,
              maxHeight: size.height * 0.8
            ), 
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Gap(10),
                    const CircularProgressIndicator(),
                    const Gap(10),
                    StreamBuilder<String>(
                      stream: streamText.stream,
                      builder: (_, snapshot) => Text(snapshot.data ?? '', textAlign: TextAlign.center)
                    )
                  ],
                )
              )
            )
          )
        )
      )
    );
    //insert the overlay entry into the overlay stack
    state.insert(overlay);
    return LoadingScreenController(
      close: (){streamText.close(); overlay.remove(); return true;},
      update: (text){streamText.sink.add(text); return true;}
    );
  }
}
