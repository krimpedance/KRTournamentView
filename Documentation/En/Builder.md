[日本語](../Ja/Builder.md)

# Building a tournament structure

- [Basic building](#basic-building)
  - [Entry](#entry)
  - [Bracket](#bracket)
  - [Building example](#building-example)
  - [Formatting](#formatting)
    - [MatchPath](#matchpath)
- [Builder building](#builder-building)
  - [Initialization](#initialization)
  - [Building a structure](#building-a-structure)
  - [Build](#build)
  - [Building example](#building-example)

# Basic building

The tournament structure is a tree structure.

The final game is the root node, and each entry is a leaf node.

<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/tournament_tree.png" height="200">

## Entry

In `KRTournamentView`, leaf nodes in tree structure are represented by `Entry` struct.

```swift
let entry = Entry()
```

## Bracket

Nodes other than leaf nodes are represented by `Bracket` struct.

```swift
let bracket = Bracket(
    children: [Entry(), Entry()],
    numberOfWinners: 1,
    winnerIndexes: [0]
)
```

+ `children`

  Set child structures as an array.

+ `numberOfWinnders`

  Set the number of wins in the `Bracket`. (Default: 1)

  Use in situations such as "two players win in a four-player match".

+ `winnerIndexes`

  To set the winners, set the `children` indices as an array.

## Building example

Here is an example of building a tournament structure using `Entry` and `Bracket`.

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

## Formatting

Finally, you can set the index of the `Entry` (`Entry.index`) and the location of the `Bracket` (`Bracket.matchPath`) by formatting.

**(In most cases, you do not need to do this, as `KRTournamentView` will automatically format it when it loads it.)**

```swift
bracket.format()
// or
let formatted = bracket.formatted()
```

### MatchPath

This is a struct object composed of `layer` and `item`, and it represents the position of each `Bracket`.

```swift
struct MatchPath {
    public let layer: Int
    public let item: Int
}
```

The relationship `Entry.index` and `Bracket.matchPath` is as shown below.
(Number at each intersection: `{layer}-{item}`)

|`.left`|`.topBottom`|
|:--:|:--:|
|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/matchPath_left.png" height=300 />|<img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/matchPath_topBottom.png" height=300 />|


# Builder building

To make building complex tournament structures easier, you can use the `TournamentBuilder` class.

First, let's look at a simple building example.

Compared to using `Entry` and` Bracket` directly, you can see that it can be built more concisely.

<table>
  <td>

  ```swift
  // Use TournamentBuilder
  let builder = TournamentBuilder(numberOfLayers: 3)
  let bracket = builder.build()


  // Use Entry and Bracket
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

## Initialization

`TournamentBuilder` can be initialized in the same way as` Bracket`.

The difference is that `children` is an array of `BuildType` enum.

```swift
let builder = TournamentBuilder(
  children: [.entry, .entry],
  numberOfWinners: 1,
  winnerIndexes: [0]
)
```

Also, if the structure is the same in all matches, you can initialize them collectively with the following initializers:

<table>
  <td>

  ```swift
  let builder = TournamentBuilder(
    numberOfLayers: 2,  // Number of layers in torunament. Height in tree structure.
    numberOfEntries: 3,
    numberOfWinners: 1
  ) { matchPath -> [Int] in
    // Returns winnerIndexes for each matchPath
    return (matchPath.layer == 1) ? [0] : [1]
  }
  ```

  </td>
  <td>
    <img src="https://raw.githubusercontent.com/krimpedance/Resources/master/KRTournamentView/builder_initializer.png" height="300">
  </td>
</table>

## Building a structure

In addition to directly setting the `childeren` property etc., it is also possible to build by method chain.

```swift
func setNumberOfWinners(_ num: Int) -> Self
func setWinnerIndexes(_ indexes: [Int]) -> Self
func addEntry(_ num: Int = 1) -> Self
func addBracket(_ handler: () -> TournamentBuilder) -> Self
```

## Build

Convert to `Bracket` by `build()` function.
When the argument `format` of the `build()` function is set to` true`, internally calls `Bracket.format()`.

```swift
let bracket = blacket.build()
// or
let bracket = blacket.build(format: true)
```

In addition, you can perform initialization and build together using the following static functions:

```swift
let bracket = TournamentBuilder.build(
  numberOfLayers: 2,
  numberOfEntries: 3,
  numberOfWinners: 1
) { matchPath -> [Int] in
  return []
}

// let builder = TournamentBuilder(
//   numberOfLayers: 2,
//   numberOfEntries: 3,
//   numberOfWinners: 1
// ) { matchPath -> [Int] in
//   return []
// }
// let bracket = builder.build(format: true)
```

## Building example

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
