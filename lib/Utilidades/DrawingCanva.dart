import 'dart:convert';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DrawingCanvas extends StatefulWidget {
  @override
  _DrawingCanvasState createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<Offset> points = []; // Puntos para dibujar
  Color selectedColor = Colors.black; // Color seleccionado
  double strokeWidth = 4.0; // Grosor del trazo
  GlobalKey globalKey = GlobalKey(); // Clave para capturar el canvas

  // Función para eliminar la última línea
  void _eliminarUltimaLinea() {
    setState(() {
      if (points.isNotEmpty) {
        // Encuentra el último Offset.infinite
        int lastInfiniteIndex = points.lastIndexOf(Offset.infinite);
        if (lastInfiniteIndex != -1) {
          // Elimina todos los puntos desde el último Offset.infinite hasta el final
          points.removeRange(lastInfiniteIndex, points.length);
        } else {
          // Si no hay Offset.infinite, elimina todos los puntos
          points.clear();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Canvas para dibujar
        RepaintBoundary(
          key: globalKey,
          child: Container(
            width: 300,
            height: 500,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  points.add(details.localPosition);
                });
              },
              onPanEnd: (details) {
                setState(() {
                  points.add(Offset.infinite); // Marca el final de un trazo
                });
              },
              child: CustomPaint(
                painter: DrawingPainter(points, selectedColor, strokeWidth),
              ),
            ),
          ),
        ),
        // Selector de color
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorPickerButton(Colors.black, selectedColor, (color) {
              setState(() {
                selectedColor = color;
              });
            }),
            ColorPickerButton(Colors.red, selectedColor, (color) {
              setState(() {
                selectedColor = color;
              });
            }),
            ColorPickerButton(Colors.blue, selectedColor, (color) {
              setState(() {
                selectedColor = color;
              });
            }),
            ColorPickerButton(Colors.green, selectedColor, (color) {
              setState(() {
                selectedColor = color;
              });
            }),
          ],
        ),
        // Botón para eliminar la última línea
        ElevatedButton(
          onPressed: _eliminarUltimaLinea,
          child: Text("Eliminar última línea"),
        ),
        // Botón para exportar a base64
        ElevatedButton(
          onPressed: _exportCanvasToBase64,
          child: Text("Exportar a Base64"),
        ),
      ],
    );
  }

  // Exportar el canvas a base64
  Future<void> _exportCanvasToBase64() async {
    try {
      // Captura el canvas como una imagen
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Convierte la imagen a base64
      String base64Image = base64Encode(pngBytes);
      print("Imagen en Base64: $base64Image");

      // Muestra un diálogo con el resultado
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Imagen en Base64"),
            content: SelectableText(base64Image),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cerrar"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error al exportar el canvas: $e");
    }
  }
}

// Pintor personalizado para dibujar en el canvas
class DrawingPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  DrawingPainter(this.points, this.color, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Botón para seleccionar colores
class ColorPickerButton extends StatelessWidget {
  final Color color;
  final Color selectedColor;
  final Function(Color) onColorSelected;

  ColorPickerButton(this.color, this.selectedColor, this.onColorSelected);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onColorSelected(color);
      },
      child: Container(
        margin: EdgeInsets.all(8),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: selectedColor == color ? Colors.black : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
