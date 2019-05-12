//
//  KRTournamentViewEntryTests.swift
//  KRTournamentViewTests
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class KRTournamentViewEntryTests: QuickSpec {
    override func spec() {
        var entry: KRTournamentViewEntry!

        beforeEach {
            entry = KRTournamentViewEntry()
        }

        it("size is the default entry size") {
            let size = Default.entrySize(with: .left)
            expect(entry.frame.size).to(equal(size))
        }

        it("backgroundColor is .clear") {
            expect(entry.backgroundColor).to(be(UIColor.clear))
        }

        it("clipsToBounds is true") {
            expect(entry.clipsToBounds).to(be(true))
        }

        describe("textLabel") { self.textLabelSpec() }
    }

    func textLabelSpec() {
        var entry: KRTournamentViewEntry!
        var textLabel: KRTournamentViewEntryLabel!

        beforeEach {
            entry = KRTournamentViewEntry()
            textLabel = entry.textLabel
            entry.layoutIfNeeded()
        }

        it("superview is the entry") {
            expect(textLabel.superview).to(be(entry))
        }

        it("backgroundColor is .clear") {
            expect(textLabel.backgroundColor).to(be(UIColor.clear))
        }

        it("textAlignment is .center") {
            expect(textLabel.textAlignment).to(equal(NSTextAlignment.center))
        }

        it("numberOfLines is 0") {
            expect(textLabel.numberOfLines).to(be(0))
        }

        it("frame is same as entry bounds") {
            expect(textLabel.frame).to(equal(entry.bounds))
        }

        it("frame is same as entry bounds when entry size is changed") {
            let size = Default.entrySize(with: .left)
            entry.frame.size = CGSize(width: size.width + 10, height: size.height + 100)
            entry.layoutIfNeeded()
            expect(textLabel.frame).to(equal(entry.bounds))
        }
    }
}
