# Button Prompts For Godot, by Clive Dev
A simple way to always display the right button prompts


[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE.md)
![Supported Godot Version](https://img.shields.io/badge/Godot-4.x-blue)

<p align="center"><img src="/.github/demonstration.gif" alt="button-prompt-showcase" width="600px" height="338px"></p>

---

Button prompts are often an underlooked aspect when making a video game, but it is seriously--in my opinion-- a *crucial* part of teaching players how to play your game and what it's mechanics are. So this asset aims to provide developers a way to overcome that aspect without the hassles that come with it; like taking account the many different controller icons, and automatically switching the showed icon depending on the controller used.

<a href='https://ko-fi.com/Y8Y34J06Q' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi6.png?v=6' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

# Features
- **🔁 Prompts switch automatically.** From keyboard and mouse, to controller, and to other controllers!
- **🎮 Supports up to 8 different controller icons!** That's definitely enough.
- **🔨 Easy to implement.** It's just nodes you add to your scene.
- **✅ Light on performance.** Little to no performance effects.

<p align="center"><img src="/.github/steam_deck.gif" alt="button-prompt-showcase" width="600px" height="338px"></p>

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
Add a new node to your scene, search for "ButtonPrompt", then select the one that suits your usage.

Alternatively, you can open the demo scene and mess around. (addons > button_prompts_for_godot > Demo Scene)

Heres a brief explanation of the two nodes:

> Note: The prompt nodes will only get the first button assigned to the specified `action` from your action map. That means, if you have multiple buttons assigned to an action, like joystick up and d-pad up, whatevers above will be shown on the prompt.

### 1. ![ButtonPromptSprite](./addons/button_prompts_for_godot/Icons/sprite_button_prompt_icon.svg) ButtonPromptSprite
This node is a Sprite2D node that displays a single button prompt. This is good for when you want to **show a single prompt with no text around it**.

Set the `Action` variable in it's properties to the **input map action** that you want it to display icons for.

Example Action: `ui_up`


### 2. ![ButtonPromptLabel](./addons/button_prompts_for_godot/Icons/ui_button_prompt_icon.svg) ButtonPromptLabel
This node is a RichTextLabel node that can display one or multiple button prompts **in-between text**. This is good for when you want to **show one or more prompts with text around it**.

Edit the `text` property of the RichTextLabel, and insert button prompts in between text by using this format: `{action_name}`.

You can change the size of the prompts by adjusting the `Prompt Scale` variable.

Example: "Press {ui_up} to change selection, then {ui_select} to confirm your choice."

## Settings

In *Project > Project Settings > General* under the `Addons` category, you will see the settings for the Button Prompts addon. If you don't see it, you can type "button prompts" in the filter settings search bar. Here's what they do:

1. **Light Themed Keyboard and Mouse**

This is self explanatory. Toggle this if you want your keyboard and mouse button prompts to be light themed. If not, leave as is.

2. **Positional Controller Button Prompts**

Instead of showing specific symbols like a, and b; or cross, and circle; you can show *positional button prompts*, which displays an icon that instead highlights where the button is positioned.

3. **Optional Supported Controllers**

This setting allows you to **preload only specific controller icons**. This can be useful if you want to not-load specific controller icons that you know your player base won't use anyways, maybe like the PS3 icons.


## Helpful Functions
These functions are accesible through `ButtonPromptsManager.Instance`.

1. `force_set_controller_prompts(controller_type)`

You can use this to force-display a specific controller's icons only. It takes in a parameter of `ButtonPromptsManager.SUPPORTED_CONTROLLERS`, which you can get from `ButtonPromptsManager.Instance`.

2. `cycle_prev_controller()` & `cycle_next_controller()`   

If you forced a specific controller using the last mentioned function, you can use these functions to cycle through the list of supported controllers and update the prompt icons without having to make your own cycling logic. 

You may want this in your settings where there are some arrows that call `cycle_prev_controller()` & `cycle_next_controller()` to change the controller icons. Like "choose your controller's icons" or something. 


# Planned Features
These are some ideas that I would like to implement in the future--if I have the time!
1. Animated Prompts
2. Customizable Icon Textures/Spritsheeet
3. Show Direction of Joystick Movement
4. Multiple Binds. Flash between prompts when more than one bind is assigned to an action
5. Higher-Res textures
6. Steam Input Integration


# License
This asset and it's code are under the [MIT License](LICENSE.md). Feel free to change, remix, or edit the code for your personal and commercial projects!


# That's it
For any questions, concerns, or bug findings; you may post them on this asset's Itch.io page. Feedback is very much appreciated. Thank you so much for checking out this asset! 