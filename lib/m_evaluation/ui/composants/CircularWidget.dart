import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multicircularprogressindicator/models/progress_model.dart';
import 'package:multicircularprogressindicator/multicircularprogressindicator.dart';

class CircularWidget extends ConsumerStatefulWidget {
  final Function(double) onValueChanged;
  final double value;

  const CircularWidget({
    Key? key,
    required this.onValueChanged,
    required this.value,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CircularWidgetState();
}

class _CircularWidgetState extends ConsumerState<CircularWidget> {
  double _currentProgressValue = 0;
  final double _radius = 70;
  late String _bottomText = "";

  @override
  void initState() {
    super.initState();
    _currentProgressValue = widget.value;
    _bottomText = "${(widget.value * 100).toStringAsFixed(1)}%";
  }

  @override
  void didUpdateWidget(CircularWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() {
        _currentProgressValue = widget.value;
        _bottomText = "${(_currentProgressValue * 100).toStringAsFixed(1)}%";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // Utilisation de MultiCircularProgressWidget pour afficher la progression
          MultiCircularProgressWidget(
            listProgress: [
              ProgressModel(
                progressValue: _currentProgressValue,
                color: Color(0xff1f6524),
              ),
            ],
            radius: _radius,
            bottomText: _bottomText, // Texte au bas du widget circulaire
            progressStyle: ProgressStyle.values[0], // Style de progression (choix depuis les enums)
          ),
        ],
      ),
    );
  }
}
