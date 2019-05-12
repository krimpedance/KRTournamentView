//
//  EntryTests.swift
//  KRTournamentView
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//
//  swiftlint:disable superfluous_disable_command
//  swiftlint:disable identifier_name
//  swiftlint:disable force_try
//  swiftlint:disable force_cast
//  swiftlint:disable function_body_length

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class EntryTests: QuickSpec {
    override func spec() {
        it("can initialize") {
            expect(Entry(index: 2).index).to(be(2))
            expect(Entry().index).to(beNil())
        }
    }
}
