//
//  UIImageView+Addition.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/03/09.
//

import UIKit
extension UIImage {
    static func getImageByUrl(url: String) -> UIImage{
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }
}
