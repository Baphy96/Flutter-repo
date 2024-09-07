import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../modelos/item_comida.dart';
import '../servicios/servicio_comida.dart';

class PantallaEditarComida extends StatefulWidget {
  final ItemComida itemComida;
  final ServicioComida servicioComida; 

  PantallaEditarComida({required this.itemComida, required this.servicioComida});

  @override
  _PantallaEditarComidaState createState() => _PantallaEditarComidaState();
}

class _PantallaEditarComidaState extends State<PantallaEditarComida> {
  final _formKey = GlobalKey<FormState>();
  late String _nombre;
  late String _descripcion;
  late double _precio;

  @override
  void initState() {
    super.initState();
    _nombre = widget.itemComida.nombre;
    _descripcion = widget.itemComida.descripcion;
    _precio = widget.itemComida.precio;
  }

  @override
  Widget build(BuildContext context) {
    final formatoMoneda = NumberFormat.simpleCurrency(name: 'CLP');

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Menú'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _nombre,
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
                initialValue: _descripcion,
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
               initialValue: formatoMoneda.format(_precio),
                decoration: InputDecoration(
                  labelText: 'Precio',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un precio';
                  }
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
                    final itemComidaActualizado = ItemComida(
                      id: widget.itemComida.id,
                      nombre: _nombre,
                      descripcion: _descripcion,
                      precio: _precio,
                    );
                    widget.servicioComida.actualizarItemComida(itemComidaActualizado);
                    Navigator.pop(context);
                  }
                },
                child: Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
