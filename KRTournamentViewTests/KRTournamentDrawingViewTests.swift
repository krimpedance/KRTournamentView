//
//  KRTournamentDrawingViewTests.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class KRTournamentDrawingViewTests: QuickSpec {

    let dataStore = KRTournamentViewDataStoreMock(
        numberOfLayers: 3,
        entrySize: CGSize(width: 60, height: 50),
        excludes: [0, 2, 7]
    )

    let matches = [KRTournamentViewMatch](
        [(2, .home), (4, .home), (5, .away), (6, .away)].map {
            KRTournamentViewMatch(matchPath: MatchPath(numberOfLayers: 3, index: $0.0)!, preferredSide: $0.1)
        }
    )

    let drawingView: KRTournamentDrawingView = {
        let view = KRTournamentDrawingView()
        view.lineWidth = 2
        view.preferredLineWidth = 3
        view.frame.size = CGSize(width: 500, height: 500)
        return view
    }()

    override func spec() {
        describe("KRTournamentDrawingView") {
            beforeEach {
                self.drawingView.dataStore = self.dataStore
                self.drawingView.matches = self.matches
            }

            describe("Properties", closure: propertiesSpec)
            describe("Draw path", closure: drawPathSpec)
            describe("Layout matches", closure: layoutMatchesSpec)
        }
    }

    func propertiesSpec() {
        it("backgroundColor is .clear") {
            expect(self.drawingView.backgroundColor).to(equal(.clear))
        }

        it("translatesAutoresizingMaskIntoConstraints is false") {
            expect(self.drawingView.translatesAutoresizingMaskIntoConstraints).to(beFalse())
        }

        context("when style is .left") {
            beforeEach { self.dataStore.style = .left }
            it("drawMargin returns 25") {
                expect(self.drawingView.drawMargin).to(equal(25))
            }
        }

        context("when style is .top") {
            beforeEach { self.dataStore.style = .top }
            it("drawMargin returns 30") {
                expect(self.drawingView.drawMargin).to(equal(30))
            }
        }
    }

    func drawPathSpec() {
        let styles = [KRTournamentViewStyle]([
            .left, .right, .top, .bottom,
            .leftRight(direction: .top), .leftRight(direction: .bottom),
            .topBottom(direction: .right), .topBottom(direction: .left)
        ])

        styles.forEach { style in
            context("style is \(style)") {
                beforeEach {
                    self.dataStore.style = style
                    self.drawingView.draw(CGRect(x: 0, y: 0, width: 500, height: 500))
                }

                it("drawPath is set") {
                    expect(self.drawingView.drawingPath).to(equal(style.drawingPath))
                }

                it("preferredDrawPath is set") {
                    expect(self.drawingView.preferredDrawingPath).to(equal(style.preferredDrawingPath))
                }
            }
        }
    }

    func layoutMatchesSpec() {
        beforeEach {
            self.drawingView.draw(CGRect(x: 0, y: 0, width: 500, height: 500))
        }

        it("is added to the view") {
            self.matches.forEach { expect($0.superview).to(be(self.drawingView)) }
        }

        it("is removed from superview when it changes to new matches") {
            self.drawingView.matches = [(2, .home), (4, .home), (5, .away), (6, .away)].map {
                KRTournamentViewMatch(matchPath: MatchPath(numberOfLayers: 3, index: $0.0)!, preferredSide: $0.1)
            }
            self.matches.forEach { expect($0.superview).to(beNil()) }
        }

        let styles = [KRTournamentViewStyle]([.left, .right, .top, .bottom, .leftRight(direction: .top), .topBottom(direction: .right)])

        styles.forEach { style in
            context("style is \(style)") {
                beforeEach {
                    self.dataStore.style = style
                    self.drawingView.draw(CGRect(x: 0, y: 0, width: 500, height: 500))
                }

                it("frame is set automatically") {
                    self.matches.enumerated().forEach { index, match in
                        expect(match.frame).to(equal(style.matchFrames[index]))
                    }
                }
            }
        }
    }
}

// MARK: - KRTournamentStyle extension for drawing path -------------------

