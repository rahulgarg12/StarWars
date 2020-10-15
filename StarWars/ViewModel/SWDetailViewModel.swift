//
//  SWDetailViewModel.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import UIKit
import Combine

final class SWDetailViewModel {
    @Published var dataModel: SWPeopleResultModel?
    @Published var film = [SWFilmModel]()
    
    private var sectionHeaderHeight: CGFloat = 30
    
    
    init(dataModel: SWPeopleResultModel) {
        self.dataModel = dataModel
    }
    
    
    //MARK: Network Helpers
    func fetchData(urlPath: String) -> AnyPublisher<SWPeopleResultModel, Error> {
        return NetworkHandler().run(url: urlPath, headers: nil)
    }
    
    func fetchFilmData(urlString: String) -> AnyPublisher<SWFilmModel, Error> {
        return NetworkHandler().run(url: urlString, headers: nil)
    }
}


//MARK:- Table Helpers
extension SWDetailViewModel {
    func getTableSectionsCount() -> Int {
        return SWDetailViewControllerSection.allCases.count
    }
    
    func getTableRowCount(for section: Int) -> Int {
        switch SWDetailViewControllerSection(rawValue: section) {
        case .name, .height, .mass, .hairColor, .skinColor, .eyeColor, .birthYear, .gender, .homeworld:
            return dataModel == nil ? 0 : 1
        case .films:
            if Reachability.isConnected(), let films = dataModel?.films, !films.isEmpty {
                return 1
            }
            return 0
        case .species:
            return dataModel?.species.count ?? 0
        case .vehicles:
            return dataModel?.vehicles.count ?? 0
        case .starships:
            return dataModel?.starships.count ?? 0
        case .created, .edited, .url:
            return dataModel == nil ? 0 : 1
        default:
            return 0
        }
    }
    
    private func getFormattedDate(from date: String?) -> String? {
        guard let date = date else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatterFormat().remote
        dateFormatter.timeZone = TimeZone.current

        if let date = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = DateFormatterFormat().local
            
            let dateString = dateFormatter.string(from: date)
            return dateString
        }
        
