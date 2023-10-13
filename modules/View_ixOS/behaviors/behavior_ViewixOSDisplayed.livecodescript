script "behavior_ViewixOSDisplayed"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewixOSDisplayed
type: behavior
version: 0.1


/*
on mouseDown pButtonNumber
   switch pButtonNumber
      case 3
         menu_PopUp "Global | IxOS | Menu"
         break
      default
         -- _MaybeGrab
         pass mouseDown
   end switch
end mouseDown

on mouseMove pNewMouseH, pNewMouseV
   if the mouse is "Down" then
      _MaybeMove pNewMouseH, pNewMouseV
   end if
   pass mouseMove
end mouseMove


--> Move
-
command _MaybeMove pNewMouseH, pNewMouseV
   get the long id of the target
   if it is not _BackgroundGraphic() then return false
   --
   
   -- being grabbed
   try
      lock screen
      -- could use rect like handlers in graphic "View|ixOS|Slice"
      put pNewMouseH - LocalArray ["oMouseX"] into xVector
      put pNewMouseV - LocalArray ["oMouseY"] into yVector
      --
      put LocalArray ["oViewLoc"] into oViewLoc
      --
      _SetNamedObjects empty, graphicObject, chartWidget
      put the result into nameLinked
      --
      if nameLinked is true then
         put LocalArray ["oChartLoc"] into oChartLoc
         put loc_TranslateByVector (oChartLoc, xVector, yVector) into newChartLoc
         set the loc of chartWidget to newChartLoc
         --
         put LocalArray ["oGraphicLoc"] into oGraphicLoc
         put loc_TranslateByVector (oGraphicLoc, xVector, yVector) into newGraphicLoc
         set the loc of graphicObject to newGraphicLoc
      else
         put the linked_Chart of me into chartObject
         if exists (chartObject) then
            put loc_TranslateByVector (oViewLoc, xVector, yVector) into nViewLoc
            set the loc of chartObject to nViewLoc
         end if
      end if
      --
      ix_LayoutLinked
      unlock screen
   end try
end _MaybeMove

command _MaybeGrab
   get the short name of the target
   if it is not "background" then return false
   
   _SetNamedObjects empty, graphicObject, chartWidget
   get the long id of the target
   if it is not graphicObject then return false
   --
   put the loc of me into LocalArray ["oViewLoc"]
   -- put the loc of graphicObject into LocalArray ["oViewLoc"]
   --
   put the mouseLoc into mLoc
   put item 1 of mLoc into LocalArray ["oMouseX"]
   put item 2 of mLoc into LocalArray ["oMouseY"]
   --
   put the result into nameLinked
   if nameLinked is true then
      put the loc of graphicObject into LocalArray ["oGraphicLoc"]
      put the loc of chartWidget into LocalArray ["oChartLoc"]
   end if
   
   put the short id of _BackgroundGraphic() into backID
   if the short id of the target = backID then
      grab me
   end if
end _MaybeGrab
*/
