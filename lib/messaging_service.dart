import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:refd_app/DataModel/DB_Service.dart';

class MessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final String userID;
  final bool isProv;
  MessagingService(
      {required this.userID, required this.isProv}); //1 prov 0 cons

  String? _token;
  String? get token => _token;

  Future init() async {
    final settings = await _requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _getToken();
      _registerForegroundMessageHandler();
    }
  }

  Future _getToken() async {
    _token = await _firebaseMessaging.getToken();
    Database db = Database();

    if (isProv) {
      db.updateProviderInfo(userID, false, '', {'token': _token});
    } else {
      db.updateConsumerInfo(userID, {'token': _token});
    }

    print(
        "******************************************************************\n FCM: $_token");

    _firebaseMessaging.onTokenRefresh.listen((token) {
      _token = token;
      if (isProv) {
        db.updateProviderInfo(userID, false, '', {'token': _token});
      } else {
        db.updateConsumerInfo(userID, {'token': _token});
      }
    });
  }

  Future<NotificationSettings> _requestPermission() async {
    return await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        announcement: false);
  }

  void _registerForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      print(" --- foreground message received ---");
      print(remoteMessage.notification!.title);
      print(remoteMessage.notification!.body);
    });
  }
}
