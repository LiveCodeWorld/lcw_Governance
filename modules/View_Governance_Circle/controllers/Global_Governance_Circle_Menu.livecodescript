script "Global | Governance | Circle | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | Governance | Circle | Menu
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
   put the commission_View of tObject into cView -- hack
   if exists (cView) then return cView
   --
   put the cicle_View of tObject into cView
   return cView
   -- return the display_View of tObject
end menu_Target

getprop disabled_ShowRing [circleView]
   if the ring_Width of circleView is empty then
      return true
   else
      return false
   end if
end disabled_ShowRing

getprop checked_ShowRing [circleView]
   return the show_Ring of circleView
end checked_ShowRing

getprop checked_ShowRingLines [circleView]
   return the ring_ShowLines of circleView
end checked_ShowRingLines

getprop checked_RingIsOpaque [circleView]
   return the ring_IsOpaque of circleView
end checked_RingIsOpaque

getprop checked_ConstrainCircle [circleView]
   return the constrain_Circle of circleView
end checked_ConstrainCircle
   
   getprop setPeople_Params
   return "Person,Graphic,-,Empty"
end setPeople_Params


--> Global | Governance | Circle | Menu
-
on menu_ConstrainCircle circleView
   put the constrain_Circle of circleView into sBoolean
   set the constrain_Circle of circleView to (sBoolean is false)
end menu_ConstrainCircle

on menu_SetPeople circleView, pType
   switch pType
      case "Person"
         set the marker_Views of circleView to "View|Governance|Person"
         break
      case "Graphic"
         set the marker_Views of circleView to "graphic"
         break
      case "Empty"
         set the marker_Views of circleView to empty
         break
   end switch   
end menu_SetPeople

on menu_RingColour circleView
   answer color
   put it into sColour
   if sColour is empty then exit to top
   
   lock screen
   set the oval_Colour of circleView to sColour
   set the show_Ring of circleView to true
   set the ring_IsOpaque of circleView to false
   set the ring_Width of circleView to 0
   unlock screen
end menu_RingColour

on _
end _

on menu_ShowRing circleView
   put the show_Ring of circleView into isShowing
   set the show_Ring of circleView to (isShowing is false)
end menu_ShowRing

on menu_RingIsOpaque circleView
   put the ring_IsOpaque of circleView into sBoolean
   set the ring_IsOpaque of circleView to (sBoolean is false)
end menu_RingIsOpaque

on menu_ShowRingLines circleView
   put the ring_ShowLines of circleView into sBoolean
   set the ring_ShowLines of circleView to (sBoolean is false)
end menu_ShowRingLines

on submenu_Ring
   return "Global | Governance | Circle | Ring | Menu"
end submenu_Ring

on submenu_Marker
   return "Global | Governance | Circle | Marker | Menu"
end submenu_Marker
