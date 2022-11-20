# Lilium

<img src="https://raw.githubusercontent.com/Luki120/luki120.github.io/master/assets/Misc/Lilium.png" width="300">

## Features

* A custom calculator for deg to rad conversion & the other way round.

## How to use

* Slide up the dock and you should see Lilium. An activator listener could definitely be added, but I dislike dependencies so that most likely won't happen.
* You can also dismiss it by swiping up the view.

## Why

* Because the Objective-C Runtime features are great, however they should be handled with caution since it's dark juju. This should not be considered safe at all and it's mainly for myself, **SO USE WITH CAUTION, I'M NOT LIABLE FOR ANYTHING THAT MAY HAPPEN TO YOUR DEVICE DUE TO INSTALLING LILIUM, THE SOFTWARE IS PROVIDED 'AS IS'. READ THE [LICENSE](#license).**

## I want to use it

* Alright sure, however as it is right now it won't compile. First of all, without linking against SpringBoard & SpringBoardHome, the tweak would throw undefined symbols. One would think that linking the frameworks is enough, well it isn't. iOS devs added a safety check(?) so that if you aren't an 'allowed client' you can't extend classes from private frameworks in a category (which is how Lilium works), so the compilation will stop and tell you exactly that. You can get around it though by just going to `$THEOS/sdks/YOUR_SDK/System/Library/PrivateFrameworks/SpringBoard.framework` and edit the .tbd file. At the very top there's a list of allowed clients, you just add the name of the tweak there and it should compile. Same thing for SpringBoardHome.<br>
Cc: Uroboro for suggesting the possibility that such list could be there.

## Contributing

* Contributions are more than welcomed, but should follow this etiquette:

	* If you're a contributor with write access to this repository, you **should NOT** push to main branch, preferably push to a new one and *then* create the PR.
	* Keep commit titles short and then explain them in comments or preferably in the commit's description.
	* Push small commits (e.g if you changed 2 directories, commit one directory, then commit the other directory and only THEN push)

## LICENSE

* [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/)

## Assets LICENSE

* Under no means shall the visual assets of this repository – i.e., all photo-, picto-, icono-, and videographic material – (if any) be altered and/or redistributed for any independent commercial or non-commercial intent beyond its original function in this project. Permissible usage of such content is restricted solely to its express application in this repository and any forks that retain the material in its original, unaltered form only.
