import 'package:flutter/material.dart';

class LimitsConfigScreen extends StatefulWidget {
  @override
  _LimitsConfigScreenState createState() => _LimitsConfigScreenState();
}

class _LimitsConfigScreenState extends State<LimitsConfigScreen> {
  double weight = 70.0; // Peso inicial
  double height = 170.0; // Estatura inicial
  double age = 30.0; // Edad inicial

  double minPressure = 60.0;
  double maxPressure = 130.0;

  double minTemperature = 35.0;
  double maxTemperature = 38.0;

  double minSaturation = 90.0;
  double maxSaturation = 100.0;

  double pressureValue = 100.0;
  double temperatureValue = 36.5;
  double saturationValue = 95.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración de límites de signos vitales'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSlider(
              'Peso',
              weight,
              40.0,
              120.0,
              (value) {
                setState(() {
                  weight = value;
                });
              },
            ),
            _buildSlider(
              'Estatura',
              height,
              120.0,
              220.0,
              (value) {
                setState(() {
                  height = value;
                });
              },
            ),
            _buildSlider(
              'Edad',
              age,
              1.0,
              120.0,
              (value) {
                setState(() {
                  age = value;
                });
              },
            ),
            _buildSignLimit(
              'Presión arterial',
              minPressure,
              maxPressure,
              pressureValue,
              (value) {
                setState(() {
                  pressureValue = value;
                });
              },
            ),
            _buildSignLimit(
              'Temperatura corporal',
              minTemperature,
              maxTemperature,
              temperatureValue,
              (value) {
                setState(() {
                  temperatureValue = value;
                });
              },
            ),
            _buildSignLimit(
              'Saturación de oxígeno',
              minSaturation,
              maxSaturation,
              saturationValue,
              (value) {
                setState(() {
                  saturationValue = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$label (${value.toStringAsFixed(1)})',
          style: TextStyle(fontSize: 18),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          onChanged: onChanged,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSignLimit(
    String label,
    double minLimit,
    double maxLimit,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$label:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey[300],
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: _calculatePosition(minLimit, maxLimit, minLimit),
                child: Container(
                  width: 5,
                  height: 30,
                  color: Colors.red,
                ),
              ),
              Positioned(
                left: _calculatePosition(minLimit, maxLimit, value),
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    double newValue = _calculateValue(
                      minLimit,
                      maxLimit,
                      details.localPosition.dx,
                      context,
                    );
                    onChanged(newValue);
                  },
                  child: Container(
                    width: 20,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: _calculatePosition(minLimit, maxLimit, maxLimit),
                child: Container(
                  width: 5,
                  height: 30,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Mínimo: ${minLimit.toStringAsFixed(1)} - Máximo: ${maxLimit.toStringAsFixed(1)}',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  double _calculatePosition(double min, double max, double value) {
    return (value - min) / (max - min) * MediaQuery.of(context).size.width - 10;
  }

  double _calculateValue(
      double min, double max, double positionX, BuildContext context) {
    double position = positionX + 10;
    double width = MediaQuery.of(context).size.width;
    double value = (position / width) * (max - min) + min;
    return value.clamp(min, max);
  }
}
