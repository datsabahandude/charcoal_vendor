class Customer {
  String? cid;
  String? customer;
  String? location;
  String? img;
  Customer();
  Customer.fromSnapshot(snapshot)
      : cid = snapshot.data()['cid'],
        customer = snapshot.data()['name'],
        location = snapshot.data()['location'],
        img = snapshot.data()['image url'];
}
