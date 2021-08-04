import 'package:agendamento_moranguinho/common/custom_drawer/custom_drawer.dart';
import 'package:agendamento_moranguinho/common/custom_drawer/empty_card.dart';
import 'package:agendamento_moranguinho/common/custom_drawer/login_card.dart';
import 'package:agendamento_moranguinho/models/orders_manager.dart';
import 'file:///C:/Users/joaoe/AndroidStudioProjects/agendamento_moranguinho/lib/common/custom_drawer/order/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Meus Agendamentos'),
        centerTitle: true,
      ),
      body: Consumer<OrdersManager>(
        builder: (_, ordersManager, __){
          if(ordersManager.user == null){
            return LoginCard();
          }
          if(ordersManager.orders.isEmpty){
            return EmptyCard(
              title: 'Nenhuma loja encontrada!',
              iconData: Icons.border_clear,
            );
          }
          return ListView.builder(
              itemCount: ordersManager.orders.length,
              itemBuilder: (_, index){
                return OrderTile(
                    ordersManager.orders.reversed.toList()[index]
                );
              }
          );
        },
      ),
    );
  }
}