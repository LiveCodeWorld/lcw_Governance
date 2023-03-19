script "lib_DisplayGrid"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: lib_DisplayGrid
type: library
version: 0.1

/*Some help*/


--> Working on
-
on grid_EditDisplayLine displayView, someLine
   -- shape_Array,1,name
   put the displayed_Object of displayView into gridView
   --
   put the selected_Path of displayView into commaItems
   if someLine is empty then
      put the selected_Value of displayView into someLine
   end if
   --
   put the displayed_Data of displayView into shapeData
   put the parent_Array of displayView into pArray
   put pArray ["id"] into shortID
   --
   put commaItems into arrayKey
   split arrayKey with comma
   --
   put item -1 of commaItems into sKey
   switch sKey
      case "id"
      case empty
         return empty
      case "foregroundcolor"
      case "backgroundcolor"
         answer color
         if it is empty then exit to top
         put it into newValue
         break
      case "name"
         put lcw_Ask ("Rename control...", someLine) into newValue
         put newValue into shapeData [arrayKey]
         break
      default
         put lcw_Ask ("Change value...", someLine) into newValue
         put newValue into shapeData [arrayKey]
   end switch
   --
   put newValue into shapeData [arrayKey]
   --
   if exists (control id shortID of gridView) then
      set the sKey of control id shortID of gridView to newValue
      set the shape_Data of gridView to shapeData
   end if
   --
   set the displayed_Data of displayView to shapeData
end grid_EditDisplayLine


--> Display | Grid
-


--> Display | Module | Model
-
on ask_ExportModuleData vObject, pDisplayModel
   put the displayed_Data of vObject into displayedData
   put the view_ModelName of vObject into modelName
   put lcw_Ask ("What name would you like for this model?", modelName) into modelName
   put modelName into displayedData ["title"]
   --
   -- module_SetModel shortName, moduleStackName, projectName, displayedData
   set the module_Model [modelName] of vObject to displayedData
   put the result into modeFile
   --
   if pDisplayModel is treu then
      display_ModuleModel vObject
   end if
   --
   return sData
end ask_ExportModuleData

on mDoubleUp_ModuleModel displayView, someLine
   breakpoint
   put the title_Text of displayView into someTitle
end mDoubleUp_ModuleModel

command display_ModuleModel mView, pModelName
   if pModelName is empty then put the view_ModelName of mView into pModelName
   put the module_Model [pModelName] of mView into mData
   --
   display_Data mData, pModelName, "module_Model"
   put the result into dView
   set the displayed_Object of dView to mView
   --
   display_SetInteractions dView, "Module | Model", "mDoubleUp_ModuleModel", "model_Display"
   return dView
end display_ModuleModel


--> Display
-
on mDoubleUp_GridModel displayView, someLine
   grid_EditDisplayLine displayView, someLine
end mDoubleUp_GridModel

command display_GridShapeData shapeData, pGridView
   put shapeData ["title"] into shapeTitle
   if shapeTitle is empty then
      put "*No Title*" into shapeTitle
   end if
   --
   display_Data shapeData, shapeTitle, "Grid Shape Data"
   put the result into displayView
   --
   if exists (pGridView) then
      set the displayed_Object of displayView to pGridView
   end if
   --
   display_SetInteractions displayView, "Grid | Model", "mDoubleUp_GridModel", "model_Grid"
   return displayView
end display_GridShapeData

on mDoubleUp_GridModelName displayView, modelName
   put the displayed_Object of displayView into gridView
   put grid_GetShapeData (modelName) into shapeData
   --
   if exists (gridView) then
      set the displayed_Data of gridView to shapeData
      put the result into shapeData
   end if
   --
   display_GridShapeData shapeData, gridView  
end mDoubleUp_GridModelName

command display_GridModels pGridView, pListShort
   put pListShort is not false into sBoolean
   if sBoolean then
      put grid_ListModelShortFiles() into sIndex
   else
      put grid_ListModelNames() into sIndex
   end if
   --
   display_Data sIndex, "Grid Models", "Grid"
   put the result into displayView
   --
   set the displayed_Object of displayView to pGridView
   set the list_Short of displayView to sBoolean
   --
   display_SetInteractions displayView, "Grid | Model | List", "mDoubleUp_GridModelName", "model_Grid"
   return displayView
end display_GridModels


