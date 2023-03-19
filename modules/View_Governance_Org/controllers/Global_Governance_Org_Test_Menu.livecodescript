script "Global | Governance | Org | Test | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Governance | Org | Test | Menu
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
   return the org_View of tObject
   -- return display_MenuTarget(tObject)
   -- return the display_View of tObject
end menu_Target

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

private function _AuthoringBehavior gridView
   put the behavior_Objects of gridView into bObjects
   put bObjects contains the name of stack "behavior_CreateGovernanceView" into sBoolean
   return sBoolean
end _AuthoringBehavior

getprop shapeArray_Params
   return "VSM,Right Bar,Bars,Cool,Block"
end shapeArray_Params

getprop testShape_Params
   return "VSM,Right Bar,Bars,Cool,Block"
end testShape_Params

getprop checked_AuthoringBehavior [gridView]
   return _AuthoringBehavior (gridView)
end checked_AuthoringBehavior


--> Global | Governance | Org | Test | Menu
-
on menu_TestShape gridView, whichShape
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
end menu_TestShape

on menu_Clear gridView
   grid_DeleteTiles gridView
end menu_Clear

on menu_EditCreateBehavior
   edit the script of stack "behavior_CreateGovernanceView" 
end menu_EditCreateBehavior

private command _
end _

on menu_DisplayGridArray gridView
   put the grid_Array of gridView into gridArray
   display_Array gridArray
end menu_DisplayGridArray

on menu_DisplayGridRectArray gridView
   put the grid_RectArray of gridView into gridRectArray
   display_Array gridRectArray
end menu_DisplayGridRectArray

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

private command __
end __

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

private command _
end _

on menu_Graphic gridView
   put the control_Type of btn "Platform" of gridView
   set the control_Type of btn "Platform" of gridView to "graphic"
end menu_Graphic
