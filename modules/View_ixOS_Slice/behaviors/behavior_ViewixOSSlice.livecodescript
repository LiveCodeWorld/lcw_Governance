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
on display_Update
   -- assume that ixView dispatches this
   update_Chart
end display_Update

on update_Chart
   put _IxView() into ixView
   put _ChartWidget() into chartWidget
   put the displayed_Column of ixView into cName
   --
   lock screen
   put the chart_Data [cName] of ixView into chartData
   set the displayed_Data of chartWidget to chartData
   unlock screen
end update_Chart

getprop column_Names
   put the column_Names of _IxView() into cNames
   return cNames
end column_Names

getprop displayed_Column
   if the long id of the target is not the long id of me then pass displayed_Column
   --
   return the displayed_Column of _IxView()
end displayed_Column

setprop displayed_Column cName
   if the long id of the target is not the long id of me then pass displayed_Column
   put _ChartWidget() into chartWidget
   put _IxView() into ixView
   
   lock screen
   set the displayed_Column of ixView to cName
   put the chart_Data [cName] of ixView into chartData
   set the displayed_Data of chartWidget to chartData
   unlock screen
   --
   return the result
end displayed_Column

getprop displayed_Data [cName]
   put _IxView() into ixView
   put the displayed_Data of ixView into sTableData 
   return sTableData
end displayed_Data

setprop displayed_Data [cName] sTableData
   put _IxView() into ixView
   put _ChartWidget() into chartWidget
   --
   lock screen
   set the displayed_Data [cName] of ixView to sTableData
   put the chart_Data [cName] of ixView into chartData
   set the displayed_Data of chartWidget to chartData
   unlock screen
   --   
   return ixView
end displayed_Data

getprop side_BySide
   put the uOPN ["side_BySide"] of me into sideBySide
   return sideBySide is not false
end side_BySide

setprop side_BySide sBoolean
   set the uOPN ["side_BySide"] of me to sBoolean
   --
   lock screen
   put _ChartWidget() into chartWidget
   if sBoolean is true then
      set the visible of chartWidget to true
      set the visible of _IxView() to true
      set the showLegend of chartWidget to false
   else
      set the visible of chartWidget to false
      set the visible of _IxView() to true
      set the showLegend of chartWidget to true
   end if
   --
   LayoutControl
   unlock screen
end side_BySide

getprop inner_Margin
   put the uOPN ["inner_Margin"] of me into sMargin
   if sMargin is empty then
      return 20
   else
      return sMargin
   end if
end inner_Margin

setprop inner_Margin sMargin
   set the uOPN ["inner_Margin"] of me to sMargin
   LayoutControl
end inner_Margin

getprop chart_IsVisible
   put the visible of _ChartWidget() into sBoolean
   return sBoolean
end chart_IsVisible

setprop chart_IsVisible sBoolean
   put _ChartWidget() into chartWidget
   --
   lock screen
   set the visible of chartWidget to sBoolean
   set the visible of _IxView() to (sBoolean is false)
   --
   -- put the showLegend of chartWidget into sBoolean
   set the showLegend of chartWidget to sBoolean
   unlock screen
end chart_IsVisible


--> Events
-
on mouseDoubleUp pButtonNumber
   put the side_BySide of me into sideBySide
   if sideBySide is true then
      pass mouseDoubleUp
   else
      put the chart_IsVisible of me into sBoolean
      set the chart_IsVisible of me to (sBoolean is false)
   end if
end mouseDoubleUp

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

private command _SetRects pRect, @ixRect, @chartRect, sideBySide
   put pRect into innerRect
   --
   put the inner_Margin of me into innerMargin
   rect_SubtractMargins innerRect, innerMargin
   --
   switch
      case sideBySide is false
         put innerRect into ixRect
         put innerRect into chartRect
         break
      case sideBySide = "half"
         put item 3 of innerRect - item 1 of innerRect into innerWidth
         put (innerWidth - innerMargin) / 2 into halfWidth
         
         put innerRect into ixRect
         put item 1 of ixRect + halfWidth into ixRight
         put ixRight into item 3 of ixRect
         --
         put innerRect into chartRect
         put item 3 of chartRect - halfWidth into chartLeft
         put chartLeft into item 1 of chartRect
         break
      default
         put item 4 of innerRect - item 2 of innerRect into innerHeight
         --
         put innerRect into chartRect
         put item 3 of chartRect - innerHeight into chartLeft
         put chartLeft into item 1 of chartRect
         
         put innerRect into ixRect
         put chartLeft - (2 * innerMargin) into ixRight
         put ixRight into item 3 of ixRect
   end switch
   return innerRect
end _SetRects

command LayoutControl pRect
   if pRect is not a rect then put the rect of me into pRect
   put the margins of me into myMargins
   rect_SubtractMargins pRect, myMargins
   
   # Geometry
   put the side_BySide of me into sideBySide
   _SetRects pRect, ixRect, chartRect, sideBySide
   put the result into frameRect
   
   # Set Rects
   lock screen
   set the rect of _SliceBackground() to pRect
   set the rect of _IxView() to ixRect
   set the rect of _ChartWidget() to chartRect
   unlock screen
   --
   return frameRect
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


--> Objects
-
getprop chart_Widget
   return _ChartWidget()
end chart_Widget

getprop ix_View
   return _IxView()
end ix_View

getprop slice_View
   return the long id of me
end slice_View

getprop view_Object
   return the long id of me
end view_Object

private function _IxView
   return the long id of group 1 of me
end _IxView

private function _SliceBackground
   return the long id of grc "Slice Background" of me
end _SliceBackground

private function _ChartWidget
   return the long id of widget "Slice Chart" of me
end _ChartWidget


--> Deps
-
command rect_SubtractMargins @someRect, pMargin
   margin_Normalize pMargin, leftM, topM, rightM, bottomM   
   add leftM to item 1 of someRect
   add topM to item 2 of someRect
   subtract rightM from item 3 of someRect
   subtract bottomM from item 4 of someRect
end rect_SubtractMargins

command margin_Normalize @someMargin, @leftM, @topM, @rightM, @bottomM
   if the number of items of someMargin < 4 then
      put item 1 of someMargin into defaultMargin
      put defaultMargin into leftM
      
      put item 2 of someMargin into actualMargin
      if actualMargin is empty then
         put leftM into topM
      else
         put actualMargin into topM
      end if
      
      put item 3 of someMargin into actualMargin
      if actualMargin is empty then
         put leftM into rightM
      else
         put actualMargin into rightM
      end if
      
      put item 4 of someMargin into actualMargin
      if actualMargin is empty then
         put topM into bottomM
      else
         put actualMargin into bottomM
      end if
   else
      put item 1 of someMargin into leftM
      put item 2 of someMargin into topM
      put item 3 of someMargin into rightM
      put item 4 of someMargin into bottomM
   end if
   put leftM,topM,rightM,bottomM into someMargin
end margin_Normalize
