#!/bin/bash

for required in unzip convert composite; do
	type $required > /dev/null
	if [ $? -ne 0 ]; then
		echo "Unable to find \"$required\" program, exiting"
		exit 1
	fi
done

cd ~/.minetest/textures || exit 1

convert_file() {
	echo "Found: $@"
	n=`basename "$@" .zip | tr -d ' \t."()[]'`
	if [ -d "$n" ]; then
		echo "   - Already imported: $n"
		continue
	fi
	echo "   - Importing as $n"
	(
		mkdir "$n"
		cd "$n"
		mkdir _z
		cd _z
		unzip -qq "$@"
		cd ..
		mkdir _n
		find _z -type f -name '*.png' -exec cp -n {} _n/ \;
		chmod -R +w _n _z # seriously? we have to do this? why can't unzip strip permissions?

		# try and determine px size
		if [ -f "_n/cobblestone.png" ]; then
			PXSIZE=`file _n/cobblestone.png |sed 's/.*, \([0-9]*\) x.*/\1/'`
		fi

		( cat <<RENAMES
background.png menubg.png
pack.png menulogo.png
apple.png default_apple.png
bed.png beds_bed.png
bed_feet_end.png beds_bed_side_bottom.png
bed_feet_side.png beds_bed_side_bottom_r.png
bed_feet_side.png beds_bed_side_bottom_l.png h
bed_feet_top.png beds_bed_top_bottom.png
bed_head_end.png beds_bed_side_top.png
bed_head_top.png beds_bed_top_top.png
bed_head_side.png beds_bed_side_top_r.png
bed_head_side.png beds_bed_side_top_l.png h
book_writable.png default_book.png
book_written.png default_book_written.png
bookshelf.png default_bookshelf.png
bread.png farming_bread.png
bucket_empty.png bucket.png
bucket_lava.png bucket_lava.png
bucket_water.png bucket_water.png
bucket_water.png bucket_river_water.png
cactus_top.png default_cactus_top.png
cactus_side.png default_cactus_side.png
brick.png default_clay_brick.png
clay_ball.png default_clay_lump.png
clay.png default_clay.png
coal.png default_coal_lump.png
coal_block.png default_coal_block.png
coal_ore.png default_mineral_coal.png
cobblestone.png default_cobble.png
cobblestone_mossy.png default_mossycobble.png
copper.png default_copper_block.png
deadbush.png default_dry_shrub.png
diamond.png default_diamond.png
diamond_axe.png default_tool_diamondaxe.png
diamond_block.png default_diamond_block.png
diamond_hoe.png farming_diamondhoe.png
diamond_ore.png default_mineral_diamond.png
diamond_pickaxe.png default_tool_diamondpickaxe.png
diamond_shovel.png default_tool_diamondshovel.png
diamond_sword.png default_tool_diamondsword.png
dirt.png default_dirt.png
dye_powder_black.png dye_black.png
dye_powder_blue.png dye_blue.png
dye_powder_brown.png dye_brown.png
dye_powder_cyan.png dye_cyan.png
dye_powder_green.png dye_dark_green.png
dye_powder_lime.png dye_green.png
dye_powder_gray.png dye_dark_grey.png
dye_powder_magenta.png dye_magenta.png
dye_powder_orange.png dye_orange.png
dye_powder_pink.png dye_pink.png
dye_powder_purple.png dye_purple.png
dye_powder_red.png dye_red.png
dye_powder_silver.png dye_grey.png
dye_powder_white.png dye_white.png
dye_powder_yellow.png dye_yellow.png
farmland_dry.png farming_soil.png
farmland_wet.pnt farming_soil_wet.png
flint.png default_flint.png
flint_and_steel.pnt fire_flint_steel.png
flower_allium.png flowers_viola.png
flower_blue_orchid.png flowers_geranium.png
flower_dandelion.png flowers_dandelion_yellow.png
flower_oxeye_daisy.png flowers_dandelion_white.png
flower_rose.png flowers_rose.png
flower_tulip_orange.png flowers_tulip.png
furnace_front.png default_furnace_front.png
furnace_side.png default_furnace_side.png
furnace_top.png default_furnace_bottom.png
furnace_top.png default_furnace_top.png
glass.png default_glass.png
glass_black.png default_obsidian_glass.png
gold_block.png default_gold_block.png
gold_ingot.png default_gold_ingot.png
gold_nugget.png default_gold_lump.png
gold_ore.png default_mineral_gold.png
grass_side.png default_grass_side.png
grass_side_snowed.png default_snow_side.png
gravel.png default_gravel.png
hay_block_side.png farming_straw.png
ice.png default_ice.png
iron_axe.png default_tool_steelaxe.png
iron_hoe.png farming_tool_steelhoe.png
iron_pickaxe.png default_tool_steelpickaxe.png
iron_shovel.png default_tool_steelshovel.png
iron_sword.png default_tool_steelsword.png
iron_block.png default_steel_block.png
iron_ingot.png default_steel_ingot.png
iron_ore.png default_mineral_iron.png
ladder.png default_ladder.png
lava_still.png default_lava.png
log_acacia.png default_acacia_tree.png
log_acacia_top.png default_acacia_tree_top.png
log_birch.png default_aspen_tree.png
log_birch_top.png default_aspen_tree_top.png
log_jungle.png default_jungletree.png
log_jungle_top.png default_jungletree_top.png
log_spruce.png default_pine_tree.png
log_spruce_top.png default_pine_tree_top.png
mushroom_brown.png flowers_mushroom_brown.png
mushroom_red.png flowers_mushroom_red.png
planks_acacia.png default_acacia_wood.png
planks_birch.png default_aspen_wood.png
planks_jungle.png default_junglewood.png
planks_oak.png default_wood.png
planks_spruce.png default_pine_wood.png
rail_normal.png default_rail.png
rail_normal_turned.png default_rail_curved.png
red_sand.png default_desert_sand.png
sand.png default_sand.png
sandstone_top.png default_sandstone.png
sandstone_normal.png default_sandstone_brick.png
sapling_birch.png default_aspen_sapling.png
sapling_jungle.png default_junglewood_sapling.png
sapling_spruce.png default_pine_sapling.png
sapling_oak.png default_sapling.png
sapling_acacia.png default_acacia_sapling.png
snowball.png default_snowball.png
stick.png default_stick.png
stone_axe.png default_tool_stoneaxe.png
stone_hoe.png farming_tool_stonehoe.png
stone_pickaxe.png default_tool_stonepickaxe.png
stone_shovel.png default_tool_stoneshovel.png
stone_sword.png default_tool_stonesword.png
stone.png default_stone.png
stonebrick.png default_stone_brick.png
torch_on.png default_torch.png
trapdoor.png default_trapdoor_wood.png
wheat.png farming_wheat.png
wheat_stage_0.png farming_wheat_1.png
wheat_stage_1.png farming_wheat_2.png
wheat_stage_2.png farming_wheat_3.png
wheat_stage_3.png farming_wheat_4.png
wheat_stage_4.png farming_wheat_5.png
wheat_stage_5.png farming_wheat_6.png
wheat_stage_6.png farming_wheat_7.png
wheat_stage_7.png farming_wheat_8.png
wood.png default_wood.png
wood_birch.png default_aspen_wood.png
wood_axe.png default_tool_woodaxe.png
wood_hoe.png farming_tool_woodhoe.png
wood_pickaxe.png default_tool_woodpickaxe.png
wood_shovel.png default_tool_woodshovel.png
wood_sword.png default_tool_woodsword.png
wool_colored_black.png wool_black.png
wool_colored_blue.png wool_blue.png
wool_colored_brown.png wool_brown.png
wool_colored_cyan.png wool_cyan.png
wool_colored_gray.png wool_dark_grey.png
wool_colored_green.png wool_dark_green.png
wool_colored_lime.png wool_green.png.png
wool_colored_magenta.png wool_magenta.png
wool_colored_orange.png wool_orange.png
wool_colored_pink.png wool_pink.png
wool_colored_purple.png wool_purple.png
wool_colored_red.png wool_red.png
wool_colored_silver.png wool_light_grey.png
wool_colored_white.png wool_white.png
wool_colored_yellow.png wool_yellow.png
RENAMES
) |		while read IN OUT FLAG; do
			echo -e "." >> _n/_tot
			if [ -f "_n/$IN" ]; then
				echo -e "." >> _n/_counter
				cp "_n/$IN" "$OUT"
			fi
		done

		# attempt to colorize grasses by color cradient
		if [ -f "_n/grass.png" ]; then
			convert _n/grass.png -crop 1x1+16+32 -depth 8 -resize ${PXSIZE}x${PXSIZE} _n/_c.png
			composite -compose Multiply _n/_c.png _n/grass_top.png default_grass.png

			convert _n/grass.png -crop 1x1+16+240 -depth 8 -resize ${PXSIZE}x${PXSIZE} _n/_c.png
			composite -compose Multiply _n/_c.png _n/grass_top.png default_dry_grass.png
		fi

		# same for leaf colors
		if [ -f "_n/foliag.png" ]; then
			convert _n/foliag.png -crop 1x1+16+32 -depth 8 -resize ${PXSIZE}x${PXSIZE} _n/_c.png
			composite -compose ATop _n/_c.png _n/leaves_oak.png default_leaves.png

			convert _n/foliag.png -crop 1x1+16+32 -depth 8 -resize ${PXSIZE}x${PXSIZE} _n/_c.png
			composite -compose ATop _n/_c.png _n/leaves_acacia.png default_acacia_leaves.png

			convert _n/foliag.png -crop 1x1+16+32 -depth 8 -resize ${PXSIZE}x${PXSIZE} _n/_c.png
			composite -compose ATop _n/_c.png _n/leaves_spruce.png default_pine_needles.png

			convert _n/foliag.png -crop 1x1+16+32 -depth 8 -resize ${PXSIZE}x${PXSIZE} _n/_c.png
			composite -compose ATop _n/_c.png _n/leaves_birch.png default_aspen_leaves.png

			convert _n/foliag.png -crop 1x1+16+32 -depth 8 -resize ${PXSIZE}x${PXSIZE} _n/_c.png
			composite -compose ATop _n/_c.png _n/leaves_jungle.png default_jungleleaves.png
		fi

		count=`cat _n/_counter | wc -c`
		tot=`cat _n/_tot | wc -c`
		echo "$n" > description.txt
		echo "(Converted from $n with Minetest Texture and Resource Pack Converter)" >> description.txt
		echo "   - Conversion quality: $count / $tot"
		if [ -n "$PXSIZE" ]; then
			echo "   - Pixel size: ${PXSIZE}px"
			echo "Pixel size: ${PXSIZE}px" >> description.txt
		fi
		echo "Conversion quality: $((100 * count / tot))%" >> description.txt
		if [ -f _z/pack.txt ]; then
			echo "Original Description:" >> description.txt
			cat _z/pack.txt >> description.txt
		fi
		rm -rf _z _n
	)
}

if [ -z "$1" ]; then
	echo "Automatically converting resourcepacks and texturepacks found..."

	if [ ! -d ~/.minetest/textures ]; then
		echo "Can't find Minetest texture folder!"
		exit 1
	fi

	echo "Scanning for texture/resourcepacks..."
	(
		find ~/.minecraft/texturepacks/ -name '*.zip'
		find ~/.minecraft/resourcepacks -name '*.zip'
	) | while read f; do
		convert_file "$f"
	done
else
	# assume file name to zip is passed
	convert_file "$1"
fi
