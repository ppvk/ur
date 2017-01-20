import 'dart:io';


main() async {
  Directory npcDirectory = new Directory('web/images/npc');

  npcDirectory.list(recursive: true).listen((FileSystemEntity fse) {
    if (fse is File && fse.path.endsWith('.png')) {
      String oldName = fse.path.split('/').last;
      List segments = oldName.split('_');

      int before = segments.indexOf('x1') + 1;
      int after = segments.indexOf('png');
      if (before == -1 || after == -1) {
        throw(oldName);
      }
      String action = segments.sublist(before, after).join('_');

      String newName = fse.parent.path.split('/').last + '_' + action + '.png';

      fse.rename(fse.parent.path + '/' + newName);
    }
  });



}
