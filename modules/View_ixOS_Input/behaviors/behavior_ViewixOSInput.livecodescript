script "behavior_ViewixOSInput"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewixOSInput
type: behavior
version: 0.1

--> Input
-
getprop linked_IxView
   put the linked_IxView of me into ixView
   if exists (ixView) is true then return ixView
   
   ## Find one named correctly
   put the linked_SliceName of me into sliceName
   put the owner of me into myOwner
   if exists (group sliceName of myOwner) then
      put the long id of group sliceName of myOwner into linkedSlice
      put the ix_View of linkedSlice into ixView
      return ixView
   end if
   
   -- put the ix_View of group "DarVoz" into ixView
   return empty
end linked_IxView

setprop linked_IxView ixView
   set the linked_IxView of me to ixView
end linked_IxView


--> Events
-
on closeField
   _IncrementBudgetInput
   pass closeField
end closeField

on mouseDown bNum
   switch bNum
      case 3
         menu_PopUp "Global | IxOS | Input | Menu"
         break
      default
         pass mouseDown
   end switch
end mouseDown

on mouseUp
   _IncrementBudgetInput
end mouseUp

on mouseDoubleUp
   _SetValues inputName, inputValue
   put lcw_Ask("Rename me", inputName) into inputName
   --
   put inputName into newName
   set the name of me to newName
   set the label of me to empty
end mouseDoubleUp


--> Input
-
getprop linked_SliceTitle
   put the linked_SliceTitle of me into sTitle
   if sTitle is not empty then return sTitle
   
   put the short name of me into sTitle
   if word 1 of sTitle = "Increment" then delete word 1 of sTitle
   --
   return sTitle
end linked_SliceTitle

command _SetValues @sTitle, @sValue, @ixView
   put the linked_IxView of me into ixView
   put the linked_SliceTitle of me into sTitle
   put the text of fld 1 of me into sValue
end _SetValues

private command _IncrementBudgetInput
   _SetValues inputName, bValue, ixView
   --
   set the budget_Increment [inputName] of ixView to bValue
end _IncrementBudgetInput

private command _SetBudgetInput
   _SetValues inputName, bValue, ixView
   --
   set the budget_Value [inputName] of ixView to bValue
end _SetBudgetInput
