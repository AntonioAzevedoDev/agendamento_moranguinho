import 'package:agendamento_moranguinho/models/product.dart';
import 'package:agendamento_moranguinho/models/user.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:agendamento_moranguinho/models/cart_manager.dart';
import 'package:agendamento_moranguinho/models/user_manager.dart';
import 'package:agendamento_moranguinho/screens/product/components/size_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
String data;
  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final controller = new TextEditingController();
  DateTime currentDate = DateTime.now();
  String dataFormatada;
  final Product product;
  String size;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.name),
          centerTitle: true,
          actions: <Widget>[
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnabled && !product.deleted) {
                  return IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                          '/edit_product',
                          arguments: product);
                    },
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: product.images.map((url) {
                  return NetworkImage(url);
                }).toList(),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Informações',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    'Loja ${product.loja}',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: ExpansionTile(
                      title: Text(
                        "${currentDate.day.toString().length < 2 ? "0${currentDate.day.toString()}" : currentDate.day.toString()}/${currentDate.month.toString().length < 2 ? "0${currentDate.month.toString()}" : currentDate.month.toString()}/${currentDate.year.toString()}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700]),
                      ),
                      leading: Icon(Icons.date_range),
                      trailing: Icon(Icons.add),
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: RaisedButton(
                            onPressed: () {
                              selectDate(context);
                            },
                            child: Text('Selecione a data da entrega',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                  if (product.deleted)
                    Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Text(
                          'Este horário não está mais disponível',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.red),
                        ))
                  else ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Horários',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: product.sizes.map((s) {
                        return SizeWidget(size: s);
                      }).toList(),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (product.hasStock)
                    Consumer2<UserManager, Product>(
                      builder: (_, userManager, product, __) {
                        return SizedBox(
                          height: 44,
                          child: RaisedButton(
                            onPressed: product.selectedSize != null
                                ? () {
                                    if (userManager.isLoggedIn) {
                                      CartManager cart = CartManager();
                                      product.dataAgenda = dataFormatada;
                                      context
                                          .read<CartManager>()
                                          .addToCart(product);

                                      Navigator.of(context).pushNamed('/cart');
                                    } else {
                                      Navigator.of(context).pushNamed('/login');
                                    }
                                  }
                                : null,
                            color: primaryColor,
                            textColor: Colors.white,
                            child: Text(
                              userManager.isLoggedIn
                                  ? 'Adicionar aos Agendamentos'
                                  : 'Entre para Agendar',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      await setState(() {
        currentDate = pickedDate;
        dataFormatada = DateFormat('dd/MM/yyyy').format(currentDate);
      });
  }
}
