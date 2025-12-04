class AppUser {
  final String uid;
  final String email;
  final String name;
  final String? photo;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    this.photo,
  });

  Map<String, dynamic> toMap() => {
    "uid": uid,
    "email": email,
    "name": name,
    "photo": photo,
  };

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
    uid: map["uid"],
    email: map["email"],
    name: map["name"],
    photo: map["photo"],
  );
}
