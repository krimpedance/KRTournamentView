//
//  KRTournamentViewEntryFake.swift
//  KRTournamentView
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//
//  swiftlint:disable superfluous_disable_command
//  swiftlint:disable identifier_name
//  swiftlint:disable force_try
//  swiftlint:disable function_body_length

@testable import KRTournamentView

extension KRTournamentViewEntry {
    static func fake(index: Int = 0) -> KRTournamentViewEntry {
        let entry = KRTournamentViewEntry()
        entry.index = index
        return entry
    }
}
