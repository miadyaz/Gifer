//
//  SavedGifs.swift
//  Gifer
//
//  Created by miad yazeed on 24/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import CoreData

class SavedGifs: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var fetchedResultsController:NSFetchedResultsController<Gify>!
    let viewContext = AppDelegate.dataController.viewContext
    
    var selectedIndx = [IndexPath]()
    var insertedIndx: [IndexPath]!
    var deletedIndx: [IndexPath]!
    var updatedIndx: [IndexPath]!
    
    
    override func viewDidLoad() {
        setupFetchedResultsController()
//        setLayout(size: view.frame.size)
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        collectionView.reloadData()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        setLayout(size: size)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Gify> = Gify.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
}
extension SavedGifs : NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }

}

extension SavedGifs: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sectionInfo = self.fetchedResultsController.sections?[section] {
            if sectionInfo.numberOfObjects > 0 {
                collectionView.restore()
                return sectionInfo.numberOfObjects
            }else{
                collectionView.setEmptyMessage("There's no Gifs")
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedCell", for: indexPath) as! GifCell
        
        let gif = fetchedResultsController.object(at: indexPath)
        cell.image.image = UIImage.gifImageWithData( gif.image!)
        cell.backgroundColor = UIColor.clear.withAlphaComponent(0)
        cell.image.backgroundColor = UIColor.clear.withAlphaComponent(0)
        cell.backgroundView?.backgroundColor = UIColor.clear.withAlphaComponent(0)
        return cell
    }
    
//    fileprivate func setLayout(size:CGSize) {
//        let space : CGFloat = 3.0
//        let dimension = (view.frame.size.width - (space * 2) ) / 3.0
////        let height = (view.frame.size.height - (space * 2) ) / 3.0
//        flowLayout.minimumInteritemSpacing = space
//        flowLayout.minimumLineSpacing = space
//
//        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
//    }
    
    func generateLayout() -> UICollectionViewLayout {
            
         let fullPhotoItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
              widthDimension: .fractionalWidth(1.0),
              heightDimension: .fractionalWidth(2/3)))

          fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2)
            
            let mainItem = NSCollectionLayoutItem(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1.0)))

            mainItem.contentInsets = NSDirectionalEdgeInsets(
              top: 2,
              leading: 2,
              bottom: 2,
              trailing: 2)
            
            
            let pairItem = NSCollectionLayoutItem(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)))

            pairItem.contentInsets = NSDirectionalEdgeInsets(
              top: 2,
              leading: 2,
              bottom: 2,
              trailing: 2)

            let trailingGroup = NSCollectionLayoutGroup.vertical(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0)),
              subitem: pairItem,
              count: 2)

            let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(4/9)),
              subitems: [mainItem, trailingGroup])

          
          let section = NSCollectionLayoutSection(group: mainWithPairGroup)
          let layout = UICollectionViewCompositionalLayout(section: section)
            
          return layout
        
        
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndx = [IndexPath]()
        deletedIndx = [IndexPath]()
        updatedIndx = [IndexPath]()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        collectionView.performBatchUpdates({() -> Void in
            for indexPath in self.insertedIndx {
                self.collectionView.insertItems(at: [indexPath])
            }
            for indexPath in self.deletedIndx {
                self.collectionView.deleteItems(at: [indexPath])
            }
            for indexPath in self.updatedIndx {
                self.collectionView.reloadItems(at: [indexPath])
            }
        }, completion: nil)
    }
    
}
