import crafttweaker.api.entity.type.player.ServerPlayer;
import crafttweaker.api.entity.type.player.Player;
import crafttweaker.api.events.CTEventManager;
import crafttweaker.api.text.TextComponent;
import crafttweaker.api.text.Style;
import crafttweaker.api.text.MutableComponent;

// 1 sec = 20 ticks
// 1 min = 1200 ticks
// 1 hour = 72000 ticks
val cooldownInTicks = 300;
val cooldownItem = <item:origins:orb_of_origin>;
var prefixText = new TextComponent("[Origin] ").setStyle(<constant:formatting:yellow>);
var successMessage = prefixText.copy() + new TextComponent("Successfully changed your origin!").setStyle(<constant:formatting:green>) as MutableComponent;
var cooldownMessage = prefixText.copy() + new TextComponent("You recently changed your origin.\n Try again in: ").setStyle(<constant:formatting:red>) as MutableComponent;

CTEventManager.register<crafttweaker.api.event.entity.player.interact.RightClickItemEvent>((event) => {
    if (event.player != null && !event.player.level.isClientSide) {
        if(event.itemStack.matches(cooldownItem)) {
            val player = event.player as Player;
            val serverPlayer = player as ServerPlayer;
            val nbt = serverPlayer.getPersistentData();
            val lastOriginUpdate = nbt.getAt("lastOriginUpdate");
            val currentTime = player.level.gameTime;

            if (lastOriginUpdate == null) {
                player.sendMessage(successMessage);
            } else {
                val cooldownDelta = (currentTime - lastOriginUpdate.asNumber().getLong()) as int;
                if (cooldownDelta >= cooldownInTicks) {
                    player.sendMessage(successMessage);
                } else {
                    event.cancel();
                    val ticksRemaining = cooldownInTicks - cooldownDelta;
                    val hours = ((ticksRemaining / 72000) % 24) as string;
                    val minutes = ((ticksRemaining / 1200) % 60) as string;
                    val seconds = ((ticksRemaining / 20) % 60) as string;
                    player.sendMessage(cooldownMessage.copy() + new TextComponent(hours + ":" + minutes + ":" + seconds).setStyle(<constant:formatting:yellow>) as MutableComponent);
                    return;
                }
            }

            nbt.put("lastOriginUpdate", currentTime);
            serverPlayer.updatePersistentData(nbt);
        }
    }
});


craftingTable.addShaped("orb_of_origin", <item:origins:orb_of_origin>, [
    [<item:minecraft:air>, <item:minecraft:diamond>, <item:minecraft:air>], 
    [<item:minecraft:diamond>, <item:the_vault:vault_diamond>, <item:minecraft:diamond>], 
    [<item:minecraft:air>, <item:minecraft:diamond>, <item:minecraft:air>]
]);