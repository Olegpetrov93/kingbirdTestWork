//
//  PhotoCellViewModel.swift
//  kingbirdTestWork
//
//  Created by Oleg on 7/8/21.
//

import UIKit

protocol PhotoCellViewModelProtocol: AnyObject {
    var id: String { get }
    var author: String { get }
    var photoImage: UIImage { get }
    var photoImageSmall: UIImage { get }
}
final class PhotoCellViewModel: PhotoCellViewModelProtocol {
    
    private var photo: PhotoCD
    
    var id: String {
        guard let id = photo.id else { return "" }
        return id
    }
    
    var author: String {
        guard let author = photo.author else { return "" }
        return author
    }
    
    var photoImage: UIImage {
        guard let photoData = photo.photo,
              let photoImage = UIImage(data: photoData) else { return UIImage() }
        return photoImage
    }
    
    init(photo: PhotoCD) {
        self.photo = photo
    }
    var photoImageSmall: UIImage {
        guard let photoData = photo.photo,
              let photoImage = UIImage(data: photoData)?.resizeImage(targetSize: CGSize(width: 150, height: 150)) else { return UIImage() }
        return photoImage
    }
}
