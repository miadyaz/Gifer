//
//  CollectionView+ContexMenu.swift
//  Gifer
//
//  Created by miad yazeed on 24/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//
import UIKit

extension ViewController {
    
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return self.makeContextMenu(for: indexPath)
        })
    }
    
    @available(iOS 13.0, *)
    func makeContextMenu(for index:IndexPath) -> UIMenu {
        
        var actions = [UIAction]()
        
        let contextMenuItems = [
            ContextMenuItem(title: "Share", image: UIImage(systemName: "square.and.arrow.up")!, index: 0),
            ContextMenuItem(title: "Add To Favorites", image: UIImage(systemName: "star")!, index: 1)
        ]
        
        for item in contextMenuItems {
            let action = UIAction(title: item.title, image: item.image, identifier: nil, discoverabilityTitle: nil) { _ in
                self.didSelectContextMenu(item: item, cellIndex: index)
            }
            actions.append(action)
        }
        let cancel = UIAction(title: "Cancel", attributes: .destructive) { _ in}
        actions.append(cancel)
        return UIMenu(title: "", children: actions)
    }
    
    private func didSelectContextMenu(item: ContextMenuItem, cellIndex: IndexPath){
        let gif = gifs[cellIndex.item]
        switch item.index {
        case 0: //share
            shareGif(gif)
        case 1: //Favorites
            addToFavorites(gif)
        default:
            print("default")
        }
    }
    
    struct ContextMenuItem {
        var title = ""
        var image = UIImage()
        var index = 0
    }
    
    func shareGif(_ gif:Gif){
        let url: URL = URL(string: gif.original)!
        let animatedGIF = NSData(contentsOf: url)!
        let itemsToShare = [animatedGIF]
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                //                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func addToFavorites(_ gif:Gif){
        let newGif = Gify(context: viewContext)
        newGif.id = gif.id
        newGif.image = try! Data(contentsOf: URL(string: gif.original)!)
        newGif.nanoURL = gif.nano
        newGif.originalURL = gif.original
        
        try! viewContext.save()
        
        let vc = UIAlertController(title: "Gif Saved :)", message: nil, preferredStyle: .alert)
        present(vc, animated: true) {
            sleep(3)
            vc.dismiss(animated: true)
        }
        
    }
}

extension SavedGifs{
    
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return self.makeContextMenu(for: indexPath)
        })
    }
    
    @available(iOS 13.0, *)
    func makeContextMenu(for index:IndexPath) -> UIMenu {
        
        var actions = [UIAction]()
        
        let contextMenuItems = [
            ContextMenuItem(title: "Share", image: UIImage(systemName: "square.and.arrow.up")!, index: 0),
            ContextMenuItem(title: "Delete", image: UIImage(systemName: "trash")!, index: 1)
        ]
        
        for item in contextMenuItems {
            let action = UIAction(title: item.title, image: item.image, identifier: nil, discoverabilityTitle: nil,attributes: item.index == 0 ?.init():.destructive) { _ in
                self.didSelectContextMenu(item: item, cellIndex: index)
            }
            actions.append(action)
        }
        
        return UIMenu(title: "", children: actions)
    }
    
    private func didSelectContextMenu(item: ContextMenuItem, cellIndex: IndexPath){
        let gif = fetchedResultsController.object(at: cellIndex)
        switch item.index {
        case 0: //share
            shareGify(gif)
        case 1: //Delete
            remove(gif)
        default:
            print("default")
        }
    }
    
    struct ContextMenuItem {
        var title = ""
        var image = UIImage()
        var index = 0
    }
    
    func shareGify(_ gif:Gify){
        
        let url: URL = URL(string: gif.originalURL!)!
        let animatedGIF = NSData(contentsOf: url)!
        let itemsToShare = [animatedGIF]
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                //                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func remove(_ gif: Gify){
       
       viewContext.delete(gif)
        try? viewContext.save()
        
        collectionView.reloadData()
        
        let vc = UIAlertController(title: "Gif Removed", message: nil, preferredStyle: .alert)
        present(vc, animated: true) {
            sleep(2)
            vc.dismiss(animated: true)
        }
        
    }
}
