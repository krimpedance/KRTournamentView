//
//  KRTournamentViewMatchTests.swift
//  KRTournamentViewTests
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class KRTournamentViewMatchTests: QuickSpec {
    let match = KRTournamentViewMatch()

    override func spec() {
        describe("KRTournamentViewMatch") {
            selfSpec()
            describe("imageView", closure: imageViewSpec)
            describe("methods", closure: methodsSpec)
        }
    }

    func selfSpec() {
        it("size is the 50x50") {
            expect(self.match.frame.size).to(equal(CGSize(width: 50, height: 50)))
        }

        it("backgroundColor is .clear") {
            expect(self.match.backgroundColor).to(be(UIColor.clear))
        }

        it("imageSize is 10x10") {
            expect(self.match.imageSize).to(equal(CGSize(width: 10, height: 10)))
        }
    }

    func imageViewSpec() {
        // Initialize imageView. Because imageView is implemented by `lazy var`
        let imageView = match.imageView
        match.layoutIfNeeded()

        it("superview is the match") {
            expect(imageView.superview).to(be(self.match))
        }

        it("backgroundColor is .clear") {
            expect(imageView.backgroundColor).to(be(UIColor.clear))
        }

        it("translatesAutoresizingMaskIntoConstraints is false") {
            expect(imageView.translatesAutoresizingMaskIntoConstraints).to(be(false))
        }

        it("center is center of match") {
            let center = CGPoint(
                x: self.match.center.x - self.match.frame.origin.x,
                y: self.match.center.y - self.match.frame.origin.y
            )
            expect(imageView.center).to(equal(center))
        }

        it("center is center of match when match size is changed") {
            self.match.frame.size = CGSize(width: 100, height: 30)
            self.match.layoutIfNeeded()
            expect(imageView.center).to(equal(CGPoint(x: 50, y: 15)))
        }

        it("size is 10x10") {
            expect(imageView.frame.size).to(equal(self.match.imageSize))
        }

        it("size is updated when imageSize is changed") {
            self.match.imageSize = CGSize(width: 20, height: 30)
            imageView.setNeedsLayout()
            imageView.layoutIfNeeded()
            expect(imageView.frame.size).to(equal(self.match.imageSize))
        }
    }

    func methodsSpec() {
        // Initialize imageView. Because imageView is implemented by `lazy var`
        let imageView = match.imageView
        match.layoutIfNeeded()

        it("update imageView center") {
            let center = CGPoint(x: 5, y: 10)
            self.match.updateImageViewCenter(center)
            self.match.layoutIfNeeded()
            expect(imageView.center).to(equal(center))
        }
    }
}

extension KRTournamentViewMatch {
    convenience init(matchPath: MatchPath, preferredSide: MatchPreferredSide? = nil) {
        self.init()
        self.matchPath = matchPath
        self.preferredSide = preferredSide
    }
}
