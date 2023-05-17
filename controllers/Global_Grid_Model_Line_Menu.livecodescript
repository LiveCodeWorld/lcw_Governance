script "Global | Grid | Model | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Grid | Model | Line | Menu
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
   put the display_View of tObject into dView
   put _TileObject (dView) into LocalArray ["tileObject"]
   return dView
end menu_Target

private function _TileExists
   put LocalArray ["tileObject"] into tileObject
   put exists (tileObject) into sBoolean
   return sBoolean
end _TileExists

private function _TileObject dView
   _SetArrays dView, shapeData, propArray
   put propArray ["id"] into shortID
   --
   put _GridView (dView) into gridView
   if exists (control id shortID of gridView) then
      put the long id of control id shortID of gridView into tileObject
      return tileObject
   else
      return empty
   end if
end _TileObject

private function _GridView dView
   if exists (dView) then
      put the displayed_Object of dView into gridView
      if exists (gridView) then
         return gridView
      end if
   end if
   --
   put grid_DisplayView() into gridView
   return gridView
end _GridView

command _SetArrays dView @shapeData, @propArray
   put the displayed_Data of dView into shapeData
   --
   put the selected_Path of dView into commaItems
   --
   put item 1 to 2 of commaItems into arrayKey
   split arrayKey with comma
   put shapeData [arrayKey] into propArray
   --
   return commaItems
end _SetArrays

private function _SelectedArrowItemNum dView
   put the selected_Path of dView into commaItems
   if item 1 of commaItems is not "grid_ArrowData" then return 0
   return item 2 of commaItems
end _SelectedArrowItemNum

private command _CreateAndFix @gridData, shapeData, gridView, dView, indexNum
   put shapeData ["grid_ArrowData"][indexNum] into propArray
   if propArray is not an array then return false
   --
   put propArray ["from_Name"] into fromName
   put propArray ["to_Name"] into toName
   --
   put propArray ["from_Number"] into fromNumber
   put propArray ["to_Number"] into toNumber
   --
   put gridData ["shape_Array"][fromNumber]["id"] into fromID
   if exists (control id fromID of gridView) is false then
      breakpoint
      exit to top
   end if
   put gridData ["shape_Array"][toNumber]["id"] into toID
   if exists (control id toID of gridView) is false then
      breakpoint
      exit to top
   end if
   
   put the long id of control id fromID of gridView into fromObject
   put the long id of control id toID of gridView into toObject
   -- 
   _CreateArrowLink fromObject, toObject, gridView, propArray
   put the result into arrowView
   --
   put "Arrow" && fromNumber,toNumber into aName
   set the name of arrowView to aName
   
   # Fix names
   set the name of fromObject to fromName
   set the label of fromObject to fromNumber
   set the tooltip of fromObject to fromName
   --
   set the name of toObject to toName
   set the label of toObject to toNumber
   set the tooltip of toObject to toName
   
   # Fix Data
   tile_FixShapeData gridData, indexNum
   put fromID into gridData ["shape_Array"][fromNumber]["id"]
   put toID into gridData ["shape_Array"][toNumber]["id"]
   
   put aName
end _CreateAndFix

private command _CreateArrowLink fromTile, toTile, gridView, propArray
   lock screen
   view_InsertFromPath "View|ixOS|Arc", gridView
   put the result into aView
   --
   set the lineSize of aView to 4
   set the startArrow of aView to false
   set the endArrow of aView to false
   --
   set the from_Object of aView to fromTile
   set the to_Object of aView to toTile
   --
   set the from_Side of aView to propArray ["from_Side"]
   set the from_StepNum of aView to propArray ["from_StepNum"]
   set the from_SliceNum of aView to propArray ["from_SliceNum"]
   --
   set the to_Side of aView to propArray ["to_Side"]
   set the to_StepNum of aView to propArray ["to_StepNum"]
   set the to_SliceNum of aView to propArray ["to_SliceNum"]
   --
   dispatch "LayoutControl" to aView
   unlock screen
   --
   return aView
