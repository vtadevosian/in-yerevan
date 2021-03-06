//
//  UIImage+Scaling.swift
//  In Yerevan
//
//  Created by Vahram Tadevosian on 12/25/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    var scaledToSafeUploadSize: UIImage? {
        let maxImageSideLength: CGFloat = 1024
        let largerSide: CGFloat = max(size.width, size.height)
        let ratioScale: CGFloat = largerSide > maxImageSideLength ? largerSide / maxImageSideLength : 1
        let newImageSize = CGSize(width: size.width / ratioScale, height: size.height / ratioScale)
        return image(scaledTo: newImageSize)
    }
    
    func image(scaledTo size: CGSize) -> UIImage? {
        defer { UIGraphicsEndImageContext() }
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
