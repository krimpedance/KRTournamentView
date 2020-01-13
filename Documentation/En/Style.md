[日本語](../Ja/Style.md)

# Styles

- [The orientation of the tournament bracket](#the-orientation-of-the-tournament-bracket)
- [color and line width](#color-and-line-width)
- [Entry size setting](#entry-size-setting)
- [Behavior by rotating the screen](#behavior-by-rotating-the-screen)

# The orientation of the tournament bracket

Set the orientation of the tournament bracket in the `style` property.

|`.left`|`.right`|`.top`|`.bottom`|`.leftRight(direction: .top)`|`.topBottom(direction: .right)`|
|:--:|:--:|:--:|:--:|:--:|:--:|
|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/tournament_left.png" />|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/tournament_right.png" />|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/tournament_top.png" />|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/tournament_bottom.png" />|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/tournament_leftRight.png" />|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/tournament_topBottom.png" />|

Set the direction of the finish match line to the `direction` property of `.leftRight` and `.topBottom`.

+ `.leftRight` : `.top` or `.bottom`
+ `.topBottom` : `.right` or `.left`


# color and line width

Customize with the following properties.

```swift
var lineColor: UIColor            // Line color (default is black).
var winnerLinecolor: UIColor      // Winner's line color (default is red).
var lineWidth: CGFloat            // Line width (default is 1.0).
var winnerLineWidth: CGFloat?     // Winner's line width (default is nil). In the case of nil, it is the same as lineWidth.
```

# Entry size setting

By implementing [Delegate](./HowToUse.md#krtournamentviewdelegate), you can change the size of the entry.

|80 x 30|200 x 80|
|:--:|:--:|:--:|:--:|
|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/entrySize_small.png" height="300" />|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/entrySize_large.png" height="300" />|

# Behavior by rotating the screen

```swift
var fixOrientation: Bool = false
```

When the above property is set to `true`, the tournament bracket will be in the same orientation as before rotation.

However, the order of entries may change.
(Entries are always in order from left to right, top to bottom.)

|`.portrait`(initial)|`.landscapeLeft`|`.landscapeRight`|`.portraitUpsideDown`|
|:--:|:--:|:--:|:--:|
|`.left`|`.bottom`|`.top`|`.right`|
|`.top`|`.left`|`.right`|`.bottom`|
|`.leftRight(.top)`|`.topBottom(.left)`|`.topBottom(.right)`|`.leftRight(.bottom)`|