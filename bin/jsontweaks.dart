import 'dart:io';
import 'dart:convert';

main() async {
  String animal = 'trant_fruit';
  int frameHeight = 8;
  int frameWidth = 3;
  String name = '4';

  File json = new File('lib/assets/trant/$animal/$animal.json');
  if (json.existsSync()) {
    String jsontext = await json.readAsString();
    List animations = JSON.decode(jsontext);

    for (Map anim in animations) {
      if (anim['name'] == name) {
        anim['frame'] = {
          'width': frameWidth,
          'height': frameHeight
        };
      }
    }

    animations.sort((Map a, Map b) => a['name'].compareTo(b['name']) );


    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String result = encoder.convert(animations);
    await json.delete();
    await json.create();
    json.writeAsString(result);
  }
}
