import 'package:firebase_auth/firebase_auth.dart';
import 'package:refd_app/DataModel/Consumer.dart';
import 'package:refd_app/DataModel/DB_Service.dart';

class LoggedConsumer {
  //firebase variables

  Database _db = Database();
  Consumer? _consumerObject;
  User? _currentUser;
  String? _userEmail;

  //user info
  var _consname, _consphoneNumber;

//get the user that is logged in
  void _getCurrentUserInfo() {
    _currentUser = FirebaseAuth.instance.currentUser;
    _userEmail = _currentUser!.email!.toString();
    print('Emaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaail');
    print(_userEmail);
  }

  String getEmailOnly() {
    _getCurrentUserInfo();
    return _userEmail!;
  }

//get current consumer info (email, name, phone number)
  Future<Consumer?> buildConsumer() async {
    _getCurrentUserInfo();
    if (_currentUser != null) {
      Database db = Database();
      _consumerObject = Consumer.fromDocumentSnapshot(
          await db.searchForConsumer(_userEmail!));
      return _consumerObject!;
    } else {
      return null;
    }
  }
}
