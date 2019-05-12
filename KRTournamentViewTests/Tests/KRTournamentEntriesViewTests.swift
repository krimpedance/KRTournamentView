//
//  KRTournamentEntriesViewTests.swift
//  KRTournamentView
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class KRTournamentEntriesViewTests: QuickSpec {
    override func spec() {
        var dataStore: KRTournamentViewDataStoreMock!
        var view: KRTournamentEntriesView!
        let entries = (0..<2).map { KRTournamentViewEntry.fake(index: $0) }

        beforeEach {
            dataStore = KRTournamentViewDataStoreMock()
            view = KRTournamentEntriesView(dataStore: dataStore, drawHalf: .first)
            view.frame.size = CGSize(width: 300, height: 300)
            view.tournamentInfoType = TournamentInfoMock.self
            view.entries = entries
        }

        context("Vertical style") {
            beforeEach {
                dataStore.style = .left
                dataStore.entrySize = .init(width: 80, height: 30)
                view.layoutIfNeeded()
            }

            it("are added to the view") {
                entries.enumerated().forEach { index, entry in
                    let frame = CGRect(x: 0, y: CGFloat(30 * index), width: 80, height: 30)
                    expect(entry.frame).to(equal(frame))
                    expect(entry.superview).to(be(view))
                }
            }

            it("are removed from superview when it changes to new entries") {
                view.entries = (0..<3).map { KRTournamentViewEntry.fake(index: $0) }
                entries.forEach {
                    expect($0.superview).to(beNil())
                }
            }
        }

        context("Horizontal style") {
            beforeEach {
                dataStore.style = .bottom
                dataStore.entrySize = .init(width: 30, height: 80)
                view.layoutIfNeeded()
            }

            it("are added to the view") {
                entries.enumerated().forEach { index, entry in
                    let frame = CGRect(x: CGFloat(30 * index), y: 0, width: 30, height: 80)
                    expect(entry.frame).to(equal(frame))
                    expect(entry.superview).to(be(view))
                }
            }

            it("are removed from superview when it changes to new entries") {
                view.entries = (0..<3).map { KRTournamentViewEntry.fake(index: $0) }
                entries.forEach {
                    expect($0.superview).to(beNil())
                }
            }
        }
    }
}

// MARK: - Mock ------------

private final class TournamentInfoMock: EntriesViewTournamentInfoProtocol {
    let style: KRTournamentViewStyle
    let entrySize: CGSize

    init(structure: Bracket, style: KRTournamentViewStyle, drawHalf: DrawHalf, rect: CGRect, entrySize: CGSize) {
        self.style = style
        self.entrySize = entrySize
    }

    func entryPoint(at index: Int) -> CGPoint {
        if style.isVertical {
            let offset = entrySize.height / 2
            return .init(x: 0, y: entrySize.height * CGFloat(index) + offset)
        } else {
            let offset = entrySize.width / 2
            return .init(x: entrySize.width * CGFloat(index) + offset, y: 0)
        }
    }
}
