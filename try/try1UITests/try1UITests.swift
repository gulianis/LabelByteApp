//
//  try1UITests.swift
//  try1UITests
//
//  Created by Sandeep Guliani on 10/6/20.
//

import XCTest

class try1UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
                

        let nameTextField = app.textFields["Email"]
        nameTextField.tap()
        nameTextField.typeText("test10@gmail.com")
        let passwordTextField = app.secureTextFields["Password"]
        
        UIPasteboard.general.string = "1234cool"
        passwordTextField.press(forDuration: 1.1)
        app.menuItems["Paste"].tap()
        //UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        app.buttons["Log In"].tap()
        
        sleep(10)
        

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    /*
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    */
}
