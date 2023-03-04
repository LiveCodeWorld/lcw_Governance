script "Global | Governance | Logo | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Governance | Logo | Menu
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
getprop rotate_Param [logoView]
   put the text_Rotation of logoView into sDegrees
   return sDegrees -- "60"
end rotate_Param

getprop rotate_Params [logoView]
   return "0,60,120,180,240,300,360"
end rotate_Params

getprop show_Param [logoView]
   return the visible_Names of logoView
end show_Param

getprop show_Params [logoView]
   return the layer_Names of logoView
end show_Params

getprop resizeStyle_Param [logoView]
   return the resize_Style of logoView
end resizeStyle_Param

getprop resizeStyle_Params [logoView]
   return the resize_Styles of logoView
end resizeStyle_Params

getprop checked_GraphicBorders [logoView]
   put the graphic_Borders of logoView into sBoolean
   return sBoolean
end checked_GraphicBorders

getprop checked_ShowNames [logoView]
   put the show_Names of logoView into sBoolean
   return sBoolean
end checked_ShowNames


--> Global | Governance | Logo | Menu
-
on menu_ResizeStyle logoView, rStyle
   set the resize_Style of logoView to rStyle
end menu_ResizeStyle

on menu_GraphicBorders logoView
   put not (the graphic_Borders of logoView) into sBoolean
   set the graphic_Borders of logoView to sBoolean
end menu_GraphicBorders

on menu_ShowNames logoView
   put not (the show_Names of logoView) into sBoolean
   set the show_Names of logoView to sBoolean
end menu_ShowNames

on _
end _

on menu_Rotate logoView, sDegree
   set the text_Rotation of logoView to sDegree
end menu_Rotate

on menu_Show logoView, layerName
   set the toggle_Visible of logoView to layerName
   put the result into layerObject
   --
   display_ObjectProperties layerObject
end menu_Show

getprop generatePoints_Params
   return "fixed,relative"
end generatePoints_Params
   
on menu_GeneratePoints logoView, useRelative
   put the layer_Object ["Oval"] of logoView into graphicObject
   get the effective points of graphicObject
   put it & CR & line 1 of it & CR&CR after allPoints
   
   put the layer_Object ["Rectangle"] of logoView into graphicObject
   get the effective points of graphicObject
   put it & CR&CR after allPoints
   
   put the layer_Object ["Round Rectangle"] of logoView into graphicObject
   get the effective points of graphicObject
   put it & CR&CR after allPoints
   
   set the poly_Points [false] of logoView to sPoints
end menu_GeneratePoints

private function _GetPoints logoView
   -- does not close rectangles
   put the graphic_Objects of logoView into graphicObjects
   repeat for each line graphicObject in graphicObjects
      if useRelative is "relative" then
         get the effective relativepoints of graphicObject
      else
         get the effective points of graphicObject
      end if
      put it & CR&CR after allPoints
   end repeat
   --
   put word 1 to -1 of allPoints
   return allPoints
end _GetPoints
