//
//  KRTournamentViewTests.swift
//  KRTournamentViewTests
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class KRTournamentViewTests: QuickSpec {

    override func spec() {
        var view: KRTournamentView!

        beforeEach {
            view = KRTournamentView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
            view.layoutIfNeeded()
        }

        it("has properties") {
            expect(view.style).to(equal(Default.style))
            expect(view.tournamentStructure == Default.tournamentStructure).to(beTrue())
            expect(view.entrySize).to(equal(Default.entrySize(with: Default.style)))
            expect(view.lineColor).to(equal(Default.lineColor))
            expect(view.winnerLineColor).to(equal(Default.winnerLineColor))
            expect(view.lineWidth).to(equal(Default.lineWidth))
            expect(view.winnerLineWidth).to(beNil())
            expect(view.fixOrientation).to(equal(Default.fixOrientation))
        }

        // Layouts ------------

        KRTournamentViewStyle.testStyles.forEach { style in
            context("style is \(style)") {
                beforeEach {
                    view.style = style
                }

                it("drawingView is resized") {
                    let drawingView = view.subviews.first { $0 is KRTournamentDrawingView }!
                    drawingView.layoutIfNeeded()
                    view.layoutIfNeeded()
                    expect(drawingView.frame).to(equal(style.drawingViewFrame))
                }

                it("firstEntriesView is resized") {
                    let entriesView = view.subviews.first { $0 is KRTournamentEntriesView }!
                    entriesView.layoutIfNeeded()
                    view.layoutIfNeeded()
                    expect(entriesView.frame).to(equal(style.firstEntriesViewFrame))
                }

                it("secondEntriesView is resized") {
                    let entriesView = view.subviews.last { $0 is KRTournamentEntriesView }!
                    entriesView.layoutIfNeeded()
                    view.layoutIfNeeded()
                    expect(entriesView.frame).to(equal(style.secondEntriesViewFrame))
                }
            }
        }
    }
}

// MARK: - KRTournamentStyle extension -------------------

private extension KRTournamentViewStyle {
    static let testStyles = [KRTournamentViewStyle]([.left, .right, .top, .bottom, .leftRight(direction: .top), .topBottom(direction: .right)])

    var drawingViewFrame: CGRect {
        let entrySize = Default.entrySize(with: self)
        switch self {
        case .left:
            return CGRect(x: entrySize.width + 5, y: 0, width: 500 - entrySize.width - 10, height: 500)
        case .right:
            return CGRect(x: 5, y: 0, width: 500 - entrySize.width - 10, height: 500)
        case .top:
            return CGRect(x: 0, y: entrySize.height + 5, width: 500, height: 500 - entrySize.height - 10)
        case .bottom:
            return CGRect(x: 0, y: 5, width: 500, height: 500 - entrySize.height - 10)
        case .leftRight:
            return CGRect(x: entrySize.width + 5, y: 0, width: 500 - (entrySize.width * 2) - 10, height: 500)
        case .topBottom:
            return CGRect(x: 0, y: entrySize.height + 5, width: 500, height: 500 - (entrySize.height * 2) - 10)
        }
    }

    var firstEntriesViewFrame: CGRect {
        let entrySize = Default.entrySize(with: self)
        switch self {
        case .left:
            return CGRect(x: 0, y: 0, width: entrySize.width, height: 500)
        case .right:
            return CGRect(x: 0, y: 0, width: 0, height: 500)
        case .top:
            return CGRect(x: 0, y: 0, width: 500, height: entrySize.height)
        case .bottom:
            return CGRect(x: 0, y: 0, width: 500, height: 0)
        case .leftRight:
            return CGRect(x: 0, y: 0, width: entrySize.width, height: 500)
        case .topBottom:
            return CGRect(x: 0, y: 0, width: 500, height: entrySize.height)
        }
    }

    var secondEntriesViewFrame: CGRect {
        let entrySize = Default.entrySize(with: self)
        switch self {
        case .left:
            return CGRect(x: 500, y: 0, width: 0, height: 500)
        case .right:
            return CGRect(x: 500 - entrySize.width, y: 0, width: entrySize.width, height: 500)
        case .top:
            return CGRect(x: 0, y: 500, width: 500, height: 0)
        case .bottom:
            return CGRect(x: 0, y: 500 - entrySize.height, width: 500, height: entrySize.height)
        case .leftRight:
            return CGRect(x: 500 - entrySize.width, y: 0, width: entrySize.width, height: 500)
        case .topBottom:
            return CGRect(x: 0, y: 500 - entrySize.height, width: 500, height: entrySize.height)
        }
    }
}
