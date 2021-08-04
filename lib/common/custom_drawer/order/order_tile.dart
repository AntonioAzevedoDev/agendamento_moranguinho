import 'package:agendamento_moranguinho/common/custom_drawer/order/cancel_order_dialog.dart';
import 'package:agendamento_moranguinho/common/custom_drawer/order/export_address_dialog.dart';
import 'package:agendamento_moranguinho/models/order.dart';
import 'package:agendamento_moranguinho/models/user.dart';
import 'package:agendamento_moranguinho/screens/cart/components/order_product_tile.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {

  const OrderTile(this.order, {this.showControls = false});

  final Order order;
  final bool showControls;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  order.formattedId,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            Text(
              order.statusText,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: order.status == Status.canceled ?
                  Colors.red : primaryColor,
                  fontSize: 14
              ),
            )

          ],

        ),
        children: <Widget>[
          Column(
            children: order.items.map((e){
              return OrderProductTile(e);
            }).toList(),

          ),

          if(showControls && order.status != Status.canceled)

            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  FlatButton(
                    onPressed: (){
                      showDialog(context: context,
                          builder: (_) => CancelOrderDialog(order)
                      );
                    },
                    textColor: Colors.red,
                    child: const Text('Cancelar'),
                  ),
                  FlatButton(
                    onPressed: order.back,
                    child: const Text('Recuar'),
                  ),
                  FlatButton(
                    onPressed: order.advance,
                    child: const Text('Avançar'),
                  ),
                  FlatButton(
                    onPressed: (){
                      showDialog(context: context,
                          builder: (_) => ExportAddressDialog(order.address,order.product)
                      );
                    },
                    textColor: primaryColor,
                    child: const Text('Informações'),
                  )
                ],
              ),
            ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildCircle("1", "Solicitado", order.status.index, 1),
              Container(
                height: 1.0,
                width: 40.0,
                color: Colors.grey[500],
              ),
              _buildCircle("2", "Agendado", order.status.index, 2),
              Container(
                height: 1.0,
                width: 40.0,
                color: Colors.grey[500],
              ),
              _buildCircle("3", "Entregue", order.status.index, 3),
            ],
          )
        ],
      ),
    );
  }
  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(
        Icons.check,
        color: Colors.white,
      );
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}