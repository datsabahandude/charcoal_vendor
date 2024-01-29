class OrderList {
  String? cid;
  String? customer;
  String? location;
  String? total;
  OrderList();
  OrderList.fromSnapshot(snapshot)
      : cid = snapshot.data()['cid'],
        customer = snapshot.data()['name'],
        location = snapshot.data()['location'],
        total = snapshot.data()['total'];
}
