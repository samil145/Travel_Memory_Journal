//
//  CollectionViewCell.swift
//  Travel Memory Journal
//
//  Created by Shamil Bayramli on 29.01.24.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        imageView.tintColor = .label
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
        
        //posterImageView.frame = contentView.bounds
    }
    
    public func configure(image: UIImage, isDefaultImage: Bool) {
        if (isDefaultImage)
        {
            posterImageView.contentMode = .center
            posterImageView.image = image
        }
        else
        {
            posterImageView.contentMode = .scaleToFill
            posterImageView.image = image
        }
    }
}
