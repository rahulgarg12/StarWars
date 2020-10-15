//
//  SWListViewModel.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import Foundation

import UIKit
import Combine

final class SWListViewModel {
    lazy var isLastPageReached = false
    lazy var isAPIInProgress = false
    
    var nextPageUrl: String?
    @Published var peopleResult = [SWPeopleResultModel]()
    
    
    func loadCachedData() {
        guard let cachedData = DBHandler().getAllPeopleModels() else { return }
        
        let cachedDataArray = cachedData.toArray(type: SWPeopleResultModel.self)
        peopleResult = cachedDataArray
    }
    
    //MARK: Network Handlers
    func fetchData(path: String) -> AnyPublisher<SWPeopleModel, Error> {
        return NetworkHandler().run(url: path, headers: nil)
    }
}


//MARK: UITableView Helpers
extension SWListViewModel {
    func isFetchMoreFeeds(at indexPath: IndexPath) -> Bool {
        if peopleResult.count > 0,
            (peopleResult.count - 1) == indexPath.row,
            !isAPIInProgress,
            !isLastPageReached {
            return true
        } else {
            return false
        }
    }
    
    func getNumberOfSections() -> Int {
        return 1
    }
    
    func getNumberOfRows(in section: Int) -> Int {
        return peopleResult.count
    }
    
    func getHeightForRow(at indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func getCellForRow(at indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: SWListTableCell.self, for: indexPath)
        if peopleResult.count > indexPath.row {
            let object = peopleResult[indexPath.row]
            cell.set(people: object)
        }
        return cell
    }
}
