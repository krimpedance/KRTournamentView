[English](./README.md)

<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/logo.png" width="100%" />

[![Version](https://img.shields.io/cocoapods/v/KRTournamentView.svg?style=flat)](http://cocoapods.org/pods/KRTournamentView)
[![License](https://img.shields.io/cocoapods/l/KRTournamentView.svg?style=flat)](http://cocoapods.org/pods/KRTournamentView)
[![Platform](https://img.shields.io/cocoapods/p/KRTournamentView.svg?style=flat)](http://cocoapods.org/pods/KRTournamentView)
[![Download](https://img.shields.io/cocoapods/dt/KRTournamentView.svg?style=flat)](http://cocoapods.org/pods/KRTournamentView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CI Status](http://img.shields.io/travis/krimpedance/KRTournamentView.svg?style=flat)](https://travis-ci.org/krimpedance/KRTournamentView)

`KRTournamentView` は様々な構造に対応できる柔軟なトーナメント表です.

<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/demo.gif" height=400 />

<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/styles.png" width="100%" />


## 特徴
+ 様々な構造に対応
+ シンプルな実装


## 必要環境
- iOS 8.0+
- Xcode 9.0+
- Swift 4.0+


## デモ
`DEMO/`以下にあるサンプルプロジェクトから確認してください.

または, [Appetize.io](https://appetize.io/app/yevb2mx7ea7p10cjqb9fp3tenm)にてシュミレートしてください.


## インストール
KRTournamentViewは[CocoaPods](http://cocoapods.org)と[Carthage](https://github.com/Carthage/Carthage)で
インストールすることができます.

```ruby
# Podfile
pod "KRTournamentView"
```

```ruby
# Cartfile
github "Krimpedance/KRTournamentView"
```


## 使い方
(`/Demo`以下のサンプルを見てみてください)

`KRTournamentView` は, `UITableView` のように`KRTournamentViewDataSource` と `KRTournamentViewDelegate` により表示項目と挙動を制御します.

```swift
let tournamentView = KRTournamentView()
tournamentView.dataSource = self
tournamentView.delegate = self
addSubview(tournamentView)
```


### KRTournamentViewDataSource

このプロトコルを用いて, トーナメント表のデータを実装します.

```swift
protocol KRTournamentViewDataSource {
    // トーナメント表のレイヤー数を返すようにします.
    func numberOfLayers(in tournamentView: KRTournamentView) -> Int
    // 各Entryのビューを実装します.
    func tournamentView(_ tournamentView: KRTournamentView, entryAt index: Int) -> KRTournamentViewEntry?
    // 各Matchのビューを実装します. 勝者はここで設定できます.
    func tournamentView(_ tournamentView: KRTournamentView, matchAt matchPath: MatchPath) -> KRTournamentViewMatch
}
```

+ `numberOfLayers(in tournamentView: KRTournamentView) -> Int`

  レイヤーは, トーナメント表の高さを表しています.
  最下層(i.e. 1回戦)のレイヤーが `1` になります.

  レイヤーが2の時は2〜4のエントリー, レイヤーが3の時は2~8のエントリーが可能になります. (`2^layer` エントリー)

+ `tournamentView(_ tournamentView: KRTournamentView, entryAt index: Int) -> KRTournamentViewEntry?`

  この関数はエントリーの数だけ呼ばれます.
  `index` は左から右, 上から下の順に採番されます.

  `KRTournamentViewEntry` クラスを拡張することで, 独自のデザインを行えます.

  あるインデックスにエントリーがない場合(i.e. シード), `nil` を返すことでトーナメント表に反映できます.

  例: `index` が `0, 4, 6` のEntryを `nil` にした場合

  <img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/seed.png" height=200 />

+ `tournamentView(_ tournamentView: KRTournamentView, matchAt matchPath: MatchPath) -> KRTournamentViewMatch`

  この関数は試合の数だけ呼ばれます.

  `matchPath.layer` でレイヤーを表します.
  `matchPath.number` はそのレイヤーの試合番号を表し, 左から右, 上から下の順に採番されます.
  (詳しくは **KRTournamentViewMatchセクション** をご覧ください.)

  `KRTournamentViewMatch` クラスを拡張することで, 独自のデザインを行えます.

  勝敗は `KRTournamentViewMatch.preferredSide` プロパティに `.home` か `.away` を設定することで反映できます.
  基本的に左または上のEntryが `.home` , 右または下のEntryが `.away` になります.

  例: `MatchPath(layer: 1, number: 0)` のMatchの `preferredSide` を `.home` に設定した場合

  <img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/preferredSide.png" height=200 />


### KRTournamentViewDelegate

このプロトコルを用いて, エントリーのサイズやタップ時の挙動を実装します.

```swift
protocol KRTournamentViewDelegate {
    // Entry のサイズを返します.
    func entrySize(in tournamentView: KRTournamentView) -> CGSize
    // Entry が選択された時に呼ばれます.
    func tournamentView(_ tournamentView: KRTournamentView, didSelectEntryAt index: Int)
    // Match が選択された時に呼ばれます.
    func tournamentView(_ tournamentView: KRTournamentView, didSelectMatchAt matchPath: MatchPath)
}
```

+ `entrySize(in tournamentView: KRTournamentView) -> CGSize`

  デフォルトは `CGSize(width: 80, height: 30)` です.
  (横並び(e.g. `.top`)の時は逆になります.)

  縦並びの時は `width` , 横並びの時は `height` が, そのままEntryの表示スペースを表すことになります.


## データの再読み込み

データを再読み込みする場合は, 以下のメソッドを使用します.

```swift
func reloadData()
```


## クラス等の説明

### KRTournamentViewEntry

Entry用の基底クラス.

表示サイズは `KRTournamentViewDelegate` にて変更できます.
表示位置は自動で計算されます.

最小構成として, `KRTournamentViewEntryLabel` クラスの `textLabel` があります.
これは, 必要な場合のみ初期化されます. (`lazy var` 実装)

`KRTournamentViewEntryLabel` は, 縦書きを楽に設定できる `UILabel` の薄いラッパークラスです.


### KRTournamentViewMatch

Match用の基底クラス.

表示時の `frame` は自動で計算されます. (下図参照)

最小構成として, `UIImageView` クラスの `imageView` があります.
これは, 必要な場合のみ初期化されます. (`lazy var` 実装)

`imageView` はAutoLayoutにより常に線の交差点に中心があります.
**サイズを変える時は `imageSize` プロパティを使用してください.**

また, `preferredSide` プロパティを使用して勝敗を表現できます.


##### MatchPath

`layer` と `number` からなる構造体で, 各Matchのパスを保持します.

また, トーナメント表内での通し番号を `getIndex(from numberOfLayers: Int)` メソッドで取得できます.

`layer` , `number` , `index` の関係は以下の画像のようになります.
(オレンジ丸の中が `index` , その右上の数字が `(layer)-(number)` .)

|`.left`|`.topBottom`|
|:--:|:--:|
|<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/match_left.png" height=300 />|<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/match_topBottom.png" height=300 />|


## スタイル・色

### トーナメント表の向き

`style` プロパティによりトーナメント表の向きを設定します.

|`.left`|`.right`|`.top`|`.bottom`|`.leftRight(direction: .top)`|`.topBottom(direction: .right)`|
|:--:|:--:|:--:|:--:|:--:|:--:|
|<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/tournament_left.png" />|<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/tournament_right.png" />|<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/tournament_top.png" />|<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/tournament_bottom.png" />|<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/tournament_leftRight.png" />|<img src="https://github.com/krimpedance/Resources/blob/master/KRTournamentView/tournament_topBottom.png" />|

`.leftRight` と `.topBottom` の `direction` プロパティには, 決勝戦の線の向きを設定します.

+ `.leftRight` : `.top` または `.bottom`
+ `.topBottom` : `.right` または `.left`


### トーナメント表の色, 線幅

以下のプロパティによりカスタマイズできます.

```swift
var lineColor: UIColor              // 線の色(標準は黒).
var preferredLinecolor: UIColor     // 勝者の線の色(標準は赤).
var lineWidth: CGFloat              // 線の幅(標準は1.0).
var preferredLineWidth: CGFloat?    // 勝者の線の幅(標準はnil). nilの場合は lineWidth と同じになる.
```

### 画面の回転による挙動

以下のプロパティを `true` にすると, 画面回転時にトーナメント表は回転前と同じ向きになります.

仕様上, エントリーの順番が逆になることがあります.
(エントリーは常に左から右, 上から下の順になる.)

```swift
var fixOrientation: Bool = false
```

|`.portrait`(初期)|`.landscapeLeft`|`.landscapeRight`|`.portraitUpsideDown`|
|:--:|:--:|:--:|:--:|
|`.left`|`.bottom`|`.top`|`.right`|
|`.top`|`.left`|`.right`|`.bottom`|
|`.leftRight(.top)`|`.topBottom(.left)`|`.topBottom(.right)`|`.leftRight(.bottom)`|


## リリースノート

+ 1.0.1 :
  - Swift 4.1 に対応.

+ 1.0.0 :
  - 最初のリリース 🎉


## ライブラリに関する質問等
バグや機能のリクエストがありましたら, 気軽にコメントしてください.


## ライセンス
KRTournamentViewはMITライセンスに準拠しています.

詳しくは`LICENSE`ファイルをみてください.
