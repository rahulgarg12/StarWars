//
//  DetailViewControllerTests.swift
//  StarWarsTests
//
//  Created by Rahul Garg on 15/10/20.
//

import XCTest
@testable import StarWars

class DetailViewControllerTests: XCTestCase {
    
    var detailVC: SWDetailViewController!
    
    override func setUp() {
        super.setUp()
        
        detailVC = SWDetailViewController.loadFromNib()
        detailVC.viewModel = SWDetailViewModel(dataModel: SWPeopleResultModel())
        detailVC.loadViewIfNeeded()
    }
    
    override func tearDown() {
        detailVC = nil
        super.tearDown()
    }
    
    func testViewController() {
        XCTAssertNotNil(detailVC, "No View Controller Available")
    }
    
    func testTableView() {
        XCTAssertNotNil(detailVC.tableView, "View Controller should have a tableview")
    }

    func testTableViewDelegate() {
        XCTAssertNotNil(detailVC.tableView.delegate, "TableView should have a delegate")
    }

    func testTableViewDatasource() {
        XCTAssertNotNil(detailVC.tableView.dataSource, "TableView should have a datasource")
    }

    func testSearchRefreshControl() {
        XCTAssertNotNil(detailVC.refreshControl, "Refresh Control is nil")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}




