//
//  tryTests.swift
//  tryTests
//
//  Created by Sandeep Guliani on 10/5/20.
//

import XCTest

@testable import try1

class tryTests: XCTestCase {

    var sut: FileTableViewController!
    var ModelTestStuff: ModelTest!
    var DataFile: DataTableView!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test2() throws {
        XCTAssertEqual(1,1, "It Fails")
    }
    
    func test3() throws {
        XCTAssertEqual(1,1, "It Fails")
    }
    
    func testCoreData() throws {
        ModelTestStuff = ModelTest()
        ModelTestStuff.deleteCoreData()
        XCTAssertEqual(ModelTestStuff.forTestingCallCoreData(),0, "It Fails")
    }
    
    func testServerCall() throws {
        currentUsername = "test10@gmail.com"
        sut = FileTableViewController()
        let dictionary = sut.recieveZipNameDict()
        let count = Int(dictionary["Count"]!)
        XCTAssertEqual(2,count,"It Failed")
    }
    
    func testImageServerCall() throws {
        currentUsername = "test10@gmail.com"
        let DataFile = DataTableView()
        let dictionary = DataFile.recieveImageNameDict("Acura_Integra_Type_R_2001")
        XCTAssertEqual(dictionary.count, 44)
    }
    
    /*
    func testServerCall() throws {
        currentUsername = "test10@gmail.com"
        var DictString = ""
        let semaphore = DispatchSemaphore(value: 0)
        GETZipNames() { output in
            DictString = output
            semaphore.signal()
        }
        semaphore.wait()
        print(DictString)
        let jsonData = DictString.data(using: .utf8)!
        let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData)
        
        var count = 0
        if let dictionary = jsonDictionary as? [String: String] {
            var zipNameList = [String: Int]()
            count = Int(dictionary["Count"]!)!
            /*
            for i in 0...count {
                let zipName = dictionary["Data_" + String(i) + "_name"] ?? ""
                let finished = dictionary["Data_" + String(i) + "_saved"] ?? ""
                let Date = dictionary["Date"] ?? ""
            */
        }
        XCTAssertEqual(2,count,"It Failed")
    }
    */

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
