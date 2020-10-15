//
//  DetailViewModelTests.swift
//  StarWarsTests
//
//  Created by Rahul Garg on 15/10/20.
//

import XCTest
@testable import StarWars

class DetailViewModelTests: XCTestCase {
    
    var detailViewModel: SWDetailViewModel!
    
    override func setUp() {
        super.setUp()
        
        detailViewModel = SWDetailViewModel(dataModel: SWPeopleResultModel())
    }
    
    func testModelResponseApi() {
        var peopleResultModel: SWPeopleResultModel?
        
        let exp = self.expectation(description: "myExpectation")
        
        let cancellable = detailViewModel.fetchData(urlPath: "http://swapi.dev/api/people/3/")
            .sink(receiveCompletion: { _ in }) { response in
                peopleResultModel = response
                exp.fulfill()
            }
        
        XCTAssertNotNil(cancellable, "Cancellable is nil")
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(peopleResultModel, "People Result Model is nil")
        }
    }

    func testFilmResponseApi() {
        var filmModel: SWFilmModel?
        
        let exp = self.expectation(description: "myExpectation")
        
        let cancellable = detailViewModel.fetchFilmData(urlString: "http://swapi.dev/api/films/1/")
            .sink(receiveCompletion: { _ in }) { response in
                filmModel = response
                exp.fulfill()
            }
        
        XCTAssertNotNil(cancellable, "Cancellable is nil")
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(filmModel, "Film Model is nil")
        }
    }
    
    override func tearDown() {
        detailViewModel = nil
        super.tearDown()
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}


