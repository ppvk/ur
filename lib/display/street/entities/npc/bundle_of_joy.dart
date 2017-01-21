part of ur.render;

class BundleOfJoy extends NPC {
  BundleOfJoy(String name) : super(name);
  load() async {
    await animation.loadFromPath('npc/npc_bundle_of_joy');
    await super.load();
    animation.set('idle_stand');
  }
}
