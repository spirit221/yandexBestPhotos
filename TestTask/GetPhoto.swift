//
//  GetPhoto.swift
//  TestTask
//
//  Created by Sergey Gusev on 14.04.2018.
//  Copyright © 2018 Sergey Gusev. All rights reserved.
//
import Alamofire
import AlamofireImage
import Foundation
import SWXMLHash

class GetPhoto {
    var path: [String] = []
    var photoCollection: [Photo] = []
    typealias DictionaryJSON = [String: Any]
    func download(finished: @escaping (([Photo]) -> Void)) {
        self.photoCollection.removeAll()
        guard let jsonURL = URL(string: "https://api-fotki.yandex.ru/api/recent/") else {
            print("error")
            return
        }
        self.path.removeAll()
        Alamofire.request(jsonURL).responseData { response in
            switch response.result {
            case .success:
                guard let xmlSW = response.result.value else { return }
                
                let xml = SWXMLHash.parse(xmlSW)
                for i in 0...2 {
                    guard let pathPhoto = xml["feed"]["entry"][i]["content"].element?.attribute(by: "src")?.text
                        else {return}
                    self.path.append(pathPhoto)
                }
                self.downloadPhoto(paths: self.path) { photo in
                    finished(photo)
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
    func downloadPhoto(paths: [String], exit: @escaping (([Photo]) -> Void)) {
        let group = DispatchGroup()
        

        for item in paths {
            guard let url = URL(string: item) else {
                print ("error url")
                return
            }
            group.enter()
            Alamofire.request(url, method: .get).responseImage { response in
                guard let posterImage = response.result.value else {
                    print ("error poster get")
                    return
                }
                
                self.photoCollection.append(Photo(binaryPhoto: posterImage))
                group.leave()

                
            }
            group.notify(queue: .main, execute: {
                exit(self.photoCollection)
                self.path.removeAll()
                

            })
        }
       
    }
}
