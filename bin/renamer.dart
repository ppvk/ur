import 'dart:io';


main() async {
  Directory assets = new Directory('lib/assets/trant');

  for (FileSystemEntity fse in assets.listSync(recursive: true)) {
    Directory trantDir = fse;

    if (fse.path.contains('kitty_chicken')) {
      print(fse.path);

      String newPath = fse.path.replaceAll('_chicken', '');
      print(newPath);
      fse.renameSync(newPath);
    }
  }
}
