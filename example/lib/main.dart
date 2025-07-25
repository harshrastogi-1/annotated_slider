import 'dart:math' as math;

import 'package:annotated_slider/annotated_slider.dart';
import 'package:annotated_slider/annotated_slider_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Main Application Widget
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

/// Home Page Widget with state management
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// State of the Home Page Widget
class _MyHomePageState extends State<MyHomePage> {
  // Current slider value
  double _value = 0.0;

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
            /// AnnotatedSliderTheme wraps the AnnotatedSlider and provides custom styling
            AnnotatedSliderTheme(
              data: AnnotatedSliderTheme.of(context).copyWith(
                trackHeight: 10.0,
                trackShape: const AnnotatedRoundedRectSliderTrackShape(),
                showValueIndicator: ShowValueIndicator.onlyForDiscrete,
                overlayShape: const AnnotatedRoundSliderOverlayShape(
                  overlayRadius: 24.0,
                ),
                markerShape: DOTShape([.2, .5, .8]), // Custom marker shape
                tickMarkShape: const AnnotatedRoundSliderTickMarkShape(),
                valueIndicatorShape:
                    const AnnotatedPaddleSliderValueIndicatorShape(),
                valueIndicatorTextStyle: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
                markerLabelTextStyle: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black,
                ),
              ),

              /// AnnotatedSlider widget
              child: AnnotatedSlider(
                min: 0.0,
                max: 1000.0,
                label: _value.toString(),
                value: _value,
                divisions: 100,
                markerLabel: ["Min", "Ideal", "Max"],
                markerLabelPosition: [.2, .5, .8],
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

/// Custom Marker Shape to draw circular dots on the slider
class DOTShape extends AnnotatedSliderMarkerShape {
  final List<double>
  value; // Normalized values (0.0 - 1.0) for marker positions

  DOTShape(this.value);

  static const double containerRadius = 4.0;

  // Caches the positions of the marker rects
  final List<Rect> markerPainter = [];

  // Required override: provide the marker values (positions)
  @override
  List<double> get markerValue => value;

  /// Calculates preferred marker positions as Rects on the slider track
  @override
  List<Rect> getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required AnnotatedSliderThemeData sliderTheme,
    bool? isEnabled,
    bool? isDiscrete,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;

    // Get sizes of thumb and overlay for calculating track bounds
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

    // Calculate track boundaries within slider widget
    final double trackLeft =
        offset.dx + math.max(overlayWidth / 2, thumbWidth / 2);
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackRight =
        trackLeft + parentBox.size.width - math.max(thumbWidth, overlayWidth);
    final double trackBottom = trackTop + trackHeight;

    final double trackWidth = trackRight - trackLeft;

    // Clear previously stored positions
    markerPainter.clear();

    // Calculate marker circle rects based on normalized value
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

  /// Paints the circular markers at their calculated positions
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
    final List<Rect> markerRects = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    for (int i = 0; i < markerRects.length; i++) {
      final center = markerRects[i].center;

      if (i == 0) {
        //First marker: golden glow with red core
        final Paint glowPaint =
            Paint()
              ..color = Colors.amber.withOpacity(0.4)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
        final Paint fillPaint =
            Paint()
              ..shader = RadialGradient(
                colors: [Colors.redAccent, Colors.deepOrange],
                radius: 0.6,
              ).createShader(
                Rect.fromCircle(center: center, radius: containerRadius),
              );
        final Paint borderPaint =
            Paint()
              ..color = Colors.amber
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.0;

        canvas.drawCircle(center, containerRadius + 3, glowPaint);
        canvas.drawCircle(center, containerRadius, fillPaint);
        canvas.drawCircle(center, containerRadius, borderPaint);
      } else {
        // 🎨 Other markers: blue–purple gradient
        final Paint glowPaint =
            Paint()
              ..color = Colors.amber.withOpacity(0.4)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
        final Paint fillPaint =
            Paint()
              ..shader = RadialGradient(
                colors: [Colors.yellow, Colors.yellowAccent],
                radius: 0.6,
              ).createShader(
                Rect.fromCircle(center: center, radius: containerRadius),
              );
        final Paint borderPaint =
            Paint()
              ..color = Colors.amber
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.0;

        canvas.drawCircle(center, containerRadius + 2, glowPaint);
        canvas.drawCircle(center, containerRadius, fillPaint);
        canvas.drawCircle(center, containerRadius, borderPaint);
      }
    }
  }
}
