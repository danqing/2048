//
//  m2048UITests.swift
//  m2048UITests
//
//  Created by Xue Qin on 1/31/18.
//  Copyright © 2018 Danqing. All rights reserved.
//

import XCTest

class m2048UITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSettings() {
        
        
        app.buttons["Settings"].tap()
        let tablesQuery = app.tables
        // Game Type
        tablesQuery.staticTexts["Game Type"].tap()
        tablesQuery.staticTexts["Powers of 3"].tap()
        tablesQuery.staticTexts["Fibonacci"].tap()
        tablesQuery.staticTexts["Powers of 2"].tap()
        app.navigationBars["Game Type"].buttons["Settings"].tap()
        // Board Size
        tablesQuery.staticTexts["Board Size"].tap()
        tablesQuery.staticTexts["3 x 3"].tap()
        tablesQuery.staticTexts["5 x 5"].tap()
        tablesQuery.staticTexts["4 x 4"].tap()
        app.navigationBars["Board Size"].buttons["Back"].tap()

        // About
        tablesQuery.staticTexts["About 2048"].tap()
        app.navigationBars["About 2048"].buttons["Settings"].tap()
        
        app.navigationBars["Settings"].buttons["Done"].tap()
    }
    
    func testThemes() {
        
        let tablesQuery = app.tables
        
        // vibrant
        app.buttons["Settings"].tap()
        tablesQuery.staticTexts["Theme"].tap()
        tablesQuery.staticTexts["Vibrant"].tap()
        app.navigationBars["Theme"].buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons["Done"].tap()
        
        // joyful
        app.buttons["Settings"].tap()
        tablesQuery.staticTexts["Theme"].tap()
        tablesQuery.staticTexts["Joyful"].tap()
        app.navigationBars["Theme"].buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons["Done"].tap()
        
        // default
        app.buttons["Settings"].tap()
        tablesQuery.staticTexts["Theme"].tap()
        tablesQuery.staticTexts["Default"].tap()
        app.navigationBars["Theme"].buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons["Done"].tap()
    }
    
    func testPlayPowerOfTwo() {
        app.buttons["Settings"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Game Type"].tap()
        tablesQuery.staticTexts["Powers of 2"].tap()
        app.navigationBars["Game Type"].buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons["Done"].tap()
        
        app.swipeUp()
        app.swipeLeft()
        app.swipeDown()
        app.swipeRight()
        app.buttons["Restart"].tap()
    }
    
    func testPlayPowerOfThree() {
        app.buttons["Settings"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Game Type"].tap()
        tablesQuery.staticTexts["Powers of 3"].tap()
        app.navigationBars["Game Type"].buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons["Done"].tap()
        
        app.swipeUp()
        app.swipeLeft()
        app.swipeDown()
        app.swipeRight()
        app.buttons["Restart"].tap()
    }
    
    func testPlayFibonacci() {
        app.buttons["Settings"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Game Type"].tap()
        tablesQuery.staticTexts["Fibonacci"].tap()
        app.navigationBars["Game Type"].buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons["Done"].tap()
        
        app.swipeUp()
        app.swipeLeft()
        app.swipeDown()
        app.swipeRight()
        app.buttons["Restart"].tap()
    }
    
}
