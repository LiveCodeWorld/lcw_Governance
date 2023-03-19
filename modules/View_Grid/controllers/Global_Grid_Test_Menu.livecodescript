script "Global | Grid | Test | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Grid | Test | Menu
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

getprop shapeArray_Params
   return "VSM,Right Bar,Bars,Cool,Block"
end shapeArray_Params


--> Global | Grid | Test | Menu
-
on menu_DisplayedData gridView
   put the displayed_Data of gridView into shapeData
   --
   display_GridShapeData shapeData, gridView
end menu_DisplayedData

private command ___
end ___

on menu_Clear gridView
   grid_DeleteTiles gridView
end menu_Clear

on menu_TestGridDimensions gridView
   breakpoint
   set the grid_Dimensions of gridView to 10,10
   set the grid_Dimensions of gridView to 14,14
end menu_TestGridDimensions

