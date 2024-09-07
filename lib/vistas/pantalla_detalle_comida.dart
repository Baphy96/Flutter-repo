import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../modelos/item_comida.dart';
import '../servicios/servicio_comida.dart';
import 'pantalla_editar_comida.dart';

class PantallaDetalleComida extends StatelessWidget {
  final ItemComida itemComida;
  final ServicioComida servicioComida;

  PantallaDetalleComida({super.key, required this.itemComida, required this.servicioComida});

  @override
  Widget build(BuildContext context) {
    final formatoMoneda = NumberFormat.simpleCurrency(name: 'CLP');

    return Scaffold(
      appBar: AppBar(
        title: Text(itemComida.nombre),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PantallaEditarComida(
                    itemComida: itemComida,
                    servicioComida: servicioComida,
                  ),
                ),
              ).then((_) {
                // Volver a cargar la pantalla principal después de editar
                Navigator.pop(context);
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool confirmDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Eliminar'),
                  content: Text('¿Estás seguro de que deseas eliminar este ítem?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Eliminar'),
                    ),
                  ],
                ),
              );

              if (confirmDelete) {
                await servicioComida.eliminarItemComida(itemComida.id);
                Navigator.pop(context); // Volver a la pantalla principal
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              itemComida.nombre,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(itemComida.descripcion),
            SizedBox(height: 10),
            Text(formatoMoneda.format(itemComida.precio)),
          ],
        ),
      ),
    );
  }
}


