# findex
lightweight application launcher using dmenu

![ScreenShot](/images/screenshot1.jpg) . ![ScreenShot](/images/screenshot2.jpg)

## Dependencies
#### Ruby
* json
* fileutils

#### third party 
* [dmenu-4.6](http://tools.suckless.org/dmenu/)

## Installatin
```
sudo cp -R src/ /opt/findex
sudo ln -s /opt/findex/findex.rb /usr/bin/findex
findex -u
```
Create a shortcut like ***Windows Key+Space*** with command ***/usr/bin/findex*** in you're desktop environment.

## Configuration
See **src/default.yaml** or **~/.config/findex/config** for example 

## Arguments

| Param | Description |
| --- | --- |
|**-u**, **--update** | refresh executeables list from the path environment|
|**-c**, **--clear-history**| history gets cleared|
|**-v**, **--version**| prints the version|
|**-h**, **--help**| prints help|

## Usgae

| Modifier | Example | Description |
| --- | --- | --- |
||**\[COMMAND\]** | normal execution of **\[COMMAND\]**|
|;|**\[COMMAND\];** |run **\[COMMAND\]** in configured terminal DEFAULT: urxvt --title "%TITLE%" --hold -e bash -c "%COMMAND%"|
|!|**\[COMMAND\]!** |  run  **\[COMMAND\]** with alternative gtk themes (some applications conflicts with dark themes)|
|#|**\[COMMAND\]#** |  run  **\[COMMAND\]** with with sudo (terminal) or gksu|

