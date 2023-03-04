script "Global | Governance | Council | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | Governance | Council | Menu
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
   return the council_View of tObject
end menu_Target

getprop number_Param [cView]
   put the ring_NumberOfPoints of cView into cNum
   return cNum
end number_Param

getprop number_Params [cView]
   return "3,4,5,6,7,8,9,10,11,12,-,ask"
end number_Params


--> Global | Governance | Council | Menu
-
on menu_Number cView, cNum
   if cNum = "ask" then
      put lcw_Ask("How many councillors?", 20) into cNum
   end if
   set the ring_NumberOfPoints of cView to cNum
end menu_Number

on _
end _

on menu_CreateMarkers circleView
   put the card_Object of circleView into cardObject
   put the view_RectOnCard of cardObject into vCardRect
   --
   if the shiftKey is "Down" then breakpoint
   dispatch "LayoutControl" to circleView with vCardRect
end menu_CreateMarkers

on menu_ClearMarkers circleView
   dispatch "ring_ClearThings" to circleView
end menu_ClearMarkers
