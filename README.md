[日本語](./README_Ja.md)

<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/logo.png" width="100%" />

[![Version](https://img.shields.io/cocoapods/v/KRTournamentView.svg?style=flat)](http://cocoapods.org/pods/KRTournamentView)
[![License](https://img.shields.io/cocoapods/l/KRTournamentView.svg?style=flat)](http://cocoapods.org/pods/KRTournamentView)
[![Platform](https://img.shields.io/cocoapods/p/KRTournamentView.svg?style=flat)](http://cocoapods.org/pods/KRTournamentView)
[![Download](https://img.shields.io/cocoapods/dt/KRTournamentView.svg?style=flat)](http://cocoapods.org/pods/KRTournamentView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CI Status](http://img.shields.io/travis/krimpedance/KRTournamentView.svg?style=flat)](https://travis-ci.org/krimpedance/KRTournamentView)

`KRTournamentView` is a flexible tournament bracket that can correspond to the various structure.

<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/demo.gif" height=400 />

<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/styles.png" width="100%" />


## Features
+ Corresponding to the various structures
+ Simple implementation


## Requirements
- iOS 8.0+
- Xcode 9.0+
- Swift 4.0+


## DEMO
To run the example project, clone the repo, and open `KRTournamentViewDemo.xcodeproj` from the DEMO directory.

or [appetize.io](https://appetize.io/app/yevb2mx7ea7p10cjqb9fp3tenm)


## Installation
KRTournamentView is available through [CocoaPods](http://cocoapods.org) and [Carthage](https://github.com/Carthage/Carthage).
To install it, simply add the following line to your Podfile or Cartfile:

```ruby
# CocoaPods
pod "KRTournamentView"
```

```ruby
# Carthage
github "Krimpedance/KRTournamentView"
```

## Usage
(see sample Xcode project in /DEMO)

`KRTournamentView` controls presentation and behavior by `KRTournamentViewDataSource` and `KRTournamentViewDelegate` like a `UITableView`.

```swift
let tournamentView = KRTournamentView()
tournamentView.dataSource = self
tournamentView.delegate = self
addSubview(tournamentView)
```


### KRTournamentViewDataSource

This protocol represents the data model object.

```swift
protocol KRTournamentViewDataSource {
    // Returns number of layers in tournament bracket.
    func numberOfLayers(in tournamentView: KRTournamentView) -> Int
    // Implements a view for each entry.
    func tournamentView(_ tournamentView: KRTournamentView, entryAt index: Int) -> KRTournamentViewEntry?
    // Implements a view for each match. The winner can be set here.
    func tournamentView(_ tournamentView: KRTournamentView, matchAt matchPath: MatchPath) -> KRTournamentViewMatch
}
```

+ `numberOfLayers(in tournamentView: KRTournamentView) -> Int`

  Layer represents height of the tournament bracket.
  Lowermost layer (i.e. first round) is `1`.

  Entries 2 to 4 when the layer is 2, Entries 2 to 8 when the layer is 3. (`2^layer` entries)

+ `tournamentView(_ tournamentView: KRTournamentView, entryAt index: Int) -> KRTournamentViewEntry?`

  This function repeats as many times as the number of entries.
  `index` is numbered from left to right, from top to bottom.

  You can create your own design by extending `KRTournamentViewEntry`.

  If there is no entry in an index, it can be reflected by returning `nil`.

  e.g. When the entry with `index` 0, 4, 6 is set to `nil`

  <img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/seed.png" height=200 />

+ `tournamentView(_ tournamentView: KRTournamentView, matchAt matchPath: MatchPath) -> KRTournamentViewMatch`

  This function repeats as many times as the number of games.

  `matchPath.layer` represents the layer.
  `matchPath.layer` represents the game number.
  It is numbered from left to right, from top to bottom.
  (Please see **KRTournamentViewMatch section** for details)

  You can create your own design by extending `KRTournamentViewMatch`.

  Win or lose is reflected by setting `.home` or `.away` to `KRTournamentViewMatch.preferredSide`.
  The left or top entry is `.home`, the right or bottom entry is `.away`.

  e.g. When `preferredSide` of Match (`MatchPath(layer: 1, number: 0)`) is set to `.home`

  <img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/preferredSide.png" height=200 />


### KRTournamentViewDelegate

This protocol represents the entries size and behaviour of the entries and matches.

```swift
protocol KRTournamentViewDelegate {
    // Returns entries size.
    func entrySize(in tournamentView: KRTournamentView) -> CGSize
    // Called after the user changes the selection of entry.
    func tournamentView(_ tournamentView: KRTournamentView, didSelectEntryAt index: Int)
    // Called after the user changes the selection of match.
    func tournamentView(_ tournamentView: KRTournamentView, didSelectMatchAt matchPath: MatchPath)
}
```

+ `entrySize(in tournamentView: KRTournamentView) -> CGSize`

  Default is `CGSize(width: 80, height: 30)`.
  (The value is reversed when entries is widthwise (e.g. `.top` style).)

  This value simultaneously represents the display space of entries.
  (lengthwise direction uses `width`, widthwise direction uses `height`.)


## Reload the data

To reload the data, use the following function.

```swift
func reloadData()
```


## Explanation of class etc

### KRTournamentViewEntry

Base class for Entry.

Display size can be set with `KRTournamentViewDelegate`.
Display position is calculated automatically.

There is `textLabel` of `KRTournamentViewEntryLabel` class as minimum configuration.
This is only initialized if necessary. (implemented by `lazy var`)

`KRTournamentViewEntryLabel` is a small wrapper class of `UILabel` to ease vertical writing.


### KRTournamentViewMatch

Base class for Match.

Display frame is calculated automatically. (See the figure below)

There is `imageView` of `UIImageView` class as minimum configuration.
This is only initialized if necessary. (implemented by `lazy var`)

The center of `imageView` is always at the intersection of the line by auto layout.
**When changing the size, please use `imageSize` property.**

`preferredSide` represents a win or loss.


##### MatchPath

This is a struct object composed of `layer` and `number`, and it represents the path of each Match.

This can get the serial number in the tournament bracket with the `getIndex(from numberOfLayers: Int)` function.

The relationship between `layer`, `number` and `index` is as shown below.
(The number in the orange circle is `index`, the number in the upper right of it is `(layer)-(number)`.)

|`.left`|`.topBottom`|
|:--:|:--:|
|<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/match_left.png" height=300 />|<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/match_topBottom.png" height=300 />|


## Style and color

### The orientation of the tournament bracket

Set the orientation of the tournament bracket in the `style` property.

|`.left`|`.right`|`.top`|`.bottom`|`.leftRight(direction: .top)`|`.topBottom(direction: .right)`|
|:--:|:--:|:--:|:--:|:--:|:--:|
|<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/tournament_left.png" />|<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/tournament_right.png" />|<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/tournament_top.png" />|<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/tournament_bottom.png" />|<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/tournament_leftRight.png" />|<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/tournament_topBottom.png" />|

Set the direction of the finish match line to the `direction` property of `.leftRight` and `.topBottom`.

+ `.leftRight` : `.top` or `.bottom`
+ `.topBottom` : `.right` or `.left`


### color and line width

Customize with the following properties.

```swift
var lineColor: UIColor              // Line color (default is black).
var preferredLinecolor: UIColor     // Winner's line color (default is red).
var lineWidth: CGFloat              // Line width (default is 1.0).
var preferredLineWidth: CGFloat?    // Winner's line width (default is nil). In the case of nil, it is the same as lineWidth.
```

### Behavior by rotating the screen

When the following property is set to `true`, the tournament bracket will be in the same orientation as before rotation.

However, the order of entries may change.
(Entries are always in order from left to right, top to bottom.)

```swift
var fixOrientation: Bool = false
```

|`.portrait`(initial)|`.landscapeLeft`|`.landscapeRight`|`.portraitUpsideDown`|
|:--:|:--:|:--:|:--:|
|`.left`|`.bottom`|`.top`|`.right`|
|`.top`|`.left`|`.right`|`.bottom`|
|`.leftRight(.top)`|`.topBottom(.left)`|`.topBottom(.right)`|`.leftRight(.bottom)`|


## Release Note

+ 1.0.2 :
  - Fixed bug of layout.

+ 1.0.1 :
  - Compatible with Swift 4.1.

+ 1.0.0 :
  - First release 🎉


## Contributing to this project
I'm seeking bug reports and feature requests.


## License
KRTournamentView is available under the MIT license.

See the LICENSE file for more info.