        return nil
    }
    
    func getHeightForHeader(in section: Int) -> CGFloat {
        if dataModel == nil {
            return .leastNormalMagnitude
        }
        
        switch SWDetailViewControllerSection(rawValue: section) {
        case .name:
            if let name = dataModel?.name, !name.isEmpty {
                return sectionHeaderHeight
            }
        case .height:
            if let height = dataModel?.height, !height.isEmpty {
                return sectionHeaderHeight
            }
        case .mass:
            if let mass = dataModel?.mass, !mass.isEmpty {
                return sectionHeaderHeight
            }
        case .hairColor:
            if let hairColor = dataModel?.hairColor, !hairColor.isEmpty {
                return sectionHeaderHeight
            }
        case .skinColor:
            if let skinColor = dataModel?.skinColor, !skinColor.isEmpty {
                return sectionHeaderHeight
            }
        case .eyeColor:
            if let eyeColor = dataModel?.eyeColor, !eyeColor.isEmpty {
                return sectionHeaderHeight
            }
        case .birthYear:
            if let birthYear = dataModel?.birthYear, !birthYear.isEmpty {
                return sectionHeaderHeight
            }
        case .gender:
            if let gender = dataModel?.gender, !gender.isEmpty {
                return sectionHeaderHeight
            }
        case .homeworld:
            if let homeworld = dataModel?.homeworld, !homeworld.isEmpty {
                return sectionHeaderHeight
            }
        case .films:
            if Reachability.isConnected(), let films = dataModel?.films, !films.isEmpty {
                return sectionHeaderHeight
            }
        case .species:
            if let species = dataModel?.species, !species.isEmpty {
                return sectionHeaderHeight
            }
        case .vehicles:
            if let vehicles = dataModel?.vehicles, !vehicles.isEmpty {
                return sectionHeaderHeight
            }
        case .starships:
            if let starships = dataModel?.starships, !starships.isEmpty {
                return sectionHeaderHeight
            }
        case .created:
            if let created = dataModel?.created, !created.isEmpty {
                return sectionHeaderHeight
            }
        case .edited:
            if let edited = dataModel?.edited, !edited.isEmpty {
                return sectionHeaderHeight
            }
        case .url:
            if let url = dataModel?.url, !url.isEmpty {
                return sectionHeaderHeight
            }
        default:
            break
        }
        
        return .leastNormalMagnitude
    }
    
    func getHeightForRow(at section: Int) -> CGFloat {
        let section = SWDetailViewControllerSection(rawValue: section)
        if section == .films {
            if Reachability.isConnected(), let films = dataModel?.films, !films.isEmpty {
                return 110
            } else {
                return .leastNormalMagnitude
            }
        }
        
        return UITableView.automaticDimension
    }
    
    func getTableHeaderView(section: Int, tableView: UITableView) -> UIView? {
        if dataModel == nil {
            return nil
        }
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemBackground
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight)
        
        let headerLabel = UILabel()
        headerLabel.frame = CGRect(x: 30, y: 15, width: headerView.bounds.width - sectionHeaderHeight, height: 15)
        headerLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        headerLabel.textColor = UIColor.label
        headerLabel.text = SWDetailViewControllerSection(rawValue: section)?.title
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func heightForFooter(in section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func getCell(at indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let section = SWDetailViewControllerSection(rawValue: indexPath.section)
        if section == .films {
            let filmCell = getFilmTableCell(for: indexPath, tableView: tableView)
            return filmCell
        }
        
        let titleCell = getHeadingTableCell(for: indexPath, tableView: tableView, section: section)
        return titleCell
    }
    
    private func getFilmTableCell(for indexPath: IndexPath, tableView: UITableView) -> SWDetailViewFilmTableCell {
        let cell = tableView.dequeueReusableCell(with: SWDetailViewFilmTableCell.self, for: indexPath)
        cell.set(films: film)
        return cell
    }
    
    private func getHeadingTableCell(for indexPath: IndexPath, tableView: UITableView, section: SWDetailViewControllerSection?) -> SWDetailViewTableCell {
        
        let cell = tableView.dequeueReusableCell(with: SWDetailViewTableCell.self, for: indexPath)
        
        switch section {
        case .name:
            cell.set(title: dataModel?.name?.capitalized)
        case .height:
            cell.set(title: dataModel?.height)
        case .mass:
            cell.set(title: dataModel?.mass)
        case .hairColor:
            cell.set(title: dataModel?.hairColor?.capitalized)
        case .skinColor:
            cell.set(title: dataModel?.skinColor?.capitalized)
        case .eyeColor:
            cell.set(title: dataModel?.eyeColor?.capitalized)
        case .birthYear:
            cell.set(title: dataModel?.birthYear)
        case .gender:
            cell.set(title: dataModel?.gender?.capitalized)
        case .homeworld:
            cell.set(title: dataModel?.homeworld?.capitalized)
        case .species:
            if let species = dataModel?.species, species.count > indexPath.row {
                cell.set(title: species[indexPath.row])
            }
        case .vehicles:
            if let vehicles = dataModel?.vehicles, vehicles.count > indexPath.row {
                cell.set(title: vehicles[indexPath.row])
            }
        case .starships:
            if let starships = dataModel?.starships, starships.count > indexPath.row {
                cell.set(title: starships[indexPath.row])
            }
        case .created:
            let date = getFormattedDate(from: dataModel?.created)
            cell.set(title: date)
        case .edited:
            let date = getFormattedDate(from: dataModel?.edited)
            cell.set(title: date)
        case .url:
            cell.set(title: dataModel?.url)
        default:
            break
        }
        
        switch section {
        case .homeworld, .species, .vehicles, .starships, .url:
            cell.accessoryType = .disclosureIndicator
        default:
            cell.accessoryType = .none
        }
        
        return cell
    }
}
