script "Global | Governance | Circle | Marker | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Governance | Circle | Marker | Menu
type: controller
version: 0.1

/*
Here you can describe this menu.
Full help text should be provided on the linked wiki.
*/


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
end menu_Target

getprop checked_MarkerDrawn [circleView]
   return the ring_MarkerDrawn of circleView
end checked_MarkerDrawn

getprop checked_MarkerFilled [circleView]
   return the ring_MarkerFilled of circleView
end checked_MarkerFilled

getprop checked_ShowMarkers [circleView]
   put the show_Markers of circleView into isShowing
   return isShowing
end checked_ShowMarkers


--> Global | Governance | Circle | Marker | Menu
-
on menu_ShowMarkers circleView
   put the show_Markers of circleView into isShowing
   set the show_Markers of circleView to (isShowing is false)
end menu_ShowMarkers

on menu_MarkerDrawn circleView
   put the ring_MarkerDrawn of circleView into isShowing
   set the ring_MarkerDrawn of circleView to (isShowing is false)
end menu_MarkerDrawn

on menu_MarkerFilled circleView
   put the ring_MarkerFilled of circleView into isShowing
   set the ring_MarkerFilled of circleView to (isShowing is false)
end menu_MarkerFilled

on menu_RingMarkerScale circleView
   put the ring_MarkerScale of circleView into markerScale
   put lcw_Ask ("Scale ring markers?", markerScale) into markerScale
   set the ring_MarkerScale of circleView to markerScale
end menu_RingMarkerScale

on _
end _

on menu_MarkerColour circleView
   answer color
   put it into sColour
   if sColour is empty then exit to top
   
   set the ring_MarkerColour of circleView to sColour
end menu_MarkerColour

on menu_MarkerBorderColour circleView
   answer color
   put it into sColour
   if sColour is empty then exit to top
   
   set the ring_MarkerBorderColour of circleView to sColour
end menu_MarkerBorderColour

on _
end _

on menu_MarkerStyle circleView
   set the ring_MarkerStyle [22] of circleView to "circle"
end menu_MarkerStyle
