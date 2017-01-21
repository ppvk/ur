part of ur.render;

class Cactus extends NPC {
  Cactus(String name) : super(name);
  load() async {
    await animation.loadFromPath('npc/npc_cactus');
    await super.load();
    animation.set('idle');
  }
}
