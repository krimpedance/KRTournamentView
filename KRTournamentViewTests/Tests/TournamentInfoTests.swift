//
//  TournamentInfoTests.swift
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

class TournamentInfoTests: QuickSpec {
    typealias InitializerDataset = (
        numberOfLayer: Int,
        style: KRTournamentViewStyle,
        drawHalf: DrawHalf,
        rect: CGRect,
        firstEntryNum: Int,
        secondEntryNum: Int,
        entrySize: CGSize,
        expectedInfo: TournamentInfo
    )

    typealias EntryPointDataset = (
        style: KRTournamentViewStyle,
        drawHalf: DrawHalf,
        rectSize: CGSize,
        firstEntryNum: Int,
        secondEntryNum: Int,
        stepSize: CGSize,
        drawMargin: CGFloat,
        expectedPoints: [CGPoint?]
    )

    override func spec() {
        it("can initialize") {
            let info = TournamentInfo(
                numberOfLayer: 2,
                style: .left,
                drawHalf: .first,
                rect: .init(x: 0, y: 0, width: 360, height: 360),
                firstEntryNum: 4,
                secondEntryNum: 0,
                entrySize: .init(width: 80, height: 100),
                stepSize: .init(width: 80, height: 40),
                drawMargin: 50
            )

            expect(info.numberOfLayer).to(equal(2))
            expect(info.style).to(equal(.left))
            expect(info.drawHalf).to(equal(.first))
            expect(info.rect).to(equal(.init(x: 0, y: 0, width: 360, height: 360)))
            expect(info.firstEntryNum).to(equal(4))
            expect(info.secondEntryNum).to(equal(0))
            expect(info.entrySize).to(equal(.init(width: 80, height: 100)))
            expect(info.stepSize).to(equal(.init(width: 80, height: 40)))
            expect(info.drawMargin).to(equal(50))
        }

        it("can initialize with Bracket") {
            let info = TournamentInfo(
                structure: TournamentBuilder.build(numberOfLayers: 3),
                style: .topBottom,
                drawHalf: .first,
                rect: .init(x: 0, y: 0, width: 500, height: 500),
                entrySize: .init(width: 30, height: 50)
            )

            let expectedInfo = TournamentInfo(
                numberOfLayer: 3,
                style: .topBottom,
                drawHalf: .first,
                rect: .init(x: 0, y: 0, width: 500, height: 500),
                firstEntryNum: 4,
                secondEntryNum: 4,
                entrySize: .init(width: 30, height: 50)
            )

            expect(info == expectedInfo).to(beTrue())
        }

        let listForInitializer: [InitializerDataset] = [
            // entrySize is in range
            (
                numberOfLayer: 2,
                style: .right,
                drawHalf: .second,
                rect: .init(x: 0, y: 0, width: 360, height: 330),
                firstEntryNum: 0,
                secondEntryNum: 4,
                entrySize: .init(width: 80, height: 30),
                expectedInfo: TournamentInfo(
                    numberOfLayer: 2,
                    style: .right,
                    drawHalf: .second,
                    rect: .init(x: 0, y: 0, width: 360, height: 330),
                    firstEntryNum: 0,
                    secondEntryNum: 4,
                    entrySize: .init(width: 80, height: 30),
                    stepSize: .init(width: 120, height: 100),
                    drawMargin: 15
                )
            ),
            (
                numberOfLayer: 2,
                style: .top,
                drawHalf: .first,
                rect: .init(x: 0, y: 0, width: 330, height: 360),
                firstEntryNum: 4,
                secondEntryNum: 0,
                entrySize: .init(width: 30, height: 80),
                expectedInfo: TournamentInfo(
                    numberOfLayer: 2,
                    style: .top,
                    drawHalf: .first,
                    rect: .init(x: 0, y: 0, width: 330, height: 360),
                    firstEntryNum: 4,
                    secondEntryNum: 0,
                    entrySize: .init(width: 30, height: 80),
                    stepSize: .init(width: 100, height: 120),
                    drawMargin: 15
                )
            ),
            // entrySize is out range
            (
                numberOfLayer: 2,
                style: .left,
                drawHalf: .first,
                rect: .init(x: 0, y: 0, width: 360, height: 360),
                firstEntryNum: 4,
                secondEntryNum: 0,
                entrySize: .init(width: 80, height: 100),
                expectedInfo: TournamentInfo(
                    numberOfLayer: 2,
                    style: .left,
                    drawHalf: .first,
                    rect: .init(x: 0, y: 0, width: 360, height: 360),
                    firstEntryNum: 4,
                    secondEntryNum: 0,
                    entrySize: .init(width: 80, height: 90),
                    stepSize: .init(width: 120, height: 90),
                    drawMargin: 45
                )
            ),
            (
                numberOfLayer: 2,
                style: .bottom,
                drawHalf: .second,
                rect: .init(x: 0, y: 0, width: 360, height: 360),
                firstEntryNum: 0,
                secondEntryNum: 4,
                entrySize: .init(width: 100, height: 80),
                expectedInfo: TournamentInfo(
                    numberOfLayer: 2,
                    style: .bottom,
                    drawHalf: .second,
                    rect: .init(x: 0, y: 0, width: 360, height: 360),
                    firstEntryNum: 0,
                    secondEntryNum: 4,
                    entrySize: .init(width: 90, height: 80),
                    stepSize: .init(width: 90, height: 120),
                    drawMargin: 45
                )
            ),
            (
                numberOfLayer: 3,
                style: .leftRight,
                drawHalf: .first,
                rect: .init(x: 0, y: 0, width: 360, height: 360),
                firstEntryNum: 4,
                secondEntryNum: 3,
                entrySize: .init(width: 60, height: 100),
                expectedInfo: TournamentInfo(
                    numberOfLayer: 3,
                    style: .leftRight,
                    drawHalf: .first,
                    rect: .init(x: 0, y: 0, width: 360, height: 360),
                    firstEntryNum: 4,
                    secondEntryNum: 3,
                    entrySize: .init(width: 60, height: 90),
                    stepSize: .init(width: 60, height: 90),
                    drawMargin: 45
                )
            ),
            (
                numberOfLayer: 3,
                style: .topBottom,
                drawHalf: .second,
                rect: .init(x: 0, y: 0, width: 360, height: 360),
                firstEntryNum: 5,
                secondEntryNum: 4,
                entrySize: .init(width: 100, height: 60),
                expectedInfo: TournamentInfo(
                    numberOfLayer: 3,
                    style: .topBottom,
                    drawHalf: .second,
                    rect: .init(x: 0, y: 0, width: 360, height: 360),
                    firstEntryNum: 5,
                    secondEntryNum: 4,
                    entrySize: .init(width: 90, height: 60),
                    stepSize: .init(width: 90, height: 60),
                    drawMargin: 45
                )
            )
        ]

        listForInitializer.forEach { dataset in
            context("\(dataset)") {
                it("can initialize after validate") {
                    let info = TournamentInfo(
                        numberOfLayer: dataset.numberOfLayer,
                        style: dataset.style,
                        drawHalf: dataset.drawHalf,
                        rect: dataset.rect,
                        firstEntryNum: dataset.firstEntryNum,
                        secondEntryNum: dataset.secondEntryNum,
                        entrySize: dataset.entrySize
                    )

                    expect(info == dataset.expectedInfo).to(beTrue())
                }
            }
        }

        let listForEntryPoint: [EntryPointDataset] = [
            (
                .left, .first, .init(width: 100, height: 200), 2, 3, .init(width: 10, height: 20), 10,
                [.init(x: 0, y: 10), .init(x: 0, y: 30)]
            ),
            (
                .right, .second, .init(width: 100, height: 200), 3, 2, .init(width: 10, height: 20), 10,
                [.init(x: 100, y: 10), .init(x: 100, y: 30)]
            ),
            (
                .top, .first, .init(width: 100, height: 200), 2, 3, .init(width: 10, height: 20), 10,
                [.init(x: 10, y: 0), .init(x: 20, y: 0)]
            ),
            (
                .bottom, .second, .init(width: 100, height: 200), 3, 2, .init(width: 10, height: 20), 10,
                [.init(x: 10, y: 200), .init(x: 20, y: 200)]
            ),
            (
                .leftRight, .first, .init(width: 100, height: 200), 2, 3, .init(width: 10, height: 20), 10,
                [.init(x: 0, y: 10), .init(x: 0, y: 30)]
            ),
            (
                .leftRight, .second, .init(width: 100, height: 200), 2, 3, .init(width: 10, height: 20), 10,
                [nil, nil, .init(x: 100, y: 10), .init(x: 100, y: 30), .init(x: 100, y: 50)]
            ),
            (
                .topBottom, .first, .init(width: 100, height: 200), 2, 3, .init(width: 10, height: 20), 10,
                [.init(x: 10, y: 0), .init(x: 20, y: 0)]
            ),
            (
                .topBottom, .second, .init(width: 100, height: 200), 2, 3, .init(width: 10, height: 20), 10,
                [nil, nil, .init(x: 10, y: 200), .init(x: 20, y: 200), .init(x: 30, y: 200)]
            )
        ]

        listForEntryPoint.forEach { dataset in
            context("\(dataset)") {
                it("returns entryPoint at index") {
                    let info = TournamentInfo(
                        style: dataset.style,
                        drawHalf: dataset.drawHalf,
                        rectSize: dataset.rectSize,
                        firstEntryNum: dataset.firstEntryNum,
                        secondEntryNum: dataset.secondEntryNum,
                        stepSize: dataset.stepSize,
                        drawMargin: dataset.drawMargin
                    )

                    dataset.expectedPoints.enumerated().forEach { index, point in
                        guard let point = point else { return }
                        expect(info.entryPoint(at: index)).to(equal(point))
                    }
                }
            }
        }

        it("returns TournamentInfo converted drawHalf") {
            let info = TournamentInfo(
                numberOfLayer: 3,
                style: .topBottom,
                drawHalf: .first,
                rect: .init(x: 0, y: 0, width: 500, height: 500),
                firstEntryNum: 4,
                secondEntryNum: 4,
                entrySize: .init(width: 30, height: 50)
            )

            let convertedIno = info.convert(drawHalf: .second)

            let expectedInfo = TournamentInfo(
                numberOfLayer: 3,
                style: .topBottom,
                drawHalf: .second,
                rect: .init(x: 0, y: 0, width: 500, height: 500),
                firstEntryNum: 4,
                secondEntryNum: 4,
                entrySize: .init(width: 30, height: 50)
            )

            expect(convertedIno == expectedInfo).to(beTrue())
        }
    }
}

// MARK: - TournamentInfo extensions ------------

private extension TournamentInfo {
    init(
        style: KRTournamentViewStyle,
        drawHalf: DrawHalf,
        rectSize: CGSize,
        firstEntryNum: Int,
        secondEntryNum: Int,
        stepSize: CGSize,
        drawMargin: CGFloat
    ) {
        self.init(
            numberOfLayer: 0,
            style: style,
            drawHalf: drawHalf,
            rect: .init(origin: .zero, size: rectSize),
            firstEntryNum: firstEntryNum,
            secondEntryNum: secondEntryNum,
            entrySize: .zero,
            stepSize: stepSize,
            drawMargin: drawMargin
        )
    }

    static func == (lhs: TournamentInfo, rhs: TournamentInfo) -> Bool {
        return lhs.numberOfLayer == rhs.numberOfLayer
            && lhs.style == rhs.style
            && lhs.drawHalf == rhs.drawHalf
            && lhs.rect == rhs.rect
            && lhs.firstEntryNum == rhs.firstEntryNum
            && lhs.secondEntryNum == rhs.secondEntryNum
            && lhs.entrySize == rhs.entrySize
            && lhs.stepSize == rhs.stepSize
            && lhs.drawMargin == rhs.drawMargin
    }
}
