JTAttributedLabel
=================

Ported back NSAttributeString in iOS 5 for you to use **Attributed UILabel in Interface Builder.** (experimental)

<img src=https://github.com/mystcolor/JTAttributedLabel/raw/master/attributesPanel.png></img>

Lesson
------

[NSAttributedString UIKit Additions](http://developer.apple.com/library/ios/#documentation/uikit/reference/NSAttributedString_UIKit_Additions/Reference/Reference.html) is newly introduced in iOS 6. There it gives the power to developers to specifiy NSAttributedString into common UI elements such as UILabel, UIButton, etc, without digging into complex CoreText APIs.

While there are already out there a few libraries such as [TTTAttributedLabel](https://github.com/mattt/TTTAttributedLabel), [RTLabel](https://github.com/honcheng/RTLabel), [OHAttributedLabel](https://github.com/AliSoftware/OHAttributedLabel), etc. All of them are quite powerful yet support various kinds of markups, but I couldn't find one bridging back the missing piece - **to support direct specifying NSAttributedString to UILabel in Interface Builder for iOS 5.** And here the JTAttributedLabel is the project trying to port back the missing part.

In Interface Builder, if you specify an NSAttributedString in UILabel, the SDK is clever enough to make your view configuration compatible with iOS 5, but returns to a plain text layout.

The first problem for me is how we can extract the NSAttributedString out from UILabel we put into Interface builder. The `attributedText` property is missing from the UILabel class in iOS 5. I remembered UI elements get `-[UIView initWithCoder:]` called once they've been initialized by the OS, and I believe there's somewhere I can find the hidden `attributedText`.

`NSCoder` is not like `NSDictionary` where we can simply use NSLog to print out the encapsulated properties. Thanks to [@nicklockwood](https://twitter.com/nicklockwood/status/287115589527408640) hints on using `NSProxy`, it is simple enough for me to create a straight forward [NSProxy subclass](https://gist.github.com/4466616) to wrap around the `NSCoder` object and see how iOS 6 deal with it. And there I discover the "UIAttributedText" key.

Having the attributedText in hand I immediately tried to assign it into those rich text UILabel libraries. I thought it was that simple but then it causes mysterous crashes in the CoreText APIs. After some investigaion I realized the underlying implementation of the NSAttributedString is slightly different. iOS 6 seems to include a new class `NSParagraphStyle` that holds the text attributes.By borrowing the techique from [@hlfcoding in his RRAutoLayout introduction][1], I am able to implement the `NSParagraphStyle` conditionally in runtime like so:

```objective-c
if( ! NSClassFromString(@"NSParagraphStyle") ){
    objc_registerClassPair(objc_allocateClassPair([JTParagraphStyle class], "NSParagraphStyle", 0));
}
```

So its in different data structure than the CoreText compliment. I realized I have to translate the iOS 6 NSAttributeString into an iOS 5 compatible version, there I found some features which couldn't be mapped stated down at "Known Issues".

So after all that, I create a subclass of `UILabel` with a `CATextLayer` to layout the NSAttributeString. And now we've a light weight but imperfect implementation.


Usage (CocoaPods)
-----------------

Install via CocoaPods, thanks [blakewatters](https://github.com/blakewatters/) for making it happen!


Usage
-----

Drop all header and implementation files in JTAttributedLabel/JTAttributedLabel to your project.

In your Interface Builder, drag in a UILabel and specify its subclass to `JTAttributedLabel` or `JTAutoLabel`.

The difference between `JTAttributedLabel` and `JTAutoLabel` is the latter one will automatically use iOS 6 default `UILabel` class for best displaying result.

Requirements
------------

- CoreText.framework
- QuartzCore.framework

Demo
----

<img src=https://github.com/mystcolor/JTAttributedLabel/raw/master/demo1.png></img>
<img src=https://github.com/mystcolor/JTAttributedLabel/raw/master/knownissue.png></img>

Updates
-------

- Vertical text center alignment (21 Jan 2013)


Known Issues
------------

- No text highlighting
- No StrikeThrough effect
- Text are not interactable, which is probably a good custom feature but I don't have any plans to support it at the moment.


If you're also like me who are not ready to drop iOS 5 (yet)
------------------------------------------------------------

There are some also some really popular libraries that brought back iOS 6 goodies for iOS 5.
- [RRAutoLayout][1]
- [PSTCollectionView](https://github.com/steipete/PSTCollectionView) 

[1]:https://github.com/RolandasRazma/RRAutoLayout


Enjoy and please feel free to fork and comments!

JTAttributedLabel is under MIT LICENSE
Made by James Tang [@mystcolor](http://www.twitter.com/mystcolor)


