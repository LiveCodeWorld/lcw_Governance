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
getprop menu_Target [tObject]
   put the grid_View of tObject into gridView
   --
   put grid_ListModelNames() into LocalArray ["MenuModelNames"]
   --
   return gridView
end menu_Target

getprop displayShapeData_Params [gridView]
   return LocalArray ["MenuModelNames"]
end displayShapeData_Params

getprop setGrid_Param [gridView]
   put the grid_ShapeTitle of gridView into gridShapeTitle
   return gridShapeTitle
end setGrid_Param

getprop setGrid_Params
   return LocalArray ["MenuModelNames"]
end setGrid_Params

getprop checked_Constrain [gridView]
   return the constrain_Grid of gridView is true
end checked_Constrain

getprop setBorder_Param [gridView]
   put the borderWidth of gridView into bWidth
   return bWidth
end setBorder_Param

getprop setBorder_Params
   return "0,1,2,3,4,6,8,10,12,14"
end setBorder_Params

getprop setProportions_Param [gridView]
   put the tile_Proportions of gridView into tProportions
   put the grid_Dimensions of gridView into gDimensions
   switch
      case tProportions = gDimensions
         return "Square"
      case tProportions = "1,1"
         return "Square Grid"
      case tProportions = "4,3"
         return "TV"
      case tProportions = "16,9"
         return "Cinema"
      default
         return "ask"
   end switch
end setProportions_Param

getprop setProportions_Params
   return "Cinema,Square,TV,-,Square Grid,Empty,Ask"
end setProportions_Params


--> Global | Grid | Menu
-
on menu_ShapeDataTitle gridView
   put the displayed_Data of gridView into shapeData
   --
   put shapeData ["title"] into sTitle
   put lcw_Ask ("Set the title of this shapeData model...", sTitle, "Shape Data", gridView) into sTitle
   put sTitle into shapeData ["title"]
   --
   set the shape_Data of gridView to shapeData
   -- put the displayed_Data of gridView into shapeData
   
   display_GridShapeData shapeData, gridView
end menu_ShapeDataTitle

on menu_ExportShapeData gridView
   -- ask_ExportModuleData gridView, true
   put the displayed_Data of gridView into shapeData
   put the view_ModelName of gridView into modelName
   put lcw_Ask ("What name would you like for this model?", modelName) into shapeTitle
   --
   put shapeTitle into shapeData ["title"]
   grid_SetShapeData shapeTitle, shapeData
end menu_ExportShapeData

private command _
end _

on menu_SetGrid gridView, shapeTitle
   set grid_ShapeTitle of gridView to shapeTitle
end menu_SetGrid

on menu_SetTileMargins gridView
   put lcw_Ask ("Set tile margins...", "8,8,8,8", "Tile Margins", gridView) into tMargins
   set the title_Margins of gridView to tMargins
end menu_SetTileMargins

on menu_SaveFaded gridView
   put the displayed_Data of gridView into shapeData
   put shapeData ["shape_Array"] into shapeArray
   --
   repeat with itemNum = 1 to item 2 of the extents of shapeArray
      put shapeArray [itemNum] into propArray
      put shapeArray [itemNum]["id"] into shortID
      if exists (control id shortID of gridView) is false then next repeat
      put the long id of control id shortID of gridView into tileObject
      --
      put the tile_Faded of tileObject into sBoolean
      put sBoolean into shapeData ["shape_Array"][itemNum]["tile_Faded"]
   end repeat
   --
   set the shape_Data of gridView to shapeData
   display_GridShapeData shapeData, gridView
end menu_SaveFaded

private command ____
end ____

on menu_Constrain gridView
   put the card_Object of gridView into cObject
   put the inner_Rect ["20"] of cObject into someRect
   --
   put the constrain_Grid of gridView into sBoolean
   set the constrain_Grid [someRect] of gridView to (sBoolean is false)
end menu_Constrain

on menu_SetProportions gridView, tProportions
   switch tProportions
      case "Ask"
         put lcw_Ask ("Set proportions...", "4,3", "Proportions", gridView) into tProportions
         if tProportions is not a point then
            return empty
         end if
         break
   end switch
   set the tile_Proportions of gridView to tProportions
end menu_SetProportions

on menu_SetBorder gridView, bWidth
   lock screen
   put the rect of gridView into oRect
   set the borderWidth of gridView to bWidth
   set the rect of gridView to oRect
   unlock screen
end menu_SetBorder

private command __
end __

on menu_DisplayedData gridView
   put the displayed_Data of gridView into shapeData
   display_GridShapeData shapeData, gridView
end menu_DisplayedData

on menu_ListGridModels gridView
   display_GridModels gridView
end menu_ListGridModels

on menu_DisplayShapeData gridView, whichShape
   put grid_GetShapeData (whichShape) into shapeData
   --
   -- put whichShape into shapeData ["title"] -- should already be set
   display_GridShapeData shapeData, gridView
end menu_DisplayShapeData

private command ___
end ___

on submenu_Create
   return "Global | Grid | Create | Menu"
end submenu_Create

on submenu_Test
   return "Global | Grid | Test | Menu"
end submenu_Test
