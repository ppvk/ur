part of ur.render;

class Bureaucrat extends NPC {
  Bureaucrat(String name) : super(name);
  load() async {
    await animation.loadFromPath('npc/npc_bureaucrat');
    await super.load();
    animation.set('idle0');
  }
}
