import 'package:agendamento_moranguinho/common/custom_drawer/empty_card.dart';
import 'package:agendamento_moranguinho/common/custom_drawer/login_card.dart';
import 'package:agendamento_moranguinho/common/custom_drawer/price_card.dart';
import 'package:agendamento_moranguinho/models/cart_manager.dart';
import 'package:agendamento_moranguinho/screens/cart/components/cart_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamentos'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __){
          if(cartManager.user == null){
            return LoginCard();
          }

          if(cartManager.items.isEmpty){
            return EmptyCard(
              iconData: Icons.event_busy,
              title: 'Nenhuma loja no pedido!',
            );
          }

          return ListView(
            children: <Widget>[
              Column(
                children: cartManager.items.map(
                        (cartProduct) => CartTile(cartProduct)
                ).toList(),
              ),
              PriceCard(
                buttonText: 'Continuar para Agendar',
                onPressed: cartManager.isCartValid ? (){
                  Navigator.of(context).pushNamed('/address');
                } : null,
              ),
            ],
          );
        },
      ),
    );
  }
}