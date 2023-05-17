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
   put the tile_Object of tObject into tileObject
   return tileObject
   -- return display_MenuTarget(tObject)
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
   set the from_Items of aView to "right,1,2"
   set the to_Items of aView to "left,1,2"
   --
   dispatch "LayoutControl" to aView
   unlock screen
end menu_Link

on menu_Rename tileObject
   put the grid_View of tileObject into gridView
   put the short name of tileObject into sName
   put lcw_Ask ("Step number...", sName, "Rename", tileObject) into sNum
   put lcw_Ask ("Rename tile...", sName, "Rename", tileObject) into sName
   put the tile_Number of tileObject into indexNum
   --
   put the displayed_Data of tileObject into shapeData
   put sName into shapeData ["shape_Array"][indexNum]["name"]
   put sNum into shapeData ["shape_Array"][indexNum]["label"]
   set the shape_Data of tileObject to shapeData
   --
   lock screen
   set the name of tileObject to sName
   set the label of tileObject to sNum
   display_GridShapeData shapeData, gridView
   unlock screen
end menu_Rename

private command _
end _

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
