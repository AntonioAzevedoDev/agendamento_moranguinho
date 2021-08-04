import 'package:agendamento_moranguinho/models/address.dart';
import 'package:agendamento_moranguinho/models/cart_manager.dart';
import 'package:agendamento_moranguinho/models/cart_product.dart';
import 'package:agendamento_moranguinho/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
enum Status { canceled, preparing, transporting, delivered, finalizado}

class Order {

  Order.fromCartManager(CartManager cartManager){
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address;
    status = Status.preparing;

  }

  Order.fromDocument(DocumentSnapshot doc){
    orderId = doc.documentID;

    items = (doc.data['items'] as List<dynamic>).map((e){
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();

    price = doc.data['price'] as num;
    userId = doc.data['user'] as String;
    address = Address.fromMap(doc.data['address'] as Map<String, dynamic>);
    date = doc.data['date'] as Timestamp;
    dataAgenda = doc.data['data'] as String;
    status = Status.values[doc.data['status'] as int];
  }

  final Firestore firestore = Firestore.instance;

  DocumentReference get firestoreRef =>
      firestore.collection('orders').document(orderId);

  void updateFromDocument(DocumentSnapshot doc){
    status = Status.values[doc.data['status'] as int];
  }

  Future<void> save() async {
    firestore.collection('orders').document(orderId).setData(
        {
          'items': items.map((e) => e.toOrderItemMap()).toList(),
          'price': price,
          'user': userId,
          'address': address.toMap(),
          'status': status.index,
          'date': Timestamp.now(),
          'data': dataAgenda
        }
    );
  }

  Function() get back {
    return status.index >= Status.transporting.index ?
        (){
      status = Status.values[status.index - 1];
      firestoreRef.updateData({'status': status.index});
    } : null;
  }

  Function() get advance {
    return status.index <= 5 ?
        (){
      status = Status.values[status.index+1];
      firestoreRef.updateData({'status': status.index});
    } : null;
  }

  void cancel(){
    status = Status.canceled;
    firestoreRef.updateData({'status': status.index});
  }

  String orderId;

  List<CartProduct> items;
  num price;

  String userId;
Product product;
  Address address;
String dataAgenda;

  Status status;

  Timestamp date;

  String get formattedId => '#${orderId.padLeft(6, '0')}';
  String get DataAgenda => '#${dataAgenda}';
  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch(status){
      case Status.canceled:
        return 'Cancelado';
      case Status.preparing:
        return 'Em análise';
      case Status.transporting:
        return 'Agendado';
      case Status.delivered:
        return 'Entregue';
      case Status.finalizado:
        return 'Finalizado';
        default:
        return '';
    }
  }

  @override
  String toString() {
    return 'Order{firestore: $firestore, orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date, data: $dataAgenda}';
  }
}