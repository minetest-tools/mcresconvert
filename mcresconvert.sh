#!/bin/bash

for required in unzip convert composite zenity; do
	type $required > /dev/null
	if [ $? -ne 0 ]; then
		echo "Unable to find \"$required\" program, exiting"
		exit 1
	fi
done

cd ~/.minetest/textures || exit 1

convert_alphatex() {
	if [ -f _n/$2 ]; then
		convert $1 -crop 1x1+$3 -depth 8 -resize ${4}x${4} _n/_c.png
		composite -compose Multiply _n/_c.png _n/$2 _n/_i.png
		composite -compose Dst_In _n/$2 _n/_i.png -alpha Set $5
		echo -e "." >> _n/_tot
		echo -e "." >> _n/_counter
	fi
}

convert_file() {
	n=`basename "$@" .zip | tr -d ' \t."()[]' | tr -d "'"`
	echo "Found: $n"
	echo "   - File: `basename "$@"`"
	(
		if ! mkdir "$n" > /dev/null 2>&1 ; then
			if ! zenity --question --width 800 --text="A texture pack folder with name \"$n\" already exists, overwrite?" --default-cancel ; then
				exit 0
			fi
			rm -rf "$n"
			mkdir -p "$n"
		fi
		cd "$n"
		mkdir _z
		cd _z
		unzip -qq "$@"
		# beware of zip files with a random extra toplevel folder.
		assets=`find . -name 'assets' -type 'd'`
		if [ "$assets" != "./assets" ]; then
			mv "$assets" assets
		fi
		cd ..
		mkdir _n
		find _z -type f -name '*.png' -exec cp -n {} _n/ \;
		chmod -R +w _n _z # seriously? we have to do this? why can't unzip strip permissions?

		# try and determine px size
		if [ -f "_n/cobblestone.png" ]; then
			PXSIZE=`file _n/cobblestone.png |sed 's/.*, \([0-9]*\) x.*/\1/'`
		fi

		( cat <<RENAMES
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
boat.png boats_inventory.png
book_writable.png default_book.png
book_written.png default_book_written.png
bookshelf.png default_bookshelf.png
bread.png farming_bread.png
bucket_empty.png bucket.png
bucket_lava.png bucket_lava.png
bucket_water.png bucket_water.png
bucket_water.png bucket_river_water.png
assets/minecraft/textures/items/brick.png default_clay_brick.png
assets/minecraft/textures/blocks/brick.png default_brick.png
clay_ball.png default_clay_lump.png
clay.png default_clay.png
coal.png default_coal_lump.png
coal_block.png default_coal_block.png
coal_ore.png default_mineral_coal.png
cobblestone.png default_cobble.png
cobblestone_mossy.png default_mossycobble.png
deadbush.png default_dry_shrub.png
diamond.png default_diamond.png
diamond_axe.png default_tool_diamondaxe.png
diamond_block.png default_diamond_block.png
diamond_hoe.png farming_diamondhoe.png
diamond_ore.png default_mineral_diamond.png
diamond_pickaxe.png default_tool_diamondpick.png
diamond_shovel.png default_tool_diamondshovel.png
diamond_sword.png default_tool_diamondsword.png
dirt.png default_dirt.png
door_wood.png doors_item_wood.png
door_iron.png doors_item_steel.png
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
dye_powder_purple.png dye_violet.png
dye_powder_red.png dye_red.png
dye_powder_silver.png dye_grey.png
dye_powder_white.png dye_white.png
dye_powder_yellow.png dye_yellow.png
farmland_dry.png farming_soil.png
farmland_wet.png farming_soil_wet.png
fence_acacia.png default_fence_acacia_wood.png
fence_oak.png default_fence_wood.png
fence_birch.png default_fence_aspen_wood.png
fence_spruce.png default_fence_pine_wood.png
fence_jungle.png default_fence_junglewood.png
fire_layer_0.png fire_basic_flame_animated.png
flint.png default_flint.png
flower_allium.png flowers_viola.png
flower_blue_orchid.png flowers_geranium.png
flower_dandelion.png flowers_dandelion_yellow.png
flower_oxeye_daisy.png flowers_dandelion_white.png
flower_rose.png flowers_rose.png
flower_tulip_orange.png flowers_tulip.png
furnace_front_off.png default_furnace_front.png
furnace_front_on.png default_furnace_front_active.png
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
iron_bars.png xpanes_bar.png
iron_axe.png default_tool_steelaxe.png
iron_hoe.png farming_tool_steelhoe.png
iron_pickaxe.png default_tool_steelpick.png
iron_shovel.png default_tool_steelshovel.png
iron_sword.png default_tool_steelsword.png
iron_block.png default_steel_block.png
iron_ingot.png default_steel_ingot.png
iron_ore.png default_mineral_iron.png
iron_trapdoor.png doors_trapdoor_steel.png
iron_trapdoor.png doors_trapdoor_steel_side.png
ladder.png default_ladder_wood.png
lava_flow.png default_lava_flowing_animated.png
lava_still.png default_lava_source_animated.png
log_oak.png default_tree.png
log_oak_top.png default_tree_top.png
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
obsidian.png default_obsidian.png
paper.png default_paper.png
planks_acacia.png default_acacia_wood.png
planks_birch.png default_aspen_wood.png
planks_jungle.png default_junglewood.png
planks_oak.png default_wood.png
planks_spruce.png default_pine_wood.png
rail_normal.png default_rail.png
rail_normal_turned.png default_rail_curved.png
red_sand.png default_desert_sand.png
red_sandstone_normal.png default_desert_stone.png
red_sandstone_smooth.png default_desert_stone_brick.png
reeds.png default_papyrus.png
sand.png default_sand.png
sandstone_top.png default_sandstone.png
sandstone_normal.png default_sandstone_brick.png
sapling_birch.png default_aspen_sapling.png
sapling_jungle.png default_junglesapling.png
sapling_spruce.png default_pine_sapling.png
sapling_oak.png default_sapling.png
sapling_acacia.png default_acacia_sapling.png
seeds_wheat.png farming_wheat_seed.png
sign.png default_sign_wood.png
snowball.png default_snowball.png
assets/minecraft/textures/blocks/snow.png default_snow.png
stick.png default_stick.png
string.png farming_cotton.png
stone_axe.png default_tool_stoneaxe.png
stone_hoe.png farming_tool_stonehoe.png
stone_pickaxe.png default_tool_stonepick.png
stone_shovel.png default_tool_stoneshovel.png
stone_sword.png default_tool_stonesword.png
stone.png default_stone.png
stonebrick.png default_stone_brick.png
sugar.png farming_flour.png
tnt_bottom.png tnt_bottom.png
tnt_side.png tnt_side.png
tnt_top.png tnt_top.png
tnt_top.png tnt_top_burning.png
tnt_top.png tnt_top_burning_animated.png
torch_on.png default_torch.png
torch_on.png default_torch_on_floor_animated.png
trapdoor.png doors_trapdoor.png
trapdoor.png doors_trapdoor_side.png
water_still.png default_water_source_animated.png
water_still.png default_river_water_source_animated.png
water_flow.png default_water_flowing_animated.png
water_flow.png default_river_water_flowing_animated.png
wheat.png farming_wheat.png
wheat_stage_0.png farming_wheat_1.png
wheat_stage_1.png farming_wheat_2.png
wheat_stage_2.png farming_wheat_3.png
wheat_stage_3.png farming_wheat_4.png
wheat_stage_4.png farming_wheat_5.png
wheat_stage_5.png farming_wheat_6.png
wheat_stage_6.png farming_wheat_7.png
wheat_stage_7.png farming_wheat_8.png
wood_axe.png default_tool_woodaxe.png
wood_hoe.png farming_tool_woodhoe.png
wood_pickaxe.png default_tool_woodpick.png
wood_shovel.png default_tool_woodshovel.png
wood_sword.png default_tool_woodsword.png
wool_colored_black.png wool_black.png
wool_colored_blue.png wool_blue.png
wool_colored_brown.png wool_brown.png
wool_colored_cyan.png wool_cyan.png
wool_colored_gray.png wool_dark_grey.png
wool_colored_green.png wool_dark_green.png
wool_colored_lime.png wool_green.png
wool_colored_magenta.png wool_magenta.png
wool_colored_orange.png wool_orange.png
wool_colored_pink.png wool_pink.png
wool_colored_purple.png wool_violet.png
wool_colored_red.png wool_red.png
wool_colored_silver.png wool_grey.png
wool_colored_white.png wool_white.png
wool_colored_yellow.png wool_yellow.png
RENAMES
) |		while read IN OUT FLAG; do
			echo -e "." >> _n/_tot
			if [ -f "_n/$IN" ]; then
				echo -e "." >> _n/_counter
				cp "_n/$IN" "$OUT"
			elif [ -f "../_z/$IN" ]; then
				echo -e "." >> _n/_counter
				cp "../_z/$IN" "$OUT"
			# uncomment below 2 lines to see if any textures were not found.
			#else
			#	echo "+$IN $OUT $FLAG: Not Found"
			fi
		done

		# attempt to colorize grasses by color cradient
		if [ -f "_n/grass.png" ]; then
			convert _n/grass.png -crop 1x1+70+120 -depth 8 -resize ${PXSIZE}x${PXSIZE} _n/_c.png
			composite -compose Multiply _n/_c.png _n/grass_top.png default_grass.png
			echo -e "." >> _n/_tot
			echo -e "." >> _n/_counter

			convert _n/grass.png -crop 1x1+16+240 -depth 8 -resize ${PXSIZE}x${PXSIZE} _n/_c.png
			composite -compose Multiply _n/_c.png _n/grass_top.png default_dry_grass.png
			echo -e "." >> _n/_tot
			echo -e "." >> _n/_counter

			convert_alphatex _n/grass.png tallgrass.png 70+120 ${PXSIZE} default_grass_5.png
			if [ -f tallgrass1.png ]; then
				convert_alphatex _n/grass.png tallgrass1.png 70+120 ${PXSIZE} default_grass_4.png
			else
				convert default_grass_5.png -page +0+$(((PXSIZE / 8) * 1)) -background none -flatten default_grass_4.png
			fi
			if [ -f tallgrass2.png ]; then
				convert_alphatex _n/grass.png tallgrass2.png 70+120 ${PXSIZE} default_grass_3.png
			else
				convert default_grass_5.png -page +0+$(((PXSIZE / 8) * 2)) -background none -flatten default_grass_3.png
			fi
			if [ -f tallgrass3.png ]; then
				convert_alphatex _n/grass.png tallgrass3.png 70+120 ${PXSIZE} default_grass_2.png
			else
				convert default_grass_5.png -page +0+$(((PXSIZE / 8) * 3)) -background none -flatten default_grass_2.png
			fi
			if [ -f tallgrass4.png ]; then
				convert_alphatex _n/grass.png tallgrass4.png 70+120 ${PXSIZE} default_grass_1.png
			else
				convert default_grass_5.png -page +0+$(((PXSIZE / 8) * 4)) -background none -flatten default_grass_1.png
			fi
			#FIXME tile this
			convert_alphatex _n/grass.png grass_side_overlay.png 70+120 ${PXSIZE} default_grass_side.png

			convert_alphatex _n/grass.png tallgrass.png 16+240 ${PXSIZE} default_dry_grass_5.png
			if [ -f tallgrass1.png ]; then
				convert_alphatex _n/grass.png tallgrass1.png 16+240 ${PXSIZE} default_dry_grass_4.png
			else
				convert default_dry_grass_5.png -page +0+$(((PXSIZE / 8) * 1)) -background none -flatten default_dry_grass_4.png
			fi
			if [ -f tallgrass2.png ]; then
				convert_alphatex _n/grass.png tallgrass2.png 16+240 ${PXSIZE} default_dry_grass_3.png
			else
				convert default_dry_grass_5.png -page +0+$(((PXSIZE / 8) * 2)) -background none -flatten default_dry_grass_3.png
			fi
			if [ -f tallgrass3.png ]; then
				convert_alphatex _n/grass.png tallgrass3.png 16+240 ${PXSIZE} default_dry_grass_2.png
			else
				convert default_dry_grass_5.png -page +0+$(((PXSIZE / 8) * 3)) -background none -flatten default_dry_grass_2.png
			fi
			if [ -f tallgrass4.png ]; then
				convert_alphatex _n/grass.png tallgrass4.png 16+240 ${PXSIZE} default_dry_grass_1.png
			else
				convert default_dry_grass_5.png -page +0+$(((PXSIZE / 8) * 4)) -background none -flatten default_dry_grass_1.png
			fi
			#FIXME tile this
			convert_alphatex _n/grass.png grass_side_overlay.png 16+240 ${PXSIZE} default_dry_grass_side.png

			# jungle grass - compose from tall grass 2 parts
			convert_alphatex _n/grass.png double_plant_grass_bottom.png 16+32 ${PXSIZE} _n/_jgb.png
			convert_alphatex _n/grass.png double_plant_grass_top.png 16+32 ${PXSIZE} _n/_jgt.png
			montage -tile 1x2 -geometry +0+0 -background none _n/_jgt.png _n/_jgb.png default_junglegrass.png
			convert default_junglegrass.png -background none -gravity South -extent $((PXSIZE*2))x$((PXSIZE*2)) default_junglegrass.png
		fi

		# crack
		if [ -f "_n/destroy_stage_0.png" ]; then
			c=( _n/destroy_stage_*.png )
			montage -tile 1x${#c[@]} -geometry +0+0 -background none ${c[@]} crack_anylength.png
			echo -e "." >> _n/_tot
			echo -e "." >> _n/_counter
		fi

		# same for leaf colors
		if [ -f "_n/foliag.png" ]; then
			FOLIAG=_n/foliag.png
		elif [ -f "_n/foliage.png" ]; then
			FOLIAG=_n/foliage.png
		fi
		if [ -n "$FOLIAG" ]; then
			convert_alphatex $FOLIAG leaves_oak.png 70+120 ${PXSIZE} default_leaves.png
			convert_alphatex $FOLIAG leaves_acacia.png 16+240 ${PXSIZE} default_acacia_leaves.png
			convert_alphatex $FOLIAG leaves_spruce.png 226+240 ${PXSIZE} default_pine_needles.png
			convert_alphatex $FOLIAG leaves_birch.png 70+120 ${PXSIZE} default_aspen_leaves.png
			convert_alphatex $FOLIAG leaves_jungle.png 16+32 ${PXSIZE} default_jungleleaves.png
			echo -e "." >> _n/_tot
			echo -e "." >> _n/_counter
		fi

		# compose doors texture maps
		if [ -f _n/door_wood_lower.png -a -f _n/door_wood_upper.png ]; then
			convert -background none _n/door_wood_upper.png -flop _n/_fu.png
			convert -background none _n/door_wood_lower.png -flop _n/_fl.png
			montage -background none _n/_fu.png _n/door_wood_upper.png \
				_n/_fl.png _n/door_wood_lower.png \
				-geometry +0+0 _n/_d.png
			convert _n/_d.png -background none -extent $(( (PXSIZE * 2) + (3 * (PXSIZE / 8) ) ))x$((PXSIZE * 2)) _n/_d2.png
			convert _n/_d2.png \
				\( -clone 0 -crop $((PXSIZE/8))x$((PXSIZE*2))+$((PXSIZE-1))+0 \) -gravity NorthWest -geometry +$((PXSIZE*2))+0 -composite \
				\( -clone 0 -crop $((PXSIZE/16))x$((PXSIZE*2))+0+0 \) -gravity NorthWest -geometry +$((PXSIZE*2+(PXSIZE/8)))+0 -composite \
				\( -clone 0 -crop $((PXSIZE/16))x$((PXSIZE*2))+$((PXSIZE*2-1))+0 \) -gravity NorthWest -geometry +$((PXSIZE*2+(3*(PXSIZE/16))))+0 -composite \
				\( -clone 0 -crop $((PXSIZE/16))x$((PXSIZE*2))+0+0 \) -gravity NorthWest -geometry +$((PXSIZE*2+(4*(PXSIZE/16))))+0 -composite \
				\( -clone 0 -crop $((PXSIZE/16))x$((PXSIZE*2))+$((PXSIZE*2-1))+0 \) -gravity NorthWest -geometry +$((PXSIZE*2+(5*(PXSIZE/16))))+0 -composite \
				doors_door_wood.png
			echo -e "." >> _n/_tot
			echo -e "." >> _n/_counter
		fi

		if [ -f _n/door_iron_lower.png -a -f _n/door_iron_upper.png ]; then
			convert -background none _n/door_iron_upper.png -flop _n/_fu.png
			convert -background none _n/door_iron_lower.png -flop _n/_fl.png
			montage -background none _n/_fu.png _n/door_iron_upper.png \
				_n/_fl.png _n/door_iron_lower.png \
				-geometry +0+0 _n/_d.png
			convert _n/_d.png -background none -extent $(( (PXSIZE * 2) + (3 * (PXSIZE / 8) ) ))x$((PXSIZE * 2)) _n/_d2.png
			convert _n/_d2.png \
				\( -clone 0 -crop $((PXSIZE/8))x$((PXSIZE*2))+$((PXSIZE-1))+0 \) -gravity NorthWest -geometry +$((PXSIZE*2))+0 -composite \
				\( -clone 0 -crop $((PXSIZE/16))x$((PXSIZE*2))+0+0 \) -gravity NorthWest -geometry +$((PXSIZE*2+(PXSIZE/8)))+0 -composite \
				\( -clone 0 -crop $((PXSIZE/16))x$((PXSIZE*2))+$((PXSIZE*2-1))+0 \) -gravity NorthWest -geometry +$((PXSIZE*2+(3*(PXSIZE/16))))+0 -composite \
				\( -clone 0 -crop $((PXSIZE/16))x$((PXSIZE*2))+0+0 \) -gravity NorthWest -geometry +$((PXSIZE*2+(4*(PXSIZE/16))))+0 -composite \
				\( -clone 0 -crop $((PXSIZE/16))x$((PXSIZE*2))+$((PXSIZE*2-1))+0 \) -gravity NorthWest -geometry +$((PXSIZE*2+(5*(PXSIZE/16))))+0 -composite \
				doors_door_steel.png
			echo -e "." >> _n/_tot
			echo -e "." >> _n/_counter
		fi

		# fences - make alternative from planks
		if [ ! -f _n/fence_oak.png ]; then
			convert _n/planks_oak.png \( -clone 0 -crop $((PXSIZE))x$((PXSIZE/4))+0+$(((PXSIZE/8)*3)) -rotate 90 -gravity center \) -composite default_fence_wood.png
		fi

		if [ ! -f _n/fence_acacia.png ]; then
			convert _n/planks_acacia.png \( -clone 0 -crop $((PXSIZE))x$((PXSIZE/4))+0+$(((PXSIZE/8)*3)) -rotate 90 -gravity center \) -composite default_fence_acacia_wood.png
		fi

		if [ ! -f _n/fence_spruce.png ]; then
			convert _n/planks_spruce.png \( -clone 0 -crop $((PXSIZE))x$((PXSIZE/4))+0+$(((PXSIZE/8)*3)) -rotate 90 -gravity center \) -composite default_fence_pine_wood.png
		fi

		if [ ! -f _n/fence_jungle.png ]; then
			convert _n/planks_jungle.png \( -clone 0 -crop $((PXSIZE))x$((PXSIZE/4))+0+$(((PXSIZE/8)*3)) -rotate 90 -gravity center \) -composite default_fence_junglewood.png
		fi

		if [ ! -f _n/fence_birch.png ]; then
			convert _n/planks_birch.png \( -clone 0 -crop $((PXSIZE))x$((PXSIZE/4))+0+$(((PXSIZE/8)*3)) -rotate 90 -gravity center \) -composite default_fence_aspen_wood.png
		fi

		# chest textures
		if [ -f _n/normal.png ]; then
			CHPX=$((PXSIZE / 16 * 14)) # chests in MC are 2/16 smaller!
			convert _n/normal.png \
				\( -clone 0 -crop $((CHPX))x$((CHPX))+$((CHPX))+0 \) -geometry +0+0 -composite -extent $((CHPX))x$((CHPX)) default_chest_top.png
			convert _n/normal.png \
				\( -clone 0 -crop $((CHPX))x$(((PXSIZE/16)*5))+$((CHPX))+$((CHPX)) \) -geometry +0+0 -composite \
				\( -clone 0 -crop $((CHPX))x$(((PXSIZE/16)*10))+$((CHPX))+$(( (2*CHPX)+((PXSIZE/16)*5) )) \) -geometry +0+$(((PXSIZE/16)*5)) -composite \
				-extent $((CHPX))x$((CHPX)) default_chest_front.png
			cp default_chest_front.png default_chest_lock.png
			convert _n/normal.png \
				\( -clone 0 -crop $((CHPX))x$(((PXSIZE/16)*5))+$((2*CHPX))+$((CHPX)) \) -geometry +0+0 -composite \
				\( -clone 0 -crop $((CHPX))x$(((PXSIZE/16)*10))+$((2*CHPX))+$(( (2*CHPX)+((PXSIZE/16)*5) )) \) -geometry +0+$(((PXSIZE/16)*5)) -composite \
				-extent $((CHPX))x$((CHPX)) default_chest_side.png
			echo -e "..." >> _n/_tot
			echo -e "..." >> _n/_counter
		fi

		if [ -f _n/sun.png ]; then
			convert _n/sun.png -colorspace HSB -separate _n/_mask.png
			convert _n/sun.png -alpha Off _n/_mask-2.png -compose CopyOpacity -composite PNG32:sun.png
			convert sun.png -bordercolor black -border 1x1 -fuzz 0% -trim sun.png
			rm _n/_mask*
			echo -e "." >> _n/_tot
			echo -e "." >> _n/_counter
		fi
		if [ -f _n/moon_phases.png ]; then
			S=`identify -format "%[fx:w/4]" _n/moon_phases.png`
			convert _n/moon_phases.png -colorspace HSB -separate _n/_mask.png
			convert _n/moon_phases.png -alpha Off _n/_mask-2.png -compose CopyOpacity -composite PNG32:moon.png
			convert -background none moon.png -gravity NorthWest -extent ${S}x${S} moon.png
			convert moon.png -bordercolor black -border 1x1 -fuzz 0% -trim moon.png
			echo -e "." >> _n/_tot
			echo -e "." >> _n/_counter
		fi

		# inventory torch
		if [ -f _n/torch_on.png ]; then
			convert _n/torch_on.png -background none -gravity North -extent ${PXSIZE}x${PXSIZE} default_torch_on_floor.png
			echo -e "." >> _n/_tot
			echo -e "." >> _n/_counter
		fi

		# hotbar
		if [ -f _n/widgets.png ]; then
			convert _n/widgets.png -background none -gravity NorthWest -crop 24x24+0+22 gui_hotbar_selected.png
			convert _n/widgets.png -background none -gravity NorthWest -extent 182x22 \
				\( -clone 0 -crop 22x22+160+0 \) -geometry +140+0 -composite \
				-gravity West -extent 162x22 gui_hotbar.png
			echo -e "." >> _n/_tot
			echo -e "." >> _n/_counter
		fi

		# health & breath
		if [ -f _n/icons.png ]; then
			convert _n/icons.png -background none -gravity NorthWest -crop 9x9+52+0 heart.png
			convert _n/icons.png -background none -gravity NorthWest -crop 9x9+16+18 bubble.png
			echo -e "." >> _n/_tot
			echo -e "." >> _n/_counter
		fi

		# steve? ha! This assumes 64x32 dimensions, won't work well with 1.8 skins.
		if [ -f _n/steve.png ]; then
			convert _n/steve.png -background none -gravity NorthWest \
			-extent 64x32 character.png
			echo -e "." >> _n/_tot
			echo -e "." >> _n/_counter
		fi

		# attempt to make desert cobblestone
		if [ -f _n/cobblestone.png -a -f _n/red_sand.png ]; then
			convert _n/red_sand.png -resize 1x1 -resize ${PXSIZE}x${PXSIZE} _n/_c.png
			convert _n/cobblestone.png _n/_c.png -compose Overlay -composite default_desert_cobble.png
			echo -e "." >> _n/_tot
			echo -e "." >> _n/_counter
		fi

		# make copper and bronze from colorizing steel
		if [ -f _n/iron_ingot.png ]; then
			#ffa05b
			convert -size ${PXSIZE}x${PXSIZE} xc:\#CA8654 _n/_c.png

			composite -compose Screen _n/_c.png _n/iron_ingot.png _n/_i.png
			composite -compose Dst_In _n/iron_ingot.png _n/_i.png -alpha Set default_copper_ingot.png

			convert _n/iron_block.png _n/_c.png -compose Overlay -composite default_copper_block.png

			#ffb07c
			convert -size ${PXSIZE}x${PXSIZE} xc:\#6F4C35 _n/_c.png

			composite -compose Screen _n/_c.png _n/iron_ingot.png _n/_i.png
			composite -compose Dst_In _n/iron_ingot.png _n/_i.png -alpha Set default_bronze_ingot.png

			convert _n/iron_block.png _n/_c.png -compose Overlay -composite default_bronze_block.png
			echo -e "...." >> _n/_tot
			echo -e "...." >> _n/_counter
		fi

		# de-animate flint and steel
		if [ -f _n/flint_and_steel.png ]; then
			convert -background none -gravity North -extent ${PXSIZE}x${PXSIZE} _n/flint_and_steel.png fire_flint_steel.png
			echo -e "." >> _n/_tot
			echo -e "." >> _n/_counter
		fi

		# cactus needs manual cropping
		if [ -f _n/cactus_top.png ]; then
			convert _n/cactus_top.png -crop +$((PXSIZE/16))+$((PXSIZE/16))x$(((PXSIZE/16)*14))x$(((PXSIZE/16)*14)) -gravity center -extent $(((PXSIZE/16)*14))x$(((PXSIZE/16)*14)) default_cactus_top.png
			convert _n/cactus_side.png -crop +$((PXSIZE/16))+$((PXSIZE/16))x$(((PXSIZE/16)*14))x$(((PXSIZE/16)*14)) -gravity center -extent $(((PXSIZE/16)*14))x$(((PXSIZE/16)*14)) default_cactus_side.png
			echo -e ".." >> _n/_tot
			echo -e ".." >> _n/_counter
		fi

		# steel ladder
		if [ -f _n/ladder.png ]; then
			convert _n/ladder.png -channel RGBA -matte -colorspace gray default_ladder_steel.png
			echo -e "." >> _n/_tot
			echo -e "." >> _n/_counter
		fi

		# steel sign
		if [ -f _n/sign.png ]; then
			convert _n/sign.png -channel RGBA -matte -colorspace gray default_sign_steel.png
			echo -e "." >> _n/_tot
			echo -e "." >> _n/_counter
		fi

		# logo
		if [ -f _n/pack.png ]; then
			# fix aspect ratio
			convert _n/pack.png -gravity North -resize 128x128 -background none -extent 160x148 screenshot.png
			echo -e ".." >> _n/_tot
			echo -e ".." >> _n/_counter
		elif [ -f _n/grass_side.png -a -f _n/dirt.png ]; then
			# make something up
			montage -geometry +0+0 _n/grass_side.png _n/grass_side.png _n/grass_side.png _n/grass_side.png \
				_n/dirt.png _n/dirt.png _n/dirt.png _n/dirt.png \
				_n/dirt.png _n/dirt.png _n/dirt.png _n/dirt.png screenshot.png
		fi

		count=`cat _n/_counter | wc -c`
		tot=`cat _n/_tot | wc -c`
		echo "$n ${PXSIZE}px [$((100 * count / tot))%]" > description.txt
		echo "(Converted from $n with Minetest Texture and Resource Pack Converter)" >> description.txt
		echo "   - Conversion quality: $count / $tot"
		if [ -n "$PXSIZE" ]; then
			echo "   - Pixel size: ${PXSIZE}px"
		fi
		if [ -f _z/pack.txt ]; then
			echo "Original Description:" >> description.txt
			cat _z/pack.txt >> description.txt
		fi
		rm -rf _z _n
	)
}

# manually passed a file name?
if [ -n "$1" ]; then
	convert_file "$@"
	exit $?
fi

choice=`zenity --list --title "Choose resource packs to convert" --column="Convert" \
	--text "Do you want to convert installed resource packs, or convert a single zip file?" \
	--column="Description" --height 400 --width 800 \
	"all" "Find Minecraft resource packs installed in your minecraft folders and convert those automatically" \
	"default" "Convert the default resource pack" \
	"other" "Choose a file to convert manually"`

if [ "$choice" == "all" ]; then
	echo "Automatically converting resourcepacks and texturepacks found..."

	echo "Scanning for texture/resourcepacks..."
	(
		find ~/.minecraft/texturepacks/ -name '*.zip'
		find ~/.minecraft/resourcepacks -name '*.zip'
	) | while read f; do
		convert_file "$f"
	done
elif [ "$choice" == "other" ]; then
	# assume file name to zip is passed
	convert_file "`zenity --file-selection --file-filter="*.zip"`"
elif [ "$choice" == "default" ]; then
	if ! cp ~/.minecraft/versions/1.9/1.9.jar /tmp/mc-default-1.9.zip ; then
		exit 1
	fi
	convert_file /tmp/mc-default-1.9.zip
	rm /tmp/mc-default-1.9.zip
fi
