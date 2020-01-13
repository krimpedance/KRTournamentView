[English](../En/HowToUse.md)

# 使い方

`/Demo` フォルダにサンプルがあるのでそちらも参考にしてください．

- [トーナメント表の追加](#トーナメント表の追加)
- [KRTournamentViewDataSource](#krtournamentviewdatasource)
- [KRTournamentViewDelegate](#krtournamentviewdelegate)
- [データの再読み込み](#データの再読み込み)

# トーナメント表の追加

`KRTournamentView` は，`UITableView` のように`KRTournamentViewDataSource` と `KRTournamentViewDelegate` により表示と挙動を制御します．

```swift
let tournamentView = KRTournamentView()
tournamentView.dataSource = self
tournamentView.delegate = self
addSubview(tournamentView)
```

# KRTournamentViewDataSource

このプロトコルを用いて，トーナメント構造と表示データを実装します．

```swift
protocol KRTournamentViewDataSource {
    // トーナメント表の構造を返すようにします．
    func structure(of tournamentView: KRTournamentView) -> Bracket
    // 各Entryのビューを実装します．
    func tournamentView(_ tournamentView: KRTournamentView，entryAt index: Int) -> KRTournamentViewEntry
    // 各Matchのビューを実装します. 勝者はここで設定できます．
    func tournamentView(_ tournamentView: KRTournamentView，matchAt matchPath: MatchPath) -> KRTournamentViewMatch
}
```

+ `structure(of tournamentView: KRTournamentView) -> Bracket`

  トーナメント構造を返します．
  構築方法は[こちら](./Builder.md)を参考にしてください．

+ `tournamentView(_ tournamentView: KRTournamentView，entryAt index: Int) -> KRTournamentViewEntry`

  この関数はエントリーの数だけ呼ばれます．
  `index` は左から右，上から下の順に採番されます．

  `KRTournamentViewEntry` クラスを拡張することで，独自のデザインを行えます．

+ `tournamentView(_ tournamentView: KRTournamentView，matchAt matchPath: MatchPath) -> KRTournamentViewMatch`

  この関数は対戦の数だけ呼ばれます．
  `MatchPath` については[こちら](./Builder.md#matchpath)を参照してください．

  `KRTournamentViewMatch` クラスを拡張することで，独自のデザインを行えます．


# KRTournamentViewDelegate

このプロトコルを用いて，エントリーのサイズやタップ時の挙動を実装します．

```swift
protocol KRTournamentViewDelegate {
    // Entry のサイズを返します．
    func entrySize(in tournamentView: KRTournamentView) -> CGSize
    // Entry が選択された時に呼ばれます．
    func tournamentView(_ tournamentView: KRTournamentView，didSelectEntryAt index: Int)
    // Match が選択された時に呼ばれます．
    func tournamentView(_ tournamentView: KRTournamentView，didSelectMatchAt matchPath: MatchPath)
}
```

+ `entrySize(in tournamentView: KRTournamentView) -> CGSize`

  サイズの違いによる見た目は[こちら](./Style.md#エントリーのサイズ設定)を参考にしてください．


# データの再読み込み

データを再読み込みする場合は，以下の関数を呼びます．

```swift
func reloadData()
```