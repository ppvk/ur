import 'dart:io';


main() async {
  Directory npcDirectory = new Directory('web/images/npc');

  npcDirectory.list(recursive: true).listen((FileSystemEntity fse) {
    //if (fse.path.contains('street_spirit_firebog') && fse is File)
    //String filename = fse.path.split('/').last;



  });



}
