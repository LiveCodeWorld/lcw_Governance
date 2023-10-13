script "Global | ixOS | Row | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | ixOS | Row | Menu
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
   -- put the dgControl of tObject into dGrid
   -- put the ix_View of tObject into ixView
   put the slice_View of tObject into sliceView
   return sliceView
end menu_Target

getprop disabled_CreatePie [sliceView]
   put _LinkedPie (sliceView) into linkedPie
   return exists (linkedPie)
end disabled_CreatePie

private function _LinkedPie sliceView
   put _SliceName (sliceView) into newSliceName
   put _SliceOwner (sliceView) into sOwner
   if exists (group newSliceName of sOwner) is false then
      return empty
   end if
   
   put the long id of group newSliceName of sOwner into linkedPie
   return linkedPie
end _LinkedPie

private function _SliceOwner sliceView
   put the long id of the owner of sliceView into sOwner
   return sOwner
end _SliceOwner

private function _SliceName sliceView
   put the ix_View of sliceView into ixView
   --
   put the data_Grid of ixView into dGrid
   put the dgHilitedIndexes of dGrid into sIndex
   put the dgDataOfIndex [sIndex] of dGrid into rArray
   put rArray ["Title"] into newSliceName
   put " Slice" after newSliceName
   return newSliceName
end _SliceName

getprop setTo_Param [aView]
   put the to_Name of aView into tName
   return tName
end setTo_Param

getprop setTo_Params [aView]
   put the link_Names of aView into fNames
   return fNames
end setTo_Params

getprop createWhere_Param
   put LocalArray ["Where"] into sWhere
   if sWhere is empty then
      return "Top"
   else
      return sWhere
   end if
end createWhere_Param

getprop createWhere_Params
   return "Top,Bottom,-,Left,Right"
end createWhere_Params

getprop createPie_Params
   return "Top,Bottom,-,Left,Right"
end createPie_Params


--> Global | ixOS | Row | Menu
-
on menu_CreatePie sliceView, sWhere
   /*
   put _SliceOwner (sliceView) into sOwner
   --
   put the loc of sliceView into sLoc
   put LocalArray ["Where"] into sWhere
   */
   --
   put _SliceName (sliceView) into newSliceName
   dispatch "create_LinkedSlice" to sliceView with newSliceName,sWhere
end menu_CreatePie

private on _
end _

on menu_CreateWhere sliceView, sWhere
   put sWhere into LocalArray ["Where"]
end menu_CreateWhere

on submenu_Dev
   return menu_DevTitle ("Global | ixOS | Row | Menu")
end submenu_Dev
