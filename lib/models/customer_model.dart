class CustomerModel {
  // String? uid;
  String? cid;
  String? customer;
  String? location;
  String? img;
  CustomerModel({
    // this.uid,
    this.cid,
    this.customer,
    this.location,
    this.img,
  });

  //retrieve data from server
  factory CustomerModel.fromMap(map) {
    return CustomerModel(
      // uid: map['uid'],
      cid: map['cid'],
      customer: map['name'],
      location: map['location'],
      img: map['image url'],
    );
  }
//send data to server
  Map<String, dynamic> toMap() {
    return {
      // 'uid': uid,
      'cid': cid,
      'name': customer,
      'location': location,
      'image url': img,
    };
  }
}
