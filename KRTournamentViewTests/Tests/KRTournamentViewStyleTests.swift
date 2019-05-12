//
//  KRTournamentViewStyleTests.swift
//  KRTournamentViewTests
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//
//  swiftlint:disable function_body_length

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class KRTournamentViewStyleTests: QuickSpec {
    override func spec() {
        it("has both side styles") {
            expect(KRTournamentViewStyle.leftRight).to(equal(.leftRight(direction: .top)))
            expect(KRTournamentViewStyle.topBottom).to(equal(.topBottom(direction: .right)))
        }

        it("has direction") {
            let styles = KRTournamentViewStyle.getList()
            let directions: [KRTournamentViewStyle.FinalDirection] = [
                .right, .left, .bottom, .top,
                .top, .top, .top, .bottom,
                .left, .right, .right, .right
            ]

            expect(styles.map { $0.direction }).to(equal(directions))
        }

        it("has isVertical") {
            let styles = KRTournamentViewStyle.getList()
            let values: [Bool] = [
                true, true, false, false,
                true, true, true, true,
                false, false, false, false
            ]

            expect(styles.map { $0.isVertical }).to(equal(values))
        }

        it("has isHalf") {
            let styles = KRTournamentViewStyle.getList()
            let values: [Bool] = [
                true, true, true, true,
                false, false, false, false,
                false, false, false, false
            ]

            expect(styles.map { $0.isHalf }).to(equal(values))
        }

        // Rotation ------------

        it("can switch to style rotate left") {
            func rotate(_ style: KRTournamentViewStyle) -> KRTournamentViewStyle {
                var style = style
                style.rotateLeft()
                return style
            }

            expect(rotate(.left)).to(equal(.bottom))
            expect(rotate(.right)).to(equal(.top))
            expect(rotate(.top)).to(equal(.left))
            expect(rotate(.bottom)).to(equal(.right))
            expect(rotate(.leftRight(direction: .top))).to(equal(.topBottom(direction: .left)))
            expect(rotate(.leftRight(direction: .bottom))).to(equal(.topBottom(direction: .right)))
            expect(rotate(.topBottom(direction: .right))).to(equal(.leftRight(direction: .top)))
            expect(rotate(.topBottom(direction: .left))).to(equal(.leftRight(direction: .bottom)))
        }

        it("can switch to style rotate right") {
            func rotate(_ style: KRTournamentViewStyle) -> KRTournamentViewStyle {
                var style = style
                style.rotateRight()
                return style
            }

            expect(rotate(.left)).to(equal(.top))
            expect(rotate(.right)).to(equal(.bottom))
            expect(rotate(.top)).to(equal(.right))
            expect(rotate(.bottom)).to(equal(.left))
            expect(rotate(.leftRight(direction: .top))).to(equal(.topBottom(direction: .right)))
            expect(rotate(.leftRight(direction: .bottom))).to(equal(.topBottom(direction: .left)))
            expect(rotate(.topBottom(direction: .right))).to(equal(.leftRight(direction: .bottom)))
            expect(rotate(.topBottom(direction: .left))).to(equal(.leftRight(direction: .top)))
        }

        it("can switch to reversed style") {
            func reverse(_ style: KRTournamentViewStyle) -> KRTournamentViewStyle {
                var style = style
                style.reverse()
                return style
            }

            expect(reverse(.left)).to(equal(.right))
            expect(reverse(.right)).to(equal(.left))
            expect(reverse(.top)).to(equal(.bottom))
            expect(reverse(.bottom)).to(equal(.top))
            expect(reverse(.leftRight(direction: .top))).to(equal(.leftRight(direction: .bottom)))
            expect(reverse(.leftRight(direction: .bottom))).to(equal(.leftRight(direction: .top)))
            expect(reverse(.topBottom(direction: .right))).to(equal(.topBottom(direction: .left)))
            expect(reverse(.topBottom(direction: .left))).to(equal(.topBottom(direction: .right)))
        }
    }
}

// MARK: - KRTournamentViewStyle extensions ------------

extension KRTournamentViewStyle {
    static func getList() -> [KRTournamentViewStyle] {
        let directions: [FinalDirection] = [.left, .right, .top, .bottom]
        let allStyles: [KRTournamentViewStyle] = [.left, .right, .top, .bottom]
            + directions.map { .leftRight(direction: $0) }
            + directions.map { .topBottom(direction: $0) }
        return allStyles
    }
}
