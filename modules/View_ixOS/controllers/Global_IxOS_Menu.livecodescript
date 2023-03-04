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
   --
   put the displayed_Data of ixView into vData
   put vData into LocalArray ["displayed_Data"]
   --
   put the displayed_AbbreviatedData of ixView into aData
   put aData into LocalArray ["displayed_AbbreviatedData"]
   --
   put the view_ModelName of ixView into vName
   put the saved_Data [vName] of ixView into savedData
   put savedData into LocalArray ["saved_Data"]
   --
   put the module_ModelNames of ixView into modelNames
   put modelNames into LocalArray ["module_ModelNames"]
   --
   return ixView
end menu_Target

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
   return the display_Format of ixView
end display_Param

getprop display_Params
   return _Formats()
end display_Params

private function _Formats
   return "short,abbreviated,number"
end _Formats


--> Global | IxOS | Menu
-
on menu_Display ixView, someHow
   set the display_Format of ixView to someHow
end menu_Display

private on _
end _

on menu_Rename ixView
   put the short name of ixView into ixName
   put lcw_Ask ("Rename this view...", ixName, "Rename", ixView) into newName
   set the name of newName to newName
end menu_Rename

on menu_NameLinked ixView
end menu_NameLinked

private on __
end __

on menu_ShowMenu ixView
   put the show_Menu of ixView into sBoolean
   set the show_Menu of ixView to (sBoolean is false)
end menu_ShowMenu

on menu_ShowButton ixView
   put the show_Button of ixView into sBoolean
   set the show_Button of ixView to (sBoolean is false)
end menu_ShowButton

on menu_SetMargin ixView
   put the inner_Margin of ixView into iMargin
   put lcw_Ask("Set the inner_Margin...", iMargin, "inner_Margin", ixView) into iMargin
   set the inner_Margin of ixView to iMargin
end menu_SetMargin

private on ___
end ___

on submenu_Chart
   return "Global | IxOS | Chart | Menu"
end submenu_Chart

on submenu_DisplayChart
   return "Global | IxOS | Chart | Display | Menu"
end submenu_DisplayChart

on submenu_CreateChart
   return "Global | IxOS | Chart | Create | Menu"
end submenu_CreateChart

getprop checked_NameLinked [ixView]
   put the name_Linked of ixView into sBoolean
   return sBoolean is true
end checked_NameLinked
   
private on ____
end ____

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

on menu_SaveData ixView
   dispatch "save_Data" to ixView
   get the result
   --
   put the displayed_Data [true] of ixView into testData
   display_Data testData, mName, "displayed_Data"
end menu_SaveData

on menu_ClearData ixView
   dispatch "clear_Data" to ixView
   set the displayed_Data of ixView to empty
end menu_ClearData

on submenu_ModuleData
   return "Global | Module | Model | Menu"
end submenu_ModuleData

private on _____
end _____

on submenu_Test
   return "Global | IxOS | Test | Menu"
end submenu_Test

