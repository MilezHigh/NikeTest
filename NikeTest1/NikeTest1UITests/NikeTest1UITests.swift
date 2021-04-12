//
//  NikeTest1UITests.swift
//  NikeTest1UITests
//
//  Created by Miles Fishman on 3/6/21.
//

import XCTest

class NikeTest1UITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        
    }

    func testTopAlbumsSelectionFlow() throws {
        let app = XCUIApplication()
        app.launch()
        
        let albumTable = app.tables["TobAlbumsTableView"]
        XCTAssert(albumTable.exists)
        albumTable.swipeUp()
        albumTable.swipeDown()
        
        let cell = albumTable.cells.element(boundBy: 0)
        XCTAssert(cell.waitForExistence(timeout: 10))
        cell.tap()
        
        let albumImage = app.images["AlbumDetailImageView"]
        let scrollView = app.scrollViews["AlbumDetailScrollView"]
        let albumName = app.staticTexts["AlbumNameLabel"]
        let artistName = app.staticTexts["ArtistNameLabel"]
        let genre = app.staticTexts["AlbumGenreLabel"]
        let releaseDate = app.staticTexts["AlbumReleaseDateLabel"]
        let copyright = app.staticTexts["AlbumCopyrightLabel"]
        XCTAssert(
            albumImage.exists
                && scrollView.exists
                && albumName.exists
                && artistName.exists
                && genre.exists
                && releaseDate.exists
                && copyright.exists
        )
        scrollView.swipeUp()
        scrollView.swipeDown()
        
        let backButton = app.buttons["Back"]
        XCTAssert(backButton.exists)
        backButton.tap()
        
        XCTAssert(albumTable.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
