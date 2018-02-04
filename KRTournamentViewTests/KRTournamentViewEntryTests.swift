//
//  KRTournamentViewEntryTests.swift
//  KRTournamentViewTests
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class KRTournamentViewEntryTests: QuickSpec {
    let entry = KRTournamentViewEntry()

    override func spec() {
        describe("KRTournamentViewEntry") {
            selfSpec()
            describe("textLabel", closure: textLabelSpec)
        }
    }

    func selfSpec() {
        it("size is the default entry size") {
            let size = Default.entrySize(with: .left)
            expect(self.entry.frame.size).to(equal(size))
        }

        it("backgroundColor is .clear") {
            expect(self.entry.backgroundColor).to(be(UIColor.clear))
        }

        it("clipsToBounds is true") {
            expect(self.entry.clipsToBounds).to(be(true))
        }
    }

    func textLabelSpec() {
        // Initialize textLabel. Because textLabel is implemented by `lazy var`
        let textLabel = entry.textLabel
        entry.layoutIfNeeded()

        it("superview is the entry") {
            expect(textLabel.superview).to(be(self.entry))
        }

        it("backgroundColor is .clear") {
            expect(textLabel.backgroundColor).to(be(UIColor.clear))
        }

        it("textAlignment is .center") {
            expect(textLabel.textAlignment.rawValue).to(be(NSTextAlignment.center.rawValue))
        }

        it("numberOfLines is 0") {
            expect(textLabel.numberOfLines).to(be(0))
        }

        it("font is system font with 15pt") {
            expect(textLabel.font).to(equal(UIFont.systemFont(ofSize: 15)))
        }

        it("adjustsFontSizeToFitWidth is true") {
            expect(textLabel.adjustsFontSizeToFitWidth).to(be(true))
        }

        it("translatesAutoresizingMaskIntoConstraints is false") {
            expect(textLabel.translatesAutoresizingMaskIntoConstraints).to(be(false))
        }

        it("frame is same as entry bounds") {
            expect(textLabel.frame).to(equal(self.entry.bounds))
        }

        it("frame is same as entry bounds when entry size is changed") {
            let size = Default.entrySize(with: .left)
            self.entry.frame.size = CGSize(width: size.width + 10, height: size.height + 100)
            self.entry.layoutIfNeeded()
            expect(textLabel.frame).to(equal(self.entry.bounds))
        }
    }
}
