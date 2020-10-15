//
//  SWDetailViewFilmCollectionCell.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import UIKit

final class SWDetailViewFilmCollectionCell: SWCollectionViewCell {
    //MARK: IBOutlets
    @IBOutlet private weak var mainContentView: UIView! {
        didSet {
            mainContentView.layer.cornerRadius = 8
            mainContentView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var directorLabel: UILabel!
    @IBOutlet private weak var producerLabel: UILabel!
    @IBOutlet private weak var openingCrawlLabel: UILabel!
    
    
    //MARK: Override Helpers
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    //MARK: Helper Methods
    func set(data: SWFilmModel) {
        if let title = data.title, !title.isEmpty {
            titleLabel.text = "Title: \(title)"
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }
        
        if let director = data.director, !director.isEmpty {
            directorLabel.text = "Director: \(director)"
            directorLabel.isHidden = false
        } else {
            directorLabel.isHidden = true
        }
        
        if let producer = data.producer, !producer.isEmpty {
            producerLabel.text = "Producer: \(producer)"
            producerLabel.isHidden = false
        } else {
            producerLabel.isHidden = true
        }
        
        if let openingCrawl = data.openingCrawl, !openingCrawl.isEmpty {
            openingCrawlLabel.text = "Opening Crawl Count: \(openingCrawl.count) characters"
            openingCrawlLabel.isHidden = false
        } else {
            openingCrawlLabel.isHidden = true
        }
    }
}

