script "Global_Asana_Template_Tree_Line_Menu"
--> MetaData
-
license: GPLv3
name: Global_Asana_Template_Tree_Line_Menu
type: controller
version: 0.1


--> Global | Asana | Template | Tree | Line | Menu
-
on menu_CleanTemplateTasks treeView
   put the top_Array of treeView into projectTaskInfoArray
   put asana_GetTemplateInfo ("name", projectTaskInfoArray) into projectName
   put asana_GetTemplateInfo ("gid", projectTaskInfoArray) into projectID
   --
   -- display_Array projectTaskInfoArray
end menu_CleanTemplateTasks


--> Global | Asana | Template | Tree | Line | Menu | Props
-

--> Global | Asana | Template | Tree | Line | Menu | Disabled
-
