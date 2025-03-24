import 'package:agendometro/Models/PendientesClass.dart';
import 'package:agendometro/Theme/AppTextStyle.dart';
import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:agendometro/Widgets/BotonSeccion.dart';
import 'package:agendometro/Widgets/PagarAccion.dart';
import 'package:flutter/material.dart';

Widget cardCitas(
  PendientesClass pendientes, {
  required Function(PendientesClass) onPressedPago,
  required Function(PendientesClass) onPressedTratamiento,
}) {
  String transformarFecha(String fechaOriginal) {
    // Dividir la fecha y la hora
    var partes = fechaOriginal.split(" ");
    if (partes.length != 2) {
      return fechaOriginal; // Si no tiene el formato esperado, devolver el original
    }

    String fecha = partes[0]; // Parte de la fecha (yyyy-mm-dd)
    String hora = partes[1]; // Parte de la hora (hh:mm:ss:ss)

    // Dividir la fecha en año, mes y día
    var partesFecha = fecha.split("-");
    if (partesFecha.length != 3) {
      return fechaOriginal; // Si no tiene el formato esperado, devolver el original
    }

    String anio = partesFecha[0];
    String mes = partesFecha[1];
    String dia = partesFecha[2];

    // Reorganizar la fecha en el formato dd-mm-yyyy
    String nuevaFecha = "$dia-$mes-$anio";
    String nuevaHora = hora.substring(0, 5);

    // Unir la nueva fecha con la hora
    return "$nuevaFecha $nuevaHora";
  }

  return Container(
      width: AppTheme.mainSize,
      height: 160,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: AppThemeColors.backgroundLight,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: 190,
                height: 140,
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pendientes.service_name,
                          style: AppTextStyles.subtitleDark,
                        ),
                        Text(
                          pendientes.customer_nombre +
                              " " +
                              pendientes.customer_apellido_paterno,
                          style: AppTextStyles.bodyDark,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Sesion ${pendientes.sessions}",
                              style: AppTextStyles.captionDark,
                            ),
                            Text(
                              "${pendientes.price}Bs",
                              style: AppTextStyles.captionDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      transformarFecha(pendientes.scheduleStartTime.toString()),
                      style: AppTextStyles.bodyDark,
                    )
                  ],
                )),
            Container(
              width: 100,
              height: 140,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      width: 100,
                      height: 30,
                      child: BotonSeccion(
                        color: AppThemeColors.primary,
                        text: "Tratamiento",
                        onPressed: () {
                          onPressedTratamiento(pendientes);
                        },
                      )),
                  Container(
                      width: 100,
                      height: 30,
                      child: BotonSeccion(
                        color: AppThemeColors.pago,
                        text: "Pagos",
                        onPressed: () {
                          onPressedPago(pendientes);
                        },
                      )),
                  Container(
                      width: 100,
                      height: 30,
                      child: BotonSeccion(
                        color: AppThemeColors.warning,
                        text: "Modificar",
                        onPressed: () {},
                      )),
                ],
              ),
            ),
          ],
        ),
      ]));
}
