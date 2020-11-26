//
//  LaunchViewController.swift
//  Gifer
//
//  Created by miad yazeed on 24/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var logoLabel : UILabel!
     var gifs = [Gif]()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        typeOn(logoLabel.text!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        getGifs()
    }
    
    
//    func getGifs(){
//
//        gifs.removeAll()
//
//        var local = [Gif]()
//        netClient.request(search: "hello") { (response, error) in
//
//            guard error == nil else{
//                print("\(#function) \n error: \(error!.localizedDescription)")
////                self.showAlert(msg: error!.localizedDescription)
//                return
//            }
//
//            if let res = response?.results{
//                for i in res{
//                    let id = i.id
//                    for med in i.media{
//
//                        let img = UIImage.gifImageWithData(try! Data(contentsOf: URL(string: med["gif"]!.url)!))
//                        let nanoURL = med["nanogif"]?.url ?? ""
//                        let originalUrl = med["gif"]?.url ?? ""
//
//                        let gif = Gif(nano: nanoURL , original: originalUrl , id: id, image: img!)
//
//                        local.append(gif)
//                    }
//                }
//                DispatchQueue.main.async {
//                    self.gifs = local
//
//                }
//            }
//        }
//    }
    
    fileprivate func typeOn(_ string:String){
        
        self.logoLabel.text = ""
        let characterArray = string.characterArray
        var characterIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            while characterArray[characterIndex] == " " {
                self.logoLabel.text!.append(" ")
                characterIndex += 1
                if characterIndex == characterArray.count {
                    timer.invalidate()
                    return
                }
            }
            if characterArray[characterIndex].isSymbol{
                usleep(1000000)
            }
            self.logoLabel.text!.append(characterArray[characterIndex])
            characterIndex += 1
            if characterIndex == characterArray.count {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.performSegue(withIdentifier: "main", sender: self.gifs)
                }
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let gifsArray = sender as! [Gif]
//        let des = segue.destination as! ViewController
//        des.gifs = gifsArray
//    }
}
extension String {
    var characterArray: [Character]{
        var characterArray = [Character]()
        for character in self {
            characterArray.append(character)
        }
        return characterArray
    }
}
