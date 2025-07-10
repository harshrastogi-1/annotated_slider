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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  var _value = 0.0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
                activeTrackColor: Color(0xFF017AFF),
                activeTickMarkColor: Color(0xFF017AFF),
                valueIndicatorColor: Color(0xFF017AFF),
                trackShape: const AnnotatedRoundedRectSliderTrackShape(),
                thumbShape: DoubleArrowThumbShape(),
                showValueIndicator: ShowValueIndicator.onlyForDiscrete,
                overlayShape: const AnnotatedRoundSliderOverlayShape(
                  overlayRadius: 24.0,
                ),
                markerShape: DOTShape(.7),
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
                markerLabel: "Ideal cover",
                value: _value,
                divisions: 100,
                markerLabelPosition: .75,
                onChangeEnd: (value) {},
                onChanged: (double value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
            ),
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DoubleArrowThumbShape extends AnnotatedSliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(20, 16);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    AnnotatedSliderThemeData? sliderTheme,
    TextDirection? textDirection,
    double? value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    const radius = 16.0;
    const triangleWidth = 8.0;
    const triangleHeight = 11.0;

    final leftTrianglePath =
        Path()
          ..moveTo(center.dx - 2, center.dy - triangleHeight / 2)
          ..lineTo(center.dx - 2, center.dy + triangleHeight / 2)
          ..lineTo(center.dx - 2 - triangleWidth, center.dy)
          ..close();

    final rightTrianglePath =
        Path()
          ..moveTo(center.dx + 2, center.dy - triangleHeight / 2)
          ..lineTo(center.dx + 2, center.dy + triangleHeight / 2)
          ..lineTo(center.dx + 2 + triangleWidth, center.dy)
          ..close();

    canvas.drawCircle(center, radius, Paint()..color = Color(0xFF017AFF));
  }
}

class DOTShape extends AnnotatedSliderMarkerShape {
  final double value; // 0.0 to 1.0 normalized

  const DOTShape(this.value);

  static const double containerRadius = 6.0;

  @override
  double get markerValue => value;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required AnnotatedSliderThemeData sliderTheme,
    bool? isEnabled,
    bool? isDiscrete,
  }) {
    final double trackWidth = parentBox.size.width;
    final double markerX = offset.dx + trackWidth * value;
    final double markerY = offset.dy;

    return Rect.fromCircle(
      center: Offset(markerX, markerY - 20), // move it 20px above track
      radius: containerRadius,
    );
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
    final double trackWidth = parentBox.size.width;
    final double markerX = offset.dx + trackWidth * value;
    final double markerY = thumbCenter.dy;

    final Offset markerPosition = Offset(markerX, markerY);

    final Paint fillPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final Paint borderPaint =
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0;

    canvas.drawCircle(markerPosition, containerRadius, fillPaint);
    canvas.drawCircle(markerPosition, containerRadius, borderPaint);
  }
}
