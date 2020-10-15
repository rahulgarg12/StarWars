//
//  SWDetailViewController.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import UIKit
import Combine

final class SWDetailViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
            tableView.refreshControl = refreshControl
            
            let cells = [SWDetailViewTableCell.self,
                         SWDetailViewFilmTableCell.self]
            tableView.register(cellTypes: cells)
            
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    //MARK: Properties
    var viewModel: SWDetailViewModel!
    
    lazy var refreshControl: UIRefreshControl = {
        let rControl = UIRefreshControl()
        rControl.attributedTitle = NSAttributedString(string: UITitle().refreshControlTitle)
        rControl.addTarget(self, action: #selector(refreshFreshData), for: .valueChanged)
        return rControl
    }()
    
    private lazy var cancellables = Set<AnyCancellable>()
    
    
    //MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBindings()
        initNavigationBar()
    }
    
    
    //MARK: Helper methods
    private func initNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        title = viewModel.dataModel?.name
    }
    
    private func initBindings() {
        viewModel.$dataModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                
                if Reachability.isConnected() {
                    self?.viewModel.film.removeAll()
                    
                    if let films = response?.films {
                        self?.fetchFilmData(films: Array(films))
                    }
                }
                
                self?.tableView.reloadData()
                
                if self?.refreshControl.isRefreshing == true {
                    self?.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$film
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                let section = IndexSet(integer: SWDetailViewControllerSection.films.rawValue)
                self?.tableView.reloadSections(section, with: .none)
            }
            .store(in: &cancellables)
    }
    
    
    //MARK: Network Helper Methods
    private func fetchData() {
        guard let urlString = viewModel.dataModel?.url else { return }
        
        viewModel.fetchData(urlPath: urlString)
            .mapError { [weak self] error -> Error in
                let alert = UIAlertController.getAlert(title: error.localizedDescription, message: nil)
                self?.present(alert, animated: true, completion: nil)
                return error
            }
            .sink(receiveCompletion: { _ in }) { [weak self] response in
                self?.viewModel.dataModel = response
            }
            .store(in: &cancellables)
    }
    
    private func fetchFilmData(films: [String]?) {
        for film in films ?? [] {
            guard !film.isEmpty else { continue }
            
            viewModel.fetchFilmData(urlString: film)
                .mapError { error -> Error in
                    return error
                }
                .sink(receiveCompletion: { _ in }) { [weak self] response in
                    self?.viewModel.film.append(response)
                }
                .store(in: &cancellables)
        }
    }
    
    //MARK: UI Helper Methods
    private func open(urlString: String?) {
        guard let urlString = urlString,
            let url = URL(string: urlString),
            UIApplication.shared.canOpenURL(url)
            else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func showFilmLandingView(film: SWFilmModel) {
        let filmDetailVC: SWFilmDetailViewController = SWFilmDetailViewController.loadFromNib()
        let filmDetailVM = SWFilmDetailViewModel(film: film)
        filmDetailVC.viewModel = filmDetailVM
        navigationController?.pushViewController(filmDetailVC, animated: true)
    }
    
    
    //MARK: Selector Methods
    @objc private func refreshFreshData() {
        if Reachability.isConnected() {
            fetchData()
        }
    }
}


//MARK:- UITableViewDelegate, UITableViewDataSource
extension SWDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getTableSectionsCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTableRowCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.getHeightForHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getHeightForRow(at: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.heightForFooter(in: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewModel.getTableHeaderView(section: section, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.getCell(at: indexPath, tableView: tableView)
        
        let section = SWDetailViewControllerSection(rawValue: indexPath.section)
        if section == .films, let filmCell = cell as? SWDetailViewFilmTableCell {
            filmCell.subject
                .receive(on: DispatchQueue.main)
                .sink { [weak self] action in
                    switch action {
                    case let .selected(film):
                        self?.showFilmLandingView(film: film)
                    }
                }.store(in: &filmCell.cancellables)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch SWDetailViewControllerSection(rawValue: indexPath.section) {
        case .name, .height, .mass, .hairColor, .skinColor, .eyeColor, .birthYear, .gender:
            return
        case .homeworld:
            open(urlString: viewModel.dataModel?.homeworld)
        case .films:
            open(urlString: viewModel.dataModel?.films[indexPath.row])
        case .species:
            open(urlString: viewModel.dataModel?.species[indexPath.row])
        case .vehicles:
            open(urlString: viewModel.dataModel?.vehicles[indexPath.row])
        case .starships:
            open(urlString: viewModel.dataModel?.starships[indexPath.row])
        case .created, .edited:
            return
        case .url:
            open(urlString: viewModel.dataModel?.url)
        default: return
        }
    }
}

