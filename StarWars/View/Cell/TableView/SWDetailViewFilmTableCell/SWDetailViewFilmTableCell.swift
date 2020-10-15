//
//  SWDetailViewFilmTableCell.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import UIKit
import Combine

final class SWDetailViewFilmTableCell: SWTableViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: SWDetailViewFilmCollectionCell.self)
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
            
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    //MARK: Properties
    var subject = PassthroughSubject<SWDetailViewCellAction, Never>()
    
    private var films = [SWFilmModel]()
    
    
    //MARK: Override Helpers
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        accessoryType = .none
    }
    
    //MARK: Helper Methods
    func set(films: [SWFilmModel]) {
        self.films = films
        
        collectionView.reloadData()
    }
}


//MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension SWDetailViewFilmTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: SWDetailViewFilmCollectionCell.self, for: indexPath)
        if films.count > indexPath.item {
            cell.set(data: films[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard films.count > indexPath.item else { return }
        
        let object = films[indexPath.item]
        subject.send(.selected(object))
    }
}


//MARK:- UICollectionViewDelegateFlowLayout
extension SWDetailViewFilmTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 100,
                      height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

