import 'package:agendometro/Models/DtoSchedules.dart';
import 'package:agendometro/Theme/AppTextStyle.dart';
import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Widgets/BotonSeccion.dart';
import 'package:agendometro/Widgets/TextInput2.dart';
import 'package:flutter/material.dart';

showFullScreenPagarAccion(BuildContext context, String servicio,
    String especialista, String cliente, String total, int tipoAccion) {
  TextEditingController montoPagoController = TextEditingController();
  final _formKeyPago = GlobalKey<FormState>();

  return showDialog(
    context: context,
    barrierDismissible: true, // Evita que se cierre al tocar fuera
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: Container(
          width: 350,
          height: 500,
          decoration: BoxDecoration(
              color: Colors.white, // Fondo de la pantalla
              borderRadius: BorderRadius.circular(12)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "Realizar Pago",
                        style: AppTextStyles.title,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: 280,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                servicio,
                                style: AppTextStyles.subtitleDark,
                              ),
                              Text(
                                cliente,
                                style: AppTextStyles.bodyDark,
                              ),
                              Text(
                                especialista,
                                style: AppTextStyles.bodyDark,
                              ),
                              Text(
                                "Fecha",
                                style: AppTextStyles.captionDark,
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ])),
                    Container(
                        width: 200,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Costo Total",
                                    style: AppTextStyles.subtitleDark,
                                  ),
                                  Text(
                                    "$total Bs",
                                    style: AppTextStyles.subtitleDark,
                                  )
                                ],
                              ),
                              tipoAccion == 0
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "fecha Pagado",
                                          style: AppTextStyles.bodyDark,
                                        ),
                                        Text(
                                          "10Bs",
                                          style: AppTextStyles.bodyDark,
                                        )
                                      ],
                                    ),
                              Container(
                                width: 200,
                                height: 2,
                                color: Colors.black,
                                margin: EdgeInsets.symmetric(vertical: 10),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Saldo",
                                    style: AppTextStyles.subtitleDark,
                                  ),
                                  Text(
                                    tipoAccion == 0 ? "$total Bs" : "10Bs",
                                    style: AppTextStyles.subtitleDark,
                                  )
                                ],
                              ),
                            ])),
                    Form(
                        key: _formKeyPago,
                        child: Container(
                          width: 200,
                          child: Column(
                            children: [
                              textInput2(
                                  controller: montoPagoController,
                                  labelText: "Monto a pagar",
                                  icon: Icons.attach_money_outlined,
                                  horizontal: 180,
                                  isNumberOnly: true)
                            ],
                          ),
                        ))
                  ],
                ),
                Container(
                    width: 350,
                    margin: EdgeInsets.only(bottom: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        BotonSeccion(
                          onPressed: () {
                            Navigator.pop(context,
                                Pago(fecha: "", monto: 0, formaPagos: []));
                          },
                          color: AppThemeColors.error,
                          text: "Cancelar",
                        ),
                        BotonSeccion(
                          onPressed: () {
                            if (_formKeyPago.currentState!.validate()) {
                              Navigator.pop(
                                  context,
                                  Pago(
                                      fecha: "",
                                      monto: double.parse(
                                          montoPagoController.text),
                                      formaPagos: []));
                            }
                          },
                          color: AppThemeColors.pago,
                          text: "Continuar",
                        ),
                      ],
                    )),
              ]),
        ),
      );
    },
  );
}
