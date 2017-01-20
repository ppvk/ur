part of ur.render;

class Batterfly extends NPC {
  Batterfly(String name) : super(name);
  load() async {
    await animation.loadFromPath('npc/npc_batterfly');
    await super.load();
  }
}
