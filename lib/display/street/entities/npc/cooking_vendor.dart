part of ur.render;

class CookingVendor extends NPC {
  CookingVendor(String name) : super(name);
  load() async {
    await animation.loadFromPath('npc/npc_cooking_vendor');
    await super.load();
    animation.set('idle_stand_part2');
  }
}
