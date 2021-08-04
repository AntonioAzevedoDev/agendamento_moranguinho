import 'package:agendamento_moranguinho/common/custom_drawer/price_card.dart';
import 'package:agendamento_moranguinho/models/cart_manager.dart';
import 'package:agendamento_moranguinho/models/checkout_manager.dart';
import 'package:agendamento_moranguinho/models/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
      checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Agendamento'),
          centerTitle: true,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkoutManager, __){
            if(checkoutManager.loading){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    const SizedBox(height: 16,),
                    Text(
                      'Processando seu agendamento...',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16
                      ),
                    )
                  ],
                ),
              );
            }

            return ListView(
              children: <Widget>[
                PriceCard(
                  buttonText: 'Finalizar Agendamento',
                  onPressed: (){
                    checkoutManager.checkout(
                        onStockFail: (e){
                          Navigator.of(context).popUntil(
                                  (route) => route.settings.name == '/cart');
                        },
                        onSuccess: (order){
                          Navigator.of(context).popUntil(
                                  (route) => route.settings.name == '/');
                          Navigator.of(context).pushNamed(
                              '/confirmation',
                              arguments: order
                          );
                        }
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}