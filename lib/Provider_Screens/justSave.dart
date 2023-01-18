  /*void _initTimer() async {
    var ref = FirebaseDatabase.instance.ref('countdowns');

    Map<String, dynamic> valuMap = {
      'startAt': ServerValue.timestamp,
      'seconds': 20,
    };

    await ref.set(valuMap);

    await FirebaseDatabase.instance
        .ref('.info/serverTimeOffset')
        .onValue
        .listen((event) {
      serverTimeOffset = event.snapshot.value;
    });

    ref.onValue.listen((event) {
      seconds = event.snapshot.child('seconds').value;
      startAt = event.snapshot.child('startAt').value;
      print('*********************************************************');
      print("Seconds: $seconds");
      print("Satrt At: $startAt");
      print("Server Offset : $serverTimeOffset");
      print("************************************************************");
      const hundredMillis = Duration(milliseconds: 100);
      Timer interval = Timer(hundredMillis, () {
        var timeleft = (seconds * 1000) -
            (DateTime.now().subtract(startAt - serverTimeOffset))
                .millisecondsSinceEpoch;
        if (timeleft < 0) {
          //cancel timer
          print('0.0 remaingng');
        } else {
          timerAsString =
              " ${(timeleft / 1000).floor()} : ${(timeleft % 1000)} ";
          print('$timerAsString');
        }
      });
    });
  }*/

