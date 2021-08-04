import 'package:agendamento_moranguinho/common/custom_drawer/price_card.dart';
import 'package:agendamento_moranguinho/models/cart_manager.dart';
import 'package:agendamento_moranguinho/screens/address/components/address_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamento'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AddressCard(),
          Consumer<CartManager>(
            builder: (_, cartManager, __){
              return PriceCard(
                buttonText: 'Continuar para o Agendamento',
                onPressed: cartManager.isAddressValid ? (){
                  Navigator.of(context).pushNamed('/checkout');
                } : null,
              );
            },
          ),
        ],
      ),
    );
  }
}