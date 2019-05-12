//
//  MatchPathTests.swift
//  KRTournamentView
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class MatchPathTests: QuickSpec {
    override func spec() {
        it("can be initialized") {
            let layer = 2
            let item = 3
            let path = MatchPath(layer: layer, item: item)
            expect(path.layer).to(be(layer))
            expect(path.item).to(be(item))
        }

        it("is equatable") {
            let match = MatchPath(layer: 2, item: 0)
            let match2 = MatchPath(layer: 2, item: 0)
            let match3 = MatchPath(layer: 2, item: 1)
            let match4 = MatchPath(layer: 3, item: 0)

            expect(match).to(equal(match2))
            expect(match).notTo(equal(match3))
            expect(match).notTo(equal(match4))
        }
    }
}
