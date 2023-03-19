script "Global | Grid | Model | List | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Grid | Model | List | Menu
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

getprop checked_ListShortFiles [dView]
   return the list_Short of dView
end checked_ListShortFiles

getprop displayedGrid_Param [dView]
   put the displayed_Object of dView into gridView
   if exists (gridView) is false then return empty
   
   put the stack_Name of gridView into stackName
   return stackName
end displayedGrid_Param

getprop displayedGrid_Params
   put revLoadedStacks ("application") into stackNames
   filter stackNames with "View|Grid *"
   return stackNames
end displayedGrid_Params


--> Global | Grid | Model | List | Menu
-
on menu_ListShortFiles dView
   put the list_Short of dView into sBoolean
   if sBoolean is false then
      put grid_ListModelShortFiles() into sIndex
   else
      put grid_ListModelNames() into sIndex
   end if
   --
   set the displayed_Data of dView to sIndex
   set the list_Short of dView to (sBoolean is false)
end menu_ListShortFiles

private command _
end _

on menu_DisplayedGrid dView, stackName
   put the rugged_ID of group 1 of stack stackName into gridView
   set the displayed_Object of dView to gridView
end menu_DisplayedGrid

on menu_Refresh displayView
   display_GridModels
end menu_Refresh
