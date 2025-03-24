import 'package:agendometro/Models/ClienteClass.dart';
import 'package:agendometro/SubPages/AgendarPage.dart';
import 'package:agendometro/SubPages/CitasPage.dart';
import 'package:agendometro/SubPages/HistorialPage.dart';
import 'package:agendometro/SubPages/MenuDrawer.dart';
import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Utilidades/GlobalVariables.dart';
import 'package:flutter/material.dart';

class HomePage2 extends StatefulWidget {
  final int initialTab; // Parámetro opcional con valor predeterminado
  final ClienteClass? cliente; // Parámetro opcional

  const HomePage2({Key? key, this.initialTab = 0, this.cliente})
      : super(key: key); // Valor predeterminado: 0

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2>
    with SingleTickerProviderStateMixin {
  late TabController _tabController; // Controlador para el TabBar

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab, // Usa el valor de initialTab
    );
  }

  @override
  void dispose() {
    _tabController.dispose(); // Libera el controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/loggo.png', // Ruta de la imagen
          height: 80, // Ajusta el tamaño
          color: AppThemeColors.primary,
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tus citas'), // Pestaña 1
            Tab(text: 'Agendar'), // Pestaña 2
            Tab(text: 'Historial'), // Pestaña 3
          ],
        ),
      ),
      drawer: MenuDrawer(),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(), // Deshabilita el swipe
        children: [
          CitasPage(), // Contenido de la pestaña 1
          AgendarPage(
            cliente: widget.cliente,
          ), // Contenido de la pestaña 2
          HistorialPage(), // Contenido de la pestaña 3
        ],
      ),
    );
  }
}
