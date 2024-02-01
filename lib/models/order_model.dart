class OrderList {
  String? cid;
  String? img;
  String? customer;
  String? location;
  // String? total;
  String? price;
  String? qty;
  String? status;
  int? time;
  OrderList();
  OrderList.fromSnapshot(snapshot)
      : cid = snapshot.data()['cid'],
        img = snapshot.data()['img'],
        customer = snapshot.data()['name'],
        location = snapshot.data()['location'],
        // total = snapshot.data()['total'],
        price = snapshot.data()['price'],
        qty = snapshot.data()['qty'],
        status = snapshot.data()['status'],
        time = snapshot.data()['time'];
}
