# findex
lightweight application launcher using dmenu

![ScreenShot](/images/screenshot1.jpg) . ![ScreenShot](/images/screenshot2.jpg)

## Dependencies
#### Ruby
* json
* fileutils

#### third party 
* [dmenu-4.6](http://tools.suckless.org/dmenu/)

## Installation

Install **ruby** and **dmenu** with you're package manager like apt-get or pacman.
```
sudo gem install --no-user-install --no-ri --no-rdoc json fileutils
cd /tmp
git clone https://github.com/Ghardo/findex.git
cd findex
sudo cp -R src/ /opt/findex
sudo ln -s /opt/findex/findex.rb /usr/bin/findex
findex -u
```
Create a shortcut like ***Windows Key+Space*** with command ***/usr/bin/findex*** in you're desktop environment.

## Configuration
See **~/.config/findex/config** for example 

## Arguments

| Param | Description |
| --- | --- |
|**-u**, **--update** | refresh executeables list from the path environment|
|**-c**, **--clear-history**| history gets cleared|
|**-v**, **--version**| prints the version|
|**-h**, **--help**| prints help|

## Usage

| Modifier | Example | Description |
| --- | --- | --- |
||**\[COMMAND\]** | normal execution of **\[COMMAND\]**|
|;|**\[COMMAND\];** |run **\[COMMAND\]** in configured terminal DEFAULT: urxvt --title "%TITLE%" --hold -e bash -c "%COMMAND%"|
|!|**\[COMMAND\]!** |  run  **\[COMMAND\]** with alternative gtk themes (some applications conflicts with dark themes)|
|![0-9]|**\[COMMAND\]!** |  run  **\[COMMAND\]** with the theme wohis set under the index in the teme configuration array|
|#|**\[COMMAND\]#** |  run  **\[COMMAND\]** with sudo (terminal) or gksu|

Modifieres can be combined but the Theme Modifier must be at least.

