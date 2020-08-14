//
//  GnomeDetailViewController.swift
//  testing
//
//  Created by Familia Fonseca López on 06/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import UIKit

class GnomeDetailViewController: UIViewController,Storyboarded {

    @IBOutlet weak var gnomeName : UILabel!
    weak var detailcoordinator: GnomeDetailCoordinator?
    var selectedGnome : Gnome?
    var allGnomes : [Gnome]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedGnome?.name ?? "Gnome detail"
        addCollectionDetail()
    }
    
    fileprivate func addCollectionDetail(){ 
        let parallaxCollectionView = GnomeDetailCollectionViewController.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.addChild(parallaxCollectionView)
        view.addSubview(parallaxCollectionView.view)
        
        let headerImageView = UIImageView()
//        let blur : UIView = UIView()
        headerImageView.asyncImage(from: selectedGnome?.thumbnail)
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        headerImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
//        blur.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 140)
//        blur.addBlur(style: .prominent)
//        headerImageView.addSubview(blur)
        view.addSubview(headerImageView)
        parallaxCollectionView.detailDelegate = self
        parallaxCollectionView.headerImageView = headerImageView
        parallaxCollectionView.gnomes = allGnomes ?? []
        parallaxCollectionView.gnomeDetail = selectedGnome
    }
}

extension GnomeDetailViewController : GnomeDetailProtocol {
    func goToFriendDetail(selectedGnome:Gnome){
        detailcoordinator?.parentCoordinator?.gnomeDetail(selectedGnome: selectedGnome, allGnomes: allGnomes ?? [])
    }
}