end _CreateArrowLink

command tile_FixShapeData @shapeData, indexNum
put shapeData ["grid_ArrowData"][indexNum] into propArray
if propArray is not an array then return false
--
put propArray ["from_Name"] into fromName
put propArray ["to_Name"] into toName
--
put propArray ["from_Number"] into fromNumber
put propArray ["to_Number"] into toNumber
--
put fromName into shapeData ["shape_Array"][fromNumber]["name"]
put fromNumber into shapeData ["shape_Array"][fromNumber]["label"]
--
put toName into shapeData ["shape_Array"][toNumber]["name"]
put toNumber into shapeData ["shape_Array"][toNumber]["label"]
--
return true
end tile_FixShapeData

private command _SetSelectedItemArray displayView, sValue, pName
   put the displayed_Object of displayView into gridView
   put the selected_Path of displayView into arrayKey
   if pName is not empty then
      put pName into item 3 of arrayKey
   end if
   split arrayKey with comma
   
   put the displayed_Data of displayView into shapeData
   put sValue into shapeData [arrayKey]
   set the displayed_Data of displayView to shapeData  
end _SetSelectedItemArray

private command _DeleteSelectedItemArray displayView, pName
   put the displayed_Object of displayView into gridView
   put the selected_Path of displayView into arrayKey
   if pName is not empty then
      put pName into item 3 of arrayKey
   end if
   split arrayKey with comma
   
   put the displayed_Data of displayView into shapeData
   delete variable shapeData [arrayKey]
   set the displayed_Data of displayView to shapeData  
end _DeleteSelectedItemArray

getprop moveTo_Param [displayView]
   put the selected_Path of displayView into commaItems
   put item 2 of commaItems into fromNum
   return fromNum
end moveTo_Param

getprop moveTo_Params
   return "1,2,3,4,5,6,7"
end moveTo_Params

getprop disabled_TileStyle [displayView]
   return _TileExists() is false
end disabled_TileStyle

getprop disabled_TestRect
   return _TileExists() is false
end disabled_TestRect

getprop tileStyle_Param [displayView]
   put _TileObject (displayView) into tileObject
   return the tile_Style of tileObject
end tileStyle_Param

getprop tileStyle_Params [displayView]
   put _TileObject (displayView) into tileObject
   return the tile_Styles of tileObject
end tileStyle_Params

getprop disabled_CreateArrow [dView]
   put the selected_Path of dView into commaItems
   put item 1 of commaItems = "grid_ArrowData" into sBoolean
   return sBoolean is false
end disabled_CreateArrow


--> Global | Grid | Model | Line | Menu
-
on menu_CreateArrow dView
   put _GridView (dView) into gridView
   put the displayed_data of gridView into gridData
   put the displayed_data of dView into shapeData
   --
   put shapeData ["grid_ArrowData"] into arrowData
   repeat with indexNum = 1 to item 2 of the extents of arrowData
      _CreateAndFix gridData, shapeData, gridView, dView, indexNum
   end repeat
   --
   set the displayed_data of dView to gridData
   set the shape_Data of gridView to gridData
end menu_CreateArrow

on menu_RenameTiles  dView
   put _SelectedArrowItemNum (dView) into indexNum
   --
   put the displayed_data of dView into shapeData
   tile_FixShapeData shapeData, indexNum
   set the displayed_data of dView to shapeData
   --
   put _GridView (dView) into gridView
end menu_RenameTiles

private command _
end _

