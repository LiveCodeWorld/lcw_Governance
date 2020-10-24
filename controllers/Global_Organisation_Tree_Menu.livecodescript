script "Global | Organisation | Tree | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | Organisation | Tree | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray


--> Menu | Init
-
on menu_Init tObject   
   -- do something when the menu first loads
end menu_Init

getprop test_Param [mTarget]
   return "b"
end test_Param

getprop test_Params [mTarget]
   return "a,b,c"
end test_Params


--> Global | Organisation | Tree | Menu
-
on menu_PeopleInCircle
   get glassfrog_FetchPeopleInCircle (68775)
   --
   display_View it
end menu_PeopleInCircle

on menu_DisplayCircle
   put 68775 into cID
   get glassfrog_FetchCircle (cID)
   --
   display_View it
end menu_DisplayCircle

on _
end _

on menu_FetchPeople
   get glassfrog_FetchPeople()
   --
   display_View it
end menu_FetchPeople

on menu_FetchCircles
   get glassfrog_ListCircles()
   --
   display_View it
end menu_FetchCircles

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_Experiment mTarget
   put mTarget
end menu_Experiment


--> Deps
-
