//
//  PersonTests.swift
//  MeetXSweat
//
//  Created by Mohamed BOUMANSOUR on 7/31/17.
//  Copyright © 2017 Mohamed BOUMANSOUR. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import MeetXSweat

private let kTestCreatePersonOnDataBasedExpectation = "CreatePersonOnDataBase expectation"

private let kGetRewardSummaryDetailsTimeOut = 10.0
private let kStubsHeader    = ["Content-Type":"application/json"]

private let kPersonHostUrl  = "https://fir-meetxsweat.firebaseio.com/person-items/email:toto@toto.fr"


private let kPersonJsonMockFile = "TotoPerson.json"



class PersonTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        stub(condition: isHost(kPersonHostUrl)) { _ in
            
            let stubPath = OHPathForFile(kPersonJsonMockFile, type(of: self))
            return fixture(filePath: stubPath!, headers: kStubsHeader)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testCreatePersonOnDataBase() {
        
        // Given 
        let email = "toto@toto.fr"
        
        // When
        let person = Person()
        person.email = email
        
        let requestExpectation = self.expectation(description: kTestCreatePersonOnDataBasedExpectation)
        person.createPersonOnDataBase { (done) in
            
            XCTAssertTrue(done, "failed")
            XCTAssertTrue(person.name=="toto", "person not updated")
            requestExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: kGetRewardSummaryDetailsTimeOut, handler:nil)
    }
    
}
