import 'package:agendamento_moranguinho/models/admin_orders_manager.dart';
import 'package:agendamento_moranguinho/models/admin_users_manager.dart';
import 'package:agendamento_moranguinho/models/cart_manager.dart';
import 'package:agendamento_moranguinho/models/home_manager.dart';
import 'package:agendamento_moranguinho/models/order.dart';
import 'package:agendamento_moranguinho/models/orders_manager.dart';
import 'package:agendamento_moranguinho/models/product.dart';
import 'package:agendamento_moranguinho/models/product_manager.dart';
import 'package:agendamento_moranguinho/models/stores_manager.dart';
import 'package:agendamento_moranguinho/models/user_manager.dart';
import 'package:agendamento_moranguinho/screens/address/address_screen.dart';
import 'package:agendamento_moranguinho/screens/base/base_screen.dart';
import 'package:agendamento_moranguinho/screens/cart/cart_screen.dart';
import 'package:agendamento_moranguinho/screens/checkout/checkout_screen.dart';
import 'package:agendamento_moranguinho/screens/confirmation/confirmation_screen.dart';
import 'package:agendamento_moranguinho/screens/edit_product/edit_product_screen.dart';
import 'package:agendamento_moranguinho/screens/login/login_screen.dart';
import 'package:agendamento_moranguinho/screens/product/product_screen.dart';
import 'package:agendamento_moranguinho/screens/select_product/select_product_screen.dart';
import 'package:agendamento_moranguinho/screens/signup/signup_screen.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => StoresManager(),
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
          cartManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) =>
          ordersManager..updateUser(userManager.user),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
          adminUsersManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, adminOrdersManager) =>
          adminOrdersManager..updateAdmin(
              adminEnabled: userManager.adminEnabled
          ),
        )
      ],
      child: MaterialApp(
        title: 'Agendamentos Moranguinho',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 180, 47,38),
          scaffoldBackgroundColor: const Color.fromARGB(255, 180, 47,38),
          appBarTheme: const AppBarTheme(
              elevation: 0
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: (settings){
          switch(settings.name){
            case '/login':
              return MaterialPageRoute(
                  builder: (_) => LoginScreen()
              );
            case '/signup':
              return MaterialPageRoute(
                  builder: (_) => SignUpScreen()
              );
            case '/product':
              return MaterialPageRoute(
                  builder: (_) => ProductScreen(
                      settings.arguments as Product
                  )
              );
            case '/cart':
              return MaterialPageRoute(
                  builder: (_) => CartScreen(),
                  settings: settings
              );
            case '/address':
              return MaterialPageRoute(
                  builder: (_) => AddressScreen()
              );
            case '/checkout':
              return MaterialPageRoute(
                  builder: (_) => CheckoutScreen()
              );
            case '/edit_product':
              return MaterialPageRoute(
                  builder: (_) => EditProductScreen(
                      settings.arguments as Product
                  )
              );
            case '/select_product':

              return MaterialPageRoute(
                  builder: (_) => SelectProductScreen()
              );
            case '/confirmation':
              return MaterialPageRoute(
                  builder: (_) => ConfirmationScreen(
                      settings.arguments as Order
                  )
              );
            case '/':
            default:
              return MaterialPageRoute(
                  builder: (_) => BaseScreen(),
                  settings: settings
              );
          }
        },
      ),
    );
  }
}