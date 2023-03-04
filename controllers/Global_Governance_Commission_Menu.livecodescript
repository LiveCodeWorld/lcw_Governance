script "Global | Governance | Commission | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Governance | Commission | Menu
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
   return the commission_View of tObject
end menu_Target

getprop number_Param [cView]
   put the ring_NumberOfPoints of cView into cNum
   return cNum
end number_Param

getprop number_Params [cView]
   return "3,4,5,6,7,8,9,10,11,12,-,ask"
end number_Params


--> Global | Governance | Commission | Menu
-
on menu_StyleCommission cView
   set the ring_MarkerColour of cView to "blue"
end menu_StyleCommission

on menu_Number cView, cNum
   if cNum = "ask" then
      put lcw_Ask("How many commissioners?", 5) into cNum
   end if
   set the ring_NumberOfPoints of cView to cNum
end menu_Number

on _
end _

on menu_RingColour cView
   put displayView
end menu_RingColour

on submenu_Ring
   return "Global | Governance | Circle | Menu"
end submenu_Ring
