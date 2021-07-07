class UserModel {
  String uId;
  String name;
  String email;
  String phone;
  bool isEmailVerified;
  String image;
  String cover;
  String bio;

  UserModel({
    this.uId,
    this.name,
    this.email,
    this.phone,
    this.isEmailVerified,
    this.image,
    this.cover,
    this.bio,
  });

  //named constructor
  UserModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    isEmailVerified = json['isEmailVerified'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'name': name,
      'email': email,
      'phone': phone,
      'isEmailVerified': isEmailVerified,
      'image': image,
      'cover': cover,
      'bio': bio,
    };
  }
}