private extension KRTournamentViewStyle {
    var drawingPath: UIBezierPath {
        switch self {
        case .left: return leftStylePath
        case .right: return rightStylePath
        case .top: return topStylePath
        case .bottom: return bottomStylePath
        case let .leftRight(direction) where direction == .bottom:
            return leftRightBottomStylePath
        case .leftRight: return leftRightTopStylePath
        case let .topBottom(direction) where direction == .left:
            return topBottomLeftStylePath
        case .topBottom: return topBottomRightStylePath
        }
    }

    var preferredDrawingPath: UIBezierPath {
        switch self {
        case .left: return leftStylePreferredPath
        case .right: return rightStylePreferredPath
        case .top: return topStylePreferredPath
        case .bottom: return bottomStylePreferredPath
        case let .leftRight(direction) where direction == .bottom:
            return leftRightBottomStylePreferredPath
        case .leftRight: return leftRightTopStylePreferredPath
        case let .topBottom(direction) where direction == .left:
            return topBottomLeftStylePreferredPath
        case .topBottom: return topBottomRightStylePreferredPath
        }
    }

    var leftStylePath: UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 2
        path.lineCapStyle = .square

        path.move(to: CGPoint(x: 0, y: 137.5))
        path.addLine(to: CGPoint(x: 125, y: 137.5))

        path.move(to: CGPoint(x: 125, y: 137.5))
        path.addLine(to: CGPoint(x: 250, y: 137.5))
        path.move(to: CGPoint(x: 250, y: 137.5))
        path.addLine(to: CGPoint(x: 250, y: 81.25))

        path.move(to: CGPoint(x: 0, y: 362.5))
        path.addLine(to: CGPoint(x: 125, y: 362.5))
        path.move(to: CGPoint(x: 125, y: 362.5))
        path.addLine(to: CGPoint(x: 125, y: 306.25))

        path.move(to: CGPoint(x: 250, y: 306.25))
        path.addLine(to: CGPoint(x: 250, y: 390.625))

        path.move(to: CGPoint(x: 375, y: 81.25))
        path.addLine(to: CGPoint(x: 375, y: 235.9375))

