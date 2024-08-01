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
        title: Text('Configuración de Límites'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
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
            _buildTitle('Presión Arterial', 'Rangos Mínimos', 'Rangos Máximos'),
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
            _buildTitle(
                'Saturación de Oxígeno', 'Rangos Mínimos', 'Rangos Máximos'),
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
            _buildTitle(
                'Temperatura Corporal', 'Rangos Mínimos', 'Rangos Máximos'),
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
            _buildTitle(
                'Frecuencia Cardíaca', 'Rangos Mínimos', 'Rangos Máximos'),
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
                child: Text('Guardar'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3F6BF4), Color(0xFF1E90FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendario',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notificaciones',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
          currentIndex: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          onTap: (index) {
            // handle navigation
          },
        ),
      ),
    );
  }

  Widget _buildTitle(String title, String minLabel, String maxLabel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              SizedBox(width: 8),
              Icon(Icons.info_outline, color: Colors.grey),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(minLabel, style: TextStyle(fontSize: 16)),
              Text(maxLabel, style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
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
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
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
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
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
