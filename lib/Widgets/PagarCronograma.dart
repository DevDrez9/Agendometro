import 'package:agendometro/Models/DtoSchedules.dart';
import 'package:agendometro/Theme/AppTextStyle.dart';
import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Widgets/BotonSeccion.dart';
import 'package:agendometro/Widgets/TextInput2.dart';
import 'package:flutter/material.dart';

showFullScreenCronogramaAccion(
    BuildContext context,
    String servicio,
    String especialista,
    String cliente,
    String total,
    CustomerServiceRequest customer) {
  TextEditingController montoPagoController = TextEditingController();
  final _formKeyPago = GlobalKey<FormState>();

  int sesiones = customer.sessions;

  List<Cuota> listaCuotas = [];
  for (var sesion in customer.dtoSchedules) {
    listaCuotas.add(
        Cuota(fecha: sesion.scheduleStartTime, montoCuota: 0, pagado: false));
  }
  listaCuotas[0].montoCuota = customer.pagos[0].monto;
  listaCuotas[0].pagado = true;

  bool estado = false;

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
                        "Cronograma de Pago",
                        style: AppTextStyles.title,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: 250,
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
                            ])),
                    Form(
                        key: _formKeyPago,
                        child: Container(
                            width: 250,
                            child: Column(
                              children: List.generate(sesiones, (index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Sesion ${index + 1}"),
                                    index == 0
                                        ? textInput2(
                                            enabled: false,
                                            labelText: customer.pagos[0].monto
                                                .toString(),
                                            icon: Icons.attach_money_outlined,
                                            horizontal: 100,
                                            isNumberOnly: true,
                                            onChanged: (value) {
                                              listaCuotas[index].montoCuota =
                                                  double.parse(value);
                                            })
                                        : textInput2(
                                            labelText: "Monto a pagar",
                                            icon: Icons.attach_money_outlined,
                                            horizontal: 100,
                                            isNumberOnly: true,
                                            onChanged: (value) {
                                              listaCuotas[index].montoCuota =
                                                  double.parse(value);
                                            })
                                  ],
                                );
                              }),
                            )))
                  ],
                ),
                /* Container(
                    width: 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Saldo",
                          style: AppTextStyles.subtitleDark,
                        ),
                        Text(
                          "$total Bs",
                          style: AppTextStyles.subtitleDark,
                        )
                      ],
                    )),*/
                estado == false
                    ? Container()
                    : Container(
                        width: 250,
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(50, 230, 57, 71),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Text(
                          "Debe completar a $total",
                          style: TextStyle(color: AppThemeColors.error),
                        ),
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
                            double precio = customer.price;
                            double total = 0;

                            for (var cuota in listaCuotas) {
                              total = total + cuota.montoCuota;
                            }
                            if (precio == total) {
                              print("Servicio");
                            } else {
                              print("Falta $precio $total");
                              estado != estado;
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