        return path
    }

    var rightStylePath: UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 2
        path.lineCapStyle = .square

        path.move(to: CGPoint(x: 500, y: 137.5))
        path.addLine(to: CGPoint(x: 375, y: 137.5))

        path.move(to: CGPoint(x: 375, y: 137.5))
        path.addLine(to: CGPoint(x: 250, y: 137.5))
        path.move(to: CGPoint(x: 250, y: 137.5))
        path.addLine(to: CGPoint(x: 250, y: 81.25))

        path.move(to: CGPoint(x: 500, y: 362.5))
        path.addLine(to: CGPoint(x: 375, y: 362.5))
        path.move(to: CGPoint(x: 375, y: 362.5))
        path.addLine(to: CGPoint(x: 375, y: 306.25))

        path.move(to: CGPoint(x: 250, y: 306.25))
        path.addLine(to: CGPoint(x: 250, y: 390.625))

        path.move(to: CGPoint(x: 125, y: 81.25))
        path.addLine(to: CGPoint(x: 125, y: 235.9375))

        return path
    }

    var topStylePath: UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 2
        path.lineCapStyle = .square

        path.move(to: CGPoint(x: 140, y: 0))
        path.addLine(to: CGPoint(x: 140, y: 125))

        path.move(to: CGPoint(x: 140, y: 125))
        path.addLine(to: CGPoint(x: 140, y: 250))
        path.move(to: CGPoint(x: 140, y: 250))
        path.addLine(to: CGPoint(x: 85, y: 250))

        path.move(to: CGPoint(x: 360, y: 0))
        path.addLine(to: CGPoint(x: 360, y: 125))
        path.move(to: CGPoint(x: 360, y: 125))
        path.addLine(to: CGPoint(x: 305, y: 125))

        path.move(to: CGPoint(x: 305, y: 250))
        path.addLine(to: CGPoint(x: 387.5, y: 250))

        path.move(to: CGPoint(x: 85, y: 375))
        path.addLine(to: CGPoint(x: 236.25, y: 375))

        return path
    }

    var bottomStylePath: UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 2
        path.lineCapStyle = .square

        path.move(to: CGPoint(x: 140, y: 500))
        path.addLine(to: CGPoint(x: 140, y: 375))

        path.move(to: CGPoint(x: 140, y: 375))
        path.addLine(to: CGPoint(x: 140, y: 250))
        path.move(to: CGPoint(x: 140, y: 250))
        path.addLine(to: CGPoint(x: 85, y: 250))

        path.move(to: CGPoint(x: 360, y: 500))
        path.addLine(to: CGPoint(x: 360, y: 375))
        path.move(to: CGPoint(x: 360, y: 375))
        path.addLine(to: CGPoint(x: 305, y: 375))

        path.move(to: CGPoint(x: 305, y: 250))
        path.addLine(to: CGPoint(x: 387.5, y: 250))

        path.move(to: CGPoint(x: 85, y: 125))
        path.addLine(to: CGPoint(x: 236.25, y: 125))

        return path
    }

    var leftRightTopStylePath: UIBezierPath {
        let stepWidth: CGFloat = 500 / 6
        let path = UIBezierPath()
        path.lineWidth = 2
        path.lineCapStyle = .square

        path.move(to: CGPoint(x: 0, y: 475))
        path.addLine(to: CGPoint(x: stepWidth, y: 475))

        path.move(to: CGPoint(x: stepWidth, y: 475))
        path.addLine(to: CGPoint(x: stepWidth*2, y: 475))

        path.move(to: CGPoint(x: 500, y: 250))
        path.addLine(to: CGPoint(x: 500 - stepWidth, y: 250))
        path.move(to: CGPoint(x: 500 - stepWidth, y: 250))
        path.addLine(to: CGPoint(x: 500 - stepWidth, y: 137.5))

        path.move(to: CGPoint(x: stepWidth*2, y: 475))
        path.addLine(to: CGPoint(x: stepWidth*2, y: 278.125))
        path.move(to: CGPoint(x: stepWidth*2, y: 278.125))
        path.addLine(to: CGPoint(x: stepWidth*3, y: 278.125))

        path.move(to: CGPoint(x: 500 - stepWidth*2, y: 137.5))
        path.addLine(to: CGPoint(x: 500 - stepWidth*2, y: 278.125))

        return path
    }

    var leftRightBottomStylePath: UIBezierPath {
        let stepWidth: CGFloat = 500 / 6
        let path = UIBezierPath()
        path.lineWidth = 2
        path.lineCapStyle = .square

        path.move(to: CGPoint(x: 0, y: 475))
        path.addLine(to: CGPoint(x: stepWidth, y: 475))

        path.move(to: CGPoint(x: stepWidth, y: 475))
        path.addLine(to: CGPoint(x: stepWidth*2, y: 475))

        path.move(to: CGPoint(x: 500, y: 250))
        path.addLine(to: CGPoint(x: 500 - stepWidth, y: 250))
        path.move(to: CGPoint(x: 500 - stepWidth, y: 250))
        path.addLine(to: CGPoint(x: 500 - stepWidth, y: 137.5))

        path.move(to: CGPoint(x: stepWidth*2, y: 475))
        path.addLine(to: CGPoint(x: stepWidth*2, y: 278.125))
        path.move(to: CGPoint(x: stepWidth*2, y: 278.125))
        path.addLine(to: CGPoint(x: stepWidth*3, y: 278.125))

        path.move(to: CGPoint(x: 500 - stepWidth*2, y: 137.5))
        path.addLine(to: CGPoint(x: 500 - stepWidth*2, y: 278.125))

        return path
    }

    var topBottomRightStylePath: UIBezierPath {
        let stepHeight: CGFloat = 500 / 6
        let path = UIBezierPath()
        path.lineWidth = 2
        path.lineCapStyle = .square

        path.move(to: CGPoint(x: 470, y: 0))
        path.addLine(to: CGPoint(x: 470, y: stepHeight))

        path.move(to: CGPoint(x: 470, y: stepHeight))
        path.addLine(to: CGPoint(x: 470, y: stepHeight*2))

        path.move(to: CGPoint(x: 250, y: 500))
        path.addLine(to: CGPoint(x: 250, y: 500 - stepHeight))
        path.move(to: CGPoint(x: 250, y: 500 - stepHeight))
        path.addLine(to: CGPoint(x: 140, y: 500 - stepHeight))

        path.move(to: CGPoint(x: 470, y: stepHeight*2))
        path.addLine(to: CGPoint(x: 277.5, y: stepHeight*2))
        path.move(to: CGPoint(x: 277.5, y: stepHeight*2))
        path.addLine(to: CGPoint(x: 277.5, y: stepHeight*3))

        path.move(to: CGPoint(x: 140, y: 500 - stepHeight*2))
        path.addLine(to: CGPoint(x: 277.5, y: 500 - stepHeight*2))

        return path
    }

    var topBottomLeftStylePath: UIBezierPath {
        let stepHeight: CGFloat = 500 / 6
        let path = UIBezierPath()
        path.lineWidth = 2
        path.lineCapStyle = .square

        path.move(to: CGPoint(x: 470, y: 0))
        path.addLine(to: CGPoint(x: 470, y: stepHeight))

        path.move(to: CGPoint(x: 470, y: stepHeight))
        path.addLine(to: CGPoint(x: 470, y: stepHeight*2))

        path.move(to: CGPoint(x: 250, y: 500))
        path.addLine(to: CGPoint(x: 250, y: 500 - stepHeight))
        path.move(to: CGPoint(x: 250, y: 500 - stepHeight))
        path.addLine(to: CGPoint(x: 140, y: 500 - stepHeight))

        path.move(to: CGPoint(x: 470, y: stepHeight*2))
        path.addLine(to: CGPoint(x: 277.5, y: stepHeight*2))
        path.move(to: CGPoint(x: 277.5, y: stepHeight*2))
        path.addLine(to: CGPoint(x: 277.5, y: stepHeight*3))

        path.move(to: CGPoint(x: 140, y: 500 - stepHeight*2))
        path.addLine(to: CGPoint(x: 277.5, y: 500 - stepHeight*2))

        return path
    }

    // MARK: Preferred Path ----------------

    var leftStylePreferredPath: UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 3
        path.lineCapStyle = .square

        path.move(to: CGPoint(x: 0, y: 25))
        path.addLine(to: CGPoint(x: 125, y: 25))

        path.move(to: CGPoint(x: 125, y: 25))
        path.addLine(to: CGPoint(x: 250, y: 25))
        path.move(to: CGPoint(x: 250, y: 25))
        path.addLine(to: CGPoint(x: 250, y: 81.25))

        path.move(to: CGPoint(x: 0, y: 250))
        path.addLine(to: CGPoint(x: 125, y: 250))
        path.move(to: CGPoint(x: 125, y: 250))
        path.addLine(to: CGPoint(x: 125, y: 306.25))

        path.move(to: CGPoint(x: 0, y: 475))
        path.addLine(to: CGPoint(x: 125, y: 475))

        path.move(to: CGPoint(x: 125, y: 306.25))
        path.addLine(to: CGPoint(x: 250, y: 306.25))

        path.move(to: CGPoint(x: 125, y: 475))
        path.addLine(to: CGPoint(x: 250, y: 475))
        path.move(to: CGPoint(x: 250, y: 475))
        path.addLine(to: CGPoint(x: 250, y: 390.625))

        path.move(to: CGPoint(x: 250, y: 81.25))
        path.addLine(to: CGPoint(x: 375, y: 81.25))

        path.move(to: CGPoint(x: 250, y: 390.625))
        path.addLine(to: CGPoint(x: 375, y: 390.625))
        path.move(to: CGPoint(x: 375, y: 390.625))
        path.addLine(to: CGPoint(x: 375, y: 235.9375))

        path.move(to: CGPoint(x: 375, y: 235.9375))
        path.addLine(to: CGPoint(x: 500, y: 235.9375))

        return path
    }

    var rightStylePreferredPath: UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 3
        path.lineCapStyle = .square

        path.move(to: CGPoint(x: 500, y: 25))
        path.addLine(to: CGPoint(x: 375, y: 25))

        path.move(to: CGPoint(x: 375, y: 25))
        path.addLine(to: CGPoint(x: 250, y: 25))
        path.move(to: CGPoint(x: 250, y: 25))
        path.addLine(to: CGPoint(x: 250, y: 81.25))

        path.move(to: CGPoint(x: 500, y: 250))
        path.addLine(to: CGPoint(x: 375, y: 250))
        path.move(to: CGPoint(x: 375, y: 250))
        path.addLine(to: CGPoint(x: 375, y: 306.25))

        path.move(to: CGPoint(x: 500, y: 475))
        path.addLine(to: CGPoint(x: 375, y: 475))

        path.move(to: CGPoint(x: 375, y: 306.25))
        path.addLine(to: CGPoint(x: 250, y: 306.25))

        path.move(to: CGPoint(x: 375, y: 475))
        path.addLine(to: CGPoint(x: 250, y: 475))
        path.move(to: CGPoint(x: 250, y: 475))
        path.addLine(to: CGPoint(x: 250, y: 390.625))

        path.move(to: CGPoint(x: 250, y: 81.25))
        path.addLine(to: CGPoint(x: 125, y: 81.25))

        path.move(to: CGPoint(x: 250, y: 390.625))
        path.addLine(to: CGPoint(x: 125, y: 390.625))
        path.move(to: CGPoint(x: 125, y: 390.625))
        path.addLine(to: CGPoint(x: 125, y: 235.9375))

        path.move(to: CGPoint(x: 125, y: 235.9375))
        path.addLine(to: CGPoint(x: 0, y: 235.9375))

        return path
    }

    var topStylePreferredPath: UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 3
        path.lineCapStyle = .square

        path.move(to: CGPoint(x: 30, y: 0))
        path.addLine(to: CGPoint(x: 30, y: 125))

        path.move(to: CGPoint(x: 30, y: 125))
        path.addLine(to: CGPoint(x: 30, y: 250))
        path.move(to: CGPoint(x: 30, y: 250))
        path.addLine(to: CGPoint(x: 85, y: 250))

        path.move(to: CGPoint(x: 250, y: 0))
        path.addLine(to: CGPoint(x: 250, y: 125))
        path.move(to: CGPoint(x: 250, y: 125))
        path.addLine(to: CGPoint(x: 305, y: 125))

        path.move(to: CGPoint(x: 470, y: 0))
        path.addLine(to: CGPoint(x: 470, y: 125))

        path.move(to: CGPoint(x: 305, y: 125))
        path.addLine(to: CGPoint(x: 305, y: 250))

        path.move(to: CGPoint(x: 470, y: 125))
        path.addLine(to: CGPoint(x: 470, y: 250))
        path.move(to: CGPoint(x: 470, y: 250))
        path.addLine(to: CGPoint(x: 387.5, y: 250))

        path.move(to: CGPoint(x: 85, y: 250))
        path.addLine(to: CGPoint(x: 85, y: 375))

        path.move(to: CGPoint(x: 387.5, y: 250))
        path.addLine(to: CGPoint(x: 387.5, y: 375))
        path.move(to: CGPoint(x: 387.5, y: 375))
        path.addLine(to: CGPoint(x: 236.25, y: 375))

        path.move(to: CGPoint(x: 236.25, y: 375))
        path.addLine(to: CGPoint(x: 236.25, y: 500))

        return path
    }

    var bottomStylePreferredPath: UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 3
        path.lineCapStyle = .square

        path.move(to: CGPoint(x: 30, y: 500))
        path.addLine(to: CGPoint(x: 30, y: 375))

        path.move(to: CGPoint(x: 30, y: 375))
        path.addLine(to: CGPoint(x: 30, y: 250))
        path.move(to: CGPoint(x: 30, y: 250))
        path.addLine(to: CGPoint(x: 85, y: 250))

        path.move(to: CGPoint(x: 250, y: 500))
        path.addLine(to: CGPoint(x: 250, y: 375))
        path.move(to: CGPoint(x: 250, y: 375))
        path.addLine(to: CGPoint(x: 305, y: 375))

        path.move(to: CGPoint(x: 470, y: 500))
        path.addLine(to: CGPoint(x: 470, y: 375))

        path.move(to: CGPoint(x: 305, y: 375))
        path.addLine(to: CGPoint(x: 305, y: 250))

        path.move(to: CGPoint(x: 470, y: 375))
        path.addLine(to: CGPoint(x: 470, y: 250))
        path.move(to: CGPoint(x: 470, y: 250))
        path.addLine(to: CGPoint(x: 387.5, y: 250))

        path.move(to: CGPoint(x: 85, y: 250))
        path.addLine(to: CGPoint(x: 85, y: 125))

        path.move(to: CGPoint(x: 387.5, y: 250))
        path.addLine(to: CGPoint(x: 387.5, y: 125))
        path.move(to: CGPoint(x: 387.5, y: 125))
        path.addLine(to: CGPoint(x: 236.25, y: 125))

        path.move(to: CGPoint(x: 236.25, y: 125))
        path.addLine(to: CGPoint(x: 236.25, y: 0))

        return path
    }

    var leftRightTopStylePreferredPath: UIBezierPath {
        let stepWidth: CGFloat = 500 / 6
        let path = UIBezierPath()
        path.lineWidth = 3
        path.lineCapStyle = .square

        path.move(to: CGPoint(x: 0, y: 25))
        path.addLine(to: CGPoint(x: stepWidth, y: 25))

        path.move(to: CGPoint(x: stepWidth, y: 25))
        path.addLine(to: CGPoint(x: stepWidth*2, y: 25))

        path.move(to: CGPoint(x: 500, y: 25))
        path.addLine(to: CGPoint(x: 500 - stepWidth, y: 25))
        path.move(to: CGPoint(x: 500 - stepWidth, y: 25))
        path.addLine(to: CGPoint(x: 500 - stepWidth, y: 137.5))

        path.move(to: CGPoint(x: 500, y: 475))
        path.addLine(to: CGPoint(x: 500 - stepWidth, y: 475))

        path.move(to: CGPoint(x: 500 - stepWidth, y: 137.5))
        path.addLine(to: CGPoint(x: 500 - stepWidth*2, y: 137.5))

        path.move(to: CGPoint(x: 500 - stepWidth, y: 475))
        path.addLine(to: CGPoint(x: 500 - stepWidth*2, y: 475))

        path.move(to: CGPoint(x: stepWidth*2, y: 25))
        path.addLine(to: CGPoint(x: stepWidth*2, y: 278.125))

        path.move(to: CGPoint(x: 500 - stepWidth*2, y: 475))
        path.addLine(to: CGPoint(x: 500 - stepWidth*2, y: 278.125))
        path.move(to: CGPoint(x: 500 - stepWidth*2, y: 278.125))
        path.addLine(to: CGPoint(x: 500 - stepWidth*3, y: 278.125))
        path.move(to: CGPoint(x: 500 - stepWidth*3, y: 278.125))
        path.addLine(to: CGPoint(x: 500 - stepWidth*3, y: 258.125))

        return path
    }

    var leftRightBottomStylePreferredPath: UIBezierPath {
        let stepWidth: CGFloat = 500 / 6
        let path = UIBezierPath()
        path.lineWidth = 3
        path.lineCapStyle = .square

        path.move(to: CGPoint(x: 0, y: 25))
        path.addLine(to: CGPoint(x: stepWidth, y: 25))

        path.move(to: CGPoint(x: stepWidth, y: 25))
        path.addLine(to: CGPoint(x: stepWidth*2, y: 25))

        path.move(to: CGPoint(x: 500, y: 25))
        path.addLine(to: CGPoint(x: 500 - stepWidth, y: 25))
        path.move(to: CGPoint(x: 500 - stepWidth, y: 25))
        path.addLine(to: CGPoint(x: 500 - stepWidth, y: 137.5))

        path.move(to: CGPoint(x: 500, y: 475))
        path.addLine(to: CGPoint(x: 500 - stepWidth, y: 475))

        path.move(to: CGPoint(x: 500 - stepWidth, y: 137.5))
        path.addLine(to: CGPoint(x: 500 - stepWidth*2, y: 137.5))

        path.move(to: CGPoint(x: 500 - stepWidth, y: 475))
        path.addLine(to: CGPoint(x: 500 - stepWidth*2, y: 475))

        path.move(to: CGPoint(x: stepWidth*2, y: 25))
        path.addLine(to: CGPoint(x: stepWidth*2, y: 278.125))

        path.move(to: CGPoint(x: 500 - stepWidth*2, y: 475))
        path.addLine(to: CGPoint(x: 500 - stepWidth*2, y: 278.125))
        path.move(to: CGPoint(x: 500 - stepWidth*2, y: 278.125))
        path.addLine(to: CGPoint(x: 500 - stepWidth*3, y: 278.125))
        path.move(to: CGPoint(x: 500 - stepWidth*3, y: 278.125))
        path.addLine(to: CGPoint(x: 500 - stepWidth*3, y: 298.125))

        return path
    }

    var topBottomRightStylePreferredPath: UIBezierPath {
        let stepHeight: CGFloat = 500 / 6
        let path = UIBezierPath()
        path.lineWidth = 3
        path.lineCapStyle = .square

        path.move(to: CGPoint(x: 30, y: 0))
        path.addLine(to: CGPoint(x: 30, y: stepHeight))

        path.move(to: CGPoint(x: 30, y: stepHeight))
        path.addLine(to: CGPoint(x: 30, y: stepHeight*2))

        path.move(to: CGPoint(x: 30, y: 500))
        path.addLine(to: CGPoint(x: 30, y: 500 - stepHeight))
        path.move(to: CGPoint(x: 30, y: 500 - stepHeight))
        path.addLine(to: CGPoint(x: 140, y: 500 - stepHeight))

        path.move(to: CGPoint(x: 470, y: 500))
        path.addLine(to: CGPoint(x: 470, y: 500 - stepHeight))

        path.move(to: CGPoint(x: 140, y: 500 - stepHeight))
        path.addLine(to: CGPoint(x: 140, y: 500 - stepHeight*2))

        path.move(to: CGPoint(x: 470, y: 500 - stepHeight))
        path.addLine(to: CGPoint(x: 470, y: 500 - stepHeight*2))

        path.move(to: CGPoint(x: 30, y: stepHeight*2))
        path.addLine(to: CGPoint(x: 277.5, y: stepHeight*2))

        path.move(to: CGPoint(x: 470, y: 500 - stepHeight*2))
        path.addLine(to: CGPoint(x: 277.5, y: 500 - stepHeight*2))
        path.move(to: CGPoint(x: 277.5, y: 500 - stepHeight*2))
        path.addLine(to: CGPoint(x: 277.5, y: 500 - stepHeight*3))
        path.move(to: CGPoint(x: 277.5, y: 500 - stepHeight*3))
        path.addLine(to: CGPoint(x: 297.5, y: 500 - stepHeight*3))

        return path
    }

    var topBottomLeftStylePreferredPath: UIBezierPath {
        let stepHeight: CGFloat = 500 / 6
        let path = UIBezierPath()
        path.lineWidth = 3
        path.lineCapStyle = .square

        path.move(to: CGPoint(x: 30, y: 0))
        path.addLine(to: CGPoint(x: 30, y: stepHeight))

        path.move(to: CGPoint(x: 30, y: stepHeight))
        path.addLine(to: CGPoint(x: 30, y: stepHeight*2))

        path.move(to: CGPoint(x: 30, y: 500))
        path.addLine(to: CGPoint(x: 30, y: 500 - stepHeight))
        path.move(to: CGPoint(x: 30, y: 500 - stepHeight))
        path.addLine(to: CGPoint(x: 140, y: 500 - stepHeight))

        path.move(to: CGPoint(x: 470, y: 500))
        path.addLine(to: CGPoint(x: 470, y: 500 - stepHeight))

        path.move(to: CGPoint(x: 140, y: 500 - stepHeight))
        path.addLine(to: CGPoint(x: 140, y: 500 - stepHeight*2))

        path.move(to: CGPoint(x: 470, y: 500 - stepHeight))
        path.addLine(to: CGPoint(x: 470, y: 500 - stepHeight*2))

        path.move(to: CGPoint(x: 30, y: stepHeight*2))
        path.addLine(to: CGPoint(x: 277.5, y: stepHeight*2))

        path.move(to: CGPoint(x: 470, y: 500 - stepHeight*2))
        path.addLine(to: CGPoint(x: 277.5, y: 500 - stepHeight*2))
        path.move(to: CGPoint(x: 277.5, y: 500 - stepHeight*2))
        path.addLine(to: CGPoint(x: 277.5, y: 500 - stepHeight*3))
        path.move(to: CGPoint(x: 277.5, y: 500 - stepHeight*3))
        path.addLine(to: CGPoint(x: 257.5, y: 500 - stepHeight*3))

        return path
    }
}

// MARK: - KRTournamentStyle extension for match -------------------

private extension KRTournamentViewStyle {
    var matchFrames: [CGRect] {
        switch self {
        case .left: return leftStyleFrames
        case .right: return rightStyleFrames
        case .top: return topStyleFrames
        case .bottom: return bottomStyleFrames
        case .leftRight: return leftRightStyleFrames
        case .topBottom: return topBottomStyleFrames
        }
    }

    var leftStyleFrames: [CGRect] {
        let frames = [CGRect]([
            CGRect(x: 62.5, y: 245, width: 125, height: 122.5),
            CGRect(x: 187.5, y: 20, width: 125, height: 122.5),
            CGRect(x: 187.5, y: 301.25, width: 125, height: 178.75),
            CGRect(x: 312.5, y: 76.25, width: 125, height: 319.375)
        ])
        return frames
    }

    var rightStyleFrames: [CGRect] {
        let frames = [CGRect]([
            CGRect(x: 312.5, y: 245, width: 125, height: 122.5),
            CGRect(x: 187.5, y: 20, width: 125, height: 122.5),
            CGRect(x: 187.5, y: 301.25, width: 125, height: 178.75),
            CGRect(x: 62.5, y: 76.25, width: 125, height: 319.375)
            ])
        return frames
    }

