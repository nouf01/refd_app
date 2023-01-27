import 'package:firebase_auth/firebase_auth.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Provider.dart';

class LoggedProvider {
  //firebase variables

  Database _db = Database();
  Provider? _providerObject;
  User? _currentUser;
  String? _userEmail;

//get the user that is logged in
  void _getCurrentUserInfo() {
    _currentUser = FirebaseAuth.instance.currentUser;
    _userEmail = _currentUser!.email!.toString();
  }

  String getEmailOnly() {
    _getCurrentUserInfo();
    return _userEmail!;
  }

//get current consumer info (email, name, phone number)
  Future<Provider?> buildProvider() async {
    _getCurrentUserInfo();
    if (_currentUser != null) {
      Database db = Database();
      _providerObject = Provider.fromDocumentSnapshot(
          await db.searchForProvider(_userEmail!));
      return _providerObject!;
    } else {
      return null;
    }
  }
}
