script "Global | Hubspot | Contacts | Line | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | Hubspot | Contacts | Line | Menu
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
   return tObject
end menu_Target

private function _GetArray displayView
   if the number of items of the selected_Path of displayView = 1 then
      put the selected_Array of displayView into tArray
   else
      put the top_Array of displayView into tArray
   end if
   return tArray
end _GetArray


--> Global | Hubspot | Contacts | Line | Menu
-
on menu_DisplayContact displayView
   put _GetArray (displayView) into tArray
   put tArray ["id"] into contactID
   --
   put hubspot_FetchContact (contactID) into contactArray
   --
   display_Data contactArray, contactID
end menu_DisplayContact

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_Experiment displayView
   put displayView
end menu_Experiment


--> Deps
-