    var topStyleFrames: [CGRect] {
        let frames = [CGRect]([
            CGRect(x: 245, y: 62.5, width: 120, height: 125),
            CGRect(x: 25, y: 187.5, width: 120, height: 125),
            CGRect(x: 300, y: 187.5, width: 175, height: 125),
            CGRect(x: 80, y: 312.5, width: 312.5, height: 125)
            ])
        return frames
    }

    var bottomStyleFrames: [CGRect] {
        let frames = [CGRect]([
            CGRect(x: 245, y: 312.5, width: 120, height: 125),
            CGRect(x: 25, y: 187.5, width: 120, height: 125),
            CGRect(x: 300, y: 187.5, width: 175, height: 125),
            CGRect(x: 80, y: 62.5, width: 312.5, height: 125)
            ])
        return frames
    }

    var leftRightStyleFrames: [CGRect] {
        let stepWidth: CGFloat = 500 / 6
        let frames = [CGRect]([
            CGRect(x: 500 - stepWidth*1.5, y: 20, width: stepWidth, height: 235),
            CGRect(x: stepWidth*1.5, y: 20, width: stepWidth, height: 460),
            CGRect(x: 500 - stepWidth*2.5, y: 132.5, width: stepWidth, height: 347.5),
            CGRect(x: 250 - stepWidth*0.5, y: 253.125, width: stepWidth, height: 50)
            ])
        return frames
    }

    var topBottomStyleFrames: [CGRect] {
        let stepHeight: CGFloat = 500 / 6
        let frames = [CGRect]([
            CGRect(x: 25, y: 500 - stepHeight*1.5, width: 230, height: stepHeight),
            CGRect(x: 25, y: stepHeight*1.5, width: 450, height: stepHeight),
            CGRect(x: 135, y: 500 - stepHeight*2.5, width: 340, height: stepHeight),
            CGRect(x: 252.5, y: 250 - stepHeight*0.5, width: 50, height: stepHeight)
            ])
        return frames
    }
}
