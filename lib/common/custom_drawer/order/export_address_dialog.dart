import 'package:agendamento_moranguinho/models/address.dart';
import 'package:agendamento_moranguinho/models/cart_product.dart';
import 'package:agendamento_moranguinho/models/product.dart';
import 'package:agendamento_moranguinho/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

class ExportAddressDialog extends StatelessWidget {

  ExportAddressDialog(this.address,this.product);

  final Address address;
  final Product product;
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pedido de Agendamento'),
      content: Screenshot(
        controller: screenshotController,
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: Text(
            '${address.district}\n${address.number} \n'
            '${address.complement}\n'
                '${address.street}\n'
                '${address.city}/${address.state}\n'
                '${address.zipCode}',
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            Navigator.of(context).pop();
            final file = await screenshotController.capture();
            await GallerySaver.saveImage(file.path);
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Exportar'),
        )
      ],
    );
  }
}