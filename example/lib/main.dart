import 'dart:math' as math;

import 'package:annotated_slider/annotated_slider.dart';
import 'package:annotated_slider/annotated_slider_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Annotated Slider Demo',
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(title: 'Flutter Annotated Slider Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _value = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnnotatedSliderTheme(
              data: AnnotatedSliderTheme.of(context).copyWith(
                trackHeight: 10.0,
                trackShape: const AnnotatedRoundedRectSliderTrackShape(),
                showValueIndicator: ShowValueIndicator.onlyForDiscrete,
                overlayShape: const AnnotatedRoundSliderOverlayShape(
                  overlayRadius: 24.0,
                ),
                markerShape: DOTShape([.3, .5, .7]),
                tickMarkShape: const AnnotatedRoundSliderTickMarkShape(),
                valueIndicatorShape:
                    const AnnotatedPaddleSliderValueIndicatorShape(),
                valueIndicatorTextStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
                markerLabelTextStyle: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black,
                ),
              ),
              child: AnnotatedSlider(
                min: 0.0,
                max: 1000.0,
                label: _value.toString(),
                markerLabel: ["Ideal cover", "Harsh", "Check"],
                value: _value,
                divisions: 100,
                markerLabelPosition: [.3, .5, .7],
                onChangeEnd: (value) {},
                onChanged: (double value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DOTShape extends AnnotatedSliderMarkerShape {
  final List<double> value; // normalized value 0.0 to 1.0

  DOTShape(this.value);

  static const double containerRadius = 6.0;
  final List<Rect> markerPainter = [];

  @override
  List<double> get markerValue => value;

  @override
  List<Rect> getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required AnnotatedSliderThemeData sliderTheme,
    bool? isEnabled,
    bool? isDiscrete,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;

    final double thumbWidth =
        sliderTheme.thumbShape
            ?.getPreferredSize(isEnabled ?? true, isDiscrete ?? false)
            .width ??
        0.0;

    final double overlayWidth =
        sliderTheme.overlayShape
            ?.getPreferredSize(isEnabled ?? true, isDiscrete ?? false)
            .width ??
        0.0;

    final double trackLeft =
        offset.dx + math.max(overlayWidth / 2, thumbWidth / 2);
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackRight =
        trackLeft + parentBox.size.width - math.max(thumbWidth, overlayWidth);
    final double trackBottom = trackTop + trackHeight;

    final double trackWidth = trackRight - trackLeft;

    for (int i = 0; i < value.length; i++) {
      final double markerX = trackLeft + (trackWidth * value[i]);
      final double markerY = (trackTop + trackBottom) / 2;
      markerPainter.add(
        Rect.fromCircle(
          center: Offset(markerX, markerY),
          radius: containerRadius,
        ),
      );
    }
    return markerPainter;
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required AnnotatedSliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    required bool isEnabled,
    required bool isDiscrete,
    required TextDirection textDirection,
  }) {
    final Canvas canvas = context.canvas;

    final List<Rect> markerRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint fillPaint =
        Paint()
          ..color = Colors.white38
          ..style = PaintingStyle.fill;

    final Paint borderPaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0;

    for (int i = 0; i < markerRect.length; i++) {
      canvas.drawCircle(markerRect[i].center, containerRadius, fillPaint);
      canvas.drawCircle(markerRect[i].center, containerRadius, borderPaint);
    }
  }
}
