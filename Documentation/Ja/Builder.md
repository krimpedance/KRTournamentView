[English](../En/Builder.md)

# トーナメント構造の構築

- [基本的な構築](#基本的な構築)
  - [Entry](#entry)
  - [Bracket](#bracket)
  - [構築例](#構築例)
  - [フォーマット](#フォーマット)
    - [MatchPath](#matchpath)
- [ビルダーによる構築](#ビルダーによる構築)
  - [初期化](#初期化)
  - [トーナメント構造の構築](#トーナメント構造の構築)
  - [ビルド](#ビルド)
  - [構築例](#構築例)

# 基本的な構築

トーナメント構造は木構造とみることができます．

一般的に決勝戦となる部分が根ノードで，初戦の各参加者の部分がそれぞれ葉ノードとなります．

<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/tournament_tree.png" height="200">

## Entry

`KRTournamentView` では，葉ノードにあたる部分を `Entry` 構造体で表現します．

```swift
let entry = Entry()
```

## Bracket

葉ノード以外のノードに当たる部分は `Bracket` 構造体で表現します．

```swift
let bracket = Bracket(
    children: [Entry(), Entry()],
    numberOfWinners: 1,
    winnerIndexes: [0]
)
```

+ `children`

  子ノードに当たる部分を配列で渡します．

+ `numberOfWinnders`

  その `Bracket` における勝利数を設定します．（初期値: 1）

  「4人対戦の2人勝ち上がり」などの状況で使用します．

+ `winnerIndexes`

  勝利者を設定する場合，`children` のインデックスを配列で渡します．

## 構築例

`Entry`, `Bracket` を使用したトーナメント構造の構築例を示します．

<table>
  <td>

  ```swift
  let bracket = Bracket(
      children: [
          Bracket(
              children: [Entry(), Entry(), Entry()],
              numberOfWinners: 2,
              winnerIndexes: [0, 2]
          ),
          Entry()
      ],
      winnerIndexes: [2]
  )
  ```
  </td>
  <td>
    <img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/bracket_sample.png" width="300">
  </td>
</table>

## フォーマット

最後にフォーマットを行うことで，`Entry` の通し番号(`Entry.index`)と`Bracket`の位置情報(`Bracket.matchPath`)を設定することができます．

**（`KRTournamentView` が読み込む時に自動でフォーマットをするので，大抵の場合は行う必要はありません．）**

```swift
bracket.format()
// もしくは
let formatted = bracket.formatted()
```

### MatchPath

`MatchPath` は，`layer` と `item` からなる構造体で, `Bracket` の位置を表しています．

```swift
struct MatchPath {
    public let layer: Int
    public let item: Int
}
```

`Entry.index` と `Bracket.matchPath` の関係は以下のようになります.
(各交点の数字: `{layer}-{item}`)

|`.left`|`.topBottom`|
|:--:|:--:|
|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/matchPath_left.png" height=300 />|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/matchPath_topBottom.png" height=300 />|


# ビルダーによる構築

複雑なトーナメント表をより簡単に構築するには，`TournamentBuilder` クラスを利用できます．

まず，簡単な構築例をみてみましょう．

`Entry`, `Bracket` を直接使用した場合と比べると，簡潔に構築できることが分かります．

<table>
  <td>

  ```swift
  // TournamentBuilder による構築
  let builder = TournamentBuilder(numberOfLayers: 3)
  let bracket = builder.build()


  // Entry, Bracket による構築
  let bracket = Bracket(children: [
      Bracket(children: [
          Bracket(children: [Entry(), Entry()]),
          Bracket(children: [Entry(), Entry()])
      ]),
      Bracket(children: [
          Bracket(children: [Entry(), Entry()]),
          Bracket(children: [Entry(), Entry()])
      ])
  ])
  ```

  </td>
  <td>
    <img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/builder_simple.png" height="300">
  </td>
</table>

## 初期化

`TournamentBuilder` は `Bracket` と同じような初期化ができます．

違う点は，`children` が，列挙型の `BuildType` の配列になっているところです．

```swift
let builder = TournamentBuilder(
  children: [.entry, .entry],
  numberOfWinners: 1,
  winnerIndexes: [0]
)
```

また，全ての対戦において構造が同じ場合は，以下のイニシャライザでまとめて初期化できます．

<table>
  <td>

  ```swift
  let builder = TournamentBuilder(
    numberOfLayers: 2,  // トーナメントのレイヤー数. 木構造でいうところの高さ.
    numberOfEntries: 3,
    numberOfWinners: 1
  ) { matchPath -> [Int] in
    // matchPath ごとに winnerIndexes を返す
    return (matchPath.layer == 1) ? [0] : [1]
  }
  ```

  </td>
  <td>
    <img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/builder_initializer.png" height="300">
  </td>
</table>

## トーナメント構造の構築

`childeren` プロパティなどを直接設定して構築する他に，メソッドチェーンによる構築も可能です．

```swift
func setNumberOfWinners(_ num: Int) -> Self
func setWinnerIndexes(_ indexes: [Int]) -> Self
func addEntry(_ num: Int = 1) -> Self
func addBracket(_ handler: () -> TournamentBuilder) -> Self
```

## ビルド

`build()` 関数により, `Bracket` へ変換します．
`build()` 関数の引数 `format` に `true` を渡すことで，`Bracket.format()` も行います．

```swift
let bracket = blacket.build()
// または
let bracket = blacket.build(format: true)
```

また，以下のスタティック関数を利用することで，初期化とビルドを同時に行うことも可能です．

```swift
let bracket = TournamentBuilder.build(
  numberOfLayers: 2,
  numberOfEntries: 3,
  numberOfWinners: 1
) { matchPath -> [Int] in
  return []
}

// 以下と同じ
// let builder = TournamentBuilder(
//   numberOfLayers: 2,
//   numberOfEntries: 3,
//   numberOfWinners: 1
// ) { matchPath -> [Int] in
//   return []
// }
// let bracket = builder.build(format: true)
```

## 構築例

<table>
  <td>

  ```swift
  let bracket = TournamentBuilder()
      .addBracket({
          TournamentBuilder()
              .setWinnerIndexes([0])
              .addEntry()
              .addBracket {
                  .init(children: [.entry, .entry], winnerIndexes: [0])
              }
      })
      .addBracket({
          TournamentBuilder()
              .setNumberOfWinners(2)
              .addEntry(3)
      })
      .build()
  ```

  </td>
  <td>
    <img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/builder_sample.png" height="300">
  </td>
</table>
