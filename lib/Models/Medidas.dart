class Medidas {
  String fecha;
  int brazoIzq;
  int brazoDcha;
  int pecho;
  int abdomen;
  int cintura;
  int flancos;
  int cuadril;
  int gluteos;
  int musloIzq;
  int musloDcho;
  int pantorrillaIzq;
  int pantorrillaDcha;
  Medidas(
      {required this.fecha,
      required this.brazoIzq,
      required this.brazoDcha,
      required this.pecho,
      required this.abdomen,
      required this.cintura,
      required this.flancos,
      required this.cuadril,
      required this.gluteos,
      required this.musloIzq,
      required this.musloDcho,
      required this.pantorrillaIzq,
      required this.pantorrillaDcha});
  Medidas.empty()
      : fecha = "",
        brazoIzq = 0,
        brazoDcha = 0,
        pecho = 0,
        abdomen = 0,
        cintura = 0,
        flancos = 0,
        cuadril = 0,
        gluteos = 0,
        musloIzq = 0,
        musloDcho = 0,
        pantorrillaIzq = 0,
        pantorrillaDcha = 0;
}
