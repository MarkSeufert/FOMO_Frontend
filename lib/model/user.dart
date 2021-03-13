import 'package:meta/meta.dart' show required;

enum SignInType {
  GOOGLE,
  ANONYMOUS,
}

class User {
  const User({
    @required this.name,
    @required this.signInType,
    this.email = '',
    this.photoUrl = '',
  });

  final String name;
  final String email;
  final String photoUrl;
  final SignInType signInType;
}
