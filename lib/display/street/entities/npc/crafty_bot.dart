part of ur.render;

class CraftyBot extends NPC {
  CraftyBot(String name) : super(name);
  load() async {
    await animation.loadFromPath('npc/npc_crafty_bot');
    await super.load();
    animation.set('sleepMode');
  }
}
