import 'package:flutter/material.dart';
import 'dart:async';

class DateCard extends StatefulWidget {

  @override
  _DateCard createState() => _DateCard();
}
class _DateCard extends State<DateCard> {
  final controller = new TextEditingController();
  DateTime currentDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      await setState(() {
        currentDate = pickedDate;
        print(currentDate);
      });
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "${currentDate.day.toString()}/${currentDate.month.toString().length < 2 ? "0${currentDate.month.toString()}" : currentDate.month.toString() }/${currentDate.year.toString()}",
          textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[700]),
        ),
        leading: Icon(Icons.date_range),
        trailing: Icon(Icons.add),
        children:<Widget> [
          Padding(padding: EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () {
                _selectDate(context);
                retornaData();
              } ,
              child: Text('Selecione a data da entrega',
                  style:TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold)),
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
  String retornaData(){
    return currentDate.toString();
  }
}