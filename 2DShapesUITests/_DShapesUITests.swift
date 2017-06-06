//
//  _DShapesUITests.swift
//  2DShapesUITests
//
//  Created by David Schwartz on 1/29/17.
//  Copyright © 2017 DDS Programming. All rights reserved.
//

import XCTest
//@testable import _DShapes

class _DShapesUITests: XCTestCase {
    
    override class func setUp() {
        print("TESTS BEGINNING!!!")
    }
    
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
    
    func testPoints() {
        XCUIApplication().textFields.allElementsBoundByIndex[0].click()
        
        for i in 0..<60 {
            XCUIApplication().typeKey("a", modifierFlags: .command)
            XCUIApplication().typeText("\(i)")
            XCUIApplication().buttons.allElementsBoundByIndex[0].click()
        }
    }
    
    func testExample() {
        
        super.measure {
            
        }
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
