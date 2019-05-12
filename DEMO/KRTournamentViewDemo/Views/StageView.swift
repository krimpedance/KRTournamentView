//
//  StageView.swift
//  KRTournamentViewDemo
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import UIKit
import KRTournamentView

class StageView: UIView {

    @IBOutlet weak var tournamentView: KRTournamentView!

    var observations = [NSKeyValueObservation]()

    let items: [(KRTournamentViewStyle, Bracket)] = [
        (
            .leftRight,
            TournamentBuilder()
                .addEntry()
                .addBracket { TournamentBuilder.build(numberOfLayers: 2) }
                .build(format: true)
        ),
        (.left, TournamentBuilder.build(numberOfLayers: 4) { _ in [0] }),
        (.right, TournamentBuilder.build(numberOfLayers: 4) { _ in [0] }),
        (.top, TournamentBuilder.build(numberOfLayers: 4) { _ in [0] }),
        (.bottom, TournamentBuilder.build(numberOfLayers: 4) { _ in [0] }),
        (.leftRight(direction: .top), TournamentBuilder.build(numberOfLayers: 4) { _ in [0] }),
        (.topBottom(direction: .right), TournamentBuilder.build(numberOfLayers: 4) { _ in [0] }),

        (
            .left,
            TournamentBuilder(winnerIndexes: [0])
                .addBracket {
                    TournamentBuilder(winnerIndexes: [0])
                        .addBracket {
                            TournamentBuilder(winnerIndexes: [0])
                                .addEntry()
                                .addEntry()
                                .build()
                        }
                        .addEntry()
                        .build()
                }
                .addEntry()
                .build(format: true)
        ),

        (
            .leftRight(direction: .top),
            TournamentBuilder(numberOfWinners: 2, winnerIndexes: [0, 4])
                .addBracket {
                    TournamentBuilder(numberOfWinners: 2, winnerIndexes: [0, 1])
                        .addBracket {
                            TournamentBuilder(winnerIndexes: [0])
                                .addEntry()
                                .addEntry()
                                .build()
                        }
                        .addEntry()
                        .addEntry()
                        .build()
                }
                .addBracket {
                    TournamentBuilder(numberOfWinners: 2, winnerIndexes: [0, 1])
                        .addEntry()
                        .addBracket {
                            TournamentBuilder(winnerIndexes: [0])
                                .addEntry()
                                .addEntry()
                                .build()
                        }
                        .addEntry()
                        .build()
                }
                .addEntry()
                .build(format: true)
        ),

        (
            .left,
            TournamentBuilder(winnerIndexes: [0])
                .addBracket {
                    TournamentBuilder(winnerIndexes: [0])
                        .addEntry()
                        .addEntry()
                        .addEntry()
                        .addEntry()
                        .build()
                }
                .addBracket {
                    TournamentBuilder(winnerIndexes: [1])
                        .addEntry()
                        .addEntry()
                        .addEntry()
                        .addEntry()
                        .build()
                }
                .addBracket {
                    TournamentBuilder(winnerIndexes: [2])
                        .addEntry()
                        .addEntry()
                        .addEntry()
                        .addEntry()
                        .build()
                }
                .addBracket {
                    TournamentBuilder(winnerIndexes: [3])
                        .addEntry()
                        .addEntry()
                        .addEntry()
                        .addEntry()
                        .build()
                }
                .build(format: true)
        ),

        (
            .leftRight(direction: .top),
            TournamentBuilder(winnerIndexes: [0])
                .addBracket {
                    TournamentBuilder(numberOfWinners: 2, winnerIndexes: [0, 2])
                        .addEntry()
                        .addEntry()
                        .addEntry()
                        .addEntry()
                        .build()
                }
                .addBracket {
                    TournamentBuilder(numberOfWinners: 2, winnerIndexes: [0, 3])
                        .addEntry()
                        .addEntry()
                        .addEntry()
                        .addEntry()
                        .build()
                }
                .build(format: true)
        ),
        (
            .leftRight(direction: .top),
            TournamentBuilder(winnerIndexes: [0])
                .addBracket {
                    TournamentBuilder(winnerIndexes: [0])
                        .addBracket {
                            TournamentBuilder(winnerIndexes: [0])
                                .addEntry()
                                .addEntry()
                                .build()
                        }
                        .addBracket {
                            TournamentBuilder(winnerIndexes: [0])
                                .addEntry()
                                .addEntry()
                                .build()
                        }
                        .build()
                }
                .addBracket {
                    TournamentBuilder(winnerIndexes: [0])
                        .addBracket {
                            TournamentBuilder(winnerIndexes: [0])
                                .addEntry()
                                .addEntry()
                                .build()
                        }
                        .addBracket {
                            TournamentBuilder(winnerIndexes: [0])
                                .addEntry()
                                .addEntry()
                                .build()
                        }
                        .build()
                }
                .build(format: true)
        ),
        (
            .leftRight(direction: .top),
            TournamentBuilder(winnerIndexes: [0])
                .addBracket {
                    TournamentBuilder(winnerIndexes: [0])
                        .addBracket {
                            TournamentBuilder(winnerIndexes: [0])
                                .addEntry()
                                .addEntry()
                                .build()
                        }
                        .addEntry()
                        .build()
                }
                .addBracket {
                    TournamentBuilder(winnerIndexes: [0])
                        .addBracket {
                            TournamentBuilder(winnerIndexes: [0])
                                .addEntry()
                                .addEntry()
                                .build()
                        }
                        .addBracket {
                            TournamentBuilder(winnerIndexes: [0])
                                .addEntry()
                                .addEntry()
                                .build()
                        }
                        .build()
                }
                .build(format: true)
        ),
        (
            .leftRight(direction: .top),
            TournamentBuilder(numberOfWinners: 2, winnerIndexes: [0, 2])
                .addBracket {
                    TournamentBuilder(winnerIndexes: [1])
                        .addBracket {
                            TournamentBuilder(winnerIndexes: [1])
                                .addBracket {
                                    TournamentBuilder(winnerIndexes: [1])
                                        .addBracket {
                                            TournamentBuilder(winnerIndexes: [0])
                                                .addBracket {
                                                    TournamentBuilder(winnerIndexes: [1])
                                                        .addEntry()
                                                        .addEntry()
                                                        .build()
                                                }
                                                .addEntry()
                                                .build()
                                        }
                                        .addEntry()
                                        .build()
                                }
                                .addEntry()
                                .build()
                        }
                        .addEntry()
                        .build()
                }
                .addBracket {
                    TournamentBuilder(numberOfWinners: 2, winnerIndexes: [1, 2])
                        .addEntry()
                        .addEntry()
                        .addBracket {
                            TournamentBuilder(winnerIndexes: [1])
                                .addEntry()
                                .addBracket {
                                    TournamentBuilder(winnerIndexes: [1])
                                        .addEntry()
                                        .addBracket {
                                            TournamentBuilder(winnerIndexes: [0])
                                                .addEntry()
                                                .addBracket {
                                                    TournamentBuilder(winnerIndexes: [1])
                                                        .addEntry()
                                                        .addEntry()
                                                        .build()
                                                }
                                                .build()
                                        }
                                        .build()
                                }
                                .build()
                        }
                        .build()
                }
                .build(format: true)
        ),
        (
            .left,
            TournamentBuilder(winnerIndexes: [1])
                .addEntry()
                .addBracket {
                    TournamentBuilder(winnerIndexes: [0])
                        .addBracket {
                            TournamentBuilder(winnerIndexes: [1])
                                .addEntry()
                                .addEntry()
                                .build()
                        }
                        .build()
                }
                .build(format: true)
        )
    ]

