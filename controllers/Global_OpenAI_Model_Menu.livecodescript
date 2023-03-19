script "Global | OpenAI | Model | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | OpenAI | Model | Menu
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
   -- return display_MenuTarget(tObject)
   return the display_View of tObject
end menu_Target


--> Global | OpenAI | Model | Menu
-
on menu_OpenAiTest displayView
   openAI_Test
end menu_OpenAiTest

private command _
end _

on menu_Refresh
   display_OpenAiModels
end menu_Refresh


