# 2048

This is a derivative and the iOS version of the game 2048. In the very unlikely case that you don't know what it is, you can check it out [here](https://github.com/gabrielecirulli/2048).

Made just for fun! You can find it on the [App Store](https://itunes.apple.com/us/app/2048-and-more!/id848859070?ls=1&mt=8).

<p align="center">
  <img src="http://a4.mzstatic.com/us/r30/Purple4/v4/a4/f8/af/a4f8af1d-3878-0817-859d-de76bae169c7/screen568x568.jpeg" alt="Screenshot"/>
</p>

## The Game

Since it is a *derivative* of the original 2048, it is not the *same*. More explicitly, it has the following additions:

* **Three board sizes**: 3x3, 4x4 and 5x5. The smaller the board is, the fewer cells you have, and the harder the game is.* 
* **Three game modes**: The original Power of 2, i.e. combining two tiles of the same value to produce their sum. The Power of 3, i.e. combining *three* consecutive tiles of the same value to produce their sum. Not surprisingly, this is pretty hard with the 3x3 board, although I found it pretty easy to get 81. 243 is a different story... And the Fibonacci sequence, i.e. combining two adjacent numbers in the sequence 2, 3, 5, 8, 13... (I omitted the two 1's in the beginning) to produce the one next to the larger value. This is pretty tricky. Try it out and you will know what I mean.
* **Three themes**: I made a bright theme and a 'joyful' theme in addition to the original one. In case you wonder how to do themes in iOS. (There may be a better way, but themes are verbose in nature, because you *have to* specify all the colors, fonts, etc.)

## The Technology

This version of 2048 is built using SpriteKit, the new 2-D game engine Apple introduced to iOS 7. As a result, it requires iOS 7 to run. On the other hand, this app has the following two great properties:

* It does not rely on *any* third-party library. Not that Cocos-2D is not great, but the fact it's using SpriteKit means that it does not have any dependencies.
* It does not have any images. That's right. The entire UI is done either via UIKit, or by Core Graphics. Check out the related files to see how that is done, if you are curious.

You should be able to download the source, and build and run without problem. However, please note that you may not want to run it in the simulator unless you don't have an Apple Developer account. SpriteKit does use OpenGL, and simulating that using CPU will cause your computer to take off.

## The Code

First off, the best thing about the code is that it's pretty well documented. Most methods have the Apple-style documentation, which means that you can triple-click on the method name to get its documentation.

The code started to resemble the structure of the original 2048. So for example, it has a game manager, a board class, a tile class, etc. I at least *tried* to stick to MVC as much as possible. Here is a brief summary to get you started:

* The `M2GameManager` class controls the game logic. There is only one action in the game: move. So the majority of that class is handling the move. The rest is checking whether you've won or died, etc.
* The `M2Grid` class is the data structure for the board. The original 2048 used a 1-D array, but heck, 2-D array doesn't seem to be too bad here! ...except looping it is a bit ugly, so I made a `forEach` helper function.
* The `M2Cell` class is the "slot"s. They are not the tiles themselves. The benefit of having this class is that the cells never move, so they are good references and they don't mess stuff up.
* The `M2Tile` class is the actual tile, and **this** is the actual SpriteKit class. If all you want is some sample code for SpriteKit, here it is. I believe my animations are smoother than the other 2048 on the App Store, and are closer to the original animation.
* The `M2GlobalState` class is a global class accessible from anywhere in the universe. Well, global stuff is evil, right? At least so we are told. But, it is at least better to encapsulate the global stuff into one single object (namespace), and that's a singleton right there.
* The `M2Theme` class and its subclasses control the theme.
* There are also some controller classes and view classes. It's probably a better idea to do the Game Over scene in SpriteKit, but I was lazy so I faked it using a view. The `M2GridView` class is the one that draws the board, btw.

### Contributing

If you'd like to contribute, great! That's more than welcome. If you do make improvements to it, remember to put yourself in the "About 2048" page to get yourself credit.

If you'd like to fork and make your own version, that's also great! Feel free to tinker with it however you'd like. It may not be a terribly good idea to change the font, add some ads, and submit to Apple, though.

#### Contributors

* Danqing Liu (me)
* [Scott Matthewman](https://github.com/scottmatthewman)


## Licence and Other

2048 for iOS is licenced under the MIT license.

If you find the source code somewhat useful, all I ask is to download it from the [App Store](https://itunes.apple.com/us/app/2048-and-more!/id848859070?ls=1&mt=8), so I know that *someone* has seen it. Relax: It is free; it does not have any ads or weird stuff; it does not send you push notifications to ask you to go back and play it.

You may also consider to [donate](https://github.com/gabrielecirulli/2048) to the maker of the original 2048 if you'd like, of course. (:
