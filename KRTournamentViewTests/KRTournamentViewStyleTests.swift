//
//  KRTournamentViewStyleTests.swift
//  KRTournamentViewTests
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class KRTournamentViewStyleTests: QuickSpec {
    let rotationSet = [(KRTournamentViewStyle, left: KRTournamentViewStyle, right: KRTournamentViewStyle, reverse: KRTournamentViewStyle)]([
        (.left, left: .bottom, right: .top, reverse: .right),
        (.right, left: .top, right: .bottom, reverse: .left),
        (.top, left: .left, right: .right, reverse: .bottom),
        (.bottom, left: .right, right: .left, reverse: .top),
        (.leftRight(direction: .left), left: .topBottom(direction: .left), right: .topBottom(direction: .right), reverse: .leftRight(direction: .bottom)),
        (.leftRight(direction: .right), left: .topBottom(direction: .left), right: .topBottom(direction: .right), reverse: .leftRight(direction: .bottom)),
        (.leftRight(direction: .top), left: .topBottom(direction: .left), right: .topBottom(direction: .right), reverse: .leftRight(direction: .bottom)),
        (.leftRight(direction: .bottom), left: .topBottom(direction: .right), right: .topBottom(direction: .left), reverse: .leftRight(direction: .top)),
        (.topBottom(direction: .left), left: .leftRight(direction: .bottom), right: .leftRight(direction: .top), reverse: .topBottom(direction: .right)),
        (.topBottom(direction: .right), left: .leftRight(direction: .top), right: .leftRight(direction: .bottom), reverse: .topBottom(direction: .left)),
        (.topBottom(direction: .top), left: .leftRight(direction: .top), right: .leftRight(direction: .bottom), reverse: .topBottom(direction: .left)),
        (.topBottom(direction: .bottom), left: .leftRight(direction: .top), right: .leftRight(direction: .bottom), reverse: .topBottom(direction: .left))
    ])

    override func spec() {
        describe("KRTournamentViewStyle") {
            KRTournamentViewStyle.getList().forEach { style in
                context("\(style)") {
                    describe("equatable") { equatableSpec(with: style) }
                    describe("computedProperties") { computedPropertiesSpec(style: style) }
                    describe("rotation") { rotationSpec(style: style) }
                }
            }
        }
    }

    func equatableSpec(with style: KRTournamentViewStyle) {
        it("== \(style) is true") {
            expect(style == style).to(be(true))
        }

        KRTournamentViewStyle.getList(exceptStyle: style).forEach { otherStyle in
            it("== \(otherStyle) is false") {
                expect(style == otherStyle).to(be(false))
            }
        }
    }

    func computedPropertiesSpec(style: KRTournamentViewStyle) {
        let isVertical: Bool
        switch style {
        case .left, .right, .leftRight: isVertical = true
        default: isVertical = false
        }

        it("has a isVertical property returns \(isVertical)") {
            expect(style.isVertical).to(be(isVertical))
        }

        let isHalf = [.left, .right, .top, .bottom].contains(style)
        it("has a isHalf property returns \(isHalf)") {
            expect(style.isHalf).to(be(isHalf))
        }
    }

    func rotationSpec(style: KRTournamentViewStyle) {
        let rotation = rotationSet.filter { $0.0 == style }.first!

        it("changes to \(rotation.left) when rotate to the left") {
            var style = style
            style.rotateLeft()
            expect(style).to(equal(rotation.left))
        }

        it("changes to \(rotation.right) when rotate to the left") {
            var style = style
            style.rotateRight()
            expect(style).to(equal(rotation.right))
        }

        it("changes to \(rotation.left) when rotate to the left") {
            var style = style
            style.reverse()
            expect(style).to(equal(rotation.reverse))
        }
    }
}

extension KRTournamentViewStyle {
    static func getList(exceptStyle: KRTournamentViewStyle? = nil) -> [KRTournamentViewStyle] {
        let directions = [FinalDirection]([.left, .right, .top, .bottom])

        switch exceptStyle {
        case .left?:
            return [.right, .top, .bottom] + directions.map { .leftRight(direction: $0) } + directions.map { .topBottom(direction: $0) }
        case .right?:
            return [.left, .top, .bottom] + directions.map { .leftRight(direction: $0) } + directions.map { .topBottom(direction: $0) }
        case .top?:
            return [.left, .right, .bottom] + directions.map { .leftRight(direction: $0) } + directions.map { .topBottom(direction: $0) }
        case .bottom?:
            return [.left, .right, .top] + directions.map { .leftRight(direction: $0) } + directions.map { .topBottom(direction: $0) }
        case .leftRight(let direction)?:
            let styles: [KRTournamentViewStyle] = directions.flatMap { ($0 == direction) ? nil : .leftRight(direction: $0) }
            return [.left, .right, .top, .bottom] + styles + directions.map { .topBottom(direction: $0) }
        case .topBottom(let direction)?:
            let styles: [KRTournamentViewStyle] = directions.flatMap { ($0 == direction) ? nil : .topBottom(direction: $0) }
            return [.left, .right, .top, .bottom] + directions.map { .leftRight(direction: $0) } + styles
        case .none:
            return [.left, .right, .top, .bottom] + directions.map { .leftRight(direction: $0) } + directions.map { .topBottom(direction: $0) }
        }
    }
}
