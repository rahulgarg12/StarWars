//
//  SWFilmDetailViewController.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import UIKit

final class SWFilmDetailViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var textView: UITextView!
    
    //MARK: Properties
    var viewModel: SWFilmDetailViewModel!
    
    
    //MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = viewModel.film.openingCrawl
        title = viewModel.film.title
    }
}

