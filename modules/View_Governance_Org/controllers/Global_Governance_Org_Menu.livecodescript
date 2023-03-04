script "Global_Governance_Org_Menu"
--> MetaData
-
license: GPLv3
name: Global_Governance_Org_Menu
type: controller
version: 0.1

local LocalArray


--> Menu | Props
-
getprop test_Params
   return "VSM,Right Bar,Bars,Cool,Block"
end test_Params

getprop shapeArray_Params
   return "VSM,Right Bar,Bars,Cool,Block"
end shapeArray_Params

getprop shape_Param
   return LocalArray ["which_Shape"]
end shape_Param

getprop shape_Params
   return "VSM,Right Bar,Bars,Cool,Block"
end shape_Params

getprop buttonView_Param [gridView]
   put the button_View of gridView into btnView
   return true
end buttonView_Param

getprop buttonView_Params [gridView]
   return "true,false"
end buttonView_Params

getprop fixedSquare_Param [gridView]
   put the fixed_Square of gridView into someBoolean
   return someBoolean
end fixedSquare_Param

getprop fixedSquare_Params
   return "true,false"
end fixedSquare_Params

getprop showBorders_Param [gridView]
   return the show_Borders of gridView
end showBorders_Param

getprop showBorders_Params
   return "true,false"
end showBorders_Params

getprop showNames_Param [gridView]
   return the show_Names of gridView
end showNames_Param

getprop showNames_Params
   return "true,false"
end showNames_Params

getprop tilesAcross_Param [gridView]
   return the tiles_Across of gridView
end tilesAcross_Param

getprop tilesAcross_Params
   return "1,2,3,4,5,6,7,8,9,10"
end tilesAcross_Params

getprop checked_AuthoringBehavior [gridView]
   return _AuthoringBehavior (gridView)
end checked_AuthoringBehavior

private function _AuthoringBehavior gridView
   put the behavior_Objects of gridView into bObjects
   put bObjects contains the name of stack "behavior_CreateGovernanceView" into sBoolean
   return sBoolean
end _AuthoringBehavior


--> Global | Governance | Org | Menu
-
on menu_Test gridView, whichShape
   put tile_GetShapeArray (whichShape) into shapeArray
   -- put tile_GetShapeArray ("Block") into shapeArray
   --
   _CreateTest
   put the result into inObject
   put the long id of group 1 of stack "Test Create" into inObject
   --
   grid_DeleteTiles inObject
   --
   put the inner_Rect ["20"] of card 1 of stack "Test Create" into someRect
   -- put rect_GetSquare (someRect, 0) into someRect
   --
   tile_Create shapeArray, inObject, someRect, 10
   --
   put someRect & CR & the rect of inObject
end menu_Test

command _CreateTest
   if exists (stack "Test Create") is false then
      create stack "Test Create"
   end if
   
   if exists (group "Test" of card 1 of stack "Test Create") is false then
      create group "Test" in card 1 of stack "Test Create"
      put the result into groupObject
   else
      put the long id of group "Test" of card 1 of stack "Test Create" into groupObject
   end if
   return groupObject
end _CreateTest

on menu_Clear
   put the long id of group 1 of stack "Test Create" into inObject
   grid_DeleteTiles inObject
end menu_Clear

on _
end _

on menu_DisplayLocalArray gridView
   put the local_Array of gridView into dArray
   put the stack_Name of gridView into sName
   
   display_Data dArray, "LocalArray", sName
end menu_DisplayLocalArray

on menu_ShapeArray gridView, whichShape
   put tile_GetShapeArray (whichShape) into shapeArray
   --
   display_Data shapeArray, whichShape, "tile_GetShapeArray (whichShape)"
end menu_ShapeArray

on menu_Shape gridView, whichShape
   lock screen
   --
   put tile_GetShapeArray (whichShape) into shapArray
   put whichShape into LocalArray ["which_Shape"]
   set the element_Array [10] of gridView to shapArray
   -- set the show_Names of gridView to true
   --
   unlock screen
end menu_Shape

on menu_FixedSquare gridView, someBoolean
   set the fixed_Square of gridView to someBoolean
end menu_FixedSquare

on _
end _

on menu_AuthoringBehavior gridView
   if _AuthoringBehavior (gridView) then
      put the name of stack "behavior_ViewGovernanceOrg" into bObject
      set the behavior of stack "behavior_ViewGovernanceOrg" to empty
      set the behavior of gridView to bObject
   else
      put the module_Behaviors of gridView into moduleBehaviors
      set the behavior_Objects of gridView to moduleBehaviors
   end if
   dispatch "preOpenControl" to gridView
end menu_AuthoringBehavior

on menu_TilesAcross gridView, tileNum
   set the tiles_Across of gridView to tileNum
end menu_TilesAcross

on menu_ButtonView gridView, someBoolean
   set the button_View of gridView to someBoolean
end menu_ButtonView

on menu_ShowNames gridView, someBoolean
   set the show_Names of gridView to someBoolean
end menu_ShowNames

on menu_ShowBorders gridView, someBoolean
   set the show_Borders of gridView to someBoolean
end menu_ShowBorders

on _
end _

on menu_Graphic gridView
   put the control_Type of btn "Platform" of gridView
   set the control_Type of btn "Platform" of gridView to "graphic"
end menu_Graphic

on menu_DisplayGridArray gridView
   put the grid_Array of gridView into gridArray
   display_Array gridArray
end menu_DisplayGridArray

on menu_DisplayGridRectArray gridView
   put the grid_RectArray of gridView into gridRectArray
   display_Array gridRectArray
end menu_DisplayGridRectArray

