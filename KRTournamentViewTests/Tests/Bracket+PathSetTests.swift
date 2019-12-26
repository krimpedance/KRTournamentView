//
//  Bracket+PathSetTests.swift
//  KRTournamentView
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//
//  swiftlint:disable superfluous_disable_command
//  swiftlint:disable identifier_name
//  swiftlint:disable force_try
//  swiftlint:disable force_cast
//  swiftlint:disable function_body_length
//  swiftlint:disable type_body_length
//  swiftlint:disable large_tuple

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class BracketPathSetTests: QuickSpec {
    override func spec() {
        it("returns path") {
            (0..<self.items.count).forEach {
                let (style, bracket) = self.items[$0]
                let expectedPathSet = self.pathSets[$0]
                let expectedParams = self.params[$0]

                let info = TournamentInfo(
                    structure: bracket,
                    style: style,
                    drawHalf: style.drawHalf,
                    rect: .init(x: 0, y: 0, width: 500, height: 500),
                    entrySize: .init(width: 50, height: 50)
                )
                var params = [(MatchPath, CGRect, [CGPoint])]()
                let pathSet = bracket.getPath(with: info) { params.append(($0, $1, $2)) }

                print("-----------------", $0)
                expect(pathSet).to(equal(expectedPathSet))
                expect(params == expectedParams).to(beTrue())

//                // For check
//                print("------------------------------------------")
//                print(pathSet.path)
//                print(pathSet.winnerPath)
//                print(params.description)
//                print("------------------------------------------")
            }
        }
    }

    let items: [(KRTournamentViewStyle, Bracket)] = [
        (
            .leftRight,
            TournamentBuilder()
                .addEntry()
                .addBracket { .init(numberOfLayers: 2) }
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
                        .addBracket { .init(children: [.entry, .entry], winnerIndexes: [0]) }
                        .addEntry()
                }
                .addEntry()
                .build(format: true)
        ),

        (
            .leftRight(direction: .top),
            TournamentBuilder(numberOfWinners: 2, winnerIndexes: [0, 4])
                .addBracket {
                    TournamentBuilder(numberOfWinners: 2, winnerIndexes: [0, 1])
                        .addBracket { .init(children: [.entry, .entry], winnerIndexes: [0]) }
                        .addEntry(2)
                }
                .addBracket {
                    TournamentBuilder(numberOfWinners: 2, winnerIndexes: [0, 1])
                        .addEntry()
                        .addBracket { .init(children: [.entry, .entry], winnerIndexes: [0]) }
                        .addEntry()
                }
                .addEntry()
                .build(format: true)
        ),

        (
            .left,
            TournamentBuilder(winnerIndexes: [0])
                .addBracket { TournamentBuilder(winnerIndexes: [0]).addEntry(4) }
                .addBracket { TournamentBuilder(winnerIndexes: [1]).addEntry(4) }
                .addBracket { TournamentBuilder(winnerIndexes: [2]).addEntry(4) }
                .addBracket { TournamentBuilder(winnerIndexes: [3]).addEntry(4) }
                .build(format: true)
        ),

        (
            .leftRight(direction: .top),
            TournamentBuilder(winnerIndexes: [0])
                .addBracket { TournamentBuilder(numberOfWinners: 2, winnerIndexes: [0, 2]).addEntry(4) }
                .addBracket { TournamentBuilder(numberOfWinners: 2, winnerIndexes: [0, 3]).addEntry(4) }
                .build(format: true)
        ),
        (
            .leftRight(direction: .top),
            TournamentBuilder(winnerIndexes: [0])
                .addBracket {
                    TournamentBuilder(winnerIndexes: [0])
                        .addBracket { TournamentBuilder(winnerIndexes: [0]).addEntry(2) }
                        .addBracket { TournamentBuilder(winnerIndexes: [0]).addEntry(2) }
                }
                .addBracket {
                    TournamentBuilder(winnerIndexes: [0])
                        .addBracket { TournamentBuilder(winnerIndexes: [0]).addEntry(2) }
                        .addBracket { TournamentBuilder(winnerIndexes: [0]).addEntry(2) }
                }
                .build(format: true)
        ),
        (
            .leftRight(direction: .top),
            TournamentBuilder(winnerIndexes: [0])
                .addBracket {
                    TournamentBuilder(winnerIndexes: [0])
                        .addBracket { TournamentBuilder(winnerIndexes: [0]).addEntry(2) }
                        .addEntry()
                }
                .addBracket {
                    TournamentBuilder(winnerIndexes: [0])
                        .addBracket { TournamentBuilder(winnerIndexes: [0]).addEntry(2) }
                        .addBracket { TournamentBuilder(winnerIndexes: [0]).addEntry(2) }
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
                                                .addBracket { TournamentBuilder(winnerIndexes: [1]).addEntry(2) }
                                                .addEntry()
                                        }
                                        .addEntry()
                                }
                                .addEntry()
                        }
                        .addEntry()
                }
                .addBracket {
                    TournamentBuilder(numberOfWinners: 2, winnerIndexes: [1, 2])
                        .addEntry(2)
                        .addBracket {
                            TournamentBuilder(winnerIndexes: [1])
                                .addEntry()
                                .addBracket {
                                    TournamentBuilder(winnerIndexes: [1])
                                        .addEntry()
                                        .addBracket {
                                            TournamentBuilder(winnerIndexes: [0])
                                                .addEntry()
                                                .addBracket { TournamentBuilder(winnerIndexes: [1]).addEntry(2) }
                                        }
                                }
                        }
                }
                .build(format: true)
        ),
        (
            .left,
            TournamentBuilder(winnerIndexes: [1])
                .addEntry()
                .addBracket {
                    TournamentBuilder(winnerIndexes: [0])
                        .addBracket { TournamentBuilder(winnerIndexes: [1]).addEntry(2) }
                }
                .build(format: true)
        )
    ]

    let pathSets: [PathSet] = [
        .init(
            path: {
                let path = UIBezierPath()
                path.move(to: .init(x: 500, y: 25))
                path.addLine(to: .init(x: 416.66666666666669, y: 25))
                path.move(to: .init(x: 500, y: 175))
                path.addLine(to: .init(x: 416.66666666666669, y: 175))
                path.move(to: .init(x: 500, y: 325))
                path.addLine(to: .init(x: 416.66666666666669, y: 325))
                path.move(to: .init(x: 500, y: 475))
                path.addLine(to: .init(x: 416.66666666666669, y: 475))
                path.move(to: .init(x: 416.66666666666669, y: 25))
                path.addLine(to: .init(x: 416.66666666666669, y: 175))
                path.move(to: .init(x: 416.66666666666669, y: 100))
                path.addLine(to: .init(x: 333.33333333333337, y: 100))
                path.move(to: .init(x: 416.66666666666669, y: 325))
                path.addLine(to: .init(x: 416.66666666666669, y: 475))
                path.move(to: .init(x: 416.66666666666669, y: 400))
                path.addLine(to: .init(x: 333.33333333333337, y: 400))
                path.move(to: .init(x: 0, y: 250))
                path.addLine(to: .init(x: 194.44444444444446, y: 250))
                path.move(to: .init(x: 194.44444444444446, y: 250))
                path.addLine(to: .init(x: 222.22222222222223, y: 250))
                path.addLine(to: .init(x: 222.22222222222223, y: 250))
                path.move(to: .init(x: 333.33333333333337, y: 100))
                path.addLine(to: .init(x: 333.33333333333337, y: 400))
                path.move(to: .init(x: 333.33333333333337, y: 250))
                path.addLine(to: .init(x: 305.55555555555554, y: 250))
                path.move(to: .init(x: 305.55555555555554, y: 250))
                path.addLine(to: .init(x: 277.77777777777777, y: 250))
                path.addLine(to: .init(x: 277.77777777777777, y: 250))
                path.move(to: .init(x: 222.22222222222223, y: 250))
                path.addLine(to: .init(x: 250, y: 250))
                path.move(to: .init(x: 250, y: 250))
                path.addLine(to: .init(x: 250, y: 230))
                path.move(to: .init(x: 250, y: 250))
                path.addLine(to: .init(x: 277.77777777777777, y: 250))
                return path
        }(),
            winnerPath: .init()
        ),
        .init(
            path: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 46.875))
                path.addLine(to: .init(x: 100, y: 46.875))
                path.move(to: .init(x: 0, y: 109.375))
                path.addLine(to: .init(x: 100, y: 109.375))
                path.move(to: .init(x: 100, y: 15.625))
                path.move(to: .init(x: 100, y: 31.25))
                path.addLine(to: .init(x: 100, y: 46.875))
                path.move(to: .init(x: 100, y: 78.125))
                path.move(to: .init(x: 100, y: 93.75))
                path.addLine(to: .init(x: 100, y: 109.375))
                path.move(to: .init(x: 0, y: 171.875))
                path.addLine(to: .init(x: 100, y: 171.875))
                path.move(to: .init(x: 0, y: 234.375))
                path.addLine(to: .init(x: 100, y: 234.375))
                path.move(to: .init(x: 100, y: 140.625))
                path.move(to: .init(x: 100, y: 156.25))
                path.addLine(to: .init(x: 100, y: 171.875))
                path.move(to: .init(x: 100, y: 203.125))
                path.move(to: .init(x: 100, y: 218.75))
                path.addLine(to: .init(x: 100, y: 234.375))
                path.move(to: .init(x: 200, y: 31.25))
                path.move(to: .init(x: 200, y: 62.5))
                path.addLine(to: .init(x: 200, y: 93.75))
                path.move(to: .init(x: 200, y: 156.25))
                path.move(to: .init(x: 200, y: 187.5))
                path.addLine(to: .init(x: 200, y: 218.75))
                path.move(to: .init(x: 0, y: 296.875))
                path.addLine(to: .init(x: 100, y: 296.875))
                path.move(to: .init(x: 0, y: 359.375))
                path.addLine(to: .init(x: 100, y: 359.375))
                path.move(to: .init(x: 100, y: 265.625))
                path.move(to: .init(x: 100, y: 281.25))
                path.addLine(to: .init(x: 100, y: 296.875))
                path.move(to: .init(x: 100, y: 328.125))
                path.move(to: .init(x: 100, y: 343.75))
                path.addLine(to: .init(x: 100, y: 359.375))
                path.move(to: .init(x: 0, y: 421.875))
                path.addLine(to: .init(x: 100, y: 421.875))
                path.move(to: .init(x: 0, y: 484.375))
                path.addLine(to: .init(x: 100, y: 484.375))
                path.move(to: .init(x: 100, y: 390.625))
                path.move(to: .init(x: 100, y: 406.25))
                path.addLine(to: .init(x: 100, y: 421.875))
                path.move(to: .init(x: 100, y: 453.125))
                path.move(to: .init(x: 100, y: 468.75))
                path.addLine(to: .init(x: 100, y: 484.375))
                path.move(to: .init(x: 200, y: 281.25))
                path.move(to: .init(x: 200, y: 312.5))
                path.addLine(to: .init(x: 200, y: 343.75))
                path.move(to: .init(x: 200, y: 406.25))
                path.move(to: .init(x: 200, y: 437.5))
                path.addLine(to: .init(x: 200, y: 468.75))
                path.move(to: .init(x: 300, y: 62.5))
                path.move(to: .init(x: 300, y: 125))
                path.addLine(to: .init(x: 300, y: 187.5))
                path.move(to: .init(x: 300, y: 312.5))
                path.move(to: .init(x: 300, y: 375))
                path.addLine(to: .init(x: 300, y: 437.5))
                path.move(to: .init(x: 400, y: 125))
                path.move(to: .init(x: 400, y: 250))
                path.addLine(to: .init(x: 400, y: 375))
                return path
        }(),
            winnerPath: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 15.625))
                path.addLine(to: .init(x: 100, y: 15.625))
                path.move(to: .init(x: 0, y: 78.125))
                path.addLine(to: .init(x: 100, y: 78.125))
                path.move(to: .init(x: 100, y: 15.625))
                path.addLine(to: .init(x: 100, y: 31.25))
                path.move(to: .init(x: 100, y: 31.25))
                path.addLine(to: .init(x: 200, y: 31.25))
                path.move(to: .init(x: 100, y: 78.125))
                path.addLine(to: .init(x: 100, y: 93.75))
                path.move(to: .init(x: 100, y: 93.75))
                path.addLine(to: .init(x: 200, y: 93.75))
                path.move(to: .init(x: 0, y: 140.625))
                path.addLine(to: .init(x: 100, y: 140.625))
                path.move(to: .init(x: 0, y: 203.125))
                path.addLine(to: .init(x: 100, y: 203.125))
                path.move(to: .init(x: 100, y: 140.625))
                path.addLine(to: .init(x: 100, y: 156.25))
                path.move(to: .init(x: 100, y: 156.25))
                path.addLine(to: .init(x: 200, y: 156.25))
                path.move(to: .init(x: 100, y: 203.125))
                path.addLine(to: .init(x: 100, y: 218.75))
                path.move(to: .init(x: 100, y: 218.75))
                path.addLine(to: .init(x: 200, y: 218.75))
                path.move(to: .init(x: 200, y: 31.25))
                path.addLine(to: .init(x: 200, y: 62.5))
                path.move(to: .init(x: 200, y: 62.5))
                path.addLine(to: .init(x: 300, y: 62.5))
                path.move(to: .init(x: 200, y: 156.25))
                path.addLine(to: .init(x: 200, y: 187.5))
                path.move(to: .init(x: 200, y: 187.5))
                path.addLine(to: .init(x: 300, y: 187.5))
                path.move(to: .init(x: 0, y: 265.625))
                path.addLine(to: .init(x: 100, y: 265.625))
                path.move(to: .init(x: 0, y: 328.125))
                path.addLine(to: .init(x: 100, y: 328.125))
                path.move(to: .init(x: 100, y: 265.625))
                path.addLine(to: .init(x: 100, y: 281.25))
                path.move(to: .init(x: 100, y: 281.25))
                path.addLine(to: .init(x: 200, y: 281.25))
                path.move(to: .init(x: 100, y: 328.125))
                path.addLine(to: .init(x: 100, y: 343.75))
                path.move(to: .init(x: 100, y: 343.75))
                path.addLine(to: .init(x: 200, y: 343.75))
                path.move(to: .init(x: 0, y: 390.625))
                path.addLine(to: .init(x: 100, y: 390.625))
                path.move(to: .init(x: 0, y: 453.125))
                path.addLine(to: .init(x: 100, y: 453.125))
                path.move(to: .init(x: 100, y: 390.625))
                path.addLine(to: .init(x: 100, y: 406.25))
                path.move(to: .init(x: 100, y: 406.25))
                path.addLine(to: .init(x: 200, y: 406.25))
                path.move(to: .init(x: 100, y: 453.125))
                path.addLine(to: .init(x: 100, y: 468.75))
                path.move(to: .init(x: 100, y: 468.75))
                path.addLine(to: .init(x: 200, y: 468.75))
                path.move(to: .init(x: 200, y: 281.25))
                path.addLine(to: .init(x: 200, y: 312.5))
                path.move(to: .init(x: 200, y: 312.5))
                path.addLine(to: .init(x: 300, y: 312.5))
                path.move(to: .init(x: 200, y: 406.25))
                path.addLine(to: .init(x: 200, y: 437.5))
                path.move(to: .init(x: 200, y: 437.5))
                path.addLine(to: .init(x: 300, y: 437.5))
                path.move(to: .init(x: 300, y: 62.5))
                path.addLine(to: .init(x: 300, y: 125))
                path.move(to: .init(x: 300, y: 125))
                path.addLine(to: .init(x: 400, y: 125))
                path.move(to: .init(x: 300, y: 312.5))
                path.addLine(to: .init(x: 300, y: 375))
                path.move(to: .init(x: 300, y: 375))
                path.addLine(to: .init(x: 400, y: 375))
                path.move(to: .init(x: 400, y: 125))
                path.addLine(to: .init(x: 400, y: 250))
                path.move(to: .init(x: 400, y: 250))
                path.addLine(to: .init(x: 500, y: 250))
                return path
        }()
        ),
        .init(
            path: {
                let path = UIBezierPath()
                path.move(to: .init(x: 500, y: 46.875))
                path.addLine(to: .init(x: 400, y: 46.875))
                path.move(to: .init(x: 500, y: 109.375))
                path.addLine(to: .init(x: 400, y: 109.375))
                path.move(to: .init(x: 400, y: 15.625))
                path.move(to: .init(x: 400, y: 31.25))
                path.addLine(to: .init(x: 400, y: 46.875))
                path.move(to: .init(x: 400, y: 78.125))
                path.move(to: .init(x: 400, y: 93.75))
                path.addLine(to: .init(x: 400, y: 109.375))
                path.move(to: .init(x: 500, y: 171.875))
                path.addLine(to: .init(x: 400, y: 171.875))
                path.move(to: .init(x: 500, y: 234.375))
                path.addLine(to: .init(x: 400, y: 234.375))
                path.move(to: .init(x: 400, y: 140.625))
                path.move(to: .init(x: 400, y: 156.25))
                path.addLine(to: .init(x: 400, y: 171.875))
                path.move(to: .init(x: 400, y: 203.125))
                path.move(to: .init(x: 400, y: 218.75))
                path.addLine(to: .init(x: 400, y: 234.375))
                path.move(to: .init(x: 300, y: 31.25))
                path.move(to: .init(x: 300, y: 62.5))
                path.addLine(to: .init(x: 300, y: 93.75))
                path.move(to: .init(x: 300, y: 156.25))
                path.move(to: .init(x: 300, y: 187.5))
                path.addLine(to: .init(x: 300, y: 218.75))
                path.move(to: .init(x: 500, y: 296.875))
                path.addLine(to: .init(x: 400, y: 296.875))
                path.move(to: .init(x: 500, y: 359.375))
                path.addLine(to: .init(x: 400, y: 359.375))
                path.move(to: .init(x: 400, y: 265.625))
                path.move(to: .init(x: 400, y: 281.25))
                path.addLine(to: .init(x: 400, y: 296.875))
                path.move(to: .init(x: 400, y: 328.125))
                path.move(to: .init(x: 400, y: 343.75))
                path.addLine(to: .init(x: 400, y: 359.375))
                path.move(to: .init(x: 500, y: 421.875))
                path.addLine(to: .init(x: 400, y: 421.875))
                path.move(to: .init(x: 500, y: 484.375))
                path.addLine(to: .init(x: 400, y: 484.375))
                path.move(to: .init(x: 400, y: 390.625))
                path.move(to: .init(x: 400, y: 406.25))
                path.addLine(to: .init(x: 400, y: 421.875))
                path.move(to: .init(x: 400, y: 453.125))
                path.move(to: .init(x: 400, y: 468.75))
                path.addLine(to: .init(x: 400, y: 484.375))
                path.move(to: .init(x: 300, y: 281.25))
                path.move(to: .init(x: 300, y: 312.5))
                path.addLine(to: .init(x: 300, y: 343.75))
                path.move(to: .init(x: 300, y: 406.25))
                path.move(to: .init(x: 300, y: 437.5))
                path.addLine(to: .init(x: 300, y: 468.75))
                path.move(to: .init(x: 200, y: 62.5))
                path.move(to: .init(x: 200, y: 125))
                path.addLine(to: .init(x: 200, y: 187.5))
                path.move(to: .init(x: 200, y: 312.5))
                path.move(to: .init(x: 200, y: 375))
                path.addLine(to: .init(x: 200, y: 437.5))
                path.move(to: .init(x: 100, y: 125))
                path.move(to: .init(x: 100, y: 250))
                path.addLine(to: .init(x: 100, y: 375))
                return path
        }(),
            winnerPath: {
                let path = UIBezierPath()
                path.move(to: .init(x: 500, y: 15.625))
                path.addLine(to: .init(x: 400, y: 15.625))
                path.move(to: .init(x: 500, y: 78.125))
                path.addLine(to: .init(x: 400, y: 78.125))
                path.move(to: .init(x: 400, y: 15.625))
                path.addLine(to: .init(x: 400, y: 31.25))
                path.move(to: .init(x: 400, y: 31.25))
                path.addLine(to: .init(x: 300, y: 31.25))
                path.move(to: .init(x: 400, y: 78.125))
                path.addLine(to: .init(x: 400, y: 93.75))
                path.move(to: .init(x: 400, y: 93.75))
                path.addLine(to: .init(x: 300, y: 93.75))
                path.move(to: .init(x: 500, y: 140.625))
                path.addLine(to: .init(x: 400, y: 140.625))
                path.move(to: .init(x: 500, y: 203.125))
                path.addLine(to: .init(x: 400, y: 203.125))
                path.move(to: .init(x: 400, y: 140.625))
                path.addLine(to: .init(x: 400, y: 156.25))
                path.move(to: .init(x: 400, y: 156.25))
                path.addLine(to: .init(x: 300, y: 156.25))
                path.move(to: .init(x: 400, y: 203.125))
                path.addLine(to: .init(x: 400, y: 218.75))
                path.move(to: .init(x: 400, y: 218.75))
                path.addLine(to: .init(x: 300, y: 218.75))
                path.move(to: .init(x: 300, y: 31.25))
                path.addLine(to: .init(x: 300, y: 62.5))
                path.move(to: .init(x: 300, y: 62.5))
                path.addLine(to: .init(x: 200, y: 62.5))
                path.move(to: .init(x: 300, y: 156.25))
                path.addLine(to: .init(x: 300, y: 187.5))
                path.move(to: .init(x: 300, y: 187.5))
                path.addLine(to: .init(x: 200, y: 187.5))
                path.move(to: .init(x: 500, y: 265.625))
                path.addLine(to: .init(x: 400, y: 265.625))
                path.move(to: .init(x: 500, y: 328.125))
                path.addLine(to: .init(x: 400, y: 328.125))
                path.move(to: .init(x: 400, y: 265.625))
                path.addLine(to: .init(x: 400, y: 281.25))
                path.move(to: .init(x: 400, y: 281.25))
                path.addLine(to: .init(x: 300, y: 281.25))
                path.move(to: .init(x: 400, y: 328.125))
                path.addLine(to: .init(x: 400, y: 343.75))
                path.move(to: .init(x: 400, y: 343.75))
                path.addLine(to: .init(x: 300, y: 343.75))
                path.move(to: .init(x: 500, y: 390.625))
                path.addLine(to: .init(x: 400, y: 390.625))
                path.move(to: .init(x: 500, y: 453.125))
                path.addLine(to: .init(x: 400, y: 453.125))
                path.move(to: .init(x: 400, y: 390.625))
                path.addLine(to: .init(x: 400, y: 406.25))
                path.move(to: .init(x: 400, y: 406.25))
                path.addLine(to: .init(x: 300, y: 406.25))
                path.move(to: .init(x: 400, y: 453.125))
                path.addLine(to: .init(x: 400, y: 468.75))
                path.move(to: .init(x: 400, y: 468.75))
                path.addLine(to: .init(x: 300, y: 468.75))
                path.move(to: .init(x: 300, y: 281.25))
                path.addLine(to: .init(x: 300, y: 312.5))
                path.move(to: .init(x: 300, y: 312.5))
                path.addLine(to: .init(x: 200, y: 312.5))
                path.move(to: .init(x: 300, y: 406.25))
                path.addLine(to: .init(x: 300, y: 437.5))
                path.move(to: .init(x: 300, y: 437.5))
                path.addLine(to: .init(x: 200, y: 437.5))
                path.move(to: .init(x: 200, y: 62.5))
                path.addLine(to: .init(x: 200, y: 125))
                path.move(to: .init(x: 200, y: 125))
                path.addLine(to: .init(x: 100, y: 125))
                path.move(to: .init(x: 200, y: 312.5))
                path.addLine(to: .init(x: 200, y: 375))
                path.move(to: .init(x: 200, y: 375))
                path.addLine(to: .init(x: 100, y: 375))
                path.move(to: .init(x: 100, y: 125))
                path.addLine(to: .init(x: 100, y: 250))
                path.move(to: .init(x: 100, y: 250))
                path.addLine(to: .init(x: 0, y: 250))
                return path
        }()
        ),
        .init(
            path: {
                let path = UIBezierPath()
                path.move(to: .init(x: 46.875, y: 0))
                path.addLine(to: .init(x: 46.875, y: 100))
                path.move(to: .init(x: 109.375, y: 0))
                path.addLine(to: .init(x: 109.375, y: 100))
                path.move(to: .init(x: 15.625, y: 100))
                path.move(to: .init(x: 31.25, y: 100))
                path.addLine(to: .init(x: 46.875, y: 100))
                path.move(to: .init(x: 78.125, y: 100))
                path.move(to: .init(x: 93.75, y: 100))
                path.addLine(to: .init(x: 109.375, y: 100))
                path.move(to: .init(x: 171.875, y: 0))
                path.addLine(to: .init(x: 171.875, y: 100))
                path.move(to: .init(x: 234.375, y: 0))
                path.addLine(to: .init(x: 234.375, y: 100))
                path.move(to: .init(x: 140.625, y: 100))
                path.move(to: .init(x: 156.25, y: 100))
                path.addLine(to: .init(x: 171.875, y: 100))
                path.move(to: .init(x: 203.125, y: 100))
                path.move(to: .init(x: 218.75, y: 100))
                path.addLine(to: .init(x: 234.375, y: 100))
                path.move(to: .init(x: 31.25, y: 200))
                path.move(to: .init(x: 62.5, y: 200))
                path.addLine(to: .init(x: 93.75, y: 200))
                path.move(to: .init(x: 156.25, y: 200))
                path.move(to: .init(x: 187.5, y: 200))
                path.addLine(to: .init(x: 218.75, y: 200))
                path.move(to: .init(x: 296.875, y: 0))
                path.addLine(to: .init(x: 296.875, y: 100))
                path.move(to: .init(x: 359.375, y: 0))
                path.addLine(to: .init(x: 359.375, y: 100))
                path.move(to: .init(x: 265.625, y: 100))
                path.move(to: .init(x: 281.25, y: 100))
                path.addLine(to: .init(x: 296.875, y: 100))
                path.move(to: .init(x: 328.125, y: 100))
                path.move(to: .init(x: 343.75, y: 100))
                path.addLine(to: .init(x: 359.375, y: 100))
                path.move(to: .init(x: 421.875, y: 0))
                path.addLine(to: .init(x: 421.875, y: 100))
                path.move(to: .init(x: 484.375, y: 0))
                path.addLine(to: .init(x: 484.375, y: 100))
                path.move(to: .init(x: 390.625, y: 100))
                path.move(to: .init(x: 406.25, y: 100))
                path.addLine(to: .init(x: 421.875, y: 100))
                path.move(to: .init(x: 453.125, y: 100))
                path.move(to: .init(x: 468.75, y: 100))
                path.addLine(to: .init(x: 484.375, y: 100))
                path.move(to: .init(x: 281.25, y: 200))
                path.move(to: .init(x: 312.5, y: 200))
                path.addLine(to: .init(x: 343.75, y: 200))
                path.move(to: .init(x: 406.25, y: 200))
                path.move(to: .init(x: 437.5, y: 200))
                path.addLine(to: .init(x: 468.75, y: 200))
                path.move(to: .init(x: 62.5, y: 300))
                path.move(to: .init(x: 125, y: 300))
                path.addLine(to: .init(x: 187.5, y: 300))
                path.move(to: .init(x: 312.5, y: 300))
                path.move(to: .init(x: 375, y: 300))
                path.addLine(to: .init(x: 437.5, y: 300))
                path.move(to: .init(x: 125, y: 400))
                path.move(to: .init(x: 250, y: 400))
                path.addLine(to: .init(x: 375, y: 400))
                return path
        }(),
            winnerPath: {
                let path = UIBezierPath()
                path.move(to: .init(x: 15.625, y: 0))
                path.addLine(to: .init(x: 15.625, y: 100))
                path.move(to: .init(x: 78.125, y: 0))
                path.addLine(to: .init(x: 78.125, y: 100))
                path.move(to: .init(x: 15.625, y: 100))
                path.addLine(to: .init(x: 31.25, y: 100))
                path.move(to: .init(x: 31.25, y: 100))
                path.addLine(to: .init(x: 31.25, y: 200))
                path.move(to: .init(x: 78.125, y: 100))
                path.addLine(to: .init(x: 93.75, y: 100))
                path.move(to: .init(x: 93.75, y: 100))
                path.addLine(to: .init(x: 93.75, y: 200))
                path.move(to: .init(x: 140.625, y: 0))
                path.addLine(to: .init(x: 140.625, y: 100))
                path.move(to: .init(x: 203.125, y: 0))
                path.addLine(to: .init(x: 203.125, y: 100))
                path.move(to: .init(x: 140.625, y: 100))
                path.addLine(to: .init(x: 156.25, y: 100))
                path.move(to: .init(x: 156.25, y: 100))
                path.addLine(to: .init(x: 156.25, y: 200))
                path.move(to: .init(x: 203.125, y: 100))
                path.addLine(to: .init(x: 218.75, y: 100))
                path.move(to: .init(x: 218.75, y: 100))
                path.addLine(to: .init(x: 218.75, y: 200))
                path.move(to: .init(x: 31.25, y: 200))
                path.addLine(to: .init(x: 62.5, y: 200))
                path.move(to: .init(x: 62.5, y: 200))
                path.addLine(to: .init(x: 62.5, y: 300))
                path.move(to: .init(x: 156.25, y: 200))
                path.addLine(to: .init(x: 187.5, y: 200))
                path.move(to: .init(x: 187.5, y: 200))
                path.addLine(to: .init(x: 187.5, y: 300))
                path.move(to: .init(x: 265.625, y: 0))
                path.addLine(to: .init(x: 265.625, y: 100))
                path.move(to: .init(x: 328.125, y: 0))
                path.addLine(to: .init(x: 328.125, y: 100))
                path.move(to: .init(x: 265.625, y: 100))
                path.addLine(to: .init(x: 281.25, y: 100))
                path.move(to: .init(x: 281.25, y: 100))
                path.addLine(to: .init(x: 281.25, y: 200))
                path.move(to: .init(x: 328.125, y: 100))
                path.addLine(to: .init(x: 343.75, y: 100))
                path.move(to: .init(x: 343.75, y: 100))
                path.addLine(to: .init(x: 343.75, y: 200))
                path.move(to: .init(x: 390.625, y: 0))
                path.addLine(to: .init(x: 390.625, y: 100))
                path.move(to: .init(x: 453.125, y: 0))
                path.addLine(to: .init(x: 453.125, y: 100))
                path.move(to: .init(x: 390.625, y: 100))
                path.addLine(to: .init(x: 406.25, y: 100))
                path.move(to: .init(x: 406.25, y: 100))
                path.addLine(to: .init(x: 406.25, y: 200))
                path.move(to: .init(x: 453.125, y: 100))
                path.addLine(to: .init(x: 468.75, y: 100))
                path.move(to: .init(x: 468.75, y: 100))
                path.addLine(to: .init(x: 468.75, y: 200))
                path.move(to: .init(x: 281.25, y: 200))
                path.addLine(to: .init(x: 312.5, y: 200))
                path.move(to: .init(x: 312.5, y: 200))
                path.addLine(to: .init(x: 312.5, y: 300))
                path.move(to: .init(x: 406.25, y: 200))
                path.addLine(to: .init(x: 437.5, y: 200))
                path.move(to: .init(x: 437.5, y: 200))
                path.addLine(to: .init(x: 437.5, y: 300))
                path.move(to: .init(x: 62.5, y: 300))
                path.addLine(to: .init(x: 125, y: 300))
                path.move(to: .init(x: 125, y: 300))
                path.addLine(to: .init(x: 125, y: 400))
                path.move(to: .init(x: 312.5, y: 300))
                path.addLine(to: .init(x: 375, y: 300))
                path.move(to: .init(x: 375, y: 300))
                path.addLine(to: .init(x: 375, y: 400))
                path.move(to: .init(x: 125, y: 400))
                path.addLine(to: .init(x: 250, y: 400))
                path.move(to: .init(x: 250, y: 400))
                path.addLine(to: .init(x: 250, y: 500))
                return path
        }()
        ),
        .init(
            path: {
                let path = UIBezierPath()
                path.move(to: .init(x: 46.875, y: 500))
                path.addLine(to: .init(x: 46.875, y: 400))
                path.move(to: .init(x: 109.375, y: 500))
                path.addLine(to: .init(x: 109.375, y: 400))
                path.move(to: .init(x: 15.625, y: 400))
                path.move(to: .init(x: 31.25, y: 400))
                path.addLine(to: .init(x: 46.875, y: 400))
                path.move(to: .init(x: 78.125, y: 400))
                path.move(to: .init(x: 93.75, y: 400))
                path.addLine(to: .init(x: 109.375, y: 400))
                path.move(to: .init(x: 171.875, y: 500))
                path.addLine(to: .init(x: 171.875, y: 400))
                path.move(to: .init(x: 234.375, y: 500))
                path.addLine(to: .init(x: 234.375, y: 400))
                path.move(to: .init(x: 140.625, y: 400))
                path.move(to: .init(x: 156.25, y: 400))
                path.addLine(to: .init(x: 171.875, y: 400))
                path.move(to: .init(x: 203.125, y: 400))
                path.move(to: .init(x: 218.75, y: 400))
                path.addLine(to: .init(x: 234.375, y: 400))
                path.move(to: .init(x: 31.25, y: 300))
                path.move(to: .init(x: 62.5, y: 300))
                path.addLine(to: .init(x: 93.75, y: 300))
                path.move(to: .init(x: 156.25, y: 300))
                path.move(to: .init(x: 187.5, y: 300))
                path.addLine(to: .init(x: 218.75, y: 300))
                path.move(to: .init(x: 296.875, y: 500))
                path.addLine(to: .init(x: 296.875, y: 400))
                path.move(to: .init(x: 359.375, y: 500))
                path.addLine(to: .init(x: 359.375, y: 400))
                path.move(to: .init(x: 265.625, y: 400))
                path.move(to: .init(x: 281.25, y: 400))
                path.addLine(to: .init(x: 296.875, y: 400))
                path.move(to: .init(x: 328.125, y: 400))
                path.move(to: .init(x: 343.75, y: 400))
                path.addLine(to: .init(x: 359.375, y: 400))
                path.move(to: .init(x: 421.875, y: 500))
                path.addLine(to: .init(x: 421.875, y: 400))
                path.move(to: .init(x: 484.375, y: 500))
                path.addLine(to: .init(x: 484.375, y: 400))
                path.move(to: .init(x: 390.625, y: 400))
                path.move(to: .init(x: 406.25, y: 400))
                path.addLine(to: .init(x: 421.875, y: 400))
                path.move(to: .init(x: 453.125, y: 400))
                path.move(to: .init(x: 468.75, y: 400))
                path.addLine(to: .init(x: 484.375, y: 400))
                path.move(to: .init(x: 281.25, y: 300))
                path.move(to: .init(x: 312.5, y: 300))
                path.addLine(to: .init(x: 343.75, y: 300))
                path.move(to: .init(x: 406.25, y: 300))
                path.move(to: .init(x: 437.5, y: 300))
                path.addLine(to: .init(x: 468.75, y: 300))
                path.move(to: .init(x: 62.5, y: 200))
                path.move(to: .init(x: 125, y: 200))
                path.addLine(to: .init(x: 187.5, y: 200))
                path.move(to: .init(x: 312.5, y: 200))
                path.move(to: .init(x: 375, y: 200))
                path.addLine(to: .init(x: 437.5, y: 200))
                path.move(to: .init(x: 125, y: 100))
                path.move(to: .init(x: 250, y: 100))
                path.addLine(to: .init(x: 375, y: 100))
                return path
        }(),
            winnerPath: {
                let path = UIBezierPath()
                path.move(to: .init(x: 15.625, y: 500))
                path.addLine(to: .init(x: 15.625, y: 400))
                path.move(to: .init(x: 78.125, y: 500))
                path.addLine(to: .init(x: 78.125, y: 400))
                path.move(to: .init(x: 15.625, y: 400))
                path.addLine(to: .init(x: 31.25, y: 400))
                path.move(to: .init(x: 31.25, y: 400))
                path.addLine(to: .init(x: 31.25, y: 300))
                path.move(to: .init(x: 78.125, y: 400))
                path.addLine(to: .init(x: 93.75, y: 400))
                path.move(to: .init(x: 93.75, y: 400))
                path.addLine(to: .init(x: 93.75, y: 300))
                path.move(to: .init(x: 140.625, y: 500))
                path.addLine(to: .init(x: 140.625, y: 400))
                path.move(to: .init(x: 203.125, y: 500))
                path.addLine(to: .init(x: 203.125, y: 400))
                path.move(to: .init(x: 140.625, y: 400))
                path.addLine(to: .init(x: 156.25, y: 400))
                path.move(to: .init(x: 156.25, y: 400))
                path.addLine(to: .init(x: 156.25, y: 300))
                path.move(to: .init(x: 203.125, y: 400))
                path.addLine(to: .init(x: 218.75, y: 400))
                path.move(to: .init(x: 218.75, y: 400))
                path.addLine(to: .init(x: 218.75, y: 300))
                path.move(to: .init(x: 31.25, y: 300))
                path.addLine(to: .init(x: 62.5, y: 300))
                path.move(to: .init(x: 62.5, y: 300))
                path.addLine(to: .init(x: 62.5, y: 200))
                path.move(to: .init(x: 156.25, y: 300))
                path.addLine(to: .init(x: 187.5, y: 300))
                path.move(to: .init(x: 187.5, y: 300))
                path.addLine(to: .init(x: 187.5, y: 200))
                path.move(to: .init(x: 265.625, y: 500))
                path.addLine(to: .init(x: 265.625, y: 400))
                path.move(to: .init(x: 328.125, y: 500))
                path.addLine(to: .init(x: 328.125, y: 400))
                path.move(to: .init(x: 265.625, y: 400))
                path.addLine(to: .init(x: 281.25, y: 400))
                path.move(to: .init(x: 281.25, y: 400))
                path.addLine(to: .init(x: 281.25, y: 300))
                path.move(to: .init(x: 328.125, y: 400))
                path.addLine(to: .init(x: 343.75, y: 400))
                path.move(to: .init(x: 343.75, y: 400))
                path.addLine(to: .init(x: 343.75, y: 300))
                path.move(to: .init(x: 390.625, y: 500))
                path.addLine(to: .init(x: 390.625, y: 400))
                path.move(to: .init(x: 453.125, y: 500))
                path.addLine(to: .init(x: 453.125, y: 400))
                path.move(to: .init(x: 390.625, y: 400))
                path.addLine(to: .init(x: 406.25, y: 400))
                path.move(to: .init(x: 406.25, y: 400))
                path.addLine(to: .init(x: 406.25, y: 300))
                path.move(to: .init(x: 453.125, y: 400))
                path.addLine(to: .init(x: 468.75, y: 400))
                path.move(to: .init(x: 468.75, y: 400))
                path.addLine(to: .init(x: 468.75, y: 300))
                path.move(to: .init(x: 281.25, y: 300))
                path.addLine(to: .init(x: 312.5, y: 300))
                path.move(to: .init(x: 312.5, y: 300))
                path.addLine(to: .init(x: 312.5, y: 200))
                path.move(to: .init(x: 406.25, y: 300))
                path.addLine(to: .init(x: 437.5, y: 300))
                path.move(to: .init(x: 437.5, y: 300))
                path.addLine(to: .init(x: 437.5, y: 200))
                path.move(to: .init(x: 62.5, y: 200))
                path.addLine(to: .init(x: 125, y: 200))
                path.move(to: .init(x: 125, y: 200))
                path.addLine(to: .init(x: 125, y: 100))
                path.move(to: .init(x: 312.5, y: 200))
                path.addLine(to: .init(x: 375, y: 200))
                path.move(to: .init(x: 375, y: 200))
                path.addLine(to: .init(x: 375, y: 100))
                path.move(to: .init(x: 125, y: 100))
                path.addLine(to: .init(x: 250, y: 100))
                path.move(to: .init(x: 250, y: 100))
                path.addLine(to: .init(x: 250, y: 0))
                return path
        }()
        ),
        .init(
            path: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 89.285714285714292))
                path.addLine(to: .init(x: 62.5, y: 89.285714285714292))
                path.move(to: .init(x: 0, y: 217.85714285714289))
                path.addLine(to: .init(x: 62.5, y: 217.85714285714289))
                path.move(to: .init(x: 62.5, y: 25))
                path.move(to: .init(x: 62.5, y: 57.142857142857146))
                path.addLine(to: .init(x: 62.5, y: 89.285714285714292))
                path.move(to: .init(x: 62.5, y: 153.57142857142858))
                path.move(to: .init(x: 62.5, y: 185.71428571428572))
                path.addLine(to: .init(x: 62.5, y: 217.85714285714289))
                path.move(to: .init(x: 0, y: 346.42857142857144))
                path.addLine(to: .init(x: 62.5, y: 346.42857142857144))
                path.move(to: .init(x: 0, y: 475.00000000000006))
                path.addLine(to: .init(x: 62.5, y: 475.00000000000006))
                path.move(to: .init(x: 62.5, y: 282.14285714285717))
                path.move(to: .init(x: 62.5, y: 314.28571428571433))
                path.addLine(to: .init(x: 62.5, y: 346.42857142857144))
                path.move(to: .init(x: 62.5, y: 410.71428571428578))
                path.move(to: .init(x: 62.5, y: 442.85714285714289))
                path.addLine(to: .init(x: 62.5, y: 475.00000000000006))
                path.move(to: .init(x: 125, y: 57.142857142857146))
                path.move(to: .init(x: 125, y: 121.42857142857144))
                path.addLine(to: .init(x: 125, y: 185.71428571428572))
                path.move(to: .init(x: 125, y: 314.28571428571433))
                path.move(to: .init(x: 125, y: 378.57142857142861))
                path.addLine(to: .init(x: 125, y: 442.85714285714289))
                path.move(to: .init(x: 500, y: 89.285714285714292))
                path.addLine(to: .init(x: 437.5, y: 89.285714285714292))
                path.move(to: .init(x: 500, y: 217.85714285714289))
                path.addLine(to: .init(x: 437.5, y: 217.85714285714289))
                path.move(to: .init(x: 437.5, y: 25))
                path.move(to: .init(x: 437.5, y: 57.142857142857146))
                path.addLine(to: .init(x: 437.5, y: 89.285714285714292))
                path.move(to: .init(x: 437.5, y: 153.57142857142858))
                path.move(to: .init(x: 437.5, y: 185.71428571428572))
                path.addLine(to: .init(x: 437.5, y: 217.85714285714289))
                path.move(to: .init(x: 500, y: 346.42857142857144))
                path.addLine(to: .init(x: 437.5, y: 346.42857142857144))
                path.move(to: .init(x: 500, y: 475.00000000000006))
                path.addLine(to: .init(x: 437.5, y: 475.00000000000006))
                path.move(to: .init(x: 437.5, y: 282.14285714285717))
                path.move(to: .init(x: 437.5, y: 314.28571428571433))
                path.addLine(to: .init(x: 437.5, y: 346.42857142857144))
                path.move(to: .init(x: 437.5, y: 410.71428571428578))
                path.move(to: .init(x: 437.5, y: 442.85714285714289))
                path.addLine(to: .init(x: 437.5, y: 475.00000000000006))
                path.move(to: .init(x: 375, y: 57.142857142857146))
                path.move(to: .init(x: 375, y: 121.42857142857144))
                path.addLine(to: .init(x: 375, y: 185.71428571428572))
                path.move(to: .init(x: 375, y: 314.28571428571433))
                path.move(to: .init(x: 375, y: 378.57142857142861))
                path.addLine(to: .init(x: 375, y: 442.85714285714289))
                path.move(to: .init(x: 187.5, y: 121.42857142857144))
                path.move(to: .init(x: 187.5, y: 250))
                path.addLine(to: .init(x: 187.5, y: 378.57142857142861))
                path.move(to: .init(x: 312.5, y: 121.42857142857144))
                path.move(to: .init(x: 312.5, y: 250))
                path.addLine(to: .init(x: 312.5, y: 378.57142857142861))
                path.move(to: .init(x: 312.5, y: 250))
                path.addLine(to: .init(x: 291.66666666666663, y: 250))
                path.move(to: .init(x: 291.66666666666663, y: 250))
                path.addLine(to: .init(x: 270.83333333333331, y: 250))
                path.addLine(to: .init(x: 270.83333333333331, y: 250))
                path.move(to: .init(x: 250, y: 250))
                path.addLine(to: .init(x: 270.83333333333331, y: 250))
                return path
        }(),
            winnerPath: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 25))
                path.addLine(to: .init(x: 62.5, y: 25))
                path.move(to: .init(x: 0, y: 153.57142857142858))
                path.addLine(to: .init(x: 62.5, y: 153.57142857142858))
                path.move(to: .init(x: 62.5, y: 25))
                path.addLine(to: .init(x: 62.5, y: 57.142857142857146))
                path.move(to: .init(x: 62.5, y: 57.142857142857146))
                path.addLine(to: .init(x: 125, y: 57.142857142857146))
                path.move(to: .init(x: 62.5, y: 153.57142857142858))
                path.addLine(to: .init(x: 62.5, y: 185.71428571428572))
                path.move(to: .init(x: 62.5, y: 185.71428571428572))
                path.addLine(to: .init(x: 125, y: 185.71428571428572))
                path.move(to: .init(x: 0, y: 282.14285714285717))
                path.addLine(to: .init(x: 62.5, y: 282.14285714285717))
                path.move(to: .init(x: 0, y: 410.71428571428578))
                path.addLine(to: .init(x: 62.5, y: 410.71428571428578))
                path.move(to: .init(x: 62.5, y: 282.14285714285717))
                path.addLine(to: .init(x: 62.5, y: 314.28571428571433))
                path.move(to: .init(x: 62.5, y: 314.28571428571433))
                path.addLine(to: .init(x: 125, y: 314.28571428571433))
                path.move(to: .init(x: 62.5, y: 410.71428571428578))
                path.addLine(to: .init(x: 62.5, y: 442.85714285714289))
                path.move(to: .init(x: 62.5, y: 442.85714285714289))
                path.addLine(to: .init(x: 125, y: 442.85714285714289))
                path.move(to: .init(x: 125, y: 57.142857142857146))
                path.addLine(to: .init(x: 125, y: 121.42857142857144))
                path.move(to: .init(x: 125, y: 121.42857142857144))
                path.addLine(to: .init(x: 187.5, y: 121.42857142857144))
                path.move(to: .init(x: 125, y: 314.28571428571433))
                path.addLine(to: .init(x: 125, y: 378.57142857142861))
                path.move(to: .init(x: 125, y: 378.57142857142861))
                path.addLine(to: .init(x: 187.5, y: 378.57142857142861))
                path.move(to: .init(x: 500, y: 25))
                path.addLine(to: .init(x: 437.5, y: 25))
                path.move(to: .init(x: 500, y: 153.57142857142858))
                path.addLine(to: .init(x: 437.5, y: 153.57142857142858))
                path.move(to: .init(x: 437.5, y: 25))
                path.addLine(to: .init(x: 437.5, y: 57.142857142857146))
                path.move(to: .init(x: 437.5, y: 57.142857142857146))
                path.addLine(to: .init(x: 375, y: 57.142857142857146))
                path.move(to: .init(x: 437.5, y: 153.57142857142858))
                path.addLine(to: .init(x: 437.5, y: 185.71428571428572))
                path.move(to: .init(x: 437.5, y: 185.71428571428572))
                path.addLine(to: .init(x: 375, y: 185.71428571428572))
                path.move(to: .init(x: 500, y: 282.14285714285717))
                path.addLine(to: .init(x: 437.5, y: 282.14285714285717))
                path.move(to: .init(x: 500, y: 410.71428571428578))
                path.addLine(to: .init(x: 437.5, y: 410.71428571428578))
                path.move(to: .init(x: 437.5, y: 282.14285714285717))
                path.addLine(to: .init(x: 437.5, y: 314.28571428571433))
                path.move(to: .init(x: 437.5, y: 314.28571428571433))
                path.addLine(to: .init(x: 375, y: 314.28571428571433))
                path.move(to: .init(x: 437.5, y: 410.71428571428578))
                path.addLine(to: .init(x: 437.5, y: 442.85714285714289))
                path.move(to: .init(x: 437.5, y: 442.85714285714289))
                path.addLine(to: .init(x: 375, y: 442.85714285714289))
                path.move(to: .init(x: 375, y: 57.142857142857146))
                path.addLine(to: .init(x: 375, y: 121.42857142857144))
                path.move(to: .init(x: 375, y: 121.42857142857144))
                path.addLine(to: .init(x: 312.5, y: 121.42857142857144))
                path.move(to: .init(x: 375, y: 314.28571428571433))
                path.addLine(to: .init(x: 375, y: 378.57142857142861))
                path.move(to: .init(x: 375, y: 378.57142857142861))
                path.addLine(to: .init(x: 312.5, y: 378.57142857142861))
                path.move(to: .init(x: 187.5, y: 121.42857142857144))
                path.addLine(to: .init(x: 187.5, y: 250))
                path.move(to: .init(x: 187.5, y: 250))
                path.addLine(to: .init(x: 208.33333333333331, y: 250))
                path.move(to: .init(x: 208.33333333333331, y: 250))
                path.addLine(to: .init(x: 229.16666666666666, y: 250))
                path.addLine(to: .init(x: 229.16666666666666, y: 250))
                path.move(to: .init(x: 312.5, y: 121.42857142857144))
                path.addLine(to: .init(x: 312.5, y: 250))
                path.move(to: .init(x: 229.16666666666666, y: 250))
                path.addLine(to: .init(x: 250, y: 250))
                path.move(to: .init(x: 250, y: 250))
                path.addLine(to: .init(x: 250, y: 230))
                return path
        }()
        ),
        .init(
            path: {
                let path = UIBezierPath()
                path.move(to: .init(x: 89.285714285714292, y: 0))
                path.addLine(to: .init(x: 89.285714285714292, y: 62.5))
                path.move(to: .init(x: 217.85714285714289, y: 0))
                path.addLine(to: .init(x: 217.85714285714289, y: 62.5))
                path.move(to: .init(x: 25, y: 62.5))
                path.move(to: .init(x: 57.142857142857146, y: 62.5))
                path.addLine(to: .init(x: 89.285714285714292, y: 62.5))
                path.move(to: .init(x: 153.57142857142858, y: 62.5))
                path.move(to: .init(x: 185.71428571428572, y: 62.5))
                path.addLine(to: .init(x: 217.85714285714289, y: 62.5))
                path.move(to: .init(x: 346.42857142857144, y: 0))
                path.addLine(to: .init(x: 346.42857142857144, y: 62.5))
                path.move(to: .init(x: 475.00000000000006, y: 0))
                path.addLine(to: .init(x: 475.00000000000006, y: 62.5))
                path.move(to: .init(x: 282.14285714285717, y: 62.5))
                path.move(to: .init(x: 314.28571428571433, y: 62.5))
                path.addLine(to: .init(x: 346.42857142857144, y: 62.5))
                path.move(to: .init(x: 410.71428571428578, y: 62.5))
                path.move(to: .init(x: 442.85714285714289, y: 62.5))
                path.addLine(to: .init(x: 475.00000000000006, y: 62.5))
                path.move(to: .init(x: 57.142857142857146, y: 125))
                path.move(to: .init(x: 121.42857142857144, y: 125))
                path.addLine(to: .init(x: 185.71428571428572, y: 125))
                path.move(to: .init(x: 314.28571428571433, y: 125))
                path.move(to: .init(x: 378.57142857142861, y: 125))
                path.addLine(to: .init(x: 442.85714285714289, y: 125))
                path.move(to: .init(x: 89.285714285714292, y: 500))
                path.addLine(to: .init(x: 89.285714285714292, y: 437.5))
                path.move(to: .init(x: 217.85714285714289, y: 500))
                path.addLine(to: .init(x: 217.85714285714289, y: 437.5))
                path.move(to: .init(x: 25, y: 437.5))
                path.move(to: .init(x: 57.142857142857146, y: 437.5))
                path.addLine(to: .init(x: 89.285714285714292, y: 437.5))
                path.move(to: .init(x: 153.57142857142858, y: 437.5))
                path.move(to: .init(x: 185.71428571428572, y: 437.5))
                path.addLine(to: .init(x: 217.85714285714289, y: 437.5))
                path.move(to: .init(x: 346.42857142857144, y: 500))
                path.addLine(to: .init(x: 346.42857142857144, y: 437.5))
                path.move(to: .init(x: 475.00000000000006, y: 500))
                path.addLine(to: .init(x: 475.00000000000006, y: 437.5))
                path.move(to: .init(x: 282.14285714285717, y: 437.5))
                path.move(to: .init(x: 314.28571428571433, y: 437.5))
                path.addLine(to: .init(x: 346.42857142857144, y: 437.5))
                path.move(to: .init(x: 410.71428571428578, y: 437.5))
                path.move(to: .init(x: 442.85714285714289, y: 437.5))
                path.addLine(to: .init(x: 475.00000000000006, y: 437.5))
                path.move(to: .init(x: 57.142857142857146, y: 375))
                path.move(to: .init(x: 121.42857142857144, y: 375))
                path.addLine(to: .init(x: 185.71428571428572, y: 375))
                path.move(to: .init(x: 314.28571428571433, y: 375))
                path.move(to: .init(x: 378.57142857142861, y: 375))
                path.addLine(to: .init(x: 442.85714285714289, y: 375))
                path.move(to: .init(x: 121.42857142857144, y: 187.5))
                path.move(to: .init(x: 250, y: 187.5))
                path.addLine(to: .init(x: 378.57142857142861, y: 187.5))
                path.move(to: .init(x: 121.42857142857144, y: 312.5))
                path.move(to: .init(x: 250, y: 312.5))
                path.addLine(to: .init(x: 378.57142857142861, y: 312.5))
                path.move(to: .init(x: 250, y: 312.5))
                path.addLine(to: .init(x: 250, y: 291.66666666666663))
                path.move(to: .init(x: 250, y: 291.66666666666663))
                path.addLine(to: .init(x: 250, y: 270.83333333333331))
                path.addLine(to: .init(x: 250, y: 270.83333333333331))
                path.move(to: .init(x: 250, y: 250))
                path.addLine(to: .init(x: 250, y: 270.83333333333331))
                return path
        }(),
            winnerPath: {
                let path = UIBezierPath()
                path.move(to: .init(x: 25, y: 0))
                path.addLine(to: .init(x: 25, y: 62.5))
                path.move(to: .init(x: 153.57142857142858, y: 0))
                path.addLine(to: .init(x: 153.57142857142858, y: 62.5))
                path.move(to: .init(x: 25, y: 62.5))
                path.addLine(to: .init(x: 57.142857142857146, y: 62.5))
                path.move(to: .init(x: 57.142857142857146, y: 62.5))
                path.addLine(to: .init(x: 57.142857142857146, y: 125))
                path.move(to: .init(x: 153.57142857142858, y: 62.5))
                path.addLine(to: .init(x: 185.71428571428572, y: 62.5))
                path.move(to: .init(x: 185.71428571428572, y: 62.5))
                path.addLine(to: .init(x: 185.71428571428572, y: 125))
                path.move(to: .init(x: 282.14285714285717, y: 0))
                path.addLine(to: .init(x: 282.14285714285717, y: 62.5))
                path.move(to: .init(x: 410.71428571428578, y: 0))
                path.addLine(to: .init(x: 410.71428571428578, y: 62.5))
                path.move(to: .init(x: 282.14285714285717, y: 62.5))
                path.addLine(to: .init(x: 314.28571428571433, y: 62.5))
                path.move(to: .init(x: 314.28571428571433, y: 62.5))
                path.addLine(to: .init(x: 314.28571428571433, y: 125))
                path.move(to: .init(x: 410.71428571428578, y: 62.5))
                path.addLine(to: .init(x: 442.85714285714289, y: 62.5))
                path.move(to: .init(x: 442.85714285714289, y: 62.5))
                path.addLine(to: .init(x: 442.85714285714289, y: 125))
                path.move(to: .init(x: 57.142857142857146, y: 125))
                path.addLine(to: .init(x: 121.42857142857144, y: 125))
                path.move(to: .init(x: 121.42857142857144, y: 125))
                path.addLine(to: .init(x: 121.42857142857144, y: 187.5))
                path.move(to: .init(x: 314.28571428571433, y: 125))
                path.addLine(to: .init(x: 378.57142857142861, y: 125))
                path.move(to: .init(x: 378.57142857142861, y: 125))
                path.addLine(to: .init(x: 378.57142857142861, y: 187.5))
                path.move(to: .init(x: 25, y: 500))
                path.addLine(to: .init(x: 25, y: 437.5))
                path.move(to: .init(x: 153.57142857142858, y: 500))
                path.addLine(to: .init(x: 153.57142857142858, y: 437.5))
                path.move(to: .init(x: 25, y: 437.5))
                path.addLine(to: .init(x: 57.142857142857146, y: 437.5))
                path.move(to: .init(x: 57.142857142857146, y: 437.5))
                path.addLine(to: .init(x: 57.142857142857146, y: 375))
                path.move(to: .init(x: 153.57142857142858, y: 437.5))
                path.addLine(to: .init(x: 185.71428571428572, y: 437.5))
                path.move(to: .init(x: 185.71428571428572, y: 437.5))
                path.addLine(to: .init(x: 185.71428571428572, y: 375))
                path.move(to: .init(x: 282.14285714285717, y: 500))
                path.addLine(to: .init(x: 282.14285714285717, y: 437.5))
                path.move(to: .init(x: 410.71428571428578, y: 500))
                path.addLine(to: .init(x: 410.71428571428578, y: 437.5))
                path.move(to: .init(x: 282.14285714285717, y: 437.5))
                path.addLine(to: .init(x: 314.28571428571433, y: 437.5))
                path.move(to: .init(x: 314.28571428571433, y: 437.5))
                path.addLine(to: .init(x: 314.28571428571433, y: 375))
                path.move(to: .init(x: 410.71428571428578, y: 437.5))
                path.addLine(to: .init(x: 442.85714285714289, y: 437.5))
                path.move(to: .init(x: 442.85714285714289, y: 437.5))
                path.addLine(to: .init(x: 442.85714285714289, y: 375))
                path.move(to: .init(x: 57.142857142857146, y: 375))
                path.addLine(to: .init(x: 121.42857142857144, y: 375))
                path.move(to: .init(x: 121.42857142857144, y: 375))
                path.addLine(to: .init(x: 121.42857142857144, y: 312.5))
                path.move(to: .init(x: 314.28571428571433, y: 375))
                path.addLine(to: .init(x: 378.57142857142861, y: 375))
                path.move(to: .init(x: 378.57142857142861, y: 375))
                path.addLine(to: .init(x: 378.57142857142861, y: 312.5))
                path.move(to: .init(x: 121.42857142857144, y: 187.5))
                path.addLine(to: .init(x: 250, y: 187.5))
                path.move(to: .init(x: 250, y: 187.5))
                path.addLine(to: .init(x: 250, y: 208.33333333333331))
                path.move(to: .init(x: 250, y: 208.33333333333331))
                path.addLine(to: .init(x: 250, y: 229.16666666666666))
                path.addLine(to: .init(x: 250, y: 229.16666666666666))
                path.move(to: .init(x: 121.42857142857144, y: 312.5))
                path.addLine(to: .init(x: 250, y: 312.5))
                path.move(to: .init(x: 250, y: 229.16666666666666))
                path.addLine(to: .init(x: 250, y: 250))
                path.move(to: .init(x: 250, y: 250))
                path.addLine(to: .init(x: 270, y: 250))
                return path
        }()
        ),
        .init(
            path: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 175))
                path.addLine(to: .init(x: 125, y: 175))
                path.move(to: .init(x: 125, y: 25))
                path.move(to: .init(x: 125, y: 100))
                path.addLine(to: .init(x: 125, y: 175))
                path.move(to: .init(x: 0, y: 325))
                path.addLine(to: .init(x: 250, y: 325))
                path.move(to: .init(x: 250, y: 100))
                path.move(to: .init(x: 250, y: 212.5))
                path.addLine(to: .init(x: 250, y: 325))
                path.move(to: .init(x: 0, y: 475))
                path.addLine(to: .init(x: 375, y: 475))
                path.move(to: .init(x: 375, y: 212.5))
                path.move(to: .init(x: 375, y: 343.75))
                path.addLine(to: .init(x: 375, y: 475))
                return path
        }(),
            winnerPath: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 25))
                path.addLine(to: .init(x: 125, y: 25))
                path.move(to: .init(x: 125, y: 25))
                path.addLine(to: .init(x: 125, y: 100))
                path.move(to: .init(x: 125, y: 100))
                path.addLine(to: .init(x: 250, y: 100))
                path.move(to: .init(x: 250, y: 100))
                path.addLine(to: .init(x: 250, y: 212.5))
                path.move(to: .init(x: 250, y: 212.5))
                path.addLine(to: .init(x: 375, y: 212.5))
                path.move(to: .init(x: 375, y: 212.5))
                path.addLine(to: .init(x: 375, y: 343.75))
                path.move(to: .init(x: 375, y: 343.75))
                path.addLine(to: .init(x: 500, y: 343.75))
                return path
        }()
        ),
        .init(
            path: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 175))
                path.addLine(to: .init(x: 83.333333333333329, y: 175))
                path.move(to: .init(x: 83.333333333333329, y: 100))
                path.addLine(to: .init(x: 83.333333333333329, y: 175))
                path.move(to: .init(x: 0, y: 475))
                path.addLine(to: .init(x: 166.66666666666666, y: 475))
                path.move(to: .init(x: 500, y: 250))
                path.addLine(to: .init(x: 416.66666666666669, y: 250))
                path.move(to: .init(x: 416.66666666666669, y: 193.75))
                path.addLine(to: .init(x: 416.66666666666669, y: 250))
                path.move(to: .init(x: 500, y: 362.5))
                path.addLine(to: .init(x: 333.33333333333337, y: 362.5))
                path.move(to: .init(x: 166.66666666666666, y: 165.625))
                path.addLine(to: .init(x: 166.66666666666666, y: 325))
                path.move(to: .init(x: 166.66666666666666, y: 334.375))
                path.addLine(to: .init(x: 166.66666666666666, y: 475))
                path.move(to: .init(x: 166.66666666666666, y: 334.375))
                path.addLine(to: .init(x: 194.44444444444446, y: 334.375))
                path.move(to: .init(x: 194.44444444444446, y: 250))
                path.addLine(to: .init(x: 194.44444444444446, y: 334.375))
                path.move(to: .init(x: 333.33333333333337, y: 117.8125))
                path.addLine(to: .init(x: 333.33333333333337, y: 193.75))
                path.move(to: .init(x: 333.33333333333337, y: 269.6875))
                path.addLine(to: .init(x: 333.33333333333337, y: 362.5))
                path.move(to: .init(x: 333.33333333333337, y: 117.8125))
                path.addLine(to: .init(x: 305.55555555555554, y: 117.8125))
                path.move(to: .init(x: 333.33333333333337, y: 269.6875))
                path.addLine(to: .init(x: 305.55555555555554, y: 269.6875))
                path.move(to: .init(x: 305.55555555555554, y: 117.8125))
                path.addLine(to: .init(x: 305.55555555555554, y: 250))
                path.move(to: .init(x: 305.55555555555554, y: 475))
                do {
                    let path2 = UIBezierPath()
                    path2.move(to: .init(x: 245, y: 250))
                    path2.addLine(to: .init(x: 255, y: 250))
                    path.append(path2)
                }
                return path
        }(),
            winnerPath: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 25))
                path.addLine(to: .init(x: 83.333333333333329, y: 25))
                path.move(to: .init(x: 83.333333333333329, y: 25))
                path.addLine(to: .init(x: 83.333333333333329, y: 100))
                path.move(to: .init(x: 83.333333333333329, y: 100))
                path.addLine(to: .init(x: 166.66666666666666, y: 100))
                path.move(to: .init(x: 0, y: 325))
                path.addLine(to: .init(x: 166.66666666666666, y: 325))
                path.move(to: .init(x: 500, y: 137.5))
                path.addLine(to: .init(x: 416.66666666666669, y: 137.5))
                path.move(to: .init(x: 500, y: 25))
                path.addLine(to: .init(x: 333.33333333333337, y: 25))
                path.move(to: .init(x: 416.66666666666669, y: 137.5))
                path.addLine(to: .init(x: 416.66666666666669, y: 193.75))
                path.move(to: .init(x: 416.66666666666669, y: 193.75))
                path.addLine(to: .init(x: 333.33333333333337, y: 193.75))
                path.move(to: .init(x: 166.66666666666666, y: 100))
                path.addLine(to: .init(x: 166.66666666666666, y: 165.625))
                path.move(to: .init(x: 166.66666666666666, y: 325))
                path.addLine(to: .init(x: 166.66666666666666, y: 334.375))
                path.move(to: .init(x: 166.66666666666666, y: 165.625))
                path.addLine(to: .init(x: 194.44444444444446, y: 165.625))
                path.move(to: .init(x: 194.44444444444446, y: 165.625))
                path.addLine(to: .init(x: 194.44444444444446, y: 250))
                path.move(to: .init(x: 194.44444444444446, y: 250))
                path.addLine(to: .init(x: 222.22222222222223, y: 250))
                path.addLine(to: .init(x: 222.22222222222223, y: 250))
                path.move(to: .init(x: 333.33333333333337, y: 25))
                path.addLine(to: .init(x: 333.33333333333337, y: 117.8125))
                path.move(to: .init(x: 333.33333333333337, y: 193.75))
                path.addLine(to: .init(x: 333.33333333333337, y: 269.6875))
                path.move(to: .init(x: 500, y: 475))
                path.addLine(to: .init(x: 305.55555555555554, y: 475))
                path.move(to: .init(x: 305.55555555555554, y: 475))
                path.addLine(to: .init(x: 305.55555555555554, y: 250))
                path.move(to: .init(x: 305.55555555555554, y: 250))
                path.addLine(to: .init(x: 277.77777777777777, y: 250))
                path.addLine(to: .init(x: 277.77777777777777, y: 250))
                path.move(to: .init(x: 222.22222222222223, y: 250))
                path.addLine(to: .init(x: 245, y: 250))
                path.move(to: .init(x: 245, y: 250))
                path.addLine(to: .init(x: 245, y: 230))
                path.move(to: .init(x: 255, y: 250))
                path.addLine(to: .init(x: 255, y: 230))
                path.move(to: .init(x: 255, y: 250))
                path.addLine(to: .init(x: 277.77777777777777, y: 250))
                return path
        }()
        ),
        .init(
            path: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 46.875))
                path.addLine(to: .init(x: 166.66666666666666, y: 46.875))
                path.move(to: .init(x: 0, y: 78.125))
                path.addLine(to: .init(x: 166.66666666666666, y: 78.125))
                path.move(to: .init(x: 0, y: 109.375))
                path.addLine(to: .init(x: 166.66666666666666, y: 109.375))
                path.move(to: .init(x: 0, y: 140.625))
                path.addLine(to: .init(x: 166.66666666666666, y: 140.625))
                path.move(to: .init(x: 0, y: 203.125))
                path.addLine(to: .init(x: 166.66666666666666, y: 203.125))
                path.move(to: .init(x: 0, y: 234.375))
                path.addLine(to: .init(x: 166.66666666666666, y: 234.375))
                path.move(to: .init(x: 0, y: 265.625))
                path.addLine(to: .init(x: 166.66666666666666, y: 265.625))
                path.move(to: .init(x: 0, y: 296.875))
                path.addLine(to: .init(x: 166.66666666666666, y: 296.875))
                path.move(to: .init(x: 0, y: 359.375))
                path.addLine(to: .init(x: 166.66666666666666, y: 359.375))
                path.move(to: .init(x: 0, y: 390.625))
                path.addLine(to: .init(x: 166.66666666666666, y: 390.625))
                path.move(to: .init(x: 0, y: 421.875))
                path.addLine(to: .init(x: 166.66666666666666, y: 421.875))
                path.move(to: .init(x: 0, y: 453.125))
                path.addLine(to: .init(x: 166.66666666666666, y: 453.125))
                path.move(to: .init(x: 166.66666666666666, y: 62.5))
                path.addLine(to: .init(x: 166.66666666666666, y: 109.375))
                path.move(to: .init(x: 166.66666666666666, y: 140.625))
                path.addLine(to: .init(x: 166.66666666666666, y: 171.875))
                path.move(to: .init(x: 166.66666666666666, y: 187.5))
                path.addLine(to: .init(x: 166.66666666666666, y: 234.375))
                path.move(to: .init(x: 166.66666666666666, y: 265.625))
                path.addLine(to: .init(x: 166.66666666666666, y: 312.5))
                path.move(to: .init(x: 166.66666666666666, y: 328.125))
                path.addLine(to: .init(x: 166.66666666666666, y: 359.375))
                path.move(to: .init(x: 166.66666666666666, y: 390.625))
                path.addLine(to: .init(x: 166.66666666666666, y: 437.5))
                path.move(to: .init(x: 166.66666666666666, y: 484.375))
                do {
                    let path2 = UIBezierPath()
                    path2.move(to: .init(x: 333.33333333333331, y: 250))
                    path2.addLine(to: .init(x: 333.33333333333331, y: 437.5))
                    path.append(path2)
                }
                return path
        }(),
            winnerPath: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 15.625))
                path.addLine(to: .init(x: 166.66666666666666, y: 15.625))
                path.move(to: .init(x: 0, y: 171.875))
                path.addLine(to: .init(x: 166.66666666666666, y: 171.875))
                path.move(to: .init(x: 0, y: 328.125))
                path.addLine(to: .init(x: 166.66666666666666, y: 328.125))
                path.move(to: .init(x: 0, y: 484.375))
                path.addLine(to: .init(x: 166.66666666666666, y: 484.375))
                path.move(to: .init(x: 166.66666666666666, y: 15.625))
                path.addLine(to: .init(x: 166.66666666666666, y: 62.5))
                path.move(to: .init(x: 166.66666666666666, y: 62.5))
                path.addLine(to: .init(x: 333.33333333333331, y: 62.5))
                path.move(to: .init(x: 166.66666666666666, y: 171.875))
                path.addLine(to: .init(x: 166.66666666666666, y: 187.5))
                path.move(to: .init(x: 166.66666666666666, y: 187.5))
                path.addLine(to: .init(x: 333.33333333333331, y: 187.5))
                path.move(to: .init(x: 166.66666666666666, y: 328.125))
                path.addLine(to: .init(x: 166.66666666666666, y: 312.5))
                path.move(to: .init(x: 166.66666666666666, y: 312.5))
                path.addLine(to: .init(x: 333.33333333333331, y: 312.5))
                path.move(to: .init(x: 166.66666666666666, y: 484.375))
                path.addLine(to: .init(x: 166.66666666666666, y: 437.5))
                path.move(to: .init(x: 166.66666666666666, y: 437.5))
                path.addLine(to: .init(x: 333.33333333333331, y: 437.5))
                path.move(to: .init(x: 333.33333333333331, y: 62.5))
                path.addLine(to: .init(x: 333.33333333333331, y: 250))
                path.move(to: .init(x: 333.33333333333331, y: 250))
                path.addLine(to: .init(x: 500, y: 250))
                return path
        }()
        ),
        .init(
            path: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 175))
                path.addLine(to: .init(x: 125, y: 175))
                path.move(to: .init(x: 0, y: 475))
                path.addLine(to: .init(x: 125, y: 475))
                path.move(to: .init(x: 500, y: 175))
                path.addLine(to: .init(x: 375, y: 175))
                path.move(to: .init(x: 500, y: 325))
                path.addLine(to: .init(x: 375, y: 325))
                path.move(to: .init(x: 125, y: 25))
                path.move(to: .init(x: 125, y: 182.5))
                path.addLine(to: .init(x: 125, y: 317.5))
                path.move(to: .init(x: 125, y: 325))
                path.addLine(to: .init(x: 125, y: 475))
                path.move(to: .init(x: 125, y: 317.5))
                path.addLine(to: .init(x: 166.66666666666669, y: 317.5))
                path.move(to: .init(x: 166.66666666666669, y: 182.5))
                path.move(to: .init(x: 166.66666666666669, y: 250))
                path.addLine(to: .init(x: 166.66666666666669, y: 317.5))
                path.move(to: .init(x: 375, y: 25))
                path.move(to: .init(x: 375, y: 182.5))
                path.addLine(to: .init(x: 375, y: 317.5))
                path.move(to: .init(x: 375, y: 475))
                path.move(to: .init(x: 375, y: 182.5))
                path.addLine(to: .init(x: 333.33333333333337, y: 182.5))
                path.move(to: .init(x: 375, y: 317.5))
                path.addLine(to: .init(x: 333.33333333333337, y: 317.5))
                path.move(to: .init(x: 333.33333333333337, y: 182.5))
                path.addLine(to: .init(x: 333.33333333333337, y: 317.5))
                path.move(to: .init(x: 333.33333333333337, y: 250))
                path.addLine(to: .init(x: 291.66666666666669, y: 250))
                path.addLine(to: .init(x: 291.66666666666669, y: 250))
                path.move(to: .init(x: 250, y: 250))
                path.addLine(to: .init(x: 291.66666666666669, y: 250))
                return path
        }(),
            winnerPath: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 25))
                path.addLine(to: .init(x: 125, y: 25))
                path.move(to: .init(x: 0, y: 325))
                path.addLine(to: .init(x: 125, y: 325))
                path.move(to: .init(x: 500, y: 25))
                path.addLine(to: .init(x: 375, y: 25))
                path.move(to: .init(x: 500, y: 475))
                path.addLine(to: .init(x: 375, y: 475))
                path.move(to: .init(x: 125, y: 25))
                path.addLine(to: .init(x: 125, y: 182.5))
                path.move(to: .init(x: 125, y: 325))
                path.addLine(to: .init(x: 125, y: 317.5))
                path.move(to: .init(x: 125, y: 182.5))
                path.addLine(to: .init(x: 166.66666666666669, y: 182.5))
                path.move(to: .init(x: 166.66666666666669, y: 182.5))
                path.addLine(to: .init(x: 166.66666666666669, y: 250))
                path.move(to: .init(x: 166.66666666666669, y: 250))
                path.addLine(to: .init(x: 208.33333333333334, y: 250))
                path.addLine(to: .init(x: 208.33333333333334, y: 250))
                path.move(to: .init(x: 375, y: 25))
                path.addLine(to: .init(x: 375, y: 182.5))
                path.move(to: .init(x: 375, y: 475))
                path.addLine(to: .init(x: 375, y: 317.5))
                path.move(to: .init(x: 208.33333333333334, y: 250))
                path.addLine(to: .init(x: 250, y: 250))
                path.move(to: .init(x: 250, y: 250))
                path.addLine(to: .init(x: 250, y: 230))
                return path
        }()
        ),
        .init(
            path: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 175))
                path.addLine(to: .init(x: 83.333333333333329, y: 175))
                path.move(to: .init(x: 0, y: 475))
                path.addLine(to: .init(x: 83.333333333333329, y: 475))
                path.move(to: .init(x: 83.333333333333329, y: 25))
                path.move(to: .init(x: 83.333333333333329, y: 100))
                path.addLine(to: .init(x: 83.333333333333329, y: 175))
                path.move(to: .init(x: 83.333333333333329, y: 325))
                path.move(to: .init(x: 83.333333333333329, y: 400))
                path.addLine(to: .init(x: 83.333333333333329, y: 475))
                path.move(to: .init(x: 500, y: 175))
                path.addLine(to: .init(x: 416.66666666666669, y: 175))
                path.move(to: .init(x: 500, y: 475))
                path.addLine(to: .init(x: 416.66666666666669, y: 475))
                path.move(to: .init(x: 416.66666666666669, y: 25))
                path.move(to: .init(x: 416.66666666666669, y: 100))
                path.addLine(to: .init(x: 416.66666666666669, y: 175))
                path.move(to: .init(x: 416.66666666666669, y: 325))
                path.move(to: .init(x: 416.66666666666669, y: 400))
                path.addLine(to: .init(x: 416.66666666666669, y: 475))
                path.move(to: .init(x: 166.66666666666666, y: 100))
                path.move(to: .init(x: 166.66666666666666, y: 250))
                path.addLine(to: .init(x: 166.66666666666666, y: 400))
                path.move(to: .init(x: 333.33333333333337, y: 100))
                path.move(to: .init(x: 333.33333333333337, y: 250))
                path.addLine(to: .init(x: 333.33333333333337, y: 400))
                path.move(to: .init(x: 333.33333333333337, y: 250))
                path.addLine(to: .init(x: 305.55555555555554, y: 250))
                path.move(to: .init(x: 305.55555555555554, y: 250))
                path.addLine(to: .init(x: 277.77777777777777, y: 250))
                path.addLine(to: .init(x: 277.77777777777777, y: 250))
                path.move(to: .init(x: 250, y: 250))
                path.addLine(to: .init(x: 277.77777777777777, y: 250))
                return path
        }(),
            winnerPath: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 25))
                path.addLine(to: .init(x: 83.333333333333329, y: 25))
                path.move(to: .init(x: 0, y: 325))
                path.addLine(to: .init(x: 83.333333333333329, y: 325))
                path.move(to: .init(x: 83.333333333333329, y: 25))
                path.addLine(to: .init(x: 83.333333333333329, y: 100))
                path.move(to: .init(x: 83.333333333333329, y: 100))
                path.addLine(to: .init(x: 166.66666666666666, y: 100))
                path.move(to: .init(x: 83.333333333333329, y: 325))
                path.addLine(to: .init(x: 83.333333333333329, y: 400))
                path.move(to: .init(x: 83.333333333333329, y: 400))
                path.addLine(to: .init(x: 166.66666666666666, y: 400))
                path.move(to: .init(x: 500, y: 25))
                path.addLine(to: .init(x: 416.66666666666669, y: 25))
                path.move(to: .init(x: 500, y: 325))
                path.addLine(to: .init(x: 416.66666666666669, y: 325))
                path.move(to: .init(x: 416.66666666666669, y: 25))
                path.addLine(to: .init(x: 416.66666666666669, y: 100))
                path.move(to: .init(x: 416.66666666666669, y: 100))
                path.addLine(to: .init(x: 333.33333333333337, y: 100))
                path.move(to: .init(x: 416.66666666666669, y: 325))
                path.addLine(to: .init(x: 416.66666666666669, y: 400))
                path.move(to: .init(x: 416.66666666666669, y: 400))
                path.addLine(to: .init(x: 333.33333333333337, y: 400))
                path.move(to: .init(x: 166.66666666666666, y: 100))
                path.addLine(to: .init(x: 166.66666666666666, y: 250))
                path.move(to: .init(x: 166.66666666666666, y: 250))
                path.addLine(to: .init(x: 194.44444444444446, y: 250))
                path.move(to: .init(x: 194.44444444444446, y: 250))
                path.addLine(to: .init(x: 222.22222222222223, y: 250))
                path.addLine(to: .init(x: 222.22222222222223, y: 250))
                path.move(to: .init(x: 333.33333333333337, y: 100))
                path.addLine(to: .init(x: 333.33333333333337, y: 250))
                path.move(to: .init(x: 222.22222222222223, y: 250))
                path.addLine(to: .init(x: 250, y: 250))
                path.move(to: .init(x: 250, y: 250))
                path.addLine(to: .init(x: 250, y: 230))
                return path
        }()
        ),
        .init(
            path: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 250))
                path.addLine(to: .init(x: 83.333333333333329, y: 250))
                path.move(to: .init(x: 83.333333333333329, y: 25))
                path.move(to: .init(x: 83.333333333333329, y: 137.5))
                path.addLine(to: .init(x: 83.333333333333329, y: 250))
                path.move(to: .init(x: 0, y: 475))
                path.addLine(to: .init(x: 166.66666666666666, y: 475))
                path.move(to: .init(x: 500, y: 175))
                path.addLine(to: .init(x: 416.66666666666669, y: 175))
                path.move(to: .init(x: 500, y: 475))
                path.addLine(to: .init(x: 416.66666666666669, y: 475))
                path.move(to: .init(x: 416.66666666666669, y: 25))
                path.move(to: .init(x: 416.66666666666669, y: 100))
                path.addLine(to: .init(x: 416.66666666666669, y: 175))
                path.move(to: .init(x: 416.66666666666669, y: 325))
                path.move(to: .init(x: 416.66666666666669, y: 400))
                path.addLine(to: .init(x: 416.66666666666669, y: 475))
                path.move(to: .init(x: 166.66666666666666, y: 137.5))
                path.move(to: .init(x: 166.66666666666666, y: 250))
                path.addLine(to: .init(x: 166.66666666666666, y: 475))
                path.move(to: .init(x: 333.33333333333337, y: 100))
                path.move(to: .init(x: 333.33333333333337, y: 250))
                path.addLine(to: .init(x: 333.33333333333337, y: 400))
                path.move(to: .init(x: 333.33333333333337, y: 250))
                path.addLine(to: .init(x: 305.55555555555554, y: 250))
                path.move(to: .init(x: 305.55555555555554, y: 250))
                path.addLine(to: .init(x: 277.77777777777777, y: 250))
                path.addLine(to: .init(x: 277.77777777777777, y: 250))
                path.move(to: .init(x: 250, y: 250))
                path.addLine(to: .init(x: 277.77777777777777, y: 250))
                return path
        }(),
            winnerPath: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 25))
                path.addLine(to: .init(x: 83.333333333333329, y: 25))
                path.move(to: .init(x: 83.333333333333329, y: 25))
                path.addLine(to: .init(x: 83.333333333333329, y: 137.5))
                path.move(to: .init(x: 83.333333333333329, y: 137.5))
                path.addLine(to: .init(x: 166.66666666666666, y: 137.5))
                path.move(to: .init(x: 500, y: 25))
                path.addLine(to: .init(x: 416.66666666666669, y: 25))
                path.move(to: .init(x: 500, y: 325))
                path.addLine(to: .init(x: 416.66666666666669, y: 325))
                path.move(to: .init(x: 416.66666666666669, y: 25))
                path.addLine(to: .init(x: 416.66666666666669, y: 100))
                path.move(to: .init(x: 416.66666666666669, y: 100))
                path.addLine(to: .init(x: 333.33333333333337, y: 100))
                path.move(to: .init(x: 416.66666666666669, y: 325))
                path.addLine(to: .init(x: 416.66666666666669, y: 400))
                path.move(to: .init(x: 416.66666666666669, y: 400))
                path.addLine(to: .init(x: 333.33333333333337, y: 400))
                path.move(to: .init(x: 166.66666666666666, y: 137.5))
                path.addLine(to: .init(x: 166.66666666666666, y: 250))
                path.move(to: .init(x: 166.66666666666666, y: 250))
                path.addLine(to: .init(x: 194.44444444444446, y: 250))
                path.move(to: .init(x: 194.44444444444446, y: 250))
                path.addLine(to: .init(x: 222.22222222222223, y: 250))
                path.addLine(to: .init(x: 222.22222222222223, y: 250))
                path.move(to: .init(x: 333.33333333333337, y: 100))
                path.addLine(to: .init(x: 333.33333333333337, y: 250))
                path.move(to: .init(x: 222.22222222222223, y: 250))
                path.addLine(to: .init(x: 250, y: 250))
                path.move(to: .init(x: 250, y: 250))
                path.addLine(to: .init(x: 250, y: 230))
                return path
        }()
        ),
        .init(
            path: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 25))
                path.addLine(to: .init(x: 41.666666666666664, y: 25))
                path.move(to: .init(x: 41.666666666666664, y: 25))
                path.addLine(to: .init(x: 41.666666666666664, y: 70))
                path.move(to: .init(x: 0, y: 205))
                path.addLine(to: .init(x: 83.333333333333329, y: 205))
                path.move(to: .init(x: 83.333333333333329, y: 137.5))
                path.addLine(to: .init(x: 83.333333333333329, y: 205))
                path.move(to: .init(x: 125, y: 137.5))
                path.addLine(to: .init(x: 125, y: 216.25))
                path.move(to: .init(x: 125, y: 295))
                do {
                    let path2 = UIBezierPath()
                    path2.move(to: .init(x: 166.66666666666666, y: 216.25))
                    path2.addLine(to: .init(x: 166.66666666666666, y: 300.625))
                    path.append(path2)
                }
                path.move(to: .init(x: 166.66666666666666, y: 385))
                do {
                    let path2 = UIBezierPath()
                    path2.move(to: .init(x: 500, y: 400))
                    path2.addLine(to: .init(x: 458.33333333333331, y: 400))
                    path.append(path2)
                }
                path.move(to: .init(x: 458.33333333333331, y: 400))
                path.addLine(to: .init(x: 458.33333333333331, y: 437.5))
                path.move(to: .init(x: 458.33333333333331, y: 475))
                do {
                    let path2 = UIBezierPath()
                    path2.move(to: .init(x: 500, y: 250))
                    path2.addLine(to: .init(x: 375, y: 250))
                    path.append(path2)
                }
                path.move(to: .init(x: 416.66666666666669, y: 381.25))
                path.addLine(to: .init(x: 416.66666666666663, y: 437.5))
                path.move(to: .init(x: 500, y: 175))
                path.addLine(to: .init(x: 333.33333333333337, y: 175))
                path.move(to: .init(x: 375, y: 250))
                path.addLine(to: .init(x: 375, y: 315.625))
                path.move(to: .init(x: 375, y: 381.25))
                do {
                    let path2 = UIBezierPath()
                    path2.move(to: .init(x: 500, y: 25))
                    path2.addLine(to: .init(x: 291.66666666666669, y: 25))
                    path.append(path2)
                }
                path.move(to: .init(x: 333.33333333333337, y: 175))
                path.addLine(to: .init(x: 333.33333333333337, y: 245.3125))
                path.move(to: .init(x: 333.33333333333331, y: 315.625))
                do {
                    let path2 = UIBezierPath()
                    path2.move(to: .init(x: 208.33333333333331, y: 300.625))
                    path2.addLine(to: .init(x: 208.33333333333331, y: 387.8125))
                    path.append(path2)
                }
                path.move(to: .init(x: 208.33333333333331, y: 475))
                do {
                    let path2 = UIBezierPath()
                    path2.move(to: .init(x: 291.66666666666669, y: 25))
                    path2.addLine(to: .init(x: 291.66666666666669, y: 85.5859375))
                    path.append(path2)
                }
                path.move(to: .init(x: 291.66666666666669, y: 100))
                path.addLine(to: .init(x: 291.66666666666669, y: 184.7265625))
                path.move(to: .init(x: 291.66666666666669, y: 85.5859375))
                path.addLine(to: .init(x: 277.77777777777783, y: 85.5859375))
                path.move(to: .init(x: 277.77777777777783, y: 85.5859375))
                path.addLine(to: .init(x: 277.77777777777783, y: 135.15625))
                path.move(to: .init(x: 277.77777777777783, y: 184.7265625))
                do {
                    let path2 = UIBezierPath()
                    path2.move(to: .init(x: 245.83333333333334, y: 261.484375))
                    path2.addLine(to: .init(x: 254.16666666666669, y: 261.484375))
                    path.append(path2)
                }
                return path
        }(),
            winnerPath: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 115))
                path.addLine(to: .init(x: 41.666666666666664, y: 115))
                path.move(to: .init(x: 41.666666666666664, y: 115))
                path.addLine(to: .init(x: 41.666666666666664, y: 70))
                path.move(to: .init(x: 41.666666666666664, y: 70))
                path.addLine(to: .init(x: 83.333333333333329, y: 70))
                path.move(to: .init(x: 83.333333333333329, y: 70))
                path.addLine(to: .init(x: 83.333333333333329, y: 137.5))
                path.move(to: .init(x: 83.333333333333329, y: 137.5))
                path.addLine(to: .init(x: 125, y: 137.5))
                path.move(to: .init(x: 0, y: 295))
                path.addLine(to: .init(x: 125, y: 295))
                path.move(to: .init(x: 125, y: 295))
                path.addLine(to: .init(x: 125, y: 216.25))
                path.move(to: .init(x: 125, y: 216.25))
                path.addLine(to: .init(x: 166.66666666666666, y: 216.25))
                path.move(to: .init(x: 0, y: 385))
                path.addLine(to: .init(x: 166.66666666666666, y: 385))
                path.move(to: .init(x: 166.66666666666666, y: 385))
                path.addLine(to: .init(x: 166.66666666666666, y: 300.625))
                path.move(to: .init(x: 166.66666666666666, y: 300.625))
                path.addLine(to: .init(x: 208.33333333333331, y: 300.625))
                path.move(to: .init(x: 0, y: 475))
                path.addLine(to: .init(x: 208.33333333333331, y: 475))
                path.move(to: .init(x: 500, y: 475))
                path.addLine(to: .init(x: 458.33333333333331, y: 475))
                path.move(to: .init(x: 500, y: 325))
                path.addLine(to: .init(x: 416.66666666666669, y: 325))
                path.move(to: .init(x: 458.33333333333331, y: 475))
                path.addLine(to: .init(x: 458.33333333333331, y: 437.5))
                path.move(to: .init(x: 458.33333333333331, y: 437.5))
                path.addLine(to: .init(x: 416.66666666666663, y: 437.5))
                path.move(to: .init(x: 416.66666666666669, y: 325))
                path.addLine(to: .init(x: 416.66666666666669, y: 381.25))
                path.move(to: .init(x: 416.66666666666669, y: 381.25))
                path.addLine(to: .init(x: 375, y: 381.25))
                path.move(to: .init(x: 375, y: 381.25))
                path.addLine(to: .init(x: 375, y: 315.625))
                path.move(to: .init(x: 375, y: 315.625))
                path.addLine(to: .init(x: 333.33333333333331, y: 315.625))
                path.move(to: .init(x: 500, y: 100))
                path.addLine(to: .init(x: 291.66666666666669, y: 100))
                path.move(to: .init(x: 333.33333333333331, y: 315.625))
                path.addLine(to: .init(x: 333.33333333333337, y: 245.3125))
                path.move(to: .init(x: 333.33333333333337, y: 245.3125))
                path.addLine(to: .init(x: 291.66666666666669, y: 245.3125))
                path.move(to: .init(x: 208.33333333333331, y: 475))
                path.addLine(to: .init(x: 208.33333333333331, y: 387.8125))
                path.move(to: .init(x: 208.33333333333331, y: 387.8125))
                path.addLine(to: .init(x: 222.22222222222223, y: 387.8125))
                path.move(to: .init(x: 222.22222222222223, y: 387.8125))
                path.addLine(to: .init(x: 236.11111111111111, y: 387.8125))
                path.addLine(to: .init(x: 236.11111111111111, y: 261.484375))
                path.move(to: .init(x: 291.66666666666669, y: 100))
                path.addLine(to: .init(x: 291.66666666666669, y: 85.5859375))
                path.move(to: .init(x: 291.66666666666669, y: 245.3125))
                path.addLine(to: .init(x: 291.66666666666669, y: 184.7265625))
                path.move(to: .init(x: 291.66666666666669, y: 184.7265625))
                path.addLine(to: .init(x: 277.77777777777783, y: 184.7265625))
                path.move(to: .init(x: 277.77777777777783, y: 184.7265625))
                path.addLine(to: .init(x: 277.77777777777783, y: 135.15625))
                path.move(to: .init(x: 277.77777777777783, y: 135.15625))
                path.addLine(to: .init(x: 263.88888888888891, y: 135.15625))
                path.addLine(to: .init(x: 263.88888888888891, y: 261.484375))
                path.move(to: .init(x: 236.11111111111111, y: 261.484375))
                path.addLine(to: .init(x: 245.83333333333334, y: 261.484375))
                path.move(to: .init(x: 245.83333333333334, y: 261.484375))
                path.addLine(to: .init(x: 245.83333333333334, y: 241.484375))
                path.move(to: .init(x: 254.16666666666669, y: 261.484375))
                path.addLine(to: .init(x: 254.16666666666669, y: 241.484375))
                path.move(to: .init(x: 254.16666666666669, y: 261.484375))
                path.addLine(to: .init(x: 263.88888888888891, y: 261.484375))
                return path
        }()
        ),
        .init(
            path: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 250))
                path.addLine(to: .init(x: 125, y: 250))
                path.move(to: .init(x: 125, y: 250))
                path.addLine(to: .init(x: 125, y: 362.5))
                path.move(to: .init(x: 125, y: 475))
                do {
                    let path2 = UIBezierPath()
                    path2.move(to: .init(x: 0, y: 25))
                    path2.addLine(to: .init(x: 375, y: 25))
                    path.append(path2)
                }
                path.move(to: .init(x: 375, y: 25))
                path.addLine(to: .init(x: 375, y: 193.75))
                path.move(to: .init(x: 375, y: 362.5))
                return path
        }(),
            winnerPath: {
                let path = UIBezierPath()
                path.move(to: .init(x: 0, y: 475))
                path.addLine(to: .init(x: 125, y: 475))
                path.move(to: .init(x: 125, y: 475))
                path.addLine(to: .init(x: 125, y: 362.5))
                path.move(to: .init(x: 125, y: 362.5))
                path.addLine(to: .init(x: 250, y: 362.5))
                path.move(to: .init(x: 250, y: 362.5))
                path.addLine(to: .init(x: 375, y: 362.5))
                path.move(to: .init(x: 375, y: 362.5))
                path.addLine(to: .init(x: 375, y: 193.75))
                path.move(to: .init(x: 375, y: 193.75))
                path.addLine(to: .init(x: 500, y: 193.75))
                return path
        }()
        )
    ]

    let params: [[(MatchPath, CGRect, [CGPoint])]] = [
        [
            (
                MatchPath(layer: 1, item: 0),
                CGRect(x: 375.0, y: 15.0, width: 83.33333333333333, height: 170.0),
                [CGPoint(x: 41.666666666666686, y: 85.0)]
            ), (
                MatchPath(layer: 1, item: 1),
                CGRect(x: 375.0, y: 315.0, width: 83.33333333333333, height: 170.0),
                [CGPoint(x: 41.666666666666686, y: 85.0)]
            ), (
                MatchPath(layer: 2, item: 0),
                CGRect(x: 291.6666666666667, y: 90.0, width: 83.33333333333333, height: 320.0),
                [CGPoint(x: 41.666666666666686, y: 160.0)]
            ), (
                MatchPath(layer: 3, item: 0),
                CGRect(x: 208.33333333333334, y: 230.0, width: 83.33333333333334, height: 40.0),
                [CGPoint(x: 41.66666666666666, y: 20.0)]
            )
        ],
        [
            (
                MatchPath(layer: 1, item: 0),
                CGRect(x: 50.0, y: 5.625, width: 100.0, height: 51.25),
                [CGPoint(x: 50.0, y: 25.625)]
            ), (
                MatchPath(layer: 1, item: 1),
                CGRect(x: 50.0, y: 68.125, width: 100.0, height: 51.25),
                [CGPoint(x: 50.0, y: 25.625)]
            ), (
                MatchPath(layer: 1, item: 2),
                CGRect(x: 50.0, y: 130.625, width: 100.0, height: 51.25),
                [CGPoint(x: 50.0, y: 25.625)]
            ), (
                MatchPath(layer: 1, item: 3),
                CGRect(x: 50.0, y: 193.125, width: 100.0, height: 51.25),
                [CGPoint(x: 50.0, y: 25.625)]
            ), (
                MatchPath(layer: 2, item: 0),
                CGRect(x: 150.0, y: 21.25, width: 100.0, height: 82.5),
                [CGPoint(x: 50.0, y: 41.25)]
            ), (
                MatchPath(layer: 2, item: 1),
                CGRect(x: 150.0, y: 146.25, width: 100.0, height: 82.5),
                [CGPoint(x: 50.0, y: 41.25)]
            ), (
                MatchPath(layer: 1, item: 4),
                CGRect(x: 50.0, y: 255.625, width: 100.0, height: 51.25),
                [CGPoint(x: 50.0, y: 25.625)]
            ), (
                MatchPath(layer: 1, item: 5),
                CGRect(x: 50.0, y: 318.125, width: 100.0, height: 51.25),
                [CGPoint(x: 50.0, y: 25.625)]
            ), (
                MatchPath(layer: 1, item: 6),
                CGRect(x: 50.0, y: 380.625, width: 100.0, height: 51.25),
                [CGPoint(x: 50.0, y: 25.625)]
            ), (
                MatchPath(layer: 1, item: 7),
                CGRect(x: 50.0, y: 443.125, width: 100.0, height: 51.25),
                [CGPoint(x: 50.0, y: 25.625)]
            ), (
                MatchPath(layer: 2, item: 2),
                CGRect(x: 150.0, y: 271.25, width: 100.0, height: 82.5),
                [CGPoint(x: 50.0, y: 41.25)]
            ), (
                MatchPath(layer: 2, item: 3),
                CGRect(x: 150.0, y: 396.25, width: 100.0, height: 82.5),
                [CGPoint(x: 50.0, y: 41.25)]
            ), (
                MatchPath(layer: 3, item: 0),
                CGRect(x: 250.0, y: 52.5, width: 100.0, height: 145.0),
                [CGPoint(x: 50.0, y: 72.5)]
            ), (
                MatchPath(layer: 3, item: 1),
                CGRect(x: 250.0, y: 302.5, width: 100.0, height: 145.0),
                [CGPoint(x: 50.0, y: 72.5)]
            ), (
                MatchPath(layer: 4, item: 0),
                CGRect(x: 350.0, y: 115.0, width: 100.0, height: 270.0),
                [CGPoint(x: 50.0, y: 135.0)]
            )
        ],
        [
            (
                MatchPath(layer: 1, item: 0),
                CGRect(x: 350.0, y: 5.625, width: 100.0, height: 51.25),
                [CGPoint(x: 50.0, y: 25.625)]
            ), (
                MatchPath(layer: 1, item: 1),
                CGRect(x: 350.0, y: 68.125, width: 100.0, height: 51.25),
                [CGPoint(x: 50.0, y: 25.625)]
            ), (
                MatchPath(layer: 1, item: 2),
                CGRect(x: 350.0, y: 130.625, width: 100.0, height: 51.25),
                [CGPoint(x: 50.0, y: 25.625)]
            ), (
                MatchPath(layer: 1, item: 3),
                CGRect(x: 350.0, y: 193.125, width: 100.0, height: 51.25),
                [CGPoint(x: 50.0, y: 25.625)]
            ), (
                MatchPath(layer: 2, item: 0),
                CGRect(x: 250.0, y: 21.25, width: 100.0, height: 82.5),
                [CGPoint(x: 50.0, y: 41.25)]
            ), (
                MatchPath(layer: 2, item: 1),
                CGRect(x: 250.0, y: 146.25, width: 100.0, height: 82.5),
                [CGPoint(x: 50.0, y: 41.25)]
            ), (
                MatchPath(layer: 1, item: 4),
                CGRect(x: 350.0, y: 255.625, width: 100.0, height: 51.25),
                [CGPoint(x: 50.0, y: 25.625)]
            ), (
                MatchPath(layer: 1, item: 5),
                CGRect(x: 350.0, y: 318.125, width: 100.0, height: 51.25),
                [CGPoint(x: 50.0, y: 25.625)]
            ), (
                MatchPath(layer: 1, item: 6),
                CGRect(x: 350.0, y: 380.625, width: 100.0, height: 51.25),
                [CGPoint(x: 50.0, y: 25.625)]
            ), (
                MatchPath(layer: 1, item: 7),
                CGRect(x: 350.0, y: 443.125, width: 100.0, height: 51.25),
                [CGPoint(x: 50.0, y: 25.625)]
            ), (
                MatchPath(layer: 2, item: 2),
                CGRect(x: 250.0, y: 271.25, width: 100.0, height: 82.5),
                [CGPoint(x: 50.0, y: 41.25)]
            ), (
                MatchPath(layer: 2, item: 3),
                CGRect(x: 250.0, y: 396.25, width: 100.0, height: 82.5),
                [CGPoint(x: 50.0, y: 41.25)]
            ), (
                MatchPath(layer: 3, item: 0),
                CGRect(x: 150.0, y: 52.5, width: 100.0, height: 145.0),
                [CGPoint(x: 50.0, y: 72.5)]
            ), (
                MatchPath(layer: 3, item: 1),
                CGRect(x: 150.0, y: 302.5, width: 100.0, height: 145.0),
                [CGPoint(x: 50.0, y: 72.5)]
            ), (
                MatchPath(layer: 4, item: 0),
                CGRect(x: 50.0, y: 115.0, width: 100.0, height: 270.0),
                [CGPoint(x: 50.0, y: 135.0)]
            )
        ],
        [
            (
                MatchPath(layer: 1, item: 0),
                CGRect(x: 5.625, y: 50.0, width: 51.25, height: 100.0),
                [CGPoint(x: 25.625, y: 50.0)]
            ), (
                MatchPath(layer: 1, item: 1),
                CGRect(x: 68.125, y: 50.0, width: 51.25, height: 100.0),
                [CGPoint(x: 25.625, y: 50.0)]
            ), (
                MatchPath(layer: 1, item: 2),
                CGRect(x: 130.625, y: 50.0, width: 51.25, height: 100.0),
                [CGPoint(x: 25.625, y: 50.0)]
            ), (
                MatchPath(layer: 1, item: 3),
                CGRect(x: 193.125, y: 50.0, width: 51.25, height: 100.0),
                [CGPoint(x: 25.625, y: 50.0)]
            ), (
                MatchPath(layer: 2, item: 0),
                CGRect(x: 21.25, y: 150.0, width: 82.5, height: 100.0),
                [CGPoint(x: 41.25, y: 50.0)]
            ), (
                MatchPath(layer: 2, item: 1),
                CGRect(x: 146.25, y: 150.0, width: 82.5, height: 100.0),
                [CGPoint(x: 41.25, y: 50.0)]
            ), (
                MatchPath(layer: 1, item: 4),
                CGRect(x: 255.625, y: 50.0, width: 51.25, height: 100.0),
                [CGPoint(x: 25.625, y: 50.0)]
            ), (
                MatchPath(layer: 1, item: 5),
                CGRect(x: 318.125, y: 50.0, width: 51.25, height: 100.0),
                [CGPoint(x: 25.625, y: 50.0)]
            ), (
                MatchPath(layer: 1, item: 6),
                CGRect(x: 380.625, y: 50.0, width: 51.25, height: 100.0),
                [CGPoint(x: 25.625, y: 50.0)]
            ), (
                MatchPath(layer: 1, item: 7),
                CGRect(x: 443.125, y: 50.0, width: 51.25, height: 100.0),
                [CGPoint(x: 25.625, y: 50.0)]
            ), (
                MatchPath(layer: 2, item: 2),
                CGRect(x: 271.25, y: 150.0, width: 82.5, height: 100.0),
                [CGPoint(x: 41.25, y: 50.0)]
            ), (
                MatchPath(layer: 2, item: 3),
                CGRect(x: 396.25, y: 150.0, width: 82.5, height: 100.0),
                [CGPoint(x: 41.25, y: 50.0)]
            ), (
                MatchPath(layer: 3, item: 0),
                CGRect(x: 52.5, y: 250.0, width: 145.0, height: 100.0),
                [CGPoint(x: 72.5, y: 50.0)]
            ), (
                MatchPath(layer: 3, item: 1),
                CGRect(x: 302.5, y: 250.0, width: 145.0, height: 100.0),
                [CGPoint(x: 72.5, y: 50.0)]
            ), (
                MatchPath(layer: 4, item: 0),
                CGRect(x: 115.0, y: 350.0, width: 270.0, height: 100.0),
                [CGPoint(x: 135.0, y: 50.0)]
            )
        ],
        [
            (
                MatchPath(layer: 1, item: 0),
                CGRect(x: 5.625, y: 350.0, width: 51.25, height: 100.0),
                [CGPoint(x: 25.625, y: 50.0)]
            ), (
                MatchPath(layer: 1, item: 1),
                CGRect(x: 68.125, y: 350.0, width: 51.25, height: 100.0),
                [CGPoint(x: 25.625, y: 50.0)]
            ), (
                MatchPath(layer: 1, item: 2),
                CGRect(x: 130.625, y: 350.0, width: 51.25, height: 100.0),
                [CGPoint(x: 25.625, y: 50.0)]
            ), (
                MatchPath(layer: 1, item: 3),
                CGRect(x: 193.125, y: 350.0, width: 51.25, height: 100.0),
                [CGPoint(x: 25.625, y: 50.0)]
            ), (
                MatchPath(layer: 2, item: 0),
                CGRect(x: 21.25, y: 250.0, width: 82.5, height: 100.0),
                [CGPoint(x: 41.25, y: 50.0)]
            ), (
                MatchPath(layer: 2, item: 1),
                CGRect(x: 146.25, y: 250.0, width: 82.5, height: 100.0),
                [CGPoint(x: 41.25, y: 50.0)]
            ), (
                MatchPath(layer: 1, item: 4),
                CGRect(x: 255.625, y: 350.0, width: 51.25, height: 100.0),
                [CGPoint(x: 25.625, y: 50.0)]
            ), (
                MatchPath(layer: 1, item: 5),
                CGRect(x: 318.125, y: 350.0, width: 51.25, height: 100.0),
                [CGPoint(x: 25.625, y: 50.0)]
            ), (
                MatchPath(layer: 1, item: 6),
                CGRect(x: 380.625, y: 350.0, width: 51.25, height: 100.0),
                [CGPoint(x: 25.625, y: 50.0)]
            ), (
                MatchPath(layer: 1, item: 7),
                CGRect(x: 443.125, y: 350.0, width: 51.25, height: 100.0),
                [CGPoint(x: 25.625, y: 50.0)]
            ), (
                MatchPath(layer: 2, item: 2),
                CGRect(x: 271.25, y: 250.0, width: 82.5, height: 100.0),
                [CGPoint(x: 41.25, y: 50.0)]
            ), (
                MatchPath(layer: 2, item: 3),
                CGRect(x: 396.25, y: 250.0, width: 82.5, height: 100.0),
                [CGPoint(x: 41.25, y: 50.0)]
            ), (
                MatchPath(layer: 3, item: 0),
                CGRect(x: 52.5, y: 150.0, width: 145.0, height: 100.0),
                [CGPoint(x: 72.5, y: 50.0)]
            ), (
                MatchPath(layer: 3, item: 1),
                CGRect(x: 302.5, y: 150.0, width: 145.0, height: 100.0),
                [CGPoint(x: 72.5, y: 50.0)]
            ), (
                MatchPath(layer: 4, item: 0),
                CGRect(x: 115.0, y: 50.0, width: 270.0, height: 100.0),
                [CGPoint(x: 135.0, y: 50.0)]
            )
        ],
        [
            (
                MatchPath(layer: 1, item: 0),
                CGRect(x: 31.25, y: 15.0, width: 62.5, height: 84.28571428571429),
                [CGPoint(x: 31.25, y: 42.142857142857146)]
            ), (
                MatchPath(layer: 1, item: 1),
                CGRect(x: 31.25, y: 143.57142857142858, width: 62.5, height: 84.2857142857143),
                [CGPoint(x: 31.25, y: 42.14285714285714)]
            ), (
                MatchPath(layer: 1, item: 2),
                CGRect(x: 31.25, y: 272.14285714285717, width: 62.5, height: 84.28571428571428),
                [CGPoint(x: 31.25, y: 42.14285714285717)]
            ), (
                MatchPath(layer: 1, item: 3),
                CGRect(x: 31.25, y: 400.7142857142858, width: 62.5, height: 84.28571428571428),
                [CGPoint(x: 31.25, y: 42.14285714285711)]
            ), (
                MatchPath(layer: 2, item: 0),
                CGRect(x: 93.75, y: 47.142857142857146, width: 62.5, height: 148.57142857142858),
                [CGPoint(x: 31.25, y: 74.2857142857143)]
            ), (
                MatchPath(layer: 2, item: 1),
                CGRect(x: 93.75, y: 304.28571428571433, width: 62.5, height: 148.57142857142856),
                [CGPoint(x: 31.25, y: 74.28571428571428)]
            ), (
                MatchPath(layer: 1, item: 4),
                CGRect(x: 406.25, y: 15.0, width: 62.5, height: 84.28571428571429),
                [CGPoint(x: 31.25, y: 42.142857142857146)]
            ), (
                MatchPath(layer: 1, item: 5),
                CGRect(x: 406.25, y: 143.57142857142858, width: 62.5, height: 84.2857142857143),
                [CGPoint(x: 31.25, y: 42.14285714285714)]
            ), (
                MatchPath(layer: 1, item: 6),
                CGRect(x: 406.25, y: 272.14285714285717, width: 62.5, height: 84.28571428571428),
                [CGPoint(x: 31.25, y: 42.14285714285717)]
            ), (
                MatchPath(layer: 1, item: 7),
                CGRect(x: 406.25, y: 400.7142857142858, width: 62.5, height: 84.28571428571428),
                [CGPoint(x: 31.25, y: 42.14285714285711)]
            ), (
                MatchPath(layer: 2, item: 2),
                CGRect(x: 343.75, y: 47.142857142857146, width: 62.5, height: 148.57142857142858),
                [CGPoint(x: 31.25, y: 74.2857142857143)]
            ), (
                MatchPath(layer: 2, item: 3),
                CGRect(x: 343.75, y: 304.28571428571433, width: 62.5, height: 148.57142857142856),
                [CGPoint(x: 31.25, y: 74.28571428571428)]
            ), (
                MatchPath(layer: 3, item: 0),
                CGRect(x: 156.25, y: 111.42857142857144, width: 62.5, height: 277.14285714285717),
                [CGPoint(x: 31.25, y: 138.57142857142856)]
            ), (
                MatchPath(layer: 3, item: 1),
                CGRect(x: 281.25, y: 111.42857142857144, width: 62.5, height: 277.14285714285717),
                [CGPoint(x: 31.25, y: 138.57142857142856)]
            ), (
                MatchPath(layer: 4, item: 0),
                CGRect(x: 218.75, y: 230.0, width: 62.5, height: 40.0),
                [CGPoint(x: 31.25, y: 20.0)]
            )
        ],
        [
            (
                MatchPath(layer: 1, item: 0),
                CGRect(x: 15.0, y: 31.25, width: 84.28571428571429, height: 62.5),
                [CGPoint(x: 42.142857142857146, y: 31.25)]
            ), (
                MatchPath(layer: 1, item: 1),
                CGRect(x: 143.57142857142858, y: 31.25, width: 84.2857142857143, height: 62.5),
                [CGPoint(x: 42.14285714285714, y: 31.25)]
            ), (
                MatchPath(layer: 1, item: 2),
                CGRect(x: 272.14285714285717, y: 31.25, width: 84.28571428571428, height: 62.5),
                [CGPoint(x: 42.14285714285717, y: 31.25)]
            ), (
                MatchPath(layer: 1, item: 3),
                CGRect(x: 400.7142857142858, y: 31.25, width: 84.28571428571428, height: 62.5),
                [CGPoint(x: 42.14285714285711, y: 31.25)]
            ), (
                MatchPath(layer: 2, item: 0),
                CGRect(x: 47.142857142857146, y: 93.75, width: 148.57142857142858, height: 62.5),
                [CGPoint(x: 74.2857142857143, y: 31.25)]
            ), (
                MatchPath(layer: 2, item: 1),
                CGRect(x: 304.28571428571433, y: 93.75, width: 148.57142857142856, height: 62.5),
                [CGPoint(x: 74.28571428571428, y: 31.25)]
            ), (
                MatchPath(layer: 1, item: 4),
                CGRect(x: 15.0, y: 406.25, width: 84.28571428571429, height: 62.5),
                [CGPoint(x: 42.142857142857146, y: 31.25)]
            ), (
                MatchPath(layer: 1, item: 5),
                CGRect(x: 143.57142857142858, y: 406.25, width: 84.2857142857143, height: 62.5),
                [CGPoint(x: 42.14285714285714, y: 31.25)]
            ), (
                MatchPath(layer: 1, item: 6),
                CGRect(x: 272.14285714285717, y: 406.25, width: 84.28571428571428, height: 62.5),
                [CGPoint(x: 42.14285714285717, y: 31.25)]
            ), (
                MatchPath(layer: 1, item: 7),
                CGRect(x: 400.7142857142858, y: 406.25, width: 84.28571428571428, height: 62.5),
                [CGPoint(x: 42.14285714285711, y: 31.25)]
            ), (
                MatchPath(layer: 2, item: 2),
                CGRect(x: 47.142857142857146, y: 343.75, width: 148.57142857142858, height: 62.5),
                [CGPoint(x: 74.2857142857143, y: 31.25)]
            ), (
                MatchPath(layer: 2, item: 3),
                CGRect(x: 304.28571428571433, y: 343.75, width: 148.57142857142856, height: 62.5),
                [CGPoint(x: 74.28571428571428, y: 31.25)]
            ), (
                MatchPath(layer: 3, item: 0),
                CGRect(x: 111.42857142857144, y: 156.25, width: 277.14285714285717, height: 62.5),
                [CGPoint(x: 138.57142857142856, y: 31.25)]
            ), (
                MatchPath(layer: 3, item: 1),
                CGRect(x: 111.42857142857144, y: 281.25, width: 277.14285714285717, height: 62.5),
                [CGPoint(x: 138.57142857142856, y: 31.25)]
            ), (
                MatchPath(layer: 4, item: 0),
                CGRect(x: 230.0, y: 218.75, width: 40.0, height: 62.5),
                [CGPoint(x: 20.0, y: 31.25)]
            )
        ],
        [
            (
                MatchPath(layer: 1, item: 0),
                CGRect(x: 62.5, y: 15.0, width: 125.0, height: 170.0),
                [CGPoint(x: 62.5, y: 85.0)]
            ), (
                MatchPath(layer: 2, item: 0),
                CGRect(x: 187.5, y: 90.0, width: 125.0, height: 245.0),
                [CGPoint(x: 62.5, y: 122.5)]
            ), (
                MatchPath(layer: 3, item: 0),
                CGRect(x: 312.5, y: 202.5, width: 125.0, height: 282.5),
                [CGPoint(x: 62.5, y: 141.25)]
            )
        ],
        [
            (
                MatchPath(layer: 1, item: 0),
                CGRect(x: 41.666666666666664, y: 15.0, width: 83.33333333333333, height: 170.0),
                [CGPoint(x: 41.666666666666664, y: 85.0)]
            ), (
                MatchPath(layer: 1, item: 1),
                CGRect(x: 375.0, y: 127.5, width: 83.33333333333333, height: 132.5),
                [CGPoint(x: 41.666666666666686, y: 66.25)]
            ), (
                MatchPath(layer: 2, item: 0),
                CGRect(x: 125.0, y: 90.0, width: 55.55555555555555, height: 395.0),
                [CGPoint(x: 41.66666666666666, y: 75.625), CGPoint(x: 41.66666666666666, y: 244.375)]
            ), (
                MatchPath(layer: 2, item: 1),
                CGRect(x: 319.44444444444446, y: 15.0, width: 55.55555555555555, height: 357.5),
                [CGPoint(x: 13.888888888888914, y: 102.8125), CGPoint(x: 13.888888888888914, y: 254.6875)]
            ), (
                MatchPath(layer: 3, item: 0),
                CGRect(x: 180.55555555555554, y: 107.8125, width: 138.8888888888889, height: 377.1875),
                [CGPoint(x: 64.44444444444446, y: 142.1875), CGPoint(x: 74.44444444444446, y: 142.1875)]
            )
        ],
        [
            (
                MatchPath(layer: 1, item: 0),
                CGRect(x: 83.33333333333333, y: 5.625, width: 166.66666666666666, height: 113.75),
                [CGPoint(x: 83.33333333333333, y: 56.875)]
            ), (
                MatchPath(layer: 1, item: 1),
                CGRect(x: 83.33333333333333, y: 130.625, width: 166.66666666666666, height: 113.75),
                [CGPoint(x: 83.33333333333333, y: 56.875)]
            ), (
                MatchPath(layer: 1, item: 2),
                CGRect(x: 83.33333333333333, y: 255.625, width: 166.66666666666666, height: 113.75),
                [CGPoint(x: 83.33333333333333, y: 56.875)]
            ), (
                MatchPath(layer: 1, item: 3),
                CGRect(x: 83.33333333333333, y: 380.625, width: 166.66666666666666, height: 113.75),
                [CGPoint(x: 83.33333333333333, y: 56.875)]
            ), (
                MatchPath(layer: 2, item: 0),
                CGRect(x: 250.0, y: 52.5, width: 166.66666666666666, height: 395.0),
                [CGPoint(x: 83.33333333333331, y: 197.5)]
            )
        ],
        [
            (
                MatchPath(layer: 1, item: 0),
                CGRect(x: 62.5, y: 15.0, width: 83.33333333333333, height: 470.0),
                [CGPoint(x: 62.5, y: 167.5), CGPoint(x: 62.5, y: 302.5)]
            ), (
                MatchPath(layer: 1, item: 1),
                CGRect(x: 354.1666666666667, y: 15.0, width: 83.33333333333333, height: 470.0),
                [CGPoint(x: 20.833333333333314, y: 167.5), CGPoint(x: 20.833333333333314, y: 302.5)]
            ), (
                MatchPath(layer: 2, item: 0),
                CGRect(x: 145.83333333333331, y: 172.5, width: 208.33333333333337, height: 155.0),
                [CGPoint(x: 104.16666666666669, y: 77.5)]
            )
        ],
        [
            (
                MatchPath(layer: 1, item: 0),
                CGRect(x: 41.666666666666664, y: 15.0, width: 83.33333333333333, height: 170.0),
                [CGPoint(x: 41.666666666666664, y: 85.0)]
            ), (
                MatchPath(layer: 1, item: 1),
                CGRect(x: 41.666666666666664, y: 315.0, width: 83.33333333333333, height: 170.0),
                [CGPoint(x: 41.666666666666664, y: 85.0)]
            ), (
                MatchPath(layer: 1, item: 2),
                CGRect(x: 375.0, y: 15.0, width: 83.33333333333333, height: 170.0),
                [CGPoint(x: 41.666666666666686, y: 85.0)]
            ), (
                MatchPath(layer: 1, item: 3),
                CGRect(x: 375.0, y: 315.0, width: 83.33333333333333, height: 170.0),
                [CGPoint(x: 41.666666666666686, y: 85.0)]
            ), (
                MatchPath(layer: 2, item: 0),
                CGRect(x: 125.0, y: 90.0, width: 83.33333333333333, height: 320.0),
                [CGPoint(x: 41.66666666666666, y: 160.0)]
            ), (
                MatchPath(layer: 2, item: 1),
                CGRect(x: 291.6666666666667, y: 90.0, width: 83.33333333333333, height: 320.0),
                [CGPoint(x: 41.666666666666686, y: 160.0)]
            ), (
                MatchPath(layer: 3, item: 0),
                CGRect(x: 208.33333333333334, y: 230.0, width: 83.33333333333334, height: 40.0),
                [CGPoint(x: 41.66666666666666, y: 20.0)]
            )
        ],
        [
            (
                MatchPath(layer: 1, item: 0),
                CGRect(x: 41.666666666666664, y: 15.0, width: 83.33333333333333, height: 245.0),
                [CGPoint(x: 41.666666666666664, y: 122.5)]
            ), (
                MatchPath(layer: 1, item: 1),
                CGRect(x: 375.0, y: 15.0, width: 83.33333333333333, height: 170.0),
                [CGPoint(x: 41.666666666666686, y: 85.0)]
            ), (
                MatchPath(layer: 1, item: 2),
                CGRect(x: 375.0, y: 315.0, width: 83.33333333333333, height: 170.0),
                [CGPoint(x: 41.666666666666686, y: 85.0)]
            ), (
                MatchPath(layer: 2, item: 0),
                CGRect(x: 125.0, y: 127.5, width: 83.33333333333333, height: 357.5),
                [CGPoint(x: 41.66666666666666, y: 122.5)]
            ), (
                MatchPath(layer: 2, item: 1),
                CGRect(x: 291.6666666666667, y: 90.0, width: 83.33333333333333, height: 320.0),
                [CGPoint(x: 41.666666666666686, y: 160.0)]
            ), (
                MatchPath(layer: 3, item: 0),
                CGRect(x: 208.33333333333334, y: 230.0, width: 83.33333333333334, height: 40.0),
                [CGPoint(x: 41.66666666666666, y: 20.0)]
            )
        ],
        [
            (
                MatchPath(layer: 1, item: 0),
                CGRect(x: 20.833333333333332, y: 15.0, width: 41.666666666666664, height: 110.0),
                [CGPoint(x: 20.833333333333332, y: 55.0)]
            ), (
                MatchPath(layer: 2, item: 0),
                CGRect(x: 62.5, y: 60.0, width: 41.666666666666664, height: 155.0),
                [CGPoint(x: 20.83333333333333, y: 77.5)]
            ), (
                MatchPath(layer: 3, item: 0),
                CGRect(x: 104.16666666666667, y: 127.5, width: 41.666666666666664, height: 177.5),
                [CGPoint(x: 20.83333333333333, y: 88.75)]
            ), (
                MatchPath(layer: 4, item: 0),
                CGRect(x: 145.83333333333331, y: 206.25, width: 41.666666666666664, height: 188.75),
                [CGPoint(x: 20.833333333333343, y: 94.375)]
            ), (
                MatchPath(layer: 1, item: 1),
                CGRect(x: 437.5, y: 390.0, width: 41.666666666666664, height: 95.0),
                [CGPoint(x: 20.833333333333314, y: 47.5)]
            ), (
                MatchPath(layer: 2, item: 1),
                CGRect(x: 395.83333333333337, y: 315.0, width: 41.666666666666664, height: 132.5),
                [CGPoint(x: 20.833333333333314, y: 66.25)]
            ), (
                MatchPath(layer: 3, item: 1),
                CGRect(x: 354.1666666666667, y: 240.0, width: 41.666666666666664, height: 151.25),
                [CGPoint(x: 20.833333333333314, y: 75.625)]
            ), (
                MatchPath(layer: 4, item: 1),
                CGRect(x: 312.50000000000006, y: 165.0, width: 41.666666666666664, height: 160.625),
                [CGPoint(x: 20.833333333333314, y: 80.3125)]
            ), (
                MatchPath(layer: 5, item: 0),
                CGRect(x: 187.49999999999997, y: 290.625, width: 41.666666666666664, height: 194.375),
                [CGPoint(x: 20.833333333333343, y: 97.1875)]
            ), (
                MatchPath(layer: 5, item: 1),
                CGRect(x: 284.72222222222223, y: 15.0, width: 27.777777777777775, height: 240.3125),
                [CGPoint(x: 6.944444444444457, y: 70.5859375), CGPoint(x: 6.944444444444457, y: 169.7265625)]
            ), (
                MatchPath(layer: 6, item: 0),
                CGRect(x: 229.16666666666666, y: 75.5859375, width: 55.55555555555557, height: 322.2265625),
                [CGPoint(x: 16.666666666666686, y: 185.8984375), CGPoint(x: 25.00000000000003, y: 185.8984375)]
            )
        ],
        [
            (
                MatchPath(layer: 1, item: 0),
                CGRect(x: 62.5, y: 240.0, width: 125.0, height: 245.0),
                [CGPoint(x: 62.5, y: 122.5)]
            ), (
                MatchPath(layer: 3, item: 0),
                CGRect(x: 312.5, y: 15.0, width: 125.0, height: 357.5),
                [CGPoint(x: 62.5, y: 178.75)]
            )
        ]
    ]
}

