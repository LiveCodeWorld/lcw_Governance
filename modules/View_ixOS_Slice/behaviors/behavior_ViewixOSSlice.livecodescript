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
getprop slice_Titles [useVisible]
   put the title_Index [useVisible] of _IxView() into titleIndex
   return titleIndex
end slice_Titles

on create_LinkedSlice newSliceName,sWhere
   put the long id of me into mySlice
   put the long id of the owner of me into sOwner
   put _NewSliceLoc (sWhere) into sLoc
   
   view_InsertFromPath "View|IxOS|Slice", sOwner, sLoc
   put the result into newSlice
   --
   set the name of newSlice to newSliceName
   --
   view_InsertFromPath "View|IxOS|Arc", sOwner
   put the result into newArrow
   --
   set the add_ToArrow of mySlice to newArrow
   set the to_Object of newArrow to mySlice
   --
   set the add_FromArrow of newSlice to newArrow
   set the from_Object of newArrow to newSlice
   --
   return newSlice
end create_LinkedSlice

private function _NewSliceLoc sWhere
   put the loc of me into sLoc
   --
   switch sWhere
      case "Top"
         put the top of me - (the height of me)/2 into item 2 of sLoc
         break
      case "Left"
         put the left of me - (the width of me)/2 into item 2 of sLoc
         break
      case "Right"
         put the right of me + (the width of me)/2 into item 2 of sLoc
         break
      case "Bottom"
      default
         put the bottom of me + (the height of me)/2 into item 2 of sLoc
         break
   end switch 
   return sLoc
end _NewSliceLoc

on create_ToArrow toName
   put the long id of me into fromSlice
   put the long id of the owner of me into sOwner
   
   view_InsertFromPath "View|IxOS|Arc", sOwner
   put the result into aObject
   
   put the long id of group toName of sOwner into toSlice
   set the from_Object of aObject to fromSlice
   set the to_Object of aObject to toSlice
   
   return aObject
end create_ToArrow

command LayoutControl pRect
   get the long id of the target
   put the long id of me into sliceView
   if it is not sliceView then
      -- pass LayoutControl
      return empty
   end if
   
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


--> Events | Mouse | Move
-
on mouseDown pButtonNumber
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
         LayoutArrows
      end try
   end if
end mouseMove


--> Layout | Arrows
-
on LayoutArrows
   lock screen
   put the to_Arrows of me into toArrows
   repeat for each line aObject in toArrows
      if exists (aObject) is false then
         set the remove_ToArrow of me to aObject
         next repeat
      end if
      dispatch "LayoutControl" to aObject
   end repeat
   
   put the from_Arrows of me into fromArrows
   repeat for each line aObject in fromArrows
      if exists (aObject) is false then
         set the remove_FromArrow of me to aObject
         next repeat
      end if
      dispatch "LayoutControl" to aObject
   end repeat
   unlock screen
end LayoutArrows

setprop add_FromArrow fArrow
   put the from_Arrows of me into fArrows
   --
   put revRuggedId (fArrow) into fArrow
   line_Add fArrow, fArrows
   --
   set the from_Arrows of me to fArrows
   return fArrows
end add_FromArrow

setprop remove_FromArrow fArrow
   put the from_Arrows of me into fArrows
   --
   put revRuggedId (fArrow) into fArrow
   line_Delete fArrow, fArrows
   --
   set the from_Arrows of me to fArrows
   return fArrows
end remove_FromArrow

setprop add_ToArrow tArrow
   put the to_Arrows of me into tArrows
   --
   put revRuggedId (tArrow) into tArrow
   line_Add tArrow, tArrows
   --
   set the to_Arrows of me to tArrows
   return tArrows
end add_ToArrow

setprop remove_ToArrow tArrow
   put the to_Arrows of me into tArrows
   --
   put revRuggedId (tArrow) into tArrow
   line_Delete tArrow, tArrows
   --
   set the to_Arrows of me to tArrows
   return tArrows
end remove_ToArrow


--> Events
-
on resizeControl 
   LayoutControl
end resizeControl

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
         -- LayoutControl
         LayoutArrows
      end try
   end if
end mouseMove

on mouseDoubleUp pButtonNumber
   put the side_BySide of me into sideBySide
   if sideBySide is true then
      pass mouseDoubleUp
   end if
   
   ## Togggle
   put the show_Chart of me into sBoolean
   set the show_Chart [false] of me to (sBoolean is false)
end mouseDoubleUp


