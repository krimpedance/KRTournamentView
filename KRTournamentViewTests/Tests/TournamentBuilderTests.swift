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
            let builder = TournamentBuilder(children: [.entry], numberOfWinners: 2, winnerIndexes: [0, 2])
            expect(builder.children).to(equal([.entry]))
            expect(builder.numberOfWinners).to(be(2))
            expect(builder.winnerIndexes).to(equal([0, 2]))

            let builder2 = TournamentBuilder()
            expect(builder2.children.isEmpty).to(beTrue())
            expect(builder2.numberOfWinners).to(be(1))
            expect(builder2.winnerIndexes).to(equal([]))
        }

        it("can initialize with symmetrical children") {
            let builders: [TournamentBuilder] = [
                .init(numberOfLayers: 1),
                .init(numberOfLayers: 2),
                .init(numberOfLayers: 1, numberOfEntries: 4, numberOfWinners: 2),
                .init(numberOfLayers: 2, numberOfEntries: 4, numberOfWinners: 2),
                .init(numberOfLayers: 2) { ($0.layer == 1) ? [0] : [1] }
            ]
            let manualBuilders: [TournamentBuilder] = [
                .init(children: [.entry, .entry]),
                TournamentBuilder()
                    .addBracket { .init(children: [.entry, .entry]) }
                    .addBracket { .init(children: [.entry, .entry]) },
                TournamentBuilder(numberOfWinners: 2).addEntry(4),
                TournamentBuilder(numberOfWinners: 2)
                    .addBracket { TournamentBuilder(numberOfWinners: 2).addEntry(4) }
                    .addBracket { TournamentBuilder(numberOfWinners: 2).addEntry(4) },
                TournamentBuilder(winnerIndexes: [1])
                    .addBracket { .init(children: [.entry, .entry], winnerIndexes: [0]) }
                    .addBracket { .init(children: [.entry, .entry], winnerIndexes: [0]) }
            ]

            expect(builders).to(equal(manualBuilders))
        }

        // Static actions ------------

        it("returns symmetrical Bracket") {
            let brackets: [Bracket] = [
                TournamentBuilder.build(numberOfLayers: 1),
                TournamentBuilder.build(numberOfLayers: 2),
                TournamentBuilder.build(numberOfLayers: 1, numberOfEntries: 4, numberOfWinners: 2),
                TournamentBuilder.build(numberOfLayers: 2, numberOfEntries: 4, numberOfWinners: 2),
                TournamentBuilder.build(numberOfLayers: 2) { ($0.layer == 1) ? [0] : [1] }
            ]
            let expectedBrackets: [Bracket] = [
                TournamentBuilder(numberOfLayers: 1).build(format: true),
                TournamentBuilder(numberOfLayers: 2).build(format: true),
                TournamentBuilder(numberOfLayers: 1, numberOfEntries: 4, numberOfWinners: 2).build(format: true),
                TournamentBuilder(numberOfLayers: 2, numberOfEntries: 4, numberOfWinners: 2).build(format: true),
                TournamentBuilder(numberOfLayers: 2) { ($0.layer == 1) ? [0] : [1] }.build(format: true)
            ]

            expect(brackets == expectedBrackets).to(beTrue())
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
            expect(builder.children).to(equal([.entry]))
            builder.addEntry(2)
            expect(builder.children).to(equal([.entry, .entry, .entry]))
        }

        it("can add bracket") {
            let bracketBuilder = TournamentBuilder(children: [.entry, .entry], numberOfWinners: 2, winnerIndexes: [0, 1])
            let builder = TournamentBuilder().addBracket { bracketBuilder }
            expect(builder.children).to(equal([.bracket(bracketBuilder)]))
        }

        it("keeps children order") {
            let builder = TournamentBuilder()
            builder.addEntry()
            builder.addBracket { .init(children: [.entry, .entry]) }
            builder.addEntry()

            let children: [TournamentBuilder.BuildType] = [.entry, .bracket(.init(children: [.entry, .entry])), .entry]
            expect(builder.children).to(equal(children))
        }

        it("can build") {
            let bracket = TournamentBuilder()
                .addEntry()
                .addBracket { .init(children: [.entry, .entry, .entry], numberOfWinners: 2, winnerIndexes: [0, 1]) }
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
                .addBracket { .init(children: [.entry, .entry, .entry], numberOfWinners: 2, winnerIndexes: [0, 1]) }
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