on menu_SetControlType displayView
   put the displayed_Object of displayView into gridView
   --
   put "control_Type" into sKey
   put the selected_Value of displayView into someLine
   put lcw_Ask ("What type of control...", someLine) into newValue
   
   put the selected_Path of displayView into commaItems
   put sKey into item -1 of commaItems
   put commaItems into arrayKey
   
   put the displayed_Data of displayView into shapeData
   put the parent_Array of displayView into pArray
   put pArray ["id"] into shortID
   --
   split arrayKey with comma
   put newValue into shapeData [arrayKey]
   --
   breakpoint
   if exists (control id shortID of gridView) then
      set the sKey of control id shortID of gridView to newValue
      set the shape_Data of gridView to shapeData
   end if
   --
   set the displayed_Data of displayView to shapeData
end menu_SetControlType

on menu_TileStyle displayView, tStyle
   put _TileObject (displayView) into tileObject
   set the tile_Style of tileObject to tStyle
   --
   _DeleteSelectedItemArray displayView, "style"
   _SetSelectedItemArray displayView, tStyle, "tile_Style"
end menu_TileStyle

on menu_MoveTo displayView, toNum
   put the displayed_Data of displayView into shapeData
   put shapeData ["shape_Array"] into shapeArray
   put the selected_Path of displayView into commaItems
   put item 2 of commaItems into fromNum
   --
   array_IndexMove shapeArray, fromNum, toNum
   put shapeArray into shapeData ["shape_Array"]
   --
   set the displayed_Data of displayView to shapeData
end menu_MoveTo

private command __
end __

on menu_AddProperty displayView
   put the displayed_Object of displayView into gridView
   put the selected_Path of displayView into commaItems
   put item 3 of commaItems into pName
   if pName is emty then put "icon_Name" into pName
   --
   put lcw_Ask ("Property name...", pName) into pName
   put lcw_Ask ("Property value...", "sitemap") into pValue
   --
   put item 1 to 2 of commaItems into arrayKey
   put pName into item 3 of arrayKey
   split arrayKey with comma
   
   # Set Displayed Data
   put the displayed_Data of displayView into shapeData
   put pValue into shapeData [arrayKey]
   set the displayed_Data of displayView to shapeData
   --
   
   # Set control props
   put "id" into arrayKey [3]
   put shapeData [arrayKey] into shortID
   if exists (control id shortID of gridView) then
      set the pName of control id shortID of gridView to pValue
      set the shape_Data of gridView to shapeData
   end if
end menu_AddProperty

on menu_DeleteProperty displayView
   put the selected_Path of displayView into arrayKey
   put item -1 of arrayKey into propName
   lcw_Answer "Delete value '[[propName]]'?", displayView, propName
   --
   put the displayed_Object of displayView into gridView
   split arrayKey with comma
   --
   put the displayed_Data of displayView into shapeData
   delete variable shapeData [arrayKey]
   set the displayed_Data of displayView to shapeData
   --
   set the shape_Data of gridView to shapeData
end menu_DeleteProperty

on menu_EditLine displayView
   grid_EditDisplayLine displayView
end menu_EditLine

private command ___
end ___

on menu_TestRect displayView
   _SetArrays displayView, shapeData, propArray
   --
   put shapeData ["grid_Dimensions"] into gridDimensions
   put item 1 of gridDimensions into tilesAcross
   put item 2 of gridDimensions into tilesDown
   --
   put propArray ["id"] into shortID
   --
   put the displayed_Object of displayView into gridView
   if exists (control id shortID of gridView) then
      put the rect of gridView into frameRect
      put the long id of control id shortID of gridView into tileObject
      --
      put propArray ["tile_Rect"] into tileRect
      put propArray ["tile_Points"] into tilePoints
      --
      switch
         case tilePoints is not empty
            put the tile_Rect of tileObject into sPoints
            put tile_GetPoints (tilePoints, frameRect, tilesAcross) into sPoints
            put sPoints
            set the points of tileObject to sPoints
            break
         case tileRect is not empty
            put grid_GetRect (tileRect, frameRect, tilesAcross, tilesDown) into sRect
            put the rect of tileObject
            set the rect of tileObject to sRect
            break
         default
            breakpoint
      end switch
   end if
end menu_TestRect

