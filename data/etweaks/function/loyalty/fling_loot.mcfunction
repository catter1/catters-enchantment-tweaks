# Get Loyalty level
execute store result score @s level run data get entity @s item.components."minecraft:enchantments".levels."minecraft:loyalty"
scoreboard players set %constant level -1

# Set base motion multipliers
scoreboard players set %constant motion.x 40
scoreboard players set %constant motion.y 80
scoreboard players set %constant motion.z 40

# Set additional multipliers for each level of Loyalty
scoreboard players set %multiplier motion.x 20
scoreboard players set %multiplier motion.y 30
scoreboard players set %multiplier motion.z 20

# Multiply the values for each Loyalty level
scoreboard players operation %multiplier motion.x *= @s level
scoreboard players operation %multiplier motion.y *= @s level
scoreboard players operation %multiplier motion.z *= @s level

# Add it to the base motion
scoreboard players operation %constant motion.x += %multiplier motion.x
scoreboard players operation %constant motion.y += %multiplier motion.y
scoreboard players operation %constant motion.z += %multiplier motion.z

# Get owner of the trident (player) coordinates
execute store result score @s player.x run execute on origin run data get entity @s Pos[0]
execute store result score @s player.y run execute on origin run data get entity @s Pos[1]
execute store result score @s player.z run execute on origin run data get entity @s Pos[2]

# Get trident's coordinates
execute store result score @s trident.x run data get entity @s Pos[0]
execute store result score @s trident.y run data get entity @s Pos[1]
execute store result score @s trident.z run data get entity @s Pos[2]

# Init the motion vectors
scoreboard players operation @s motion.x = @s player.x
scoreboard players operation @s motion.y = @s player.y
scoreboard players operation @s motion.z = @s player.z

# Set motion vectors to distance between trident and player
scoreboard players operation @s motion.x -= @s trident.x
scoreboard players operation @s motion.y -= @s trident.y
scoreboard players operation @s motion.z -= @s trident.z

# If trident is higher than player, we still want upwards motion!
execute if score @s motion.y matches ..0 run scoreboard players operation @s motion.y *= %constant level

# Multiply base motion vectors by our multipliers set above
scoreboard players operation @s motion.x *= %constant motion.x
scoreboard players operation @s motion.y *= %constant motion.y
scoreboard players operation @s motion.z *= %constant motion.z

# Extra y-motion applied for case where trident and player have the same y level
scoreboard players set %constant level 330
scoreboard players operation %constant level *= @s level
scoreboard players operation @s motion.y += %constant level

# Merge motion vectors into storage with correct counter-multiples for floating point divison
execute store result storage etweaks:loyalty Motion[0] double 0.0005 run scoreboard players get @s motion.x
execute store result storage etweaks:loyalty Motion[1] double 0.0005 run scoreboard players get @s motion.y
execute store result storage etweaks:loyalty Motion[2] double 0.0005 run scoreboard players get @s motion.z

# Merge storage to actual item Motion
execute as @e[type=item,distance=..2.5] run data modify entity @s Motion set from storage etweaks:loyalty Motion