script "Global | IxOS | Input | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | IxOS | Input | Menu
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


--> Global | IxOS | Input | Menu
-
on menu_SetLinked displayView
   put the card_TopViews ["View|IxOS"] of displayView
end menu_SetLinked

on menu_Behavior displayView
   put the behavior of displayView into bObject
   edit the script of bObject
end menu_Behavior

private on _
end _

on submenu_Dev
   return menu_DevTitle ("Global | IxOS | Input | Menu")
end submenu_Dev
