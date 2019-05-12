//
//  TournamentStructureTests.swift
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

class TournamentStructureTests: QuickSpec {
    private struct FakeBracket: TournamentStructure {}

    override func spec() {
        it("returns entries") {
            let items: [TournamentStructure] = [
                Entry(index: 4),
                Bracket(children: [Entry(index: 1), Entry(index: 2)]),
                Bracket(children: [
                    Bracket(children: [Entry(index: 1), Entry(index: 2)]),
                    Bracket(children: [Entry(index: 4), Entry(index: 5)])
                ]),
                FakeBracket()
            ]

            let expectedList: [(KRTournamentViewStyle, DrawHalf, [[Entry]])] = [
                (
                    .left, .first,
                    [
                        [Entry(index: 4)],
                        [Entry(index: 1), Entry(index: 2)],
                        [Entry(index: 1), Entry(index: 2), Entry(index: 4), Entry(index: 5)],
                        []
                    ]
                ),
                (
                    .bottom, .second,
                    [
                        [Entry(index: 4)],
                        [Entry(index: 1), Entry(index: 2)],
                        [Entry(index: 1), Entry(index: 2), Entry(index: 4), Entry(index: 5)],
                        []
                    ]
                ),
                (
                    .leftRight, .first,
                    [
                        [Entry(index: 4)],
                        [Entry(index: 1)],
                        [Entry(index: 1), Entry(index: 2)],
                        []
                    ]
                ),
                (
                    .topBottom, .second,
                    [
                        [Entry(index: 4)],
                        [Entry(index: 2)],
                        [Entry(index: 4), Entry(index: 5)],
                        []
                    ]
                )
            ]

            expectedList.forEach { style, half, expectedEntries in
                items.enumerated().forEach { index, item in
                    let entries = item.entries(style: style, drawHalf: half)
                    expect(entries == expectedEntries[index]).to(beTrue())
                }
            }
        }

        it("can compare") {
            let entry1 = Entry()
            let entry2 = Entry(index: 1)
            let entry3 = Entry(index: 2)
            let bracket1 = Bracket(matchPath: .init(layer: 1, item: 1), children: [entry1, entry2])
            let bracket2 = Bracket(children: [entry1, entry2])
            let bracket3 = Bracket(children: [entry1, entry2, entry3])
            let bracket4 = Bracket(children: [entry1, entry2], numberOfWinners: 2)
            let bracket5 = Bracket(children: [entry1, entry2], winnerIndexes: [1, 2])

            expect(entry1 == entry1).to(beTrue())
            expect(entry2 == entry2).to(beTrue())
            expect(entry1 == entry2).to(beFalse())
            expect(entry2 == entry3).to(beFalse())

            expect(entry1 == bracket1).to(beFalse())

            expect(bracket1 == bracket1).to(beTrue())
            expect(bracket1 == bracket2).to(beFalse())
            expect(bracket2 == bracket3).to(beFalse())
            expect(bracket2 == bracket4).to(beFalse())
            expect(bracket2 == bracket5).to(beFalse())
        }
    }
}
