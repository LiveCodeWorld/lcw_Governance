script "Global | Grid | Model | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Grid | Model | Menu
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
   put the display_View of tObject into dView
   put dView into LocalArray ["dView"]
   --
   if exists (dView) then
      put the displayed_Object of dView into gridView
      if exists (gridView) then
         return gridView
      end if
   end if
   --
   put grid_DisplayView() into gridView
   return gridView
end menu_Target

-- getprop setDisplayedData_Params
put revLoadedStacks ("application") into stackNames
filter stackNames with "View|Grid *"
return stackNames
end setDisplayedData_Params


--> Global | Grid | Model | Menu
-
on menu_SetModelTitle gridView
   put LocalArray ["dView"] into dView
   put the title_Text of dView into sTitle
   put lcw_Ask ("What title would you like to give this model?", sTitle) into sTitle
   --
   put the displayed_Data of dView into shapeData
   put sTitle into shapeData ["title"]
   --
   grid_SetShapeData sTitle, shapeData
   set the displayed_Data of dView to shapeData
   set the title_Text of dView to sTitle
end menu_SetModelTitle

on menu_DisplayModelData gridView, modelName
   display_ModuleModel gridView, modelName
end menu_DisplayModelData

on menu_SetDisplayedData gridView
   put LocalArray ["dView"] into dView
   --
   put the displayed_Data of dView into shapeData
   set the displayed_Data of gridView to shapeData   
end menu_SetDisplayedData
   
private command _
end _

on menu_CleanData gridView
   put LocalArray ["dView"] into dView
   put the displayed_Data of dView into shapeData
   --
   put shapeData ["shape_Array"] into shapeArray
   repeat with indexNum = 1 to item 2 of the extents of shapeArray
      put shapeArray [indexNum]["element id"] into shortID
      delete variable shapeData ["shape_Array"][indexNum]["element id"]
      put shortID into shapeData ["shape_Array"][indexNum]["id"]
   end repeat
   --
   set the displayed_Data of dView to shapeData
end menu_CleanData

on menu_ExportData gridView
   -- put the displayed_Data of gridView into shapeData
   put LocalArray ["dView"] into dView
   put the displayed_Data of dView into shapeData
   
   put shapeData ["title"] into shortName
   if shortName is empty then
      put the title_Tet of dView into shortName
   end if
   put lcw_Ask("What name would you like to give this grid model?", shortName, "Grid Model Name", gridView) into shortName
   --
   grid_SetShapeData shortName, shapeData
   --
   display_GridShapeData shapeData, gridView
   display_GridModels
end menu_ExportData

on menu_ImportData gridView, modelName
   put the module_Model [modelName] of gridView into shapeData
   --
   set the displayed_Data of gridView to shapeData
   --
   if the shiftKey is "Down" then
      display_ModuleModel gridView, modelName
   end if
end menu_ImportData

on menu_DeleteModelData gridView, modelName
   put the module_ModelFile [modelName] of gridView into mFile
   lcw_Answer "Delete file '[[modelName]]?", gridView, modelName
   --
   revDeleteFile mFile
end menu_DeleteModelData

private command __
end __

on menu_ListGridModels
   display_GridModels
end menu_ListGridModels