--> Fair
-
getprop fair_Value [sTitle]
   put _IxView() into ixView
   if sTitle is empty then
      put the total_Budget of ixView into fairValue
   else
      put the budget_Value [sTitle] of ixView into fairValue
   end if
   return fairValue
end fair_Value

setprop fair_Value [sTitle] sValue
   put _IxView() into ixView
   if sTitle is empty then
      set the total_Budget of ixView to sValue
   else
      set the budget_Value [sTitle] of ixView to sValue
   end if
   return ixView
end fair_Value
   
getprop to_BudgetTitle
   put the to_BudgetTitle of me into bTitle
   if bTitle is empty then
      -- PR Team Slice
      put the short name of me into bTitle
      if word -1 of bTitle = "Slice" then delete word -1 of bTitle
   end if
   return bTitle
end to_BudgetTitle


--> Update Linked
-
on slice_UpdateLinked
   put _IxView() into ixView
   /* For fancy links on cards and other things
   dispatch "ix_UpdateLinkedFields" to ixView
   dispatch "ix_UpdateCardCharts" to ixView
   */
   dispatch "ix_UpdateLinkedCharts" to ixView
   
   ## Update to_Arrows   
   put the to_Arrows of me into toArrows
   repeat for each line toArrow in toArrows
      put the arrow_Data of toArrow into aData
      put aData ["to_Object"] into toObject
      --
      put the to_BudgetTitle of me into sTitle
      put the fair_Value of me into fairValue
      set the fair_Value [sTitle] of toObject to fairValue
      --
      -- slice_UpdateTable
      dispatch "slice_UpdateChart" to toObject
   end repeat
end slice_UpdateLinked

on slice_UpdateTable
   put _IxView() into ixView
   --
   dispatch "ix_UpdateTable" to ixView
   return ixView
end slice_UpdateTable

on slice_UpdateChart
   put _IxView() into ixView
   put _ChartWidget() into chartWidget
   put the displayed_Column of ixView into cName
   --   
   lock screen
   put the chart_Data [cName] of ixView into chartData
   
   ## Add Chart Title
   put the chart_Title of me into chartTitle
   put chartTitle into chartData ["label"]
   
   set the displayed_Data of chartWidget to chartData
   unlock screen
end slice_UpdateChart

getprop chart_Title
   put the short name of me into chartTitle
   if word -1 of chartTitle = "Slice" then delete word -1 of chartTitle
   return chartTitle
end chart_Title

getprop linked_Charts
   return _ChartWidget()
end linked_Charts


--> Displayed
-
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
   put the chart_Data  [cName] of ixView into chartData
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

getprop column_Names
   put the column_Names of _IxView() into cNames
   return cNames
end column_Names

getprop show_Background
   return the visible of _SliceBackground()
end show_Background

setprop show_Background sBoolean
   set the visible of _SliceBackground() to sBoolean is true
end show_Background

getprop show_Chart
   put the visible of _ChartWidget() into sBoolean
   return sBoolean
end show_Chart

setprop show_Chart [showLegend] sBoolean
   put _ChartWidget() into chartWidget
   --
   lock screen
   set the visible of chartWidget to sBoolean
   set the visible of _IxView() to (sBoolean is false)
   --
   if showLegend is a boolean then
      set the showLegend of chartWidget to showLegend
   end if
   unlock screen
   return chartWidget
end show_Chart

getprop show_Table
   put the visible of _IxView() into sBoolean
   return sBoolean
end show_Table

setprop show_Table sBoolean
   set the visible of _IxView() to sBoolean   
end show_Table

getprop show_ChartOnly
   put the side_BySide of me into sideBySide
   if sideBySide is true then return false
   --
   put the visible of _IxView() into ixVis
   put the show_Chart of me into chartVis
   if ixVis is false and chartVis is true then
      return true
   else
      return false
   end if
end show_ChartOnly

setprop show_ChartOnly sBoolean
   lock screen
   set the side_BySide of me to false
   if sBoolean is true then
      set the show_Chart of me to true
      set the visible of _IxView() to false
   else
      set the show_Chart of me to false
      set the visible of _IxView() to true
   end if
   unlock screen
end show_ChartOnly

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
getprop formatted_Height
   put the long id of me into sliceView
   get the long id of the target
   if it is not sliceView then
      return 0
   end if
   
   ## Roughly Guess formatted Height
   put the formatted_Height of _IxView() into fHeight
   put the inner_Margin of me into innerMargin
   add 2 * innerMargin to fHeight
   return fHeight
end formatted_Height

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
