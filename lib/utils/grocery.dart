import 'order.dart';

class Grocery {
  List<Order> _orders;

  Grocery(this._orders);



  List<Order> get orders => _orders;
  int get length => _orders.length;



}