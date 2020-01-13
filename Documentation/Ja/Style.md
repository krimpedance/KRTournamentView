[English](../En/Style.md)

# トーナメント表の見た目の設定

- [向きの設定](#向きの設定)
- [色, 線幅の設定](#色-線幅の設定)
- [エントリーのサイズ設定](#エントリーのサイズ設定)
- [画面の回転による挙動の変更](#画面の回転による挙動の変更)

# 向きの設定

`style` プロパティによりトーナメント表の向きを設定します.

|`.left`|`.right`|`.top`|`.bottom`|`.leftRight(direction: .top)`|`.topBottom(direction: .right)`|
|:--:|:--:|:--:|:--:|:--:|:--:|
|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/tournament_left.png" />|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/tournament_right.png" />|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/tournament_top.png" />|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/tournament_bottom.png" />|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/tournament_leftRight.png" />|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/tournament_topBottom.png" />|

`.leftRight` と `.topBottom` の `direction` プロパティには, 決勝戦の線の向きを設定します.

+ `.leftRight` : `.top` または `.bottom`
+ `.topBottom` : `.right` または `.left`


# 色, 線幅の設定

以下のプロパティによりカスタマイズできます.

```swift
var lineColor: UIColor              // 線の色(初期値は黒).
var winnerLinecolor: UIColor        // 勝者の線の色(初期値は赤).
var lineWidth: CGFloat              // 線の幅(初期値は1.0).
var winnerLineWidth: CGFloat?       // 勝者の線の幅(初期値はnil). nilの場合は lineWidth と同じになる.
```

# エントリーのサイズ設定

[デリゲート](./HowToUse.md#KRTournamentViewDelegate) を実装することで，エントリーのサイズを変更できます．

|80 x 30|200 x 80|
|:--:|:--:|
|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/entrySize_small.png" height="300" />|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/entrySize_large.png" height="300" />|

# 画面の回転による挙動の変更

```swift
var fixOrientation: Bool = false
```

このプロパティを `true` にすると, 画面回転時にトーナメント表は回転前と同じ向きになります.

（エントリーは常に左から右, 上から下の順になるため，エントリーの順番が逆になることがあります.）

|`.portrait`(初期)|`.landscapeLeft`|`.landscapeRight`|`.portraitUpsideDown`|
|:--:|:--:|:--:|:--:|
|`.left`|`.bottom`|`.top`|`.right`|
|`.top`|`.left`|`.right`|`.bottom`|
|`.leftRight(.top)`|`.topBottom(.left)`|`.topBottom(.right)`|`.leftRight(.bottom)`|