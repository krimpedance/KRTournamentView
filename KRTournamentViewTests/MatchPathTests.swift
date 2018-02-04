//
//  MatchPathTests.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class MatchPathTests: QuickSpec {
    override func spec() {
        describe("MatchPath") {
            describe("initializer", closure: initializerSpec)
            describe("equatable", closure: equatableSpec)
            describe("methods", closure: methodsSpec)
        }
    }

    func initializerSpec() {
        context("uses layer and number") {
            it("can be initialized") {
                let layer = 2
                let number = 3
                let path = MatchPath(layer: layer, number: number)
                expect(path.layer).to(be(layer))
                expect(path.number).to(be(number))
            }
        }

        context("uses number of layers and index") {
            it("can be initialized") {
                let path = MatchPath(numberOfLayers: 3, index: 5)
                expect(path).notTo(beNil())
                expect(path?.layer).to(be(2))
                expect(path?.number).to(be(1))
            }

            it("cannot be initialized when numberOfLayers <= 0") {
                let path = MatchPath(numberOfLayers: 0, index: 2)
                expect(path).to(beNil())
            }

            it("cannot be initialized when index < 0") {
                let path = MatchPath(numberOfLayers: 2, index: -1)
                expect(path).to(beNil())
            }

            it("cannot be initialized when index is out of range") {
                let path = MatchPath(numberOfLayers: 2, index: 3)
                expect(path).to(beNil())
            }
        }
    }

    func equatableSpec() {
        it("is equatable") {
            let match = MatchPath(layer: 2, number: 0)
            let match2 = MatchPath(numberOfLayers: 3, index: 4)
            expect(match).to(equal(match2))
        }

        it("is not same when layer is different") {
            let match = MatchPath(layer: 2, number: 0)
            let match2 = MatchPath(layer: 1, number: 0)
            expect(match).notTo(equal(match2))
        }

        it("is not same when number is different") {
            let match = MatchPath(layer: 2, number: 0)
            let match2 = MatchPath(layer: 2, number: 1)
            expect(match).notTo(equal(match2))
        }
    }

    func methodsSpec() {
        let match = MatchPath(numberOfLayers: 3, index: 5)
        it("returns index") {
            expect(match?.getIndex(from: 3)).to(be(5))
            expect(match?.getIndex(from: 4)).to(be(9))
        }
    }
}
