import 'package:flutter/material.dart';
import 'package:sensor_app/config_screen.dart';
import 'package:sensor_app/configuracion.dart';
import 'package:sensor_app/sensors.dart';
import 'api_service.dart';

class AlertsScreen extends StatefulWidget {
  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allAlerts = []; // Lista completa de alertas
  List<Map<String, dynamic>> filteredAlerts = []; // Lista filtrada de alertas

  String _selectedFilter = 'Emergencias';
  final ApiService apiService = ApiService();  // Instancia de ApiService

  Future<List<Map<String, dynamic>>> _fetchAlerts() async {
    try {
      //return await apiService.fetchAlerts();
      List<Map<String, dynamic>> alerts = await apiService.fetchAlerts();
      allAlerts = alerts;
      // Filtrar las alertas según el tipo seleccionado
      return alerts.where((alert) {
        switch (_selectedFilter) {
          case 'Emergencias':
            return alert['tipoAlerta'] == 8; 
          case 'Recordatorios':
            return alert['tipoAlerta'] == 9; 
          default:
            return false;
        }
      }).toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar alertas: $e')),
      );
      return [];
    }
  }

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SensorsScreen(),
    LimitsConfigScreen(),
    AlertsScreen(),
    GeneralSettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navegar a la página seleccionada
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  void initState() {
    super.initState();
    // Supongamos que ya has cargado las alertas en allAlerts
    filteredAlerts = allAlerts; // Inicialmente, muestra todas las alertas
    // Escucha cambios en el campo de búsqueda
    _searchController.addListener(_filterAlerts);
  }

  void _filterAlerts() {
    String searchQuery = _searchController.text.toLowerCase();
    setState(() {
      filteredAlerts = allAlerts.where((alert) {
        return alert['nombre'].toLowerCase().contains(searchQuery) || 
               alert['mensaje'].toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back, color: Colors.black),
        title: Text(
          'Alerta y Notificaciones',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAlerts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar alertas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay alertas'));
          }

          List<Map<String, dynamic>> alerts = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchBar(),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFilterButton('Emergencias'),
                  _buildFilterButton('Recordatorios'),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: alerts.length,
                  itemBuilder: (context, index) {
                    final alert = alerts[index];
                        Color alertColor;
                        switch (alert['tipoAlerta']) {
                          case 8: //Emergencias
                            alertColor = Colors.red[100]!;
                            break;
                          default: //Recordatorios
                            alertColor = Colors.yellow[100]!;
                        }

                    return Card(
                      color: alertColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: Icon(
                          alert['tipoAlerta'] == 8
                              ? Icons.warning
                              : alert['tipoAlerta'] == 9
                                  ? Icons.info_outline
                                  : Icons.notifications,
                          color: Colors.black,
                        ),
                        title: Text(alert['nombre']!,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(alert['mensaje']!),
                        trailing: Icon(Icons.delete, color: Colors.black),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3F6BF4), Color(0xFF1E90FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/assets/images/12.png')),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/assets/images/20.png')),
              label: 'Limites',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/assets/images/14.png')),
              label: 'Notificaciones',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/assets/images/15.png')),
              label: 'Perfil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }


  Widget _buildFilterButton(String title) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = title;
          });
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: _selectedFilter == title ? Colors.blue : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: _selectedFilter == title ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'BUSCAR',
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.filter_list, color: Colors.grey),
        ],
      ),
    );
  }
}


