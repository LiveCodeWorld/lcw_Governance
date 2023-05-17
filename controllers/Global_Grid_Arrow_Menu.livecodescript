script "Global | Grid | Arrow | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Grid | Arrow | Menu
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


--> Global | Grid | Arrow | Menu
-
on menu_CreateArrows gridView
   put the displayed_data of gridView into shapeData
   --
   grid_CreateArrows shapeData, gridView
end menu_CreateArrows

on menu_DislayArrows gridView
   display_GridArrowIndex gridView
end menu_DislayArrows

on menu_DeleteArrows gridView
   grid_DeleteArrows gridView
end menu_DeleteArrows

private command _
end _

on menu_StoreArrowData gridView
   put display_MenuDisplayView() into displayView
   put the displayed_Index of displayView into cIDs
   breakpoint
   --
   put 1 into indexNum
   repeat for each line shortID in cIDs
      put the long id of control id shortID of gridView into arrowView
      put the arrow_Data of arrowView into arrowData [indexNum]
      add 1 to indexNum
   end repeat
   --
   -- display_Data arrowData
   put the displayed_Data of gridView into shapeData
   put arrowData into shapeData ["grid_ArrowData"]
   --
   display_GridShapeData shapeData, gridView
end menu_StoreArrowData

private command __
end __

on menu_ClearTiles gridView
   grid_DeleteTiles gridView
end menu_ClearTiles


