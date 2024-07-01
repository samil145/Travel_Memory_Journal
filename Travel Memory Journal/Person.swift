////
////  Person.swift
////  Travel Memory Journal
////
////  Created by Shamil Bayramli on 18.02.24.
////
//
//import UIKit
//
//class Post : NSObject, Codable
//{
//    var images: Data
//    var city: String
//    var country: String
//    var travelName: String
//    var date: String
//    
//    init(images: Data, city: String, country: String, travelName: String, date: String) {
//        self.images = images
//        self.city = city
//        self.country = country
//        self.travelName = travelName
//        self.date = date
//    }
//}
//
//extension UIImage {
//    var data: Data? {
//        if let data = self.jpegData(compressionQuality: 1.0) {
//            return data
//        } else {
//            return nil
//        }
//    }
//}
//
//extension Data {
//    var image: UIImage? {
//        if let image = UIImage(data: self) {
//            return image
//        } else {
//            return nil
//        }
//    }
//}
