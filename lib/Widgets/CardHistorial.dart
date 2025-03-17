import 'package:agendometro/Models/PendientesClass.dart';
import 'package:agendometro/Theme/AppTextStyle.dart';
import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:agendometro/Utilidades/GlobalVariables.dart';
import 'package:agendometro/Widgets/BotonSeccion.dart';
import 'package:flutter/material.dart';

Widget cardHistorial(PendientesClass pendientes) {
  int estado = pendientes.progressState;

  //1: pendiente sin progreso, 2: en progreso, 3: finalizado y 4: cancelado
  Color fondo() {
    switch (estado) {
      case 1:
        return AppThemeColors.primary;
      case 2:
        return AppThemeColors.secondary;
      case 3:
        return AppThemeColors.success;
      case 4:
        return AppThemeColors.error;
      default:
        return AppThemeColors.primary;
    }
  }

  return Container(
      width: AppTheme.mainSize,
      height: 150,
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 8),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppThemeColors.backgroundLight,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          width: 220,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              Text(
                GlobalVariables.instance.mainUsuario.persona.nombre,
                style: AppTextStyles.bodyDark,
              ),
              Text(
                pendientes.scheduleStartTime.toString(),
                style: AppTextStyles.captionDark,
              ),
            ],
          ),
        ),
        Container(
          width: 80,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: fondo(),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        )
      ]));
}
