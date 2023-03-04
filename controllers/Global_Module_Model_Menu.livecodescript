script "Global | Module | Model | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | Module | Model | Menu
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
   put the ix_View of tObject into ixView
   if exists (ixView) is false then
      put the display_View of tObject into dView
      put the displayed_Object of dView into ixView
   end if
   --
   put the displayed_Data of ixView into vData
   put vData into LocalArray ["displayed_Data"]
   --
   put the displayed_AbbreviatedData of ixView into aData
   put aData into LocalArray ["displayed_AbbreviatedData"]
   --
   put the short name of ixView into vName
   put the saved_Data [vName] of ixView into savedData
   put savedData into LocalArray ["saved_Data"]
   --
   put the module_ModelNames of ixView into modelNames
   put modelNames into LocalArray ["module_ModelNames"]
   --
   return ixView
end menu_Target

getprop importData_Params [ixView]
   put the module_ModelNames of ixView into modelNames
   return modelNames
end importData_Params

getprop displayModelData_Params [ixView]
   return LocalArray ["module_ModelNames"]
end displayModelData_Params

getprop deleteModelData_Params [ixView]
   return LocalArray ["module_ModelNames"]
end deleteModelData_Params

getprop disabled_RevertToSaved [ixView]
   switch
      case LocalArray ["saved_Data"] is empty
         return true
      case LocalArray ["saved_Data"] = LocalArray ["displayed_AbbreviatedData"]
         return true
      default
         return false
   end switch 
end disabled_RevertToSaved

getprop disabled_ClearData [ixView]
   return LocalArray ["saved_Data"] is empty
end disabled_ClearData

getprop checked_SaveData [ixView]
   return LocalArray ["saved_Data"] = LocalArray ["displayed_AbbreviatedData"]
end checked_SaveData

command ix_ExportModel ixView, pModelName
   if pModelName is empty then put the view_ModelName of ixView into pModelName
   --
   put the saved_TableData of ixView into sData
   set the module_Model [pModelName] of ixView to sData
   put the result into modeFile
   return modeFile
end ix_ExportModel

command display_ModuleModel ixView, pModelName
   if pModelName is empty then put the view_ModelName of ixView into pModelName
   put the module_Model [pModelName] of ixView into mData
   --
   display_Data mData, pModelName, "module_Model"
   put the module_ModelFile [pModelName] of ixView into mFile
   put mFile
end display_ModuleModel


--> Global | Module | Model | Menu
-
on menu_DisplayModelData ixView, modelName
   display_ModuleModel ixView, modelName
end menu_DisplayModelData

on menu_ExportData ixView
   ix_ExportModel ixView
   display_ModuleModel ixView
end menu_ExportData

on menu_ImportData ixView, modelName
   put the module_Model [modelName] of ixView into sData
   --
   /*
   if sData ["total"] is empty then
      breakpoint -- old saved format
      set the displayed_Data [true] of ixView to sData
   end if
   */
   
   -- set the name of ixView to modelName
   set the saved_TableData ["abbreviated"] of ixView to sData
   --
   display_ModuleModel ixView, modelName
end menu_ImportData

on menu_DeleteModelData ixView, modelName
   put the module_ModelFile [modelName] of ixView into mFile
   lcw_Answer "Delete file '[[modelName]]?", ixView, modelName
   --
   -- delete file mFile
   revDeleteFile mFile
end menu_DeleteModelData

private on _
end _

on menu_SaveData ixView
   dispatch "save_Data" to ixView
   --
   put the displayed_Data [true] of ixView into testData
   display_Data testData, mName, "displayed_Data"
end menu_SaveData

on menu_ClearData ixView
   -- put the short name of ixView into vName
   -- set the saved_Data [vName] of ixView to empty
   dispatch "clear_Data" to ixView
end menu_ClearData

on menu_RevertToSaved ixView
   put the short name of ixView into vName
   put the saved_Data [vName] of ixView into savedData
   --
   set the displayed_Data of ixView to savedData
end menu_RevertToSaved
