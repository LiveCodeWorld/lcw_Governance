script "Global | IxOS | Slice | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | IxOS | Slice | Menu
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
   -- called once for each menu
   return the display_View of tObject
end menu_Target

getprop colourPalette_Param [colourRecord]
   return the title_Text of colourRecord
end colourPalette_Param

getprop colourPalette_Params
   return colour_ListPaletteNames()
end colourPalette_Params

getprop checked_NameLinked [graphicView]
   put the name_Linked of graphicView into sBoolean
   return sBoolean is true
end checked_NameLinked


--> Global | IxOS | Slice | Menu
-
on menu_NameLinked graphicView
   put the name_Linked of graphicView into sBoolean
   if sBoolean is false then
      set the name_Linked of graphicView to true
   end if
end menu_NameLinked

private command _
end _

on menu_ColourPalette graphicView, paletteTitle
   put colour_GetPalette (paletteTitle) into cPaletteData
   set the colour_PaletteData of graphicView to cPaletteData
end menu_ColourPalette

on submenu_Chart
   return "Global | IxOS | Chart | Menu"
end submenu_Chart

private command __
end __

on menu_EditBehavior graphicView
   put the behavior of graphicView into bObject
   edit the script of bObject
end menu_EditBehavior


