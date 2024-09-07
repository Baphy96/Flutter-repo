import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../modelos/item_comida.dart';
import '../servicios/servicio_comida.dart';
import 'pantalla_principal.dart'; 

class PantallaMenu extends StatefulWidget {
  final ServicioComida servicioComida;

  PantallaMenu({required this.servicioComida});

  @override
  _PantallaMenuState createState() => _PantallaMenuState();
}

class _PantallaMenuState extends State<PantallaMenu> {
  late Future<List<ItemComida>> _futureItems;
  final Map<ItemComida, int> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    _refrescarLista();
  }

  Future<void> _refrescarLista() async {
    setState(() {
      _futureItems = widget.servicioComida.obtenerItemsComida();
    });
  }

  int get _cantidadTotalProductos {
    return _selectedItems.values.fold(0, (sum, quantity) => sum + quantity);
  }

  void _mostrarDialogo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmación'),
        content: Text('El producto ha sido agregado exitosamente'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => PantallaPrincipal(
                    productos: _selectedItems.keys.toList(), // Pasa la lista de productos seleccionados
                  ),
                ),
                (route) => false, // Elimina todas las rutas anteriores
              );
            },
            child: Text('Ir a Inicio'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
            },
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart),
                if (_cantidadTotalProductos > 0)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        '$_cantidadTotalProductos',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              // Implementar acción del carrito aquí
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ir al carrito con $_cantidadTotalProductos productos')),
              );
            },
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 248, 191, 171), // Color Fondo de pantalla
      body: FutureBuilder<List<ItemComida>>(
        future: _futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se encontraron elementos de comida'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                final formatoPrecio = NumberFormat('#,###', 'es_CL').format(item.precio.toInt());
                final precioConSimbolo = '\$' + formatoPrecio;

                return ListTile(
                  leading: Icon(Icons.restaurant_menu, color: Colors.orange), 
                  title: Text(item.nombre),
                  subtitle: Text('${item.descripcion}\n$precioConSimbolo'),
                  trailing: SizedBox(
                    width: 150,
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButton<int>(
                            value: _selectedItems.containsKey(item)
                                ? _selectedItems[item]
                                : null,
                            hint: Text('Cantidad'),
                            items: List.generate(
                              10,
                              (index) => DropdownMenuItem(
                                value: index + 1,
                                child: Text('${index + 1}'),
                              ),
                            ),
                            onChanged: (int? value) {
                              setState(() {
                                if (value != null) {
                                  _selectedItems[item] = value;
                                } else {
                                  _selectedItems.remove(item);
                                }
                              });
                            },
                          ),
                        ),
                        Checkbox(
                          value: _selectedItems.containsKey(item),
                          onChanged: (bool? checked) {
                            setState(() {
                              if (checked == true) {
                                _selectedItems[item] = _selectedItems[item] ?? 1;
                              } else {
                                _selectedItems.remove(item);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          // Implementa la lógica para agregar los productos seleccionados
          _mostrarDialogo(context);
          // Aquí puedes añadir lógica para procesar los items seleccionados y sus cantidades
        },
      ),
    );
  }
}
