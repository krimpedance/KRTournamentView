//
//  TournamentBuilderTests.swift
//  KRTournamentView
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//
//  swiftlint:disable superfluous_disable_command
//  swiftlint:disable identifier_name
//  swiftlint:disable force_try
//  swiftlint:disable force_cast
//  swiftlint:disable function_body_length

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class TournamentBuilderTests: QuickSpec {
    override func spec() {
        it("can initialize") {
            let builder = TournamentBuilder(numberOfWinners: 2, winnerIndexes: [0, 2])
            expect(builder.children.isEmpty).to(beTrue())
            expect(builder.numberOfWinners).to(be(2))
            expect(builder.winnerIndexes).to(equal([0, 2]))

            let builder2 = TournamentBuilder()
            expect(builder2.children.isEmpty).to(beTrue())
            expect(builder2.numberOfWinners).to(be(1))
            expect(builder2.winnerIndexes).to(equal([]))
        }

        // Static actions ------------

        it("returns symmetrical Bracket") {
            let builtBrackets: [Bracket] = [
                TournamentBuilder.build(numberOfLayers: 1),
                TournamentBuilder.build(numberOfLayers: 2),
                TournamentBuilder.build(numberOfLayers: 1, numberOfEntries: 4, numberOfWinners: 2),
                TournamentBuilder.build(numberOfLayers: 2, numberOfEntries: 4, numberOfWinners: 2),
                TournamentBuilder.build(numberOfLayers: 2) { ($0.layer == 1) ? [0] : [1] }
            ]
            let brackets: [Bracket] = [
                .init(matchPath: .init(layer: 1, item: 0), children: [Entry(index: 0), Entry(index: 1)]),
                .init(
                    matchPath: .init(layer: 2, item: 0),
                    children: [
                        Bracket(matchPath: .init(layer: 1, item: 0), children: [Entry(index: 0), Entry(index: 1)]),
                        Bracket(matchPath: .init(layer: 1, item: 1), children: [Entry(index: 2), Entry(index: 3)])
                    ]
                ),
                .init(
                    matchPath: .init(layer: 1, item: 0),
                    children: [Entry(index: 0), Entry(index: 1), Entry(index: 2), Entry(index: 3)],
                    numberOfWinners: 2,
                    winnerIndexes: []
                ),
                .init(
                    matchPath: .init(layer: 2, item: 0),
                    children: [
                        Bracket(
                            matchPath: .init(layer: 1, item: 0),
                            children: [Entry(index: 0), Entry(index: 1), Entry(index: 2), Entry(index: 3)],
                            numberOfWinners: 2
                        ),
                        Bracket(
                            matchPath: .init(layer: 1, item: 1),
                            children: [Entry(index: 4), Entry(index: 5), Entry(index: 6), Entry(index: 7)],
                            numberOfWinners: 2
                        )
                    ],
                    numberOfWinners: 2
                ),
                .init(
                    matchPath: .init(layer: 2, item: 0),
                    children: [
                        Bracket(matchPath: .init(layer: 1, item: 0), children: [Entry(index: 0), Entry(index: 1)], winnerIndexes: [0]),
                        Bracket(matchPath: .init(layer: 1, item: 1), children: [Entry(index: 2), Entry(index: 3)], winnerIndexes: [0])
                    ],
                    winnerIndexes: [1]
                )
            ]

            expect(builtBrackets == brackets).to(beTrue())

            // For check
//            (0..<builtBrackets.count).forEach {
//                print(builtBrackets[$0] == brackets[$0], builtBrackets[$0], brackets[$0], separator: "\n")
//            }
        }

        // Actions ------------

        it("can set numberOfWinners") {
            let builder = TournamentBuilder()
            builder.setNumberOfWinners(2)
            expect(builder.numberOfWinners).to(be(2))
        }

        it("can set winnerIdexes") {
            let builder = TournamentBuilder()
            builder.setWinnerIndexes([0, 1, 2])
            expect(builder.winnerIndexes).to(equal([0, 1, 2]))
        }

        it("can add entries") {
            let builder = TournamentBuilder()
            builder.addEntry()
            expect(builder.children == [Entry()]).to(beTrue())
            builder.addEntry(2)
            expect(builder.children == [Entry(), Entry(), Entry()]).to(beTrue())
        }

        it("can add bracket") {
            let bracket = Bracket(children: [Entry(), Entry()], numberOfWinners: 2, winnerIndexes: [0, 1])
            let builder = TournamentBuilder()
            builder.addBracket {
                Bracket(children: [Entry(), Entry()], numberOfWinners: 2, winnerIndexes: [0, 1])
            }
            expect(builder.children == [bracket]).to(beTrue())
        }

        it("keeps children order") {
            let builder = TournamentBuilder()
            builder.addEntry()
            builder.addBracket {
                Bracket(children: [Entry(), Entry()])
            }
            builder.addEntry()

            let children: [TournamentStructure] = [Entry(), Bracket(children: [Entry(), Entry()]), Entry()]
            expect(builder.children == children).to(beTrue())
        }

        it("can build") {
            let bracket = TournamentBuilder()
                .addEntry()
                .addBracket {
                    TournamentBuilder(numberOfWinners: 2, winnerIndexes: [0, 1])
                        .addEntry(3)
                        .build()
                }
                .build()

            let expectedBracket = Bracket(
                children: [
                    Entry(),
                    Bracket(children: [Entry(), Entry(), Entry()], numberOfWinners: 2, winnerIndexes: [0, 1])
                ]
            )

            expect(bracket == expectedBracket).to(beTrue())
        }

        it("can build and format") {
            let bracket = TournamentBuilder()
                .addEntry()
                .addBracket {
                    TournamentBuilder(numberOfWinners: 2, winnerIndexes: [0, 1])
                        .addEntry(3)
                        .build()
                }
                .build(format: true)

            let expectedBracket = Bracket(
                matchPath: .init(layer: 2, item: 0),
                children: [
                    Entry(index: 0),
                    Bracket(
                        matchPath: .init(layer: 1, item: 0),
                        children: [Entry(index: 1), Entry(index: 2), Entry(index: 3)],
                        numberOfWinners: 2,
                        winnerIndexes: [0, 1]
                    )
                ]
            )

            expect(bracket == expectedBracket).to(beTrue())
        }

        // Int extension ------------

        it("has divisors") {
            expect((-5).divisors).to(equal([]))
            expect(0.divisors).to(equal([]))
            expect(1.divisors).to(equal([1]))
            expect(2.divisors).to(equal([1]))
            expect(3.divisors).to(equal([1]))
            expect(4.divisors).to(equal([1, 2]))
            expect(9.divisors).to(equal([1, 3]))
            expect(24.divisors).to(equal([1, 2, 3, 4, 6, 8, 12]))
        }
    }
}
