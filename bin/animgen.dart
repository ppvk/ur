import 'dart:io';
import 'dart:convert';


main() async {
  Directory npcDirectory = new Directory('web/images/npc');

  List<Directory> npcs = npcDirectory.listSync();
  for (Directory fse in npcs) {
    String folderName = fse.path.split('/').last;
    String newFilePath = fse.path + '/' + folderName + '.json';
    List<File> anims = fse.listSync();

    List animation = [];

    for (File anim in anims.where((file) => file.path.endsWith('.png'))) {
      String animName = anim.path.split('/').last
        .replaceAll(folderName + '_', '')
        .replaceAll('.png', '');

        animation.add({
          'image': 'images/npc/' + folderName + '/' + anim.path.split('/').last,
          'height': 0,
          'width': 0,
          'animations': {
            animName: {
              'frames': []
            }
          }
        });
    }
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String result = encoder.convert(animation);
    File animFile = new File(newFilePath);
    await animFile.create();
    animFile.writeAsString(result);
  }

}
