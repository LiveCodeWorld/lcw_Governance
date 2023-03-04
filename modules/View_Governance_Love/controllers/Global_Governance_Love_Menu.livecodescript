script "Global | Governance | Love | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | Governance | Love | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
on menu_Init tObject
   -- called only once for top menu
   pass menu_Init
end menu_Init

getprop menu_Target [tObject]
   -- called once for each menu
   return the display_View of tObject
end menu_Target

getprop menu_CheckTarget [mTarget]
   -- use to do initialisation
   pass menu_CheckTarget
end menu_CheckTarget

getprop test_Param [mTarget]
   return "b"
end test_Param

getprop groupProperties_Params [vObject]
   return the group_Names of vObject
   return "1,2,3"
end groupProperties_Params

getprop checked_TestChecked
   -- put menu_GetChecked (the params)
   return true
end checked_TestChecked


--> Global | Governance | Love | Menu
-
on menu_GroupProperties vObject, gNum
   put the group_Object [gNum] of vObject into sObject
   display_ObjectProperties sObject
end menu_GroupProperties

on _
end _

on submenu_Council
   return "Global | Governance | Council | Menu"
end submenu_Council

on submenu_Committee
   return "Global | Governance | HexText | Menu"
end submenu_Committee

on submenu_Commission
   return "Global | Governance | Commission | Menu"
end submenu_Commission
