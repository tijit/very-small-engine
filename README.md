#  features

aiwana engine basics
- player movement
- accurate moving solids
- accurate moving jump-through platforms
- saving/loading
- touch saves and bullet blockers
- automatic camera that snaps to screen & example smooth panning camera
- large number of customisable engine settings
- crisp pixel scaling filter that doesnt make the game look blurry
- thought-out folder structure for asset list separating level objects and code. i also tried to signpost code that the user can freely edit and what is advanced system code

standard "jtool" gimmicks
- water2 & water3
- vines
- jump refreshers
- gravity flippers
- platforms and "snapforms"

advanced music system
- separate options for music, sound effects, master volume
- automatic loading and unloading of audio files
- crossfading between tracks
- song title display in pause menu
- see `code/scripts/musicScripts` for use and a few other convenience functions

easy to modify menus
- buttons scale to the size placed in room editor
- an invisible menu "cursor" automatically navigates any buttons placed in a room
- the menus are minimilastic visually, to change the style see draw events:
	- `code/objects/menu/parents/MenuButtonParent`
	- `code/objects/menu/parents/ButtonOptionParent`
- functions for generating buttons to edit game options:
	- `buttonTemplateToggle(option, textTrue="On", textFalse="Off")`
	- `buttonTemplateSlider(option, isPercentage=true, increment=0.1, low=0, high=1)`

input manager
- any number of binds for each action (or "verb")
- see `code/scripts/inputScripts`:
- `inputInit()` generates default binds, add or change `inputAddBind(verb,button)` calls to change
- checking if a button is held/pressed/released is checked via the verb, not the button. for example u would type `inputPressed("shoot")` instead of `inputPressed(ord("Z"))`
- for examples see `code/objects/player/Player` (step event)

gamepad support and button rebinding
- automatic button name lookup
- can detect dualshock 4 and maybe other types of playstation controllers. not sure tho i only have one pad so i cant test anything else
- two binds are automatically swapped if there is a collision
- should be easy to add new bindable buttons - its done by a list of verbs in `code/objects/menu/rebinding/ControlsMenuButtonSpawner`


#  what do i want to include in the future?

- an example tileset or two
- setting to disable gamepad
- setting to change gamepad thumbstick deadzone
- more comments and documentation


#  what is *not* in the engine?

- anything that comes down to "style"
- difficulty settings
- society has moved past the need for slippery ice blocks


#  known bugs

- snapform is sometimes not snapped to when moving down and player is jumping up (relative to gravity)

