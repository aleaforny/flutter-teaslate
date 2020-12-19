import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_teaslate/flutter_teaslate.dart';

String API_KEY = "type_your_api_key_here";

void main() {
  print("Starting tests unit");

  test('can connect to API', () {
    String goodKey = API_KEY;
    String badKey = "wrong";

    TeaSlate teaslate = TeaSlate(key: badKey, debug: true, ignoreCertErrors: true);
    expect(teaslate.connect().then((bool connected) => expect(connected, false)), completes);

    TeaSlate teaslate_2 = TeaSlate(key: goodKey, debug: true, ignoreCertErrors: true);
    expect(teaslate_2.connect().then((bool connected) => expect(connected, true)), completes);
  });

  test('can retrieve a translation', () {
    String translation = "whatIsYourName";

    TeaSlate teaslate = TeaSlate(key: API_KEY, debug: true, ignoreCertErrors: true);

    expect(teaslate.connect().then((bool connected) {
      if (connected) {
        expect(teaslate.translate(translation, lang:"en"), "What is your name?");
        expect(teaslate.translate(translation, lang:"fr"), "Quel est votre nom ?");
        expect(teaslate.translate(translation, lang:"hu"), "What is your name?", reason: "not found translation returns the first one");
      } else {
        fail("wasn't able to connect API");
      }
    }), completes);
  });

  print("Ending test units");
}
