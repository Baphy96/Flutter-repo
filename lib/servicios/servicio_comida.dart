import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/item_comida.dart';

class ServicioComida {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ItemComida>> obtenerItemsComida() async {
    final snapshot = await _db.collection('comidas').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ItemComida(
        id: doc.id,
        nombre: data['nombre'],
        descripcion: data['descripcion'],
        precio: (data['precio'] as num).toDouble(),
      );
    }).toList();
  }

  Future<void> agregarItemComida(ItemComida itemComida) async {
    await _db.collection('comidas').add({
      'nombre': itemComida.nombre,
      'descripcion': itemComida.descripcion,
      'precio': itemComida.precio,
    });
  }

  Future<void> actualizarItemComida(ItemComida itemComida) async {
    await _db.collection('comidas').doc(itemComida.id).update({
      'nombre': itemComida.nombre,
      'descripcion': itemComida.descripcion,
      'precio': itemComida.precio,
    });
  }

  Future<void> eliminarItemComida(String id) async {
    await _db.collection('comidas').doc(id).delete();
  }
}

