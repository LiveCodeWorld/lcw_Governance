script "Global_Asana_Project_Tree_Line_Menu"
--> MetaData
-
license: GPLv3
name: Global_Asana_Project_Tree_Line_Menu
type: controller
version: 0.1


--> Global | Asana | Project | Tree | Line | Menu
-
on menu_DisplayTaskArray indexView
   put the selected_Index of indexView into taskName
   put the displayed_Data of indexView into taskNameArray
   put taskNameArray [taskName] into taskID
   --
   put asana_FetchTask (taskID) into responseArray
   put responseArray ["data"] into projectTaskData
   display_Array projectTaskData
   put asana_FetchTaskNotes (taskID)
   --
   put the meta_Data ["projectID"] of indexView into projectID
   put the meta_Data ["projectName"] of indexView into projectName
   put the meta_Data ["projectTaskData"] of indexView into projectTaskData
end menu_DisplayTaskArray


--> Global | Asana | Project | Tree | Line | Menu | Props
-

--> Global | Asana | Project | Tree | Line | Menu | Disabled
-
