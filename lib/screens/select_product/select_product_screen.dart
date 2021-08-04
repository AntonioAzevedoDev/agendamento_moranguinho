import 'package:agendamento_moranguinho/models/product_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vincular Loja'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Consumer<ProductManager>(
        builder: (_, productManager, __){
          return ListView.builder(
            itemCount: productManager.allProducts.length,
            itemBuilder: (_, index){
              final product = productManager.allProducts[index];
              return ListTile(
                leading: Image.network(product.images.first),
                title: Text(product.name),
                subtitle: Text('Loja ${product.loja}'),
                onTap: (){
                  Navigator.of(context).pop(product);
                },
              );
            },
          );
        },
      ),
    );
  }
}