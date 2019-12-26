// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "KRTournamentView",
    platforms: [.iOS(.v8)],
    products: [
        .library(
            name: "KRTournamentView",
            targets: ["KRTournamentView"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "KRTournamentView",
            dependencies: [],
            path: "KRTournamentView/Classes"
        ),
        .testTarget(
            name: "KRTournamentViewTests",
            dependencies: ["KRTournamentView"],
            path: "KRTournamentViewTests"
        ),
    ]
)
