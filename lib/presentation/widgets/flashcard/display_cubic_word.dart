import 'package:dictionary/domain/entities/flashcard.dart';
import 'package:dictionary/presentation/widgets/search_widgets/search_widgets.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class DisplayCubicWord extends StatefulWidget {
  final Flashcard card;
  final double planeSize = 200;
  final double cubeContainerHeight = 300;

  DisplayCubicWord({Key key, this.card}) : super(key: key);

  @override
  _DisplayCubicWordState createState() => _DisplayCubicWordState();
}

class _DisplayCubicWordState extends State<DisplayCubicWord>
    with SingleTickerProviderStateMixin {
  var _planeInfoList = List<Map<String, dynamic>>();

  AnimationController _animationController;
  Tween _tween;
  Animation _animation;
  double _offsetAngle = 0;
  double _baseAngle;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        GestureDetector(
          onHorizontalDragStart: (details) {
            _animationController.stop();
          },
          onHorizontalDragUpdate: (details) => setState(
              () => _offsetAngle += details.delta.dx / width * pi /* /2 * 2 */),
          onHorizontalDragEnd: (details) {
            double targetAngle =
                (_offsetAngle / _baseAngle).round() * _baseAngle;
            _animationController.duration = Duration(
              milliseconds:
                  ((_offsetAngle - targetAngle).abs() / _baseAngle * 5000)
                      .round(),
            );
            _tween.begin = _offsetAngle;
            _tween.end = targetAngle;
            _animationController.reset();
            _animationController.forward();
          },
          child: Container(
              width: width,
              height: widget.cubeContainerHeight,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: _planeInfoList
                        .asMap()
                        .map(
                          (index, planeInfo) => MapEntry(
                            index,
                            CubePlane(
                              widget: planeInfo["widget"].cast<Widget>(),
                              sideCount: _planeInfoList.length,
                              startAngle: planeInfo["startAngle"],
                              offsetAngle: _offsetAngle,
                              size: widget.planeSize,
                            ),
                          ),
                        )
                        .values
                        .toList(),
                  ),
                ),
              )),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    _tween = Tween(begin: 0, end: _baseAngle);
    _animation = _tween.animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _animationController.addListener(() => setState(() {
          _offsetAngle = _animation.value;
        }));

    _planeInfoList = [
      {
        "startAngle": 0.0,
        "widget": WordAndPhoneticsWidget(
          word: widget.card.word,
        ),
      },
    ];
    Column widgetColumnt = MeaningWidget(
      word: widget.card.word,
    ) as Column;
    widgetColumnt.children.asMap().forEach(
      (index, element) {
        _planeInfoList.add(
          {
            "startAngle": (index + 1) * pi / 2,
            "widget": element,
          },
        );
      },
    );
    _baseAngle = 2 * pi / _planeInfoList.length;
    _planeInfoList.asMap().forEach((index, plane) {
      plane["startAngle"] = index * _baseAngle;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class CubePlane extends StatelessWidget {
  final Widget widget;
  final int sideCount;
  final double startAngle;
  final double offsetAngle;
  final double size;

  const CubePlane(
      {Key key,
      this.widget,
      this.sideCount,
      this.startAngle,
      this.offsetAngle,
      this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var inradius = this.size / (2 * tan(pi / sideCount));
    var currentAngle = startAngle + offsetAngle;
    var angleRelatedToFront = (currentAngle.abs() % (2 * pi));
    return Container(
      width: size,
      height: size,
      child: 1.48353 < angleRelatedToFront && angleRelatedToFront < 4.79966
          ? Container()
          : Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..translate(
                  sin(currentAngle) * inradius,
                  0.0,
                  -cos(currentAngle) * inradius,
                )
                ..rotateY(-currentAngle),
              child: Card(
                child: widget,
              ),
            ),
    );
  }
}
