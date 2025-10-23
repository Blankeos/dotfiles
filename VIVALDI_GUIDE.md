## Vivaldi Guide

[📹 Preview Video](https://x.com/carlo_taleon/status/1922366821090414840)

Most settings are synced with my account. Since there is zero concept of a "serialized config" for Vivaldi, I just have a guide, that I religiously update whenever I change my settings:

> Symbol meanings: ☑️ Uncheck | ✅ Check

- **Themes** > I use [Arc Dark Pure](https://themes.vivaldi.net/themes/NOb71LX8J1g), but overrode the highlight to `#2b7fff`
- Type in the URL bar: `vivaldi:flags` > Allow CSS Modifications - Enabled.
- **Appearance** > Custom UI Modifications (This is now visible)
  - Select the folder I have in this repo `.config/vivald-mod`
  - That folder contains what I got from either vivalarc-6.9, etc. [(Here)](https://github.com/tovifun/VivalArc/tree/main).
- Panel
  - **Panel Position** > Right Side
  - **Panel Options** > Show Panel Toggle - ☑️
- Tabs
  - **New Tab Position** - After Active Tab - ✅
  - **Tab Features > Tab Stacking** > Accordion - ✅
  - **Tab Features** > Show Tab Cycler - ✅
  - **Tab Display** > Display Close Button > On Left Side - ☑️ (Because it hides the favicon)
  - **Tab Display** > Display Trashed Can - ☑️ (Might not exist anymore)
  - **Tab Display** > Display Synced Tabs - ☑️ (Might not exist anymore)
- Address Bar
  - **Address Field Options** > Show Full Address - ✅
  - **Extension Visibility** > Expand Hidden Extensions to Drop-Down Menu - ✅
- Keyboard (My preferred Hotkeys, just search and set, do this step-by-step since I also remove conflicting hotkeys)
  - New Tab - Clear and Add `^T` (There are times when you prefer to make a new tab only, instead of Command Palette)
  - Quick Commands - Clear and Add `⌘T` (Like Arc)
  - Create Bookmark - Remove `⌘D` (I don't use it)
  - Pin Tab - Add `⌘D` (Like Arc)
  - Address Bar - Add `^D` (Like Arc)
  - Copy Selected Text to Note - `⌥⌘C`
  - Toggle UI - Set `⌥⌘C` (Vivaldi's open/close for Tab Bar is shared, this can remove it)
  - Save Page As - Remove `⌘S`
  - Tab Bar - Set `⌘S`, `^⌘S` (Two hotkeys because in some apps, `⌘S` is overriden. i.e. Excalidraw)
  - Print - Clear and Add `^P`.
  - Panel - Add `⌘P`.
  - Tab Cycler Back - Remove `⌘⌥←`
  - Tab Cycler Forward - Remove `⌘⌥→`
  - Previous Tab - Add `⌘⌥←`
  - Next Tab - Add `⌘⌥→`
- Custom Quick Commands - just useful Arc-like splitting features, making it easier to use. Use the exact names so they're easier to search in `⌘T`. Unfortunately, it requires clicks for selection first.
  - `usplit - Unsplit/Until Current Tabs` - Untile All Tabs in Set
  - `csplit - Split/Tile in Flex Column` - Tile Horizontally
  - `rsplit - Split/Tile in Flex Row` - Tile Vertically
  - `gsplit - Split/Tile in Flex Row` - Tile To Grid
