//
//  SWListViewController.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import UIKit
import Combine

final class SWListViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            
            tableView.register(cellType: SWListTableCell.self)
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.refreshControl = refreshControl
        }
    }
    
    
    //MARK: Properties
    var viewModel = SWListViewModel()
    
    lazy var refreshControl: UIRefreshControl = {
        let rControl = UIRefreshControl()
        rControl.attributedTitle = NSAttributedString(string: UITitle().refreshControlTitle)
        rControl.addTarget(self, action: #selector(refreshFreshData), for: .valueChanged)
        return rControl
    }()
    
    private lazy var cancellables = Set<AnyCancellable>()

    
    //MARK: Override Helpers
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initBindings()
        viewModel.loadCachedData()
        if Reachability.isConnected() {
            fetchData(path: API.people, isRemovePrevious: true)
        }
        initNavigationBar()
    }
    
    private func initNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = UITitle.ViewController().listView
    }
    
    private func initBindings() {
        viewModel.$peopleResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    
    //MARK: Network Handlers
    private func fetchData(path: String, isRemovePrevious: Bool = false) {
        viewModel.fetchData(path: path)
            .mapError { [weak self] error -> Error in
                let alert = UIAlertController.getAlert(title: error.localizedDescription, message: nil)
                self?.present(alert, animated: true, completion: nil)
                return error
            }
            .sink(receiveCompletion: { _ in }) { [weak self] response in
                if isRemovePrevious {
                    self?.viewModel.peopleResult.removeAll()
                }
                
                self?.viewModel.isAPIInProgress = false
                
                if let result = response.results {
                    self?.viewModel.peopleResult.append(contentsOf: result)
                    
                    self?.viewModel.isLastPageReached = result.isEmpty
                    
                    for model in result {
                        if let _ = DBHandler().getPeopleModel(for: model.url) {
//                            DBHandler().delete(key: model.url)
                        } else {
                            DBHandler().save(model: model)
                        }
                    }
                }
                
                self?.viewModel.nextPageUrl = response.next
                
                if self?.refreshControl.isRefreshing == true {
                    self?.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
    }


    //MARK: Selector Helpers
    @objc private func refreshFreshData() {
        if Reachability.isConnected(),
           !viewModel.isAPIInProgress {
            viewModel.isLastPageReached = false
            viewModel.peopleResult.removeAll()
            
            fetchData(path: API.people, isRemovePrevious: true)
        }
    }
}


//MARK:- UITableViewDelegate, UITableViewDataSource
extension SWListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getHeightForRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //pagination
        if viewModel.isFetchMoreFeeds(at: indexPath),
            let path = viewModel.nextPageUrl,
            !path.isEmpty {
            
            viewModel.isAPIInProgress = true
            fetchData(path: path)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.getCellForRow(at: indexPath, tableView: tableView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard viewModel.peopleResult.count > indexPath.row else { return }
        
        let detailsVC: SWDetailViewController = SWDetailViewController.loadFromNib()
        let detailVM = SWDetailViewModel(dataModel: viewModel.peopleResult[indexPath.row])
        detailsVC.viewModel = detailVM
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

