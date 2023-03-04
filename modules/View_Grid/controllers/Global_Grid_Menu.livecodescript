script "Global | Grid | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Grid | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop setGrid_Params
   return grid_ListShapeNames()
end setGrid_Params

getprop checked_KeepSquare [gridView]
   return the keep_Square of gridView is true
end checked_KeepSquare


--> Global | Grid | Menu
-
on menu_GridDimensions gridView
   set the grid_Dimensions of gridView to 10,10
   set the grid_Dimensions of gridView to 14,14
end menu_GridDimensions

on menu_SetGrid gridView, whichShape
   put tile_GetShapeArray (whichShape) into shapeArray
   --
   switch whichShape
      case "MVG"
         set grid_ShapeArray [14,14] of gridView to shapeArray
         break
      default
         set grid_ShapeArray [10,10] of gridView to shapeArray
   end switch
   
   /*
   put the card_Object of gridView into cObject
   put the inner_Rect ["20"] of cObject into frameRect
   --
   if the keep_Square of gridView is true then
      put rect_GetSquare (frameRect, 0) into frameRect
   end if
   
   switch whichShape
      case "MVG"
         tile_Create shapeArray, gridView, frameRect, 14, 14
         break
      default
         tile_Create shapeArray, gridView, frameRect, 10, 10
   end switch
   */
end menu_SetGrid

on menu_Clear gridView
   grid_DeleteTiles gridView
end menu_Clear

on _
end _

on menu_KeepSquare gridView
   put the card_Object of gridView into cObject
   put the inner_Rect ["20"] of cObject into someRect
   --
   put the keep_Square of gridView into sBoolean
   set the keep_Square [someRect] of gridView to (sBoolean is false)
end menu_KeepSquare

on menu_SetBorder gridView, bWidth
   lock screen
   put the rect of gridView into oRect
   set the borderWidth of gridView to bWidth
   set the rect of gridView to oRect
   unlock screen
end menu_SetBorder

getprop setBorder_Param [gridView]
   put the borderWidth of gridView into bWidth
   return bWidth
end setBorder_Param

getprop setBorder_Params
   return "0,1,2,3,4,6,8,10,12,14"
end setBorder_Params

on menu_DisplayShapeArray gridView
   put the shape_Array of gridView into shapeArray
   --
   display_Data shapeArray, "shapeArray"
end menu_DisplayShapeArray
