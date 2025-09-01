# Button Prompts For Godot, by Clive Dev
A simple way to always display the right button prompts


[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE.md)
![Supported Godot Version](https://img.shields.io/badge/Godot-4.x-blue)

---

Button prompts are often an underlooked aspect when making a video game, but it is seriously--in my opinion-- a *crucial* part of teaching players how to play your game and what it's mechanics are. So this asset aims to provide developers a way to overcome that aspect without the hassles that come with it; like taking account the many different controller icons, and automatically switching the showed icon depending on the controller used.

[![Ko-fi button](https://storage.ko-fi.com/cdn/kofi6.png)](https://ko-fi.com/Y8Y34J06Q)

# Features
- **Prompts switch automatically.** From keyboard and mouse, to controller, and to other controllers!
- **Supports up to 8 different controller icons!** That's definitely enough.
- **Easy to implement.** It's just nodes you add to your scene.
- **Light on performance.** Little to no performance effects.

# Currently supported controller icons:
- PS5/Dualsense
- Xbox Series
- Steam Deck
- Nintendo Switch Controller
- PS4/Dualshock 4
- Xbox One
- PS3/Dualshock 3
- Xbox 360

For controllers not on the list, it defaults to Xbox icons because that's what's usually, universally used.

Special thanks to [Those Awesome Guys](https://thoseawesomeguys.com/prompts/) for their amazing work on their prompt icons pack, which is what is used for this asset!

And also thanks to [this video](https://youtu.be/d6GtGbI-now) for inspiring this asset.


# Installation
1. Download the latest Github Release
2. Extract the file, and inside `addons`; drag and drop `button_prompts_for_godot` to your project's own `addons` folder. If you don't have an `addons` folder yet, you may drag and drop the extracted `addons` folder, along with it's content, to your project.
3. In Godot, on the menu bar at the top; go to *Project > Project Settings > Plugins* then enable: **Button Prompts For Godot**.
4. Your all set!


# Getting Started
Add a new node to your scene, search for "ButtonPrompt", select the one that suits your usage.

### 1. ![ButtonPromptSprite](./addons/button_prompts_for_godot/Icons/sprite_button_prompt_icon.svg) ButtonPromptSprite
This node is simply a sprite node that displays a button prompt icon. This is good for when you want to show button prompts on it's own, without any text around it.

Set the `Action` variable in it's properties to the **input map action** that you want it to display icons for.


### 2. ![ButtonPromptLabel](./addons/button_prompts_for_godot/Icons/ui_button_prompt_icon.svg) ButtonPromptLabel
This node is a `RichTextLabel` node that can insert prompt icons *between* text. This is good for when you want to have more dialogue around your button prompts.

Simply edit the `text` property of the rich text label. To insert button prompts in between text, put `{action}`. You can change the size of the prompts by adjusting the `Prompt Scale` variable.

Example: "Press {ui_up} to change selection, then {ui_select} to confirm your choice."

> Note: The prompt nodes will only get the first button assigned to the specified `action` from your action map. That means, if you have multiple buttons assigned to an action, like joystick up and d-pad up, whatevers above will be shown on the prompt.


## Configurable Settings
In *Project > Project Settings > General* under the `Addons` category, you will see the settings for the Button Prompts addon. If you don't see it, you can type "button prompts" in the filter settings search bar. Here's what they do:

### 1. Light Themed Keyboard and Mouse
This is self explanatory. Toggle this if you want your keyboard and mouse button prompts to be light themed. If not, leave as is.

### 2. Positional Controller Button Pronpts
Instead of showing specific symbols like a, b, and y; or cross, circle, and triangle; you can show *positional button prompts* which displays an icon that instead highlights where the button is positioned.

### 3. Optional Supported Controllers
This setting was made so that you could disable controllers that *you may not want to load*. The textures of the different controller icons are in spritesheets, and for each controller, they are **pre-loaded on runtime**; and this option is good if you don't want that for all of them. If you think that your player base won't even use some of the supported controllers, like the PS3 for example, you may disable those controllers and prevent it's textures from being loaded. 


## Helpful Methods
There are a few helper functions that you could use to force change the icons used in prompts, this is helpful for when you want to make a settings menu that overrides the prompts to display icons for a specific controller only, and not automatically detect it. These functions are accesible through `ButtonPromptsManager.Instance`.

### 1. `force_set_controller_prompts(controller_type)`
You can use this to force-display a specific controller's prompt icons only. It takes in a parameter of `ButtonPromptsManager.SUPPORTED_CONTROLLERS`, which you can get from `ButtonPromptsManager.Instance`.

### 2. `cycle_prev_controller()` & `cycle_next_controller()`   
These are pretty simple and don't require any parameters. If you forced a specific controller using the last mentioned function, you can use these functions to cycle through the list of supported controllers and update the prompt icons without having to come up with some cycling logic. 

Example: in your settings you could put some arrows that call `cycle_prev_controller()` & `cycle_next_controller()` to change the controller prompts. Like "choose your controller" or something. 

---

That's all the things you'll need know.

# Planned Features
These are some ideas that I would like to implement in the future (if I have the time):
1. Animated Prompts
2. Customizable Icon Textures/Spritsheeet
3. Show Direction of Joystick Movement
4. Multiple Binds. Flash between prompts when more than one bind is assigned to an action
5. Higher-Res textures
6. Steam Input Integration


# License
This asset and it's code are under the [MIT License](LICENSE.md). Feel free to change, remix, or edit the code for your personal and commercial projects!


# That's it
For any questions, concerns, or bug findings; you may post them on this asset's Itch.io page. Feedback is very much appreciated. Thank you for checking out this asset! 