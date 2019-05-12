//
//  BracketTests.swift
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

class BracketTests: QuickSpec {
    private struct FakeBracket: TournamentStructure {}

    override func spec() {
        // Initializer ------------

        it("can initialize") {
            let bracket = Bracket(
                matchPath: .init(layer: 2, item: 1),
                children: [Entry(index: 2), Entry(index: 3), Entry(index: 5), FakeBracket()],
                numberOfWinners: 2,
                winnerIndexes: [0, 2]
            )
            expect(bracket.matchPath).to(equal(.init(layer: 2, item: 1)))
            expect(bracket.children == [Entry(index: 2), Entry(index: 3), Entry(index: 5)]).to(beTrue())
            expect(bracket.numberOfWinners).to(be(2))
            expect(bracket.winnerIndexes).to(equal([0, 2]))

            let bracket2 = Bracket(
                children: [Entry(index: 2), Entry(index: 3), Entry(index: 5), FakeBracket()],
                numberOfWinners: 3,
                winnerIndexes: [0, 1, 3]
            )
            expect(bracket2.matchPath).to(beNil())
            expect(bracket2.children == [Entry(index: 2), Entry(index: 3), Entry(index: 5)]).to(beTrue())
            expect(bracket2.numberOfWinners).to(be(3))
            expect(bracket2.winnerIndexes).to(equal([0, 1, 3]))
        }

        it("can initialize with default value") {
            let bracket = Bracket(
                matchPath: .init(layer: 2, item: 1),
                children: [Entry(index: 2), Entry(index: 3), Entry(index: 5), FakeBracket()]
            )
            expect(bracket.matchPath).to(equal(.init(layer: 2, item: 1)))
            expect(bracket.children == [Entry(index: 2), Entry(index: 3), Entry(index: 5)]).to(beTrue())
            expect(bracket.numberOfWinners).to(be(1))
            expect(bracket.winnerIndexes).to(equal([]))

            let bracket2 = Bracket(children: [Entry(index: 2), Entry(index: 3), Entry(index: 5), FakeBracket()])
            expect(bracket2.matchPath).to(beNil())
            expect(bracket2.children == [Entry(index: 2), Entry(index: 3), Entry(index: 5)]).to(beTrue())
            expect(bracket2.numberOfWinners).to(be(1))
            expect(bracket2.winnerIndexes).to(equal([]))
        }

        // MatchPaths ------------

        it("returns matchPaths") {
            let brackets: [Bracket] = [
                TournamentBuilder.build(numberOfLayers: 2),
                TournamentBuilder()
                    .addBracket { TournamentBuilder.build(numberOfLayers: 2) }
                    .addBracket { TournamentBuilder.build(numberOfLayers: 3) }
                    .build(format: true),
                TournamentBuilder()
                    .addBracket { TournamentBuilder.build(numberOfLayers: 1) }
                    .build(format: true),
                TournamentBuilder()
                    .addBracket { TournamentBuilder.build(numberOfLayers: 1, numberOfEntries: 4, numberOfWinners: 2) }
                    .build(format: true)
            ]
            let matchPaths: [[MatchPath]] = [
                [
                    .init(layer: 2, item: 0),
                    .init(layer: 1, item: 0), .init(layer: 1, item: 1)
                ],
                [
                    .init(layer: 4, item: 0),
                    .init(layer: 3, item: 0),
                    .init(layer: 2, item: 0), .init(layer: 2, item: 1),
                    .init(layer: 3, item: 1),
                    .init(layer: 2, item: 2),
                    .init(layer: 1, item: 0), .init(layer: 1, item: 1),
                    .init(layer: 2, item: 3),
                    .init(layer: 1, item: 2), .init(layer: 1, item: 3)
                ],
                [
                    .init(layer: 1, item: 0)
                ],
                [
                    .init(layer: 2, item: 0),
                    .init(layer: 1, item: 0)
                ]
            ]

            expect(brackets.map { $0.getMatchPaths() }).to(equal(matchPaths))
        }

        // Formatting ------------

        it("returns formatted Bracket") {
            let brackets: [Bracket] = [
                Bracket(children: [Entry(), Entry()]),
                Bracket(matchPath: .init(layer: 5, item: 0), children: [Entry(), Entry()]),
                TournamentBuilder()
                    .addBracket { Bracket(children: [Entry(), Entry()]) }
                    .addBracket { Bracket(children: [Entry(), Entry(), Entry()]) }
                    .build(),
                TournamentBuilder()
                    .addBracket {
                        TournamentBuilder()
                            .addBracket { Bracket(children: [Entry(), Entry()]) }
                            .addBracket { Bracket(children: [Entry(), Entry()]) }
                            .build()
                    }
                    .addBracket {
                        TournamentBuilder()
                            .addBracket {
                                TournamentBuilder()
                                    .addBracket { Bracket(children: [Entry(), Entry()]) }
                                    .addBracket { Bracket(children: [Entry(), Entry()]) }
                                    .build()
                            }
                            .addBracket {
                                TournamentBuilder()
                                    .addBracket { Bracket(children: [Entry(), Entry()]) }
                                    .addBracket { Bracket(children: [Entry(), Entry()]) }
                                    .build()
                            }
                            .build()
                    }
                    .build(),
                TournamentBuilder()
                    .addBracket { Bracket(children: [Entry(), Entry()]) }
                    .build()
            ]

            let expectedBrackets: [Bracket] = [
                Bracket(matchPath: .init(layer: 1, item: 0), children: [Entry(index: 0), Entry(index: 1)]),
                Bracket(matchPath: .init(layer: 1, item: 0), children: [Entry(index: 0), Entry(index: 1)]),
                Bracket(matchPath: .init(layer: 2, item: 0), children: [
                    Bracket(matchPath: .init(layer: 1, item: 0), children: [Entry(index: 0), Entry(index: 1)]),
                    Bracket(matchPath: .init(layer: 1, item: 1), children: [Entry(index: 2), Entry(index: 3), Entry(index: 4)])
                ]),
                Bracket(matchPath: .init(layer: 4, item: 0), children: [
                    Bracket(matchPath: .init(layer: 3, item: 0), children: [
                        Bracket(matchPath: .init(layer: 2, item: 0), children: [Entry(index: 0), Entry(index: 1)]),
                        Bracket(matchPath: .init(layer: 2, item: 1), children: [Entry(index: 2), Entry(index: 3)])
                    ]),
                    Bracket(matchPath: .init(layer: 3, item: 1), children: [
                        Bracket(matchPath: .init(layer: 2, item: 2), children: [
                            Bracket(matchPath: .init(layer: 1, item: 0), children: [Entry(index: 4), Entry(index: 5)]),
                            Bracket(matchPath: .init(layer: 1, item: 1), children: [Entry(index: 6), Entry(index: 7)])
                        ]),
                        Bracket(matchPath: .init(layer: 2, item: 3), children: [
                            Bracket(matchPath: .init(layer: 1, item: 2), children: [Entry(index: 8), Entry(index: 9)]),
                            Bracket(matchPath: .init(layer: 1, item: 3), children: [Entry(index: 10), Entry(index: 11)])
                        ])
                    ])
                ]),
                Bracket(matchPath: .init(layer: 2, item: 0), children: [
                    Bracket(matchPath: .init(layer: 1, item: 0), children: [Entry(index: 0), Entry(index: 1)])
                ])
            ]

            let formattedBrackets = brackets.map { $0.formatted(force: true) }

            (0..<formattedBrackets.count).forEach {
                print(formattedBrackets[$0] == expectedBrackets[$0])
            }

            expect(formattedBrackets == expectedBrackets).to(beTrue())

            // Default force value is true
            expect(formattedBrackets == brackets.map { $0.formatted() }).to(beTrue())

            // Modify self
            let mBrackets: [Bracket] = brackets.map {
                var bracket = $0
                bracket.format()
                return bracket
            }
            expect(formattedBrackets == mBrackets).to(beTrue())
        }

        it("returns Bracket that format if needed") {
            let bracket = Bracket(matchPath: .init(layer: 5, item: 0), children: [Entry(), Entry()])
            expect(bracket == bracket.formatted(force: false)).to(beTrue())
            expect(bracket.formatted(force: false).matchPath).notTo(equal(.init(layer: 1, item: 0)))

            let bracket2 = Bracket(children: [Entry(), Entry()])
            expect(bracket2.formatted(force: false).matchPath).to(equal(.init(layer: 1, item: 0)))
        }
    }
}
