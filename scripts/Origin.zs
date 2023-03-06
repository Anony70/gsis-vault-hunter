import crafttweaker.api.entity.type.player.Player;
import crafttweaker.api.item.ItemCooldowns;
import crafttweaker.api.events.CTEventManager;
import crafttweaker.api.event.entity.player.interact.RightClickItemEvent;

CTEventManager.register<crafttweaker.api.event.entity.player.interact.RightClickItemEvent>((event) => {
    // One day CD 86400*20
    event.player.getCooldowns().addCooldown(<item:origins:orb_of_origin>, 1728000);
});


craftingTable.addShaped("orb_of_origin", <item:origins:orb_of_origin>, [
    [<item:minecraft:air>, <item:minecraft:diamond>, <item:minecraft:air>], 
    [<item:minecraft:diamond>, <item:the_vault:vault_diamond>, <item:minecraft:diamond>], 
    [<item:minecraft:air>, <item:minecraft:diamond>, <item:minecraft:air>]
]);