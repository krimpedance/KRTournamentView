//
//  KRTournamentEntriesViewTests.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class KRTournamentEntriesViewTests: QuickSpec {
    override func spec() {
        describe("KRTournamentEntriesView") {
            describe("initializer", closure: initializerSpec)
            describe("entries", closure: entriesSpec)
            describe("layout", closure: layoutSpec)
        }
    }

    func initializerSpec() {
        let view = KRTournamentEntriesView(half: .second)

        it("half is .second") {
            expect(view.half).to(equal(DrawHalf.second))
        }

        it("entries is empty") {
            expect(view.entries).to(beEmpty())
        }

        it("backgroundColor is .clear") {
            expect(view.backgroundColor).to(equal(.clear))
        }

        it("translatesAutoresizingMaskIntoConstraints is false") {
            expect(view.translatesAutoresizingMaskIntoConstraints).to(beFalse())
        }
    }

    func entriesSpec() {
        let dataStore = KRTournamentViewDataStoreMock()
        var view: KRTournamentEntriesView!
        let entries = (0..<2).map { _ in KRTournamentViewEntry() }

        beforeEach {
            view = KRTournamentEntriesView(half: .first)
            view.dataStore = dataStore
            view.entries = entries
        }

        it("are added to the view") {
            entries.forEach {
                expect($0.superview).to(be(view))
            }
        }

        it("are removed from superview when it changes to new entries") {
            view.entries = (0..<3).map { _ in KRTournamentViewEntry() }
            entries.forEach {
                expect($0.superview).to(beNil())
            }
        }
    }

    func layoutSpec() {
        context(".left style") {
            let positions = [CGPoint]([CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 90), CGPoint(x: 0, y: 180), CGPoint(x: 0, y: 270)])
            layoutSpec(with: .left, expectedPositions: positions)
        }

        context(".top style") {
            let positions = [CGPoint]([CGPoint(x: 0, y: 0), CGPoint(x: 80, y: 0), CGPoint(x: 160, y: 0), CGPoint(x: 240, y: 0)])
            layoutSpec(with: .top, expectedPositions: positions)
        }
    }
}

// MARK: - Sub specs ---------------

extension KRTournamentEntriesViewTests {
    func layoutSpec(with style: KRTournamentViewStyle, expectedPositions positions: [CGPoint]) {
        let dataStore = KRTournamentViewDataStoreMock(style: style, numberOfLayers: 2, entrySize: CGSize(width: 60, height: 30))
        var view: KRTournamentEntriesView!

        beforeEach {
            view = KRTournamentEntriesView(half: .first)
            view.dataStore = dataStore
            view.frame.size = CGSize(width: 300, height: 300)
        }

        it("entries frame is adjusted") {
            view.entries = (0..<4).map { _ in KRTournamentViewEntry() }
            view.layoutIfNeeded()

            view.entries.enumerated().forEach { index, entry in
                let frame = CGRect(origin: positions[index], size: view.validEntrySize)
                expect(entry.frame).to(equal(frame))
            }
        }

        it("entry position is set center when number of entries is 1") {
            let entry = KRTournamentViewEntry()
            view.entries = [entry]
            view.layoutIfNeeded()

            let origin = style.isVertical ? CGPoint(x: 0, y: 135) : CGPoint(x: 120, y: 0)
            let frame = CGRect(origin: origin, size: view.validEntrySize)
            expect(entry.frame).to(equal(frame))
        }
    }
}
