//
//  ListViewControllerTests.swift
//  StarWarsTests
//
//  Created by Rahul Garg on 15/10/20.
//

import XCTest
@testable import StarWars

class ListViewControllerTests: XCTestCase {
    
    var listVC: SWListViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        listVC = storyboard.instantiateViewController(identifier: SWListViewController.className)
        listVC.viewModel = SWListViewModel()
        listVC.loadViewIfNeeded()
    }
    
    override func tearDown() {
        listVC = nil
        super.tearDown()
    }
    
    func testViewController() {
        XCTAssertNotNil(listVC, "No View Controller Available")
    }
    
    func testTableView() {
        XCTAssertNotNil(listVC.tableView, "View Controller should have a tableview")
    }

    func testTableViewDelegate() {
        XCTAssertNotNil(listVC.tableView.delegate, "TableView should have a delegate")
    }

    func testTableViewDatasource() {
        XCTAssertNotNil(listVC.tableView.dataSource, "TableView should have a datasource")
    }

    func testSearchRefreshControl() {
        XCTAssertNotNil(listVC.refreshControl, "Refresh Control is nil")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}



