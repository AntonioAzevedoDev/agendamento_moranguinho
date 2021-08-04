class ItemSize {

  ItemSize({this.name, this.price, this.stock,this.data});

  ItemSize.fromMap(Map<String, dynamic> map){
    name = map['name'] as String;
    price = map['price'] as num;
    stock = map['stock'] as int;
    data = map['data'] as String;
  }

  String name;
  num price;
  int stock;
  String data;

  bool get hasStock => stock > 0;

  ItemSize clone(){
    return ItemSize(
      name: name,
      price: price,
      stock: stock,
      data: data
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'price': price,
      'stock': stock,
      'data': data
    };
  }

  @override
  String toString() {
    return 'ItemSize{name: $name, price: $price, stock: $stock, data: $data}';
  }
}