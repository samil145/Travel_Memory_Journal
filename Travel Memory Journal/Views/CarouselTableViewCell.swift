//
//  CarouselTableViewCell.swift
//  Travel Memory Journal
//
//  Created by Shamil Bayramli on 06.02.24.
//

import UIKit

protocol CarouselTableViewCellDelegateDelete: AnyObject
{
    func deleteButtonTapped(cell: CarouselTableViewCell)
}

class CarouselTableViewCell: UITableViewCell {

    static let identifier = "CarouselTableViewCell"
    
    weak var delegateDelete: CarouselTableViewCellDelegateDelete?
    
    let userImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default))
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let travellabel: UILabel =
    {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel: UILabel =
    {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel =
    {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public var carouselView: CarouselView =
    {
        var carouselView = CarouselView(pages: 0, frame: .zero)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        return carouselView
    }()
    
    let shareButton: ShareButton =
    {
        let button = ShareButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular, scale: .default)), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public var deleteButton: DeleteButton =
    {
        let button = DeleteButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular, scale: .default)), for: .normal)
        button.tintColor = .systemRed
        button.addTarget(nil, action: #selector(deletePost(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var carouselImages = [UIImage]()
    
    @objc func deletePost(sender: AnyObject)
    {
        delegateDelete?.deleteButtonTapped(cell: self)
    }
    
    public func configureUserImageView(travelName: String)
    {
        travellabel.text = travelName
    }
    
    public func configureLocationLabel(cityName: String, countryName: String)
    {
        locationLabel.text = "\(cityName), \(countryName)"
    }
    
    public func configureDateLabel(date: String)
    {
        dateLabel.text = date
    }
    
    public func configureCarouselView(pageCount: Int, frame: CGRect, carouselImages: [UIImage])
    {
        carouselView.pages = pageCount
        carouselView.frameCell = frame
        self.carouselImages = carouselImages
        carouselView.pageControlIsHidden(bool: (self.carouselImages.count == 1 ? true : false))
    }
    
  
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(travellabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(carouselView)
        contentView.addSubview(shareButton)
        contentView.addSubview(deleteButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        carouselView.setupUI()
        carouselView.configureView(images: carouselImages)
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            userImageView.widthAnchor.constraint(equalToConstant: 30),
            userImageView.heightAnchor.constraint(equalToConstant: 30),
            
            travellabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            travellabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            
            shareButton.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: 10),
            shareButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            shareButton.widthAnchor.constraint(equalToConstant: 30),
            shareButton.heightAnchor.constraint(equalToConstant: 35),
              
            
            deleteButton.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: 10),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 35),
            
            
            locationLabel.topAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            
            carouselView.topAnchor.constraint(equalTo: contentView.topAnchor),
            carouselView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            carouselView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            carouselView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150)
        ])
        
//        NSLayoutConstraint.activate([
//            userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
//            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
//            userImageView.widthAnchor.constraint(equalToConstant: 30),
//            userImageView.heightAnchor.constraint(equalToConstant: 30),
//            
//            travellabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
//            travellabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
//            
//            shareButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -110),
//            shareButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
//            shareButton.widthAnchor.constraint(equalToConstant: 30),
//            shareButton.heightAnchor.constraint(equalToConstant: 35),
//              
//            
//            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -110),
//            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
//            deleteButton.widthAnchor.constraint(equalToConstant: 25),
//            deleteButton.heightAnchor.constraint(equalToConstant: 30),
//            
//            
//            locationLabel.topAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: 10),
//            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
//            
//            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
//            dateLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
//        ])
    }
}
