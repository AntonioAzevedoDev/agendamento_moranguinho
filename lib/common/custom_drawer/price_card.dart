import 'package:agendamento_moranguinho/models/cart_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PriceCard extends StatelessWidget {

  const PriceCard({this.buttonText, this.onPressed});

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final productsPrice = cartManager.productsPrice;
    final deliveryPrice = cartManager.deliveryPrice;
    final totalPrice = cartManager.totalPrice;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Resumo do Agendamento',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Nome'),
                Text(' ${cartManager.user.name}')
              ],
            ),
            const Divider(),
            if(deliveryPrice != null)
              ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Empresa'),
                    Text('${cartManager.address.street}')
                  ],
                ),
                const Divider(),
              ],
            const SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('E-mail',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${cartManager.user.email}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                )
              ],
            ),
            const SizedBox(height: 8,),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              disabledColor: Theme.of(context).primaryColor.withAlpha(100),
              textColor: Colors.white,
              onPressed: onPressed,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}