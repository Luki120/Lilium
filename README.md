# Lilium

![Lilium](https://raw.githubusercontent.com/Luki120/luki120.github.io/master/assets/Misc/Lilium.png)

## Features

* A custom calculator for deg to rad conversion & the other way round.

## How to use

* Slide up the dock and you should see Lilium. An activator listener could definitely be added, but I dislike dependencies so that most likely won't happen.
* You can also dismiss it by swiping up the view.

## Why

* Well, the objc runtime features are great, but should also be handled with caution since it's dark juju. This should not be considered safe at all and it's mainly for myself, **SO USE WITH CAUTION, I'M NOT LIABLE FOR ANYTHING THAT MAY HAPPEN TO YOUR DEVICE DUE TO INSTALLING LILIUM, THE SOFTWARE IS PROVIDED 'AS IS'.**

## I want to use it

* Alright, sure go ahead, this is open source software so I won't stop you. However, as it is right now it won't compile. First of all, without linking against SpringBoard & SpringBoardHome, the tweak would throw undefined symbols. One would think that linking the frameworks is enough, well it isn't. Apple added a safety check(?) so that if you aren't an 'allowed client' you can't extend classes from private frameworks in a category (which is how Lilium works), the compilation will stop and tell you exactly that. You can get around it though by just going to `$THEOS/sdks/YOUR_SDK/System/Library/PrivateFrameworks/SpringBoard.framework` and editing the .tbd file. At the very top of the list, there's the list of allowed clients, you just add the name of the tweak there and it should magically compile. Same thing for SpringBoardHome.<br>
Cc: Uroboro for suggesting the possibility that such list could be there.

## Contributing

* Contributions are more than welcomed, but should follow this etiquette:
* Push small commits (e.g if you changed 2 directories, commit one directory, then commit the other directory and only THEN push)
* Keep commit titles short and then explain them in the comments or the description.
* If you're a contributor with write access to this repository, you **should NOT** push to main branch, preferably push to a new branch and *then* create the PR.

## LICENSE

* [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/)

## Assets LICENSE

* Under no means shall the visual assets of this repository – i.e., all photo-, picto-, icono-, and videographic material – (if any) be altered and/or redistributed for any independent commercial or non-commercial intent beyond it's original function in this project. Permissible usage of such content is restricted solely to it's express application in this repository and any forks that retain the material in it's original, unaltered form only.
