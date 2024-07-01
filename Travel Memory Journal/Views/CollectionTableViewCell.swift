//
//  CollectionTableViewCell.swift
//  Travel Memory Journal
//
//  Created by Shamil Bayramli on 29.01.24.
//

import UIKit

class CollectionTableViewCell: UITableViewCell, AddViewControllerDelegate {

    static let identifier = "CollectionTableViewCell"
    
    let defaultImage = UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: 150, weight: .regular, scale: .default))
    var images: [UIImage] = [UIImage]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 300, height: 180)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .backgroundMain
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        images.append(defaultImage!)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame = CGRect(x: contentView.frame.origin.x+10, y: contentView.frame.origin.y, width: contentView.bounds.width-20, height: contentView.bounds.height)
        contentView.backgroundColor = .backgroundMain
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = CGRect(x: contentView.frame.origin.x+10, y: contentView.frame.origin.y, width: contentView.bounds.width-20, height: contentView.bounds.height)
        contentView.backgroundColor = .backgroundMain
        //collectionView.frame = contentView.bounds
    }
    
    func addViewControllerAddImage(image: UIImage) {
        //images.insert(image, at: 0)
        if (images.contains(defaultImage!))
        {
            images.remove(at: 0)
            images.append(image)
        }
        else
        {
            images.append(image)
        }
        collectionView.reloadData()
    }
}

extension CollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(image: images[indexPath.item], isDefaultImage: images.contains(defaultImage!) ? true : false)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 180)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalCellWidth = 300 * images.count
        let totalSpacingWidth = 10 * (images.count - 1)
        let leftInset = max(0, (collectionView.bounds.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2.0)
        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        
    }
}
