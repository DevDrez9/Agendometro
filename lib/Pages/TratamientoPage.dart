import 'package:agendometro/Models/Medidas.dart';
import 'package:agendometro/Models/PendientesClass.dart';
import 'package:agendometro/Pages/HomePage2.dart';
import 'package:agendometro/SubPages/TratamientoPage1.dart';
import 'package:agendometro/Utilidades/DrawingCanva.dart';
import 'package:flutter/material.dart';

class TratamientoPage extends StatefulWidget {
  final PendientesClass? tratamiento;
  TratamientoPage({super.key, this.tratamiento});

  @override
  State<TratamientoPage> createState() => _TratamientoPageState();
}

class _TratamientoPageState extends State<TratamientoPage> {
  int avance = 1;

  Medidas medias = Medidas.empty();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage2()),
          );
          return false; // Evita que el sistema maneje el retroceso
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Tratamiento"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage2()),
                  );
                },
              ),
            ),
            body: Container(child: mostrarSeccion())));
  }

  Widget mostrarSeccion() {
    switch (avance) {
      case 1:
        return TratamientoPage1();
      case 2:
        return DrawingCanvas();
      default:
        return TratamientoPage1();
    }
  }

  siguiente1() {}
}
