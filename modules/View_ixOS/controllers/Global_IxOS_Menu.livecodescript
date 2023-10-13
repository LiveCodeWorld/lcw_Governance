script "Global | IxOS | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | IxOS | Menu
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
   put the ix_View of tObject into ixView
   if exists (ixView) is false then
      put the display_View of tObject into dView
      if exists (dView) is false then return empty
      put the displayed_Object of dView into ixView
   end if
   return ixView
end menu_Target

getprop disabled_LinkChart [ixView]
   return true
end disabled_LinkChart

getprop disabled_DisplayChart [ixView]
   return true
end disabled_DisplayChart

getprop checked_ShowHeaders [ixView]
   put the data_Grid of ixView into dGrid
   put the dgProp["show header"] of dGrid into showHeader
   return showHeader
end checked_ShowHeaders

getprop checked_ShowTotal [ixView]
   put the show_Total of ixView into sBoolean
   return sBoolean
end checked_ShowTotal

getprop checked_ShowName [ixView]
   put the showname of ixView into sBoolean
   return sBoolean
end checked_ShowName

getprop checked_ShowMenu [ixView]
   put the show_Menu of ixView into sBoolean
   return sBoolean
end checked_ShowMenu

getprop checked_ShowButton [ixView]
   put the show_Button of ixView into sBoolean
   return sBoolean
end checked_ShowButton

getprop display_Param [ixView]
   return the displayed_Column of ixView
end display_Param

getprop display_Params [ixView]
   -- return "Budget,Income,Shards,-,All"
   put the column_Names of ixView into cNames
   line_Delete "Title", cNames
   replace CR with comma in cNames
   return cNames & ",-,All,None" 
end display_Params

getprop displayFormat_Param [ixView]
   return the display_Format of ixView
end displayFormat_Param

getprop displayFormat_Params
   return "short,abbreviated,number"
end displayFormat_Params

getprop setCurrency_Param [ixView]
   put the currency_Symbol of ixView into cSymbol
   return cSymbol
end setCurrency_Param

getprop setCurrency_Params
   return "£,$,€"
end setCurrency_Params


--> Global | IxOS | Menu
-
on menu_SetIncome ixView
   put the view_ModelName of ixView into pModelName
   --
   put the total_Budget of ixView into sIncome
   put lcw_Ask ("Enter a total income for this project...", sIncome, "Income", ixView) into sIncome
   set the total_Budget [pModelName] of ixView to sIncome
   put the result into vData
   --
   display_Data vData, "vData", pModelName
end menu_SetIncome

on submenu_ModuleData
   return "Global | Module | Model | Menu"
end submenu_ModuleData

private on _
end _

on menu_Display ixView, cName
   set the displayed_Column of ixView to cName
end menu_Display

on menu_DisplayFormat ixView, someHow
   set the display_Format of ixView to someHow
end menu_DisplayFormat

private on __
end __

on menu_SetCurrency ixView, cSymbol
   put the ix_View of ixView into ixView
   set the currency_Symbol of ixView to cSymbol
end menu_SetCurrency

on menu_SetMargin ixView
   put the inner_Margin of ixView into iMargin
   put lcw_Ask("Set the inner_Margin...", iMargin, "inner_Margin", ixView) into iMargin
   set the inner_Margin of ixView to iMargin
end menu_SetMargin

on menu_BackgroundColour ixView
   put the backgroundColor of ixView into startingColor
   answer color with startingColor
   put it into sColour
   if sColour is empty then return false
   
   set the background_Colour of ixView to sColour
end menu_BackgroundColour

private on ___
end ___

on menu_ShowTotal ixView
   put the show_Total of ixView into sBoolean
   set the show_Total of ixView to (sBoolean is false)
end menu_ShowTotal

on menu_ShowMenu ixView
   put the show_Menu of ixView into sBoolean
   set the show_Menu of ixView to (sBoolean is false)
end menu_ShowMenu

on menu_ShowButton ixView
   put the show_Button of ixView into sBoolean
   set the show_Button of ixView to (sBoolean is false)
end menu_ShowButton

on menu_ShowHeaders ixView
   put the data_Grid of ixView into dGrid
   --
   put the dgProp["show header"] of dGrid into showHeader
   set the dgProp["show header"] of dGrid to (showHeader is false)
end menu_ShowHeaders

private on ____
end ____

on menu_MouseUpCommand ixView
   put the mouse_Up of ixView into mUp
   put lcw_Ask ("Set the mouse-up command...", mUp, "display_Description") into mUp
   set the mouse_Up of ixView to mUp
end menu_MouseUpCommand

on menu_MouseDoubleUpCommand ixView
   put the mouse_DoubleUp of ixView into mDoubleUp
   put lcw_Ask ("Set the double-click command...", mDoubleUp, "display_Description") into mDoubleUp
   set the mouse_DoubleUp of ixView to mDoubleUp
end menu_MouseDoubleUpCommand

private on _____
end _____

on submenu_Chart
   return "Global | IxOS | Chart | Menu"
end submenu_Chart

on submenu_LinkChart
   return "Global | IxOS | Chart | Create | Menu"
end submenu_LinkChart

on submenu_DisplayChart
   return "Global | IxOS | Chart | Display | Menu"
end submenu_DisplayChart

private on ______
end ______

on menu_RefreshDataGrid ixView
   put the data_Grid of ixView into dGrid
   --
   dispatch "RefreshList" to dGrid
   dispatch "LayoutControl" to ixView
end menu_RefreshDataGrid

on submenu_Dev
   return "Global | IxOS | Test | Menu"
end submenu_Dev
