//
//  PathSetTests.swift
//  KRTournamentView
//
//  Copyright © 2019 Krimpedance. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class PathSetTests: QuickSpec {
    override func spec() {
        let rect1 = CGRect(x: 0, y: 0, width: 50, height: 50)
        let rect2 = CGRect(x: 50, y: 50, width: 50, height: 50)

        var path1: UIBezierPath!
        var path2: UIBezierPath!
        var pathSet: PathSet!

        beforeEach {
            path1 = UIBezierPath(rect: rect1)
            path2 = UIBezierPath(rect: rect2)
            pathSet = PathSet(path: path1, winnerPath: path2)
        }

        it("can be initialized") {
            expect(pathSet.path).to(be(path1))
            expect(pathSet.winnerPath).to(be(path2))
        }

        it("has subscript") {
            expect(pathSet[false]).to(be(path1))
            expect(pathSet[true]).to(be(path2))
        }

        it("can append other PathSet instance") {
            let path3 = UIBezierPath(rect: .init(x: 50, y: 0, width: 50, height: 50))
            let path4 = UIBezierPath(rect: .init(x: 0, y: 50, width: 50, height: 50))
            let pathSet2 = PathSet(path: path3, winnerPath: path4)

            pathSet.append(pathSet2)

            let joinedPath1 = UIBezierPath(rect: rect1)
            joinedPath1.append(path3)

            let joinedPath2 = UIBezierPath(rect: rect2)
            joinedPath2.append(path4)

            expect(pathSet.path).to(equal(joinedPath1))
            expect(pathSet.winnerPath).to(equal(joinedPath2))
        }
    }
}
