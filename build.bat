@echo off

set name=GrowingPlants

xcopy /s /y .\%name%\ %Appdata%\Balatro\Mods\%name%\*

exit