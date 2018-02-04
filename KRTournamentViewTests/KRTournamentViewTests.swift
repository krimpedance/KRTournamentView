//
//  KRTournamentViewTests.swift
//  KRTournamentViewTests
//
//  Copyright © 2018 Krimpedance. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import KRTournamentView

class KRTournamentViewTests: QuickSpec {
    var view: KRTournamentView!

    override func spec() {
        describe("KRTournamentView") {
            beforeEach {
                self.view = KRTournamentView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
            }
            describe("Layout", closure: layoutSpec)
            describe("Properties", closure: propertiesSpec)
            describe("data reloading", closure: dataReloadingSpec)
        }
    }

    func layoutSpec() {
        KRTournamentViewStyle.testStyles.forEach { style in
            context("style is \(style)") {
                beforeEach {
                    self.view.style = style
                    self.view.updateLayout()
                    self.view.layoutIfNeeded()
                }

                it("drawingView is resized") {
                    expect(self.view.drawingView.frame).to(equal(style.drawingViewFrame))
                }

                it("firstEntriesView is resized") {
                    expect(self.view.firstEntriesView.frame).to(equal(style.firstEntriesViewFrame))
                }

                it("secondEntriesView is resized") {
                    expect(self.view.secondEntriesView.frame).to(equal(style.secondEntriesViewFrame))
                }
            }
        }
    }

    func propertiesSpec() {
        beforeEach {
            self.view.updateLayout()
            self.view.layoutIfNeeded()
        }

        it("style is \(Default.style)") {
            expect(self.view.style).to(equal(Default.style))
        }

        it("numberOfLayers is \(Default.numberOfLayers)") {
            expect(self.view.numberOfLayers).to(equal(Default.numberOfLayers))
        }

        it("entrySize is \(Default.entrySize(with: Default.style))") {
            expect(self.view.entrySize).to(equal(Default.entrySize(with: Default.style)))
        }

        it("lineColor is drawingView.lineColor") {
            expect(self.view.lineColor).to(equal(self.view.drawingView.lineColor))
        }

        it("preferredLineColor is drawingView.preferredLineColor") {
            expect(self.view.preferredLineColor).to(equal(self.view.drawingView.preferredLineColor))
        }

        it("lineWidth is drawingView.lineWidth") {
            expect(self.view.lineWidth).to(equal(self.view.drawingView.lineWidth))
        }

        it("preferredLineWidth is drawingView.preferredLineWidth") {
            expect(self.view.preferredLineWidth).to(beNil())
        }

        it("fixOrientation is \(Default.fixOrientation)") {
            expect(self.view.fixOrientation).to(equal(Default.fixOrientation))
        }

        context("when value is changed") {
            it("drawingView.lineColor changes") {
                self.view.lineColor = .green
                expect(self.view.drawingView.lineColor).to(equal(UIColor.green))
            }

            it("drawingView.preferredLineColor changes") {
                self.view.preferredLineColor = .orange
                expect(self.view.drawingView.preferredLineColor).to(equal(UIColor.orange))
            }

            it("drawingView.lineWidth changes") {
                self.view.lineWidth = 10
                expect(self.view.drawingView.lineWidth).to(equal(10))
            }

            it("drawingView.preferredLineWidth changes") {
                self.view.preferredLineWidth = 20
                expect(self.view.drawingView.preferredLineWidth).to(equal(20))
            }
        }
    }

    func dataReloadingSpec() {
        let testData: [(layers: Int, excludes: [Int], entries: Int, matches: Int)] = [
            (2, [], 4, 3),
            (3, [2, 3, 6], 5, 4)
        ]

        testData.forEach { layers, excludes, entries, matches in
            context("when numberOfLayers is \(layers) and excludes is \(excludes)") {
                let dataSource = KRTournamentViewDataSourceMock(numberOfLayers: layers, excludes: excludes)

                beforeEach {
                    self.view.updateLayout()
                    self.view.layoutIfNeeded()
                    self.view.dataSource = dataSource
                    self.view.reloadData()
                    self.view.layoutIfNeeded()
                }

                it("entriesView.entries count is \(entries)") {
                    expect(self.view.firstEntriesView.entries.count).to(equal(entries))
                }

                it("drawingView.matches count is \(matches)") {
                    expect(self.view.drawingView.matches.count).to(equal(matches))
                }
            }
        }
    }
}

