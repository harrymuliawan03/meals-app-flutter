import 'dart:convert';

class ResponseLogin {
  final bool valid;
  final String? role;
  final String? name;

  ResponseLogin({required this.valid, this.role, this.name});
}
