import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../servicios/servicio_comida.dart';
import 'pantalla_detalle_comida.dart';
import 'pantalla_agregar_comida.dart';
import 'pantalla_editar_comida.dart';  
import '../modelos/item_comida.dart';
import 'pantalla_menu.dart';

class PantallaInicio extends StatefulWidget {
  @override
  _PantallaInicioState createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  late Future<List<ItemComida>> _futureItems;
  final ServicioComida _servicioComida = ServicioComida();

  @override
  void initState() {
    super.initState();
    _refrescarLista();
  }

  Future<void> _refrescarLista() async {
    setState(() {
      _futureItems = _servicioComida.obtenerItemsComida();
    });
  }

  Future<void> _eliminarItem(ItemComida item) async {
    final resultado = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Producto'),
        content: Text('¿Estás seguro de que deseas eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );

    if (resultado == true) {
      try {
        await _servicioComida.eliminarItemComida(item.id);
        // Actualiza la lista después de eliminar
        setState(() {
          _futureItems = _servicioComida.obtenerItemsComida();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto eliminado con éxito')),
        );
      } catch (e) {
        // Maneja el error si ocurre
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el producto')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PantallaAgregarComida(servicioComida: _servicioComida),
                ),
              ).then((_) => _refrescarLista());
            },
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PantallaMenu(servicioComida: _servicioComida),
                ),
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
                // Formatear el precio con separadores de miles y sin decimales
                final formatoPrecio = NumberFormat('#,###', 'es_CL').format(item.precio.toInt());
                final precioConSimbolo = '\$' + formatoPrecio;

                return ListTile(
                  title: Text(item.nombre),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(precioConSimbolo), // Muestra el precio con el símbolo delante
                      Text(item.descripcion), // Muestra la descripción del producto
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PantallaEditarComida(
                                itemComida: item,
                                servicioComida: _servicioComida,
                              ),
                            ),
                          ).then((_) => _refrescarLista());
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _eliminarItem(item); // Llama al método de eliminación
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PantallaDetalleComida(
                          itemComida: item,
                          servicioComida: _servicioComida,
                        ),
                      ),
                    ).then((_) => _refrescarLista());
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}