// MARK: - KRTournamentViewDataSource mock -------------------

class KRTournamentViewDataSourceMock: KRTournamentViewDataSource {
    let numberOfLayers: Int
    let excludes: [Int]

    init(numberOfLayers: Int = Default.numberOfLayers, excludes: [Int] = []) {
        self.numberOfLayers = numberOfLayers
        self.excludes = excludes
    }

    func numberOfLayers(in tournamentView: KRTournamentView) -> Int {
        return numberOfLayers
    }

    func tournamentView(_ tournamentView: KRTournamentView, entryAt index: Int) -> KRTournamentViewEntry? {
        if excludes.contains(index) { return nil }
        return Default.tournamentViewEntry
    }

    func tournamentView(_ tournamentView: KRTournamentView, matchAt matchPath: MatchPath) -> KRTournamentViewMatch {
        return Default.tournamentViewMatch
    }
}

// MARK: - KRTournamentStyle extension -------------------

private extension KRTournamentViewStyle {
    static let testStyles = [KRTournamentViewStyle]([.left, .right, .top, .bottom, .leftRight(direction: .top), .topBottom(direction: .right)])

    var drawingViewFrame: CGRect {
        let entrySize = Default.entrySize(with: self)
        switch self {
        case .left:
            return CGRect(x: entrySize.width + 5, y: 0, width: 500 - entrySize.width - 10, height: 500)
        case .right:
            return CGRect(x: 5, y: 0, width: 500 - entrySize.width - 10, height: 500)
        case .top:
            return CGRect(x: 0, y: entrySize.height + 5, width: 500, height: 500 - entrySize.height - 10)
        case .bottom:
            return CGRect(x: 0, y: 5, width: 500, height: 500 - entrySize.height - 10)
        case .leftRight:
            return CGRect(x: entrySize.width + 5, y: 0, width: 500 - (entrySize.width * 2) - 10, height: 500)
        case .topBottom:
            return CGRect(x: 0, y: entrySize.height + 5, width: 500, height: 500 - (entrySize.height * 2) - 10)
        }
    }

    var firstEntriesViewFrame: CGRect {
        let entrySize = Default.entrySize(with: self)
        switch self {
        case .left:
            return CGRect(x: 0, y: 0, width: entrySize.width, height: 500)
        case .right:
            return CGRect(x: 0, y: 0, width: 0, height: 500)
        case .top:
            return CGRect(x: 0, y: 0, width: 500, height: entrySize.height)
        case .bottom:
            return CGRect(x: 0, y: 0, width: 500, height: 0)
        case .leftRight:
            return CGRect(x: 0, y: 0, width: entrySize.width, height: 500)
        case .topBottom:
            return CGRect(x: 0, y: 0, width: 500, height: entrySize.height)
        }
    }

    var secondEntriesViewFrame: CGRect {
        let entrySize = Default.entrySize(with: self)
        switch self {
        case .left:
            return CGRect(x: 500, y: 0, width: 0, height: 500)
        case .right:
            return CGRect(x: 500 - entrySize.width, y: 0, width: entrySize.width, height: 500)
        case .top:
            return CGRect(x: 0, y: 500, width: 500, height: 0)
        case .bottom:
            return CGRect(x: 0, y: 500 - entrySize.height, width: 500, height: entrySize.height)
        case .leftRight:
            return CGRect(x: 500 - entrySize.width, y: 0, width: entrySize.width, height: 500)
        case .topBottom:
            return CGRect(x: 0, y: 500 - entrySize.height, width: 500, height: entrySize.height)
        }
    }
}
