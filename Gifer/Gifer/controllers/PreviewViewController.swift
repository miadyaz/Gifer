//
//  PreviewViewController.swift
//  Gifer
//
//  Created by miad yazeed on 25/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var gifView : UIImageView!
    
    
    var gif : Gif? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.85)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if gif != nil {
            gifView.image = UIImage.gifImageWithURL(gif!.original)
        }
        
    }
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
