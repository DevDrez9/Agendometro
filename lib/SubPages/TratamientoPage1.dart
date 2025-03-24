import 'package:agendometro/Models/Medidas.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:agendometro/Widgets/BotonPrimario.dart';
import 'package:agendometro/Widgets/TextInput2.dart';
import 'package:flutter/material.dart';

class TratamientoPage1 extends StatefulWidget {
  const TratamientoPage1({super.key});

  @override
  State<TratamientoPage1> createState() => _TratamientoPage1State();
}

class _TratamientoPage1State extends State<TratamientoPage1> {
  TextEditingController brazoIzqController = TextEditingController();
  TextEditingController brazoDchaController = TextEditingController();
  TextEditingController pechoController = TextEditingController();
  TextEditingController abdomenController = TextEditingController();
  TextEditingController cinturaController = TextEditingController();
  TextEditingController flancosController = TextEditingController();
  TextEditingController cuadrilController = TextEditingController();
  TextEditingController gluteosController = TextEditingController();
  TextEditingController musloIzqController = TextEditingController();
  TextEditingController musloDchoController = TextEditingController();
  TextEditingController pantorrillaIzqController = TextEditingController();
  TextEditingController pantorrillaDchaController = TextEditingController();

  Medidas medidas = Medidas.empty();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: AppTheme.mainSize,
            height: AppTheme.mainSize,
            color: Colors.amber,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              width: AppTheme.mainSize,
              child: Form(
                  child: Column(
                children: [
                  rowForm("Brazo Izquierdo", brazoIzqController,
                      "Brazo Derecho", brazoDchaController),
                  rowForm(
                      "Pecho", pechoController, "Abdomen", abdomenController),
                  rowForm("Cintura", cinturaController, "Flancos",
                      flancosController),
                  rowForm("Cuadril", cuadrilController, "Gluteos",
                      gluteosController),
                  rowForm("Muslo Izquierdo", musloIzqController,
                      "Muslo Derecho", musloDchoController),
                  rowForm("Pantorrilla Izquierdo", pantorrillaIzqController,
                      "Pantorrilla Derecho", pantorrillaDchaController),
                ],
              ))),
          SizedBox(
            height: 20,
          ),
          PrimaryButton(text: "Guardar", onPressed: () {})
        ]),
      ),
    );
  }

  Widget rowForm(String titulo1, TextEditingController controller1,
      String titulo2, TextEditingController controller2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        textInput2(
            labelText: titulo1,
            controller: controller1,
            horizontal: AppTheme.mainSize / 2.1),
        textInput2(
            labelText: titulo2,
            controller: controller2,
            horizontal: AppTheme.mainSize / 2.1),
      ],
    );
  }
}
