//
//  KRTournamentViewDataStoreTests.swift
//  KRTournamentView
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class KRTournamentViewDataStoreTests: QuickSpec {
    override func spec() {
        describe("KRTournamentViewDataStore") {
            let entrySize = CGSize(width: 100, height: 20)
            let dataStore = KRTournamentViewDataStoreMock(entrySize: entrySize)

            it("entriesSpaceWidth returns entrySize.width where vertical style is set") {
                dataStore.style = .left
                expect(dataStore.entriesSpaceWidth).to(be(entrySize.width))
            }

            it("entriesSpaceWidth returns entrySize.height where horizontal style is set") {
                dataStore.style = .top
                expect(dataStore.entriesSpaceWidth).to(be(entrySize.height))
            }
        }
    }
}

class KRTournamentViewDataStoreMock: KRTournamentViewDataStore {
    var style: KRTournamentViewStyle
    var numberOfLayers: Int
    var entrySize: CGSize
    var excludes: [Int]

    init(style: KRTournamentViewStyle? = nil, numberOfLayers: Int? = nil, entrySize: CGSize? = nil, excludes: [Int]? = nil) {
        self.style = style ?? .left
        self.numberOfLayers = numberOfLayers ?? 2
        self.entrySize = entrySize ?? CGSize(width: 80, height: 30)
        self.excludes = excludes ?? []
    }
}
