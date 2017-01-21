part of ur.render;

class Chicken extends NPC {
  Chicken(String name) : super(name);
  load() async {
    await animation.loadFromPath('npc/npc_chicken');
    await super.load();
    animation.set('pause');
  }
}
