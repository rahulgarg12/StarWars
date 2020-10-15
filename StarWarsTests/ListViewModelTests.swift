//
//  ListViewModelTests.swift
//  StarWarsTests
//
//  Created by Rahul Garg on 15/10/20.
//

import XCTest
@testable import StarWars

class ListViewModelTests: XCTestCase {
    
    var listViewModel: SWListViewModel!
    
    override func setUp() {
        super.setUp()
        
        listViewModel = SWListViewModel()
    }
    
    func testGetAllBookmark() {
        XCTAssertNotNil(listViewModel.loadCachedData(), "Load Cached Data error")
    }
    
    func testResponseApi() {
        var peopleModel: SWPeopleModel?
        var peopleResultModel: [SWPeopleResultModel]?
        
        let exp = self.expectation(description: "myExpectation")
        
        let cancellable = listViewModel.fetchData(path: API.people)
            .sink(receiveCompletion: { _ in }) { response in
                peopleModel = response
                peopleResultModel = response.results
                exp.fulfill()
            }
        
        XCTAssertNotNil(cancellable, "Cancellable is nil")
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(peopleModel, "People Model is nil")
            XCTAssertNotNil(peopleResultModel, "People Result Model is nil")
        }
    }
//    
    override func tearDown() {
        listViewModel = nil
        super.tearDown()
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

