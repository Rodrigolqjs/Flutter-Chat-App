import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/models/users_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsersService {
  Future<List<User>> getUsers() async {
    try {
      final token = await AuthService.getToken();
      final url = '${Environment.apiUrl}/users';
      final resp = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      });
      final mappedResp = UsersResponse.fromJson(resp.body);

      return mappedResp.users;
    } catch (err) {
      print(err);
      return [];
    }
  }
}
