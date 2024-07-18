import 'package:flutter/material.dart';

class LimitsConfigScreen extends StatefulWidget {
  @override
  _LimitsConfigScreenState createState() => _LimitsConfigScreenState();
}

class _LimitsConfigScreenState extends State<LimitsConfigScreen> {
  double minPressure = 60.0;
  double maxPressure = 120.0;
  RangeValues pressureRange = RangeValues(60, 90);

  double minSaturation = 90.0;
  double maxSaturation = 100.0;
  double saturationValue = 95.0;

  double minTemperature = 35.0;
  double maxTemperature = 40.0;
  double temperatureValue = 37.0;

  double minHeartRate = 60.0;
  double maxHeartRate = 120.0;
  double heartRateValue = 80.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración de límites'),
        //backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/alerts');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTitle('Presión Arterial', 'Rangos mínimos', 'Rangos máximos'),
            _buildRangeSlider(
              'Presión Arterial',
              pressureRange,
              minPressure,
              maxPressure,
              (RangeValues newRange) {
                setState(() {
                  pressureRange = newRange;
                });
              },
            ),
            _buildTitle('Saturación de Oxígeno'),
            _buildSlider(
              saturationValue,
              minSaturation,
              maxSaturation,
              (newValue) {
                setState(() {
                  saturationValue = newValue;
                });
              },
            ),
            _buildTitle('Temperatura Corporal'),
            _buildSlider(
              temperatureValue,
              minTemperature,
              maxTemperature,
              (newValue) {
                setState(() {
                  temperatureValue = newValue;
                });
              },
            ),
            _buildTitle('Frecuencia Cardíaca'),
            _buildSlider(
              heartRateValue,
              minHeartRate,
              maxHeartRate,
              (newValue) {
                setState(() {
                  heartRateValue = newValue;
                });
              },
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('GUARDAR'),
                style: ElevatedButton.styleFrom(
                  //backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title, [String? minLabel, String? maxLabel]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Icon(Icons.info_outline, color: Colors.grey),
          ],
        ),
        if (minLabel != null && maxLabel != null) ...[
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(minLabel, style: TextStyle(fontSize: 16)),
              Text(maxLabel, style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildRangeSlider(
    String label,
    RangeValues values,
    double min,
    double max,
    ValueChanged<RangeValues> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RangeSlider(
          values: values,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          labels: RangeLabels(
            values.start.round().toString(),
            values.end.round().toString(),
          ),
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${values.start.round()}', style: TextStyle(fontSize: 16)),
            Text('${values.end.round()}', style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSlider(
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: value.round().toString(),
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${min.round()}', style: TextStyle(fontSize: 16)),
            Text('${value.round()}', style: TextStyle(fontSize: 16)),
            Text('${max.round()}', style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
