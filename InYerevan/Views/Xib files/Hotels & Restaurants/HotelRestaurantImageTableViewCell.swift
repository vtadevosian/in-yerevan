//
//  HotelRestaurantImageTableViewCell.swift
//  InYerevan
//
//  Created by HarutMikichyan on 1/10/19.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit
import Firebase

class HotelRestaurantImageTableViewCell: UITableViewCell {
    static let id = "HotelRestaurantImageTableViewCell"
    
    //MARK:- Interface Builder Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Other Properties
    var imagesUrl = [String]()
    var hotelRestaurantImages = [UIImage]()
    var isHotel: Bool!
    var hotelViewController: HotelDescriptionViewController!
    var restaurantViewController: RestaurantDescriptionViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //register TableViewCell
        collectionView.register(UINib(nibName: HotelRestaurantCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: HotelRestaurantCollectionViewCell.id)
    }
    
    //MARK:- Storage Private Method
    private func downloadImage(at urls: String, completion: @escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: urls)
        let megaByte = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(UIImage(data: imageData))
            }
        }
    }
}

//MARK:- Images TableViewCell Delegate DataSource
extension HotelRestaurantImageTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isHotel {
            hotelViewController.imageHotel.image = hotelRestaurantImages[indexPath.row]
//            hotelViewController.imageHotel.contentMode = 
        } else {
            restaurantViewController.restaurantImage.image = hotelRestaurantImages[indexPath.row]
            restaurantViewController.restaurantImage.contentMode = .scaleAspectFill
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let num = CGFloat(0)
        return UIEdgeInsets(top: num, left: num, bottom: num, right: num)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelRestaurantCollectionViewCell.id, for: indexPath) as! HotelRestaurantCollectionViewCell
        if imagesUrl.count != 0 {
            if self.hotelRestaurantImages.count <= indexPath.row {
                DispatchQueue.main.async {
                    self.downloadImage(at: self.imagesUrl[indexPath.row], completion: { (image) in
                        guard let image = image else { return }
                        
                        cell.cellImage.image = image
                        self.hotelRestaurantImages.append(image)
                    })
                }
            } else {
                cell.cellImage.image = self.hotelRestaurantImages[indexPath.row]
            }
        }
        return cell
    }
}
