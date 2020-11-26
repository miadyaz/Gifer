//
//  netClient.swift
//  Gifer
//
//  Created by miad yazeed on 23/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import Alamofire

class netClient {
    
    class func request (search: String = "", completion: @escaping (_ result: GIFResponse?, _ error: Error?) -> Void){
        AF.request("https://api.tenor.com/v1/search?q=\(search)&key=CT4UWW03ZYNK&limit=20").responseDecodable(of: GIFResponse.self) { response in
            
            switch response.result {
            case .success:
                completion(response.value, nil)
            case let .failure(error):
                completion(nil,error)
            }
        }
    }
    
    class func downloadImage(_ url: String ,completion: @escaping (_ result: UIImage?, _ error: Error?) -> Void){
        AF.request(url).response { response in
               
            switch response.result {
               case .success:
                completion(UIImage(data: response.data!), nil)
               case let .failure(error):
                   completion(nil,error)
               }
           }
       }
    
}
