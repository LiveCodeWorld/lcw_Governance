script "Global | Steps | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Steps | Menu
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
   -- return display_MenuTarget(tObject)
   return the display_View of tObject
end menu_Target


--> Global | Steps | Menu
-
on menu_ImportSteps gridView
   set grid_ShapeTitle of gridView to "24 Steps"
end menu_ImportSteps

on menu_SnakeRelabel gridView
   put the displayed_Data of gridView into shapeData
   put shapeData ["grid_Dimensions"] into gridDimensions
   --
   put shapeData ["shape_Array"] into shapeArray
   repeat with tileNumber = 1 to item 2 of the extents of shapeArray
      put steps_GetSnakeNum (tileNumber, gridDimensions) into snakeNum
      put snakeNum into shapeData ["shape_Array"][tileNumber]["label"]
   end repeat
   set the displayed_Data of gridView to shapeData
end menu_SnakeRelabel

on menu_TestSimpleLinkArray gridView
   put "World" into linkArray ["Hello"]
   put dotArray_FromLinkArray (linkArray, "dot", "Test Graph") into dotArray
   --
   display_DotArray dotArray
   --
   display_GraphFromDotArray dotArray
end menu_TestSimpleLinkArray

on submenu_Arrows
   return "Global | Grid | Arrow | Menu"
end submenu_Arrows

private command _
end _

on menu_ClearTiles gridView
   grid_DeleteTiles gridView
end menu_ClearTiles

private command _
end _

on insert_Menu
   return "Global | Grid | Menu"
end insert_Menu
