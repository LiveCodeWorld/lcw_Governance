script "Global | Grid | Tile | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Grid | Tile | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   return display_MenuTarget(tObject)
   -- return the display_View of tObject
end menu_Target

getprop checked_Framed [tileObject]
   put the tile_Framed of tileObject into sBoolean
   return sBoolean
end checked_Framed

getprop checked_Faded [tileObject]
   put the tile_Faded of tileObject into sBoolean
   return sBoolean
end checked_Faded

getprop tileStyle_Param [tileObject]
   return the tile_Style of tileObject
end tileStyle_Param

getprop tileStyle_Params [tileObject]
   -- return "regular,triangle,rectangle,oval"
   return the tile_Styles of tileObject
end tileStyle_Params

-- getprop link_Param [tileObject]
put the to_Name of aView into sName
return sName
end link_Param

getprop link_Params [tileObject]
   put the link_Names of tileObject into tNames
   return tNames
end link_Params


--> Global | Grid | Tile | Menu
-
on menu_Link tileObject, toName
   put the layout_View of tileObject into gridView
   put the long id of control toName of gridView into toObject
   put the loc of tileObject into tLoc
   --
   lock screen
   view_InsertFromPath "View|ixOS|Arc", gridView, tLoc
   put the result into aView
   --
   set the lineSize of aView to 4
   set the startArrow of aView to false
   set the endArrow of aView to false
   --
   set the from_Object of aView to tileObject
   set the to_Object of aView to toObject
   --
   set the from_Items of aView to "right,1,1"
   set the to_Items of aView to "left,1,1"
   --
   dispatch "LayoutControl" to aView
   unlock screen
end menu_Link

on menu_TileStyle tileObject, tStyle
   set the tile_Style of tileObject to tStyle
end menu_TileStyle

on menu_Framed tileObject
   put the tile_Framed of tileObject into sBoolean
   set the tile_Framed of tileObject to (sBoolean is false)
end menu_Framed

on menu_Faded tileObject
   put the tile_Faded of tileObject into sBoolean
   set the tile_Faded of tileObject to (sBoolean is false)
end menu_Faded