// MARK: - KRTournamentViewStyle extension ------------

private extension KRTournamentViewStyle {
    var drawHalf: DrawHalf {
        switch self {
        case .left, .top, .leftRight, .topBottom: return .first
        case .right, .bottom: return .second
        }
    }
}

// MARK: - PathSet extensions ------------

extension PathSet: Equatable {
    public static func == (lhs: PathSet, rhs: PathSet) -> Bool {
        return (lhs.path == rhs.path) && (lhs.winnerPath == rhs.winnerPath)
    }
}

// MARK: - Equatable ------------

func == (lhs: [(MatchPath, CGRect, [CGPoint])], rhs: [(MatchPath, CGRect, [CGPoint])]) -> Bool {
    for i in 0..<lhs.count {
        let left = lhs[i]
        let right = rhs[i]

        if (left.0 == right.0) && (left.1 == right.1) && (left.2 == right.2) { continue }
        return false
    }

    return true
}

// MARK: - Extensions for description ------------

extension MatchPath: CustomStringConvertible {
    public var description: String {
        return "MatchPath(layer: \(layer), item: \(item))"
    }
}

extension CGRect: CustomStringConvertible {
    public var description: String {
        return "CGRect(x: \(origin.x), y: \(origin.y), width: \(width), height: \(height))"
    }
}

extension CGPoint: CustomStringConvertible {
    public var description: String {
        return "CGPoint(x: \(x), y: \(y))"
    }
}

extension Array where Element == (MatchPath, CGRect, [CGPoint]) {
    public var description: String {
        let descriptions = map { matchPath, rect, points in
            return """
            (
            \(String(describing: matchPath)),
            \(String(describing: rect)),
            [\(points.map(String.init(describing:)).joined(separator: ", "))]
            )
            """
        }
        return """
        [
        \(descriptions.joined(separator: ", "))
        ]
        """
    }
}
