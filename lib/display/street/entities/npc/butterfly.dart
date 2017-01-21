part of ur.render;

class Butterfly extends NPC {
  Butterfly(String name) : super(name);
  load() async {
    await animation.loadFromPath('npc/npc_butterfly');
    await super.load();
    animation.set('fly-top');
  }
}
