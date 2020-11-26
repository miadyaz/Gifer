//
//  ViewController.swift
//  Gifer
//
//  Created by miad yazeed on 23/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet var collectionView : UICollectionView!
    @IBOutlet var indicator : UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var gifs = [Gif]()
    var filteredData = [String]()
    let viewContext = AppDelegate.dataController.viewContext
    var searchRequest: DataRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
        getGifs()
        collectionView.collectionViewLayout = generateLayout()
        
    }
    
    
    func getGifs(by text: String = ""){
        
        gifs.removeAll()
        collectionView.reloadData()
        setIndicator(true)
        
        var local = [Gif]()
        netClient.request(search: text) { (response, error) in
            
            guard error == nil else{
                print("\(#function) \n error: \(error!.localizedDescription)")
                DispatchQueue.main.async {
                    self.showAlert(msg: error!.localizedDescription)
                    self.setIndicator(false)
                }
                return
            }
            
            if let res = response?.results{
                for i in res{
                    let id = i.id
                    for med in i.media{

                        let img = UIImage.gifImageWithData(try! Data(contentsOf: URL(string: med["nanogif"]!.url)!))
                        let nanoURL = med["nanogif"]?.url ?? ""
                        let originalUrl = med["gif"]?.url ?? ""
                        
                        let gif = Gif(nano: nanoURL , original: originalUrl , id: id, image: img!)
                        
                        local.append(gif)
                    }
                }
                DispatchQueue.main.async {
                    self.gifs = local
                    self.collectionView.reloadData()
                    self.setIndicator(false)
                }
            }
        }
    }
    fileprivate func showAlert(msg:String = "Something went wrong please try again later .." ){
        
        let vc = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    fileprivate func setIndicator(_ shown:Bool) {
        shown ? indicator.startAnimating() : indicator.stopAnimating()
        search.isUserInteractionEnabled = !indicator.isAnimating
        tabBarController?.tabBar.isUserInteractionEnabled = !indicator.isAnimating
        for item in (tabBarController?.tabBar.items)!{
            item.isEnabled = !indicator.isAnimating
        }
    }
    
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GifCell
        
        cell.image.image = gifs[indexPath.item].image
        return  cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.gif = gifs[indexPath.item]
        
        present(vc, animated: true, completion: nil)
    }
    
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
    
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        
        if let currentReq =  searchRequest{
            currentReq.cancel()
            self.searchRequest = AF.request("https://api.tenor.com/v1/autocomplete?key=CT4UWW03ZYNK&q=\(searchText)&limit=20").responseDecodable(of: SearchResponse.self) { (response) in
                switch response.result{
                case .success:
                    DispatchQueue.main.async {
                        self.filteredData = response.value!.results
                        self.tableView.reloadData()
                        self.setTableVisible(true)
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }else{
            self.searchRequest = AF.request("https://api.tenor.com/v1/autocomplete?key=CT4UWW03ZYNK&q=\(searchText)&limit=20").responseDecodable(of: SearchResponse.self) { (response) in
                switch response.result{
                case .success:
                    DispatchQueue.main.async {
                        self.filteredData = response.value!.results
                        self.tableView.reloadData()
                        self.setTableVisible(true)
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.setTableVisible(false)
        getGifs(by: searchBar.text ?? "")
        search.text = ""
    }
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! UITableViewCell
        cell.textLabel?.text = filteredData[indexPath.row]
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setTableVisible(false)
        let searchText = filteredData[indexPath.row]
        getGifs(by: searchText)
        search.text = ""
        search.resignFirstResponder()
    }
    
    func setTableVisible(_ bool:Bool){
        tableView.isHidden = !bool
    }
}

