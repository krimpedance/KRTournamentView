//
//  KRTournamentCalculatableTests.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class KRTournamentCalculatableTests: QuickSpec {
    let numberOfLayer = 3
    let excludes = [0, 2, 7]
    let viewSize = CGSize(width: 200, height: 300)
    let halfStyles = [KRTournamentViewStyle]([.left, .right, .top, .bottom])

    override func spec() {
        describe("KRTournamentCalculatable") {
            describe("maxEntryNumber", closure: maxEntryNumberSpec)
            describe("validEntrySize", closure: validEntrySizeSpec)
            describe("stepSize", closure: stepSizeSpec)
        }
    }

    func maxEntryNumberSpec() {
        let dataStore = KRTournamentViewDataStoreMock()
        let mock = KRTournamentCalculatableMock(dataStore: dataStore)
        (1...4).forEach { num in
            context("numberOfLayers is \(num)") {
                beforeEach { dataStore.numberOfLayers = num }

                let entryNum = Int(pow(2, Double(num)))
                it("returns \(entryNum)") { expect(mock.maxEntryNumber).to(equal(entryNum)) }
            }
        }
    }

    func validEntrySizeSpec() {
        let dataStore = KRTournamentViewDataStoreMock(numberOfLayers: 3)
        let mock = KRTournamentCalculatableMock(dataStore: dataStore)

        [KRTournamentViewStyle]([.left, .top]).forEach { style in
            context("style is \(style), entrySize is in range") {
                it("returns 50x30") {
                    dataStore.style = style
                    dataStore.entrySize = CGSize(width: 50, height: 30)
                    mock.frame.size = CGSize(width: 500, height: 500)
                    expect(mock.validEntrySize).to(equal(CGSize(width: 50, height: 30)))
                }
            }

            context("style is \(style), entrySize is out of range") {
                let expectedSize = style.isVertical ?
                    CGSize(width: 40, height: 300 / CGFloat(mock.maxEntryNumber)) :
                    CGSize(width: 300 / CGFloat(mock.maxEntryNumber), height: 50)

                it("returns \(expectedSize.width)x\(expectedSize.height)") {
                    dataStore.style = style
                    dataStore.entrySize = CGSize(width: 40, height: 50)
                    mock.frame.size = CGSize(width: 300, height: 300)
                    expect(mock.validEntrySize).to(equal(expectedSize))
                }
            }
        }
    }

    func stepSizeSpec() {
        let numberOfLayer = 3
        let dataStore = KRTournamentViewDataStoreMock(
            numberOfLayers: numberOfLayer,
            entrySize: CGSize(width: 50, height: 30),
            excludes: [0, 2, 7]
        )
        let mock = KRTournamentCalculatableMock(
            size: CGSize(width: 500, height: 500),
            dataStore: dataStore
        )

        context("style is .left") {
            let expectedSize = CGSize(width: 125.0, height: 117.5)
            it("returns \(expectedSize)") {
                dataStore.style = .left
                expect(mock.stepSize).to(equal(expectedSize))
            }
        }

        context("style is .top") {
            let expectedSize = CGSize(width: 112.5, height: 125.0)
            it("returns \(expectedSize)") {
                dataStore.style = .top
                expect(mock.stepSize).to(equal(expectedSize))
            }
        }

        [(DrawHalf.first, 470.0), (DrawHalf.second, 235.0)].forEach { half, expectedValue in
            context("style is .leftRight, half is \(half)") {
                let expectedSize = CGSize(width: 500.0 / 6, height: expectedValue)
                it("returns \(expectedSize)") {
                    dataStore.style = .leftRight(direction: .top)
                    mock.half = half
                    expect(mock.stepSize).to(equal(expectedSize))
                }
            }
        }

        [(DrawHalf.first, 450.0), (DrawHalf.second, 225.0)].forEach { half, expectedValue in
            context("style is .leftRight, half is \(half)") {
                let expectedSize = CGSize(width: expectedValue, height: 500.0 / 6)
                it("returns \(expectedSize)") {
                    dataStore.style = .topBottom(direction: .right)
                    mock.half = half
                    expect(mock.stepSize).to(equal(expectedSize))
                }
            }
        }
    }
}

// MARK: - Mock class ---------------

class KRTournamentCalculatableMock: UIView, KRTournamentCalculatable {
    var dataStore: KRTournamentViewDataStore!
    var half: DrawHalf = .first

    convenience init(size: CGSize? = nil, dataStore: KRTournamentViewDataStore? = nil, half: DrawHalf = .first) {
        self.init(frame: CGRect(origin: .zero, size: size ?? CGSize(width: 100, height: 100)))
        self.dataStore = dataStore ?? KRTournamentViewDataStoreMock()
        self.half = half
    }
}
