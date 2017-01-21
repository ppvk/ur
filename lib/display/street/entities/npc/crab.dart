part of ur.render;

class Crab extends NPC {
  Crab(String name) : super(name);
  load() async {
    await animation.loadFromPath('npc/npc_crab');
    await super.load();
    animation.set('idle0');
  }
}
