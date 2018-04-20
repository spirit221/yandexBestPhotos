//
//  ViewController.swift
//  TestTask
//
//  Created by Sergey Gusev on 14.04.2018.
//  Copyright © 2018 Sergey Gusev. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    let cellID = "collectionViewCell"
    var photos: [Photo] = []
    let getPhoto = GetPhoto()
    let coreDataGetting = CoreDataGetting()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Best Photos of Yandex"
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        getTop()
    }
    
    @IBAction func update(_ sender: UIButton) {
        getTop()
    }
    
    func getTop() {
        photos.removeAll()
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.startAnimating()
        
        if Connectivity.isConnectedToInternet {
            getPhoto.download() { [weak self] photo in
                self?.activityIndicator.removeFromSuperview()
                self?.photos = photo
                self?.collectionView.reloadData()
                self?.coreDataGetting.delete()
                
                self?.coreDataGetting.save(photo: photo)
            }
        } else {
            DispatchQueue.main.async {
            self.photos = self.coreDataGetting.getData()
            self.activityIndicator.removeFromSuperview()
            self.collectionView.reloadData()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? CollectionViewCell
        cell?.commonInit(data: photos[indexPath.item].binaryPhoto)
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let secondViewController = SecondViewController()
        
        secondViewController.commonInit(image: photos[indexPath.item].binaryPhoto)
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
}

