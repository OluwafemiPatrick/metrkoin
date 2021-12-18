
import 'package:metrkoin/models/profile_info.dart';

// Future<ProfileInfo> loginAndFetchUserData(String username, password) async {
//   final response = await http.get(Uri.parse("https://instanalyticapp.herokuapp.com/login?name=$username&pass=Password123\$"));
//
//   if (response.statusCode == 200) {
//     print ("DATA FETCHED SUCCESSFULLY: " + response.body);
//     setState(() {
//       _isLoading = false;
//       _isDataPresent = true;
//     });
//     prefs.setString('ig_username', username);
//     prefs.setString('ig_password', password);
//     return UserInfo.fromJson(jsonDecode(response.body));
//   }
//   else {
//     throw Exception('failed to load data from api');
//   }
// }
