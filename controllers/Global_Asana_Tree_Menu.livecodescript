script "Global_Asana_Tree_Menu"
--> MetaData
-
license: GPLv3
name: Global_Asana_Tree_Menu
type: controller
version: 0.1


--> Global | Asana | Tree | Menu
-
on submenu_OpenBanking
   return "Global | Starling | Menu"
end submenu_OpenBanking

on _
end _

on menu_DisplayLikes displayView
   put the displayed_Data of displayView into taskData
   --
   put asana_GetTaskVoteNum (taskData) & CR & asana_GetTaskVoteNames (taskData)
end menu_DisplayLikes

on menu_DisplayDataArray displayView
   put the displayed_Data of displayView into someData
   display_Array someData
end menu_DisplayDataArray

on _
end _

on menu_DisplayOrgs indexView
   put asana_ListOrgs() into orgNames
   set the displayed_Index of indexView to orgNames
end menu_DisplayOrgs

on menu_DisplayWorkspaces indexView
   put asana_ListWorkspaces() into spaceNames
   set the displayed_Index of indexView to spaceNames
end menu_DisplayWorkspaces

on menu_DisplayAll indexView
   put asana_ListAll() into allNames
   set the displayed_Index of indexView to allNames
end menu_DisplayAll

on _
end _

on menu_DisplayTemplateArray
   put asana_GetTemplateData() into asanaData
   display_Array asanaData, "asana_GetTemplateData()", "Global | Asana | Template | Tree | Menu", "Global | Asana | Template | Tree | Line | Menu"
   put the result into treeView
end menu_DisplayTemplateArray

on menu_DisplayStoredWorkspaceInfo
   put asana_GetWorkspaceInfoArray ("data") into workspaceInfoArray
   --
   display_Array workspaceInfoArray, "asana_GetWorkspaceArray()"
end menu_DisplayStoredWorkspaceInfo

on _
end _

on menu_GatherWorkspaceInfo
   put asana_FetchMyWorkSpaceData() into workspaceInfoArray
   asana_SetWorkspaceInfoArray "data", workspaceInfoArray
   --
   display_Array workspaceInfoArray, "asana_FetchMyWorkSpaceData()"
end menu_GatherWorkspaceInfo


--> Global | Asana | Tree | Menu | Props
-

--> Global | Asana | Tree | Menu | Disabled
-