    var index = 0 {
        didSet {
            if items.count <= index { return }
            tournamentView.style = items[index].0
            tournamentView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .white
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 0.5

        tournamentView.dataSource = self
        tournamentView.delegate = self
        tournamentView.style = items[index].0
        tournamentView.lineWidth = 2

//        setUpObservers()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        index += 1
    }
}

// MARK: - Actions -------------------

extension StageView {
    func setUpObservers() {
        observations = [
            DataStore.instance.observe(\.entries, options: .new) { [unowned self] _, _ in
                self.tournamentView.reloadData()
            },
            DataStore.instance.observe(\.styleNumber, options: .new) { [unowned self] _, _ in
                self.tournamentView.style = DataStore.instance.style
                self.tournamentView.reloadData()
            },
            DataStore.instance.observe(\.lineColor, options: .new) { [unowned self] _, _ in
                self.tournamentView.lineColor = DataStore.instance.lineColor
                self.tournamentView.reloadData()
            },
            DataStore.instance.observe(\.preferredLineColor, options: .new) { [unowned self] _, _ in
                self.tournamentView.winnerLineColor = DataStore.instance.preferredLineColor
                self.tournamentView.reloadData()
            },
            DataStore.instance.observe(\.fixOrientation, options: .new) { [unowned self] _, _ in
                self.tournamentView.fixOrientation = DataStore.instance.fixOrientation
            }
        ]
    }
}

// MARK: - KRTournament data source -------------------

extension StageView: KRTournamentViewDataSource {
    func structure(of tournamentView: KRTournamentView) -> Bracket {
        return items[index].1
    }

    func tournamentView(_ tournamentView: KRTournamentView, entryAt index: Int) -> KRTournamentViewEntry {
        let entry = KRTournamentViewEntry()
        switch tournamentView.style {
        case .left, .right, .leftRight:
            entry.textLabel.text = "entry \(index+1)"
        case .top, .bottom, .topBottom:
            entry.textLabel.verticalText = "entry \(index+1)"
        }
        return entry
    }

    func tournamentView(_ tournamentView: KRTournamentView, matchAt matchPath: MatchPath) -> KRTournamentViewMatch {
        return KRTournamentViewMatch()
    }
}

// MARK: - KRTournament delegate -------------------

extension StageView: KRTournamentViewDelegate {
    func tournamentView(_ tournamentView: KRTournamentView, didSelectEntryAt index: Int) {
        print("entry \(index) is selected")
    }

    func tournamentView(_ tournamentView: KRTournamentView, didSelectMatchAt matchPath: MatchPath) {
        print("match \(matchPath.layer)-\(matchPath.item) is selected")
    }
}
