import 'package:flutter/material.dart';
import '../servicios/servicio_comida.dart';
import 'pantalla_inicio.dart';
import 'pantalla_menu.dart';
import '../modelos/item_comida.dart';

class PantallaPrincipal extends StatelessWidget {
  final List<ItemComida> productos;

  PantallaPrincipal({required this.productos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://img.freepik.com/vector-premium/conjunto-ilustracion-comida-rapida-dibujos-animados_530597-17.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Color.fromARGB(107, 255, 147, 59).withOpacity(0.3),
            ),
          ),
          // Contenido principal
          Column(
            children: [
              // Texto "Food Place" centrado en la parte superior
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Text(
                    'Food Place',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Texto "Comida rápida, sabor inolvidable" centrado debajo de "Food Place"
              Center( 
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Comida rápida, sabor inolvidable',
                    textAlign: TextAlign.center, // Asegura el centrado del texto
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900, // Negrita
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              Spacer(), // Empuja los íconos hacia la parte inferior
              // Iconos en la parte inferior
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.add, size: 50, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PantallaInicio(),
                            ),
                          );
                        },
                      ),
                      Text(
                        'Agregar Producto',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 50), // Espacio entre los íconos
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.menu, size: 50, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PantallaMenu(servicioComida: ServicioComida()), // Pasa la lista de productos
                            ),
                          );
                        },
                      ),
                      Text(
                        'Menú',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40), // Espacio entre los íconos y el borde inferior
            ],
          ),
        ],
      ),
    );
  }
}
