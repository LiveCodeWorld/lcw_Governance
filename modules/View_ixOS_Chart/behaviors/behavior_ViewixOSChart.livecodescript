script "behavior_ViewixOSChart"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewixOSChart
type: behavior
version: 0.1

/*
Here you make make notes as a basic form of help for this view.
Full help text can be found on the linked wiki for the view.
*/

--> Working on
-
getprop name_Linked
   _SetNamedObjects empty, ixView, chartWidget
   return the result
end name_Linked

on nameChanged pOldName, pNewName
   _SetNamedObjects pOldName, ixView, graphicView
   if the result is true then
      _SetNames pNewName, ixName, graphicName
      --
      set the lockmessages to true
      set the name of ixView to ixName
      set the name of graphicView to graphicName
      set the lockmessages to false
   end if
end namechanged

private command _SetNamedObjects pChartName, @ixView, @graphicView
   _SetNames pChartName, ixName, graphicName
   --
   if exists (graphic graphicName) then
      put the long id of graphic graphicName into graphicView
   else
      put empty into graphicView
   end if
   
   if exists (group ixName) then
      put the long id of group ixName into ixView
   else
      put empty into ixView      
   end if
   --
   return (ixView is not empty) AND (graphicView is not empty)
end _SetNamedObjects

private command _SetNames pChartName, @ixName, @graphicName
   if pChartName is empty then
      put the short name of me into pChartName -- "View|ixOS|Chart"
   end if
   
   set the itemDelimiter to "|"
   --
   put item 1 to -2 pChartName into ixName
   put ixName & "|Slice" into graphicName
   --
   return pChartName
end _SetNames


--> Events
-
on moveControl
   put _IxView() into ixView
   if ixView is empty then pass moveControl
   
   put the loc of me into vLoc
   set the centre_Loc of ixView to vLoc
end moveControl

on resizeControl
   put the rect of me into viewRect
   LayoutControl viewRect
   pass resizeControl
end resizeControl

command LayoutControl pRect
   if pRect is empty then put the rect of me into pRect
   lock screen
   set the rect of me to pRect
   --
   put _IxView() into ixView
   if exists (ixView) then
      set the dg_Rect of ixView to pRect
   end if
   --
   unlock screen
end LayoutControl


--> Props
-
getprop chart_OptionsData
   put the chartJSONOptions of me into pJSON
   put json_ToArray (pJSON) into cData
   return cData
end chart_OptionsData

getprop chart_Data
   put the chartJSONData of me into pJSON
   put json_ToArray (pJSON) into cData
   return cData
end chart_Data

getprop displayed_Data
   put the csvData of me into sData
   return sData
end displayed_Data

setprop displayed_Data sData
   set the csvData of me to sData
end displayed_Data

getprop show_Scale
   put the showXScale of me into xBoolean
   put the showYScale of me into yBoolean
   return xBoolean AND yBoolean
end show_Scale

setprop show_Scale sBoolean
   lock screen
   set the showXScale of me to sBoolean
   set the showYScale of me to sBoolean
   unlock screen
end show_Scale


--> Objects
-
private function _IxView
   -- linked view
   -- put the top_View ["View|ixOS|Chart"] of me into ixosView
   put the short name of me into vName
   if exists (group vName) then
      return the long id of group vName
   else
      return empty
   end if
end _IxView

getprop chart_Widget
   return the long id of me
end chart_Widget

getprop view_Object
   return the long id of me
end view_Object
