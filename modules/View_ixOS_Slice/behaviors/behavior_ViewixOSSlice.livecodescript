script "behavior_ViewixOSSlice"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewixOsSlice
type: behavior
version: 0.1

--> Variables
-
local LocalArray


--> Working on
-
getprop name_Linked
   _SetNamedObjects empty, ixView, chartWidget
   return the result
end name_Linked

on nameChanged pOldName, pNewName
   _SetNamedObjects pOldName, ixView, chartWidget
   if the result is true then
      _SetNames pNewName, ixName, chartName
      --
      set the lockmessages to true
      set the name of ixView to ixName
      set the name of chartWidget to chartName
      set the lockmessages to false
   end if
end namechanged

private command _SetNamedObjects pGraphicName, @ixView, @chartWidget
   _SetNames pGraphicName, ixName, chartName
   --
   if exists (widget chartName) then
      put the long id of widget chartName into chartWidget
   else
      put empty into chartWidget
   end if
   
   if exists (group ixName) then
      put the long id of group ixName into ixView
   else
      put empty into ixView      
   end if
   --
   return (ixView is not empty) AND (chartWidget is not empty)
end _SetNamedObjects

private command _SetNames pGraphicName, @ixName, @chartName
   if pGraphicName is empty then
      put the short name of me into pGraphicName -- "View|ixOS|Slice"
   end if
   
   set the itemDelimiter to "|"
   --
   put item 1 to -2 pGraphicName into ixName
   put ixName & "|Chart" into chartName
   --
   return pGraphicName
end _SetNames


--> Colour
-
getprop colour_PaletteData
   put the colour_Palette of me into cPaletteData ["palette"]
   put the colour_PaletteTitle of me into cPaletteData ["title"]
   return cPaletteData
end colour_PaletteData

setprop colour_PaletteData cPaletteData
   -- display_Data cPaletteData, "colour_Palette"
   put cPaletteData ["title"] into pTitle
   put cPaletteData ["palette"] into paletteArray
   --
   set the colour_Palette [pTitle] of me to paletteArray
end colour_PaletteData

getprop colour_Palette
   local paletteArray
   
   put the backgroundcolor of me into someRGB
   colorMind_AddToArray paletteArray, 3, someRGB
   --
   put the backgroundcolor of _IxView() into someRGB
   colorMind_AddToArray paletteArray, 1, someRGB
   --
   put the hilitecolor of _IxView() into someRGB
   colorMind_AddToArray paletteArray, 2, someRGB
   --
   put the bordercolor of _IxView() into someRGB
   colorMind_AddToArray paletteArray, 4, someRGB
   --
   put the foregroundcolor of _IxView() into someRGB
   colorMind_AddToArray paletteArray, 5, someRGB
   --
   return cArray
end colour_Palette

setprop colour_Palette [pTitle] paletteArray
   if pTitle is not empty then
      set the colour_PaletteTitle of me to pTitle
   end if
   
   set the backgroundcolor of me to colorMind_GetFromArray (3, paletteArray)
   --
   set the backgroundcolor of _IxView() to colorMind_GetFromArray (1, paletteArray)
   set the foregroundcolor of _IxView() to colorMind_GetFromArray (5, paletteArray)
   --
   set the hilitecolor of _IxView() to colorMind_GetFromArray (2, paletteArray)
   set the bordercolor of _IxView() to colorMind_GetFromArray (4, paletteArray)
   --
   return empty   
end colour_Palette


--> Geometry
-
getprop chart_Rect
   put the rect of me into pRect
   _SetRects pRect, ixRect, chartRect
   return chartRect
end chart_Rect

private command _SetRects pRect, @ixRect, @chartRect
   put pRect into innerRect
   put the inner_Margin of me into innerMargin
   rect_SubtractMargins innerRect, innerMargin
   --
   put item 3 of innerRect - item 1 of innerRect into innerWidth
   put (innerWidth - innerMargin) / 2 into halfWidth
   
   put innerRect into ixRect
   put item 1 of ixRect + halfWidth into ixRight
   put ixRight into item 3 of ixRect
   --
   put innerRect into chartRect
   put item 3 of chartRect - halfWidth into chartLeft
   put chartLeft into item 1 of chartRect
   --
   return innerRect
end _SetRects

getprop inner_Margin
   return 40
end inner_Margin

command LayoutControl pRect
   if pRect is not a rect then
      put the rect of me into pRect
   else
      set the rect of me to pRect
   end if
   
   # Geometry
   _SetRects pRect, ixRect, chartRect
   put the result into innerRect
   
   # Set Rects
   _SetNamedObjects empty, ixView, chartWidget
   if exists (ixView) then set the rect of ixView to ixRect
   --
   if exists (chartWidget) then set the rect of chartWidget to chartRect
   --
   return innerRect
end LayoutControl

command LayoutControl pRect
   if pRect is not a rect then
      put the rect of me into pRect
   else
      set the rect of me to pRect
   end if
   --
   put the inner_Margin of me into innerMargin
   --
   rect_SubtractMargins pRect, innerMargin
   put item 3 of pRect - item 1 of pRect into innerWidth
   put (innerWidth - innerMargin) / 2 into halfWidth
   
   put _IxView() into ixView
   if exists (ixView) then
      put pRect into ixRect
      put item 1 of ixRect + halfWidth into ixRight
      put ixRight into item 3 of ixRect
      --
      set the rect of ixView to ixRect
   end if
   --
   put _ChartWidget() into chartView
   if exists (chartView) then
      put pRect into chartRect
      put item 3 of chartRect - halfWidth into chartLeft
      put chartLeft into item 1 of chartRect
      --
      set the rect of chartView to chartRect
   end if
end LayoutControl


--> Events
-
on mouseDown pButtonNumber
   --  LayoutControl
   switch pButtonNumber
      case 3
         menu_PopUp "Global | IxOS | Slice | Menu"
         break
      default
         if the shiftKey is "Down" then
            grab me
         else
            pass mouseDown
         end if
   end switch
end mouseDown

on mouseMove
   if the mouse is "Down" then
      try -- being grabbed
         LayoutControl
      end try
   end if
end mouseMove


--> Objects
-
getprop chart_Widget
   return _ChartWidget()
end chart_Widget

getprop slice_View
   return the long id of me
end slice_View

getprop view_Object
   return the long id of me
end view_Object

private function _IxView
   _SetNames graphicName, ixName, chartName
   if exists (group ixName) is false then return empty
   return the long id of group ixName
end _IxView

private function _ChartWidget
   _SetNames graphicName, ixName, chartName
   if exists (widget chartName) is false then return empty
   return the long id of widget chartName
end _ChartWidget
