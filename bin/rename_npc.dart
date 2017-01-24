import 'dart:io';


main() async {
  Directory npcDirectory = new Directory('web/images/npc');

  npcDirectory.list(recursive: true).listen((FileSystemEntity fse) {
    if (fse is File)
      fse.rename(fse.path.replaceAll('npc_', ''));
  });



}
