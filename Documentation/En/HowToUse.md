[日本語](../Ja/HowToUse.md)

# How to use

(see sample Xcode project in `/DEMO`)

- [Add KRTournamentView](#add-krtournamentview)
- [KRTournamentViewDataSource](#krtournamentviewdatasource)
- [KRTournamentViewDelegate](#krtournamentviewdelegate)
- [Reload the data](#reload-the-data)

# Add KRTournamentView

`KRTournamentView` controls presentation and behavior by `KRTournamentViewDataSource` and `KRTournamentViewDelegate` like a `UITableView`.

```swift
let tournamentView = KRTournamentView()
tournamentView.dataSource = self
tournamentView.delegate = self
addSubview(tournamentView)
```

# KRTournamentViewDataSource

This protocol represents the data model object.

```swift
protocol KRTournamentViewDataSource {
    // Structure of tournament bracket.
    func structure(of tournamentView: KRTournamentView) -> Bracket
    // Implements a view for each entry.
    func tournamentView(_ tournamentView: KRTournamentView，entryAt index: Int) -> KRTournamentViewEntry
    // Implements a view for each match. The winner can be set here.
    func tournamentView(_ tournamentView: KRTournamentView，matchAt matchPath: MatchPath) -> KRTournamentViewMatch
}
```

+ `structure(of tournamentView: KRTournamentView) -> Bracket`

  Returns tournament structure.

  Please refer [here](./Builder.md) for how to make a tournament structure.

+ `tournamentView(_ tournamentView: KRTournamentView，entryAt index: Int) -> KRTournamentViewEntry`

  This function repeats as many times as the number of entries.
  `index` is numbered from left to right, from top to bottom.

  You can create your own design by extending `KRTournamentViewEntry`.

+ `tournamentView(_ tournamentView: KRTournamentView，matchAt matchPath: MatchPath) -> KRTournamentViewMatch`

  This function repeats as many times as the number of games.
  See [here](./Builder.md#matchpath) for `MatchPath`.

  You can create your own design by extending `KRTournamentViewMatch`.


# KRTournamentViewDelegate

This protocol represents the entries size and behaviour of the entries and matches.

```swift
protocol KRTournamentViewDelegate {
    // Returns entries size.
    func entrySize(in tournamentView: KRTournamentView) -> CGSize
    // Called after the user changes the selection of entry.
    func tournamentView(_ tournamentView: KRTournamentView，didSelectEntryAt index: Int)
    // Called after the user changes the selection of match.
    func tournamentView(_ tournamentView: KRTournamentView，didSelectMatchAt matchPath: MatchPath)
}
```

+ `entrySize(in tournamentView: KRTournamentView) -> CGSize`

  Please refer to [here](./Style.md#entry-size-setting) for the appearance due to the difference in size.


# Reload the data

To reload the data, use the following function.

```swift
func reloadData()
```