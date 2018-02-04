//
//  KRTournamentViewEntryLabelTests.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class KRTournamentViewEntryLabelTests: QuickSpec {
    override func spec() {
        describe("KRTournamentViewEntryLabel") {
            var label: KRTournamentViewEntryLabel!

            beforeEach {
                label = KRTournamentViewEntryLabel()
                label.text = "hoge"
            }

            it("text can set vertical text by verticalText") {
                label.verticalText = "fuga"
                expect(label.text).to(equal("f\nu\ng\na\n"))
            }

            it("text is not updated when verticalText is set to nil") {
                label.verticalText = nil
                expect(label.text).to(equal("hoge"))
            }
        }
    }
}
