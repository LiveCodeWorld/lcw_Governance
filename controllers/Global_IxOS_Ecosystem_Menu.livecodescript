script "Global | IxOS | Ecosystem | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | IxOS | Ecosystem | Menu
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
   return the card_Object of tObject
end menu_Target

getprop checked_ChartsVisible [cardObject]
   put the charts_Visible of cardObject into sBoolean
   return sBoolean
end checked_ChartsVisible


--> Global | IxOS | Ecosystem | Menu
-
on submenu_Card
   return "Global | Card | Menu"
end submenu_Card

on submenu_Browser
   return "Global | Browser | Menu"
end submenu_Browser

private command _
end _

on menu_DisplayNestr
   display_Nestr
end menu_DisplayNestr
   
on menu_ChartsVisible cardObject
   put the charts_Visible of cardObject into sBoolean
   set the charts_Visible of cardObject to (sBoolean is false)
end menu_ChartsVisible

on menu_UpdateCharts cardObject
   put the ix_Views of cardObject into ixViews
   repeat for each line ixView in ixViews
      put the csv_Data of ixView into someCSV
      --
      put the chart_Objects of ixView into chartObjects
      repeat for each line chartObject in chartObjects
         set the displayed_Data of chartObject to someCSV
         set the visible of chartObject to true
      end repeat
   end repeat
end menu_UpdateCharts

private command __
end __

on menu_DeleteBalls cardObject
   put the ball_Objects of cardObject into ballObjects
   repeat for each line ballObject in ballObjects
      delete ballObject
   end repeat
end menu_DeleteBalls
   
on menu_PositionCharts cardObject
   dispatch "LayoutControl" to cardObject
end menu_PositionCharts
