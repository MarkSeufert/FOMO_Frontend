import 'package:meta/meta.dart' show required;

enum SignInType {
  GOOGLE,
  ANONYMOUS,
  UNKNOWN,
}

class User {
  const User({
    this.id,
    @required this.name,
    this.email = '',
    this.signInType,
    this.photoUrl = '',
  });

  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final SignInType signInType;

  factory User.fromJson(Map<String, dynamic> json, {SignInType signInType}) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      signInType: signInType ?? SignInType.UNKNOWN,
    );
  }
}
