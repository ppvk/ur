library ur.meters;

import 'dart:html';
import 'package:intl/intl.dart';

abstract class Meters {
  static NumberFormat _commaFormatter = new NumberFormat("#,###");

  static Element _currantElement = querySelector('#currant-text .current');
  static int _currants = 0;
  static set currants(int amount) {
    _currants = amount;
    _currantElement.text = _commaFormatter.format(amount);
  }

  static get currants => _currants;

  static Element _imgElement = querySelector('#img-text .current');
  static int _img = 0;
  static set img(int amount) {
    _img = amount;
    _imgElement.text = _commaFormatter.format(amount);
  }

  static get img => _img;

  static Element _moodElement = querySelector('#mood-text .fraction .current');
  static int _mood = 100;
  static set mood(int amount) {
    _mood = amount;
    _moodElement.text = _commaFormatter.format(amount);
    _updateMoodDisplay();
  }

  static get mood => _mood;
  static Element _moodMaxElement = querySelector('#mood-text .fraction .max');
  static int _moodMax = 100;
  static set moodMax(int amount) {
    _moodMax = amount;
    _moodMaxElement.text = _commaFormatter.format(amount);
    _updateMoodDisplay();
  }

  static get moodMax => _moodMax;
  static Element _moodPercent = querySelector('#mood-text .percent .number');
  static Element _moodHurtDisk = querySelector('#mood-disk .hurt');
  static _updateMoodDisplay() {
    num percent = ((mood / moodMax) * 100);
    _moodPercent.text = percent.toString();
    _moodHurtDisk.style.opacity = (1 - percent / 100).toString();
  }

  static Element _energyElement = querySelector('#energy-text .current');
  static int _energy = 100;
  static set energy(int amount) {
    _energy = amount;
    _energyElement.text = _commaFormatter.format(amount);
    _updateEnergyDisplay();
  }

  static get energy => _energy;
  static Element _energyMaxElement = querySelector('#energy-text .max');
  static int _energyMax = 100;
  static set energyMax(int amount) {
    _energyMax = amount;
    _energyMaxElement.text = _commaFormatter.format(amount);
    _updateEnergyDisplay();
  }

  static get energyMax => _energyMax;
  static Element _energyHealthDisk = querySelector('#energy-disks .green');
  static Element _energyHurtDisk = querySelector('#energy-disks .red');
  static _updateEnergyDisplay() {
    _energyHurtDisk.style.opacity = (1 - energy / energyMax).toString();
    _energyHealthDisk.style.transform =
        'rotate(${130 - (energy / energyMax) * 130}deg)';
    _energyHurtDisk.style.transform =
        'rotate(${130 - (energy / energyMax) * 130}deg)';
  }
}
