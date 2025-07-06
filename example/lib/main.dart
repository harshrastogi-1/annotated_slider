import 'package:annotated_slider/annotated_slider.dart';
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
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 8.0,
                trackShape: const RoundedRectSliderTrackShape(),
                thumbShape: DoubleArrowThumbShape(),
                showValueIndicator: ShowValueIndicator.onlyForDiscrete,
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 24.0,
                ),
                tickMarkShape: const RoundSliderTickMarkShape(),
                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                valueIndicatorTextStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.red,
                ),
              ),
              child: AnnotatedSlider(
                min: 0.0,
                max: 1000.0,
                label: "Harsh ",
                markerLabel: "Harsh",
                value: _value,
                markerLabelPosition: 1.5,
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

class DoubleArrowThumbShape extends SliderComponentShape {
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
    SliderThemeData? sliderTheme,
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

    canvas.drawCircle(center, radius, Paint()..color = Colors.black);
  }
}
