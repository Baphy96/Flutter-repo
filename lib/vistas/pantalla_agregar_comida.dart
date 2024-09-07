import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../modelos/item_comida.dart';
import '../servicios/servicio_comida.dart';

class PantallaAgregarComida extends StatefulWidget {
  final ServicioComida servicioComida;

  PantallaAgregarComida({required this.servicioComida});

  @override
  _PantallaAgregarComidaState createState() => _PantallaAgregarComidaState();
}

class _PantallaAgregarComidaState extends State<PantallaAgregarComida> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _descripcion = '';
  double _precio = 0.0;

  @override
  Widget build(BuildContext context) {
    final formatoMoneda = NumberFormat.simpleCurrency(name: 'CLP');

    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Nuevo Menú'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nombre = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
                onSaved: (value) {
                  _descripcion = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Precio',
                  prefixText: formatoMoneda.currencySymbol, // Agrega símbolo de moneda
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un precio';
                  }
                  // Verifica si el valor ingresado es un número válido
                  if (double.tryParse(value.replaceAll(RegExp(r'[^\d.]'), '')) == null) {
                    return 'Por favor ingresa un precio válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _precio = double.tryParse(value?.replaceAll(RegExp(r'[^\d.]'), '') ?? '') ?? 0.0;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    final nuevoItemComida = ItemComida(
                      id: DateTime.now().toString(), // Genera un ID temporal
                      nombre: _nombre,
                      descripcion: _descripcion,
                      precio: _precio,
                    );
                    widget.servicioComida.agregarItemComida(nuevoItemComida);
                    Navigator.pop(context);
                  }
                },
                child: Text('Agregar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


