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
    
    let backgroundContainer: UIView =
    {
        let view_ = UIView()
        view_.backgroundColor = .postMain
        
        view_.layer.cornerRadius = 20
        view_.layer.masksToBounds = true
        view_.translatesAutoresizingMaskIntoConstraints = false

        return view_
    }()
    
    let userImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let travellabel: UILabel =
    {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel: UILabel =
    {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .white
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
//        carouselView.layer.cornerRadius = 30
//        carouselView.layer.masksToBounds = true
//        carouselView.clipsToBounds = true
        return carouselView
    }()
    
    let shareButton: ShareButton =
    {
        let button = ShareButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular, scale: .default)), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public var deleteButton: DeleteButton =
    {
        let button = DeleteButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular, scale: .default)), for: .normal)
        button.tintColor = UIColor(rgb: 0x950002)
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
    
//    public func configureCarouselView(pageCount: Int, carouselImages: [UIImage])
//    {
//        carouselView.pages = pageCount
////        carouselView.frameCell = frame
//        self.carouselImages = carouselImages
//        carouselView.pageControlIsHidden(bool: (self.carouselImages.count == 1 ? true : false))
//    }
    
  
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(travellabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(carouselView)
        contentView.addSubview(shareButton)
        contentView.addSubview(deleteButton)
        contentView.addSubview(backgroundContainer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(userImageView)
        contentView.addSubview(travellabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(carouselView)
        contentView.addSubview(shareButton)
        contentView.addSubview(deleteButton)
        contentView.addSubview(backgroundContainer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        carouselView.setupUI()
        carouselView.configureView(images: carouselImages)
        contentView.sendSubviewToBack(backgroundContainer)
        
        
        
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            userImageView.widthAnchor.constraint(equalToConstant: 30),
            userImageView.heightAnchor.constraint(equalToConstant: 30),
            
            travellabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 25),
            travellabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            
            shareButton.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: -16),
            shareButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            shareButton.widthAnchor.constraint(equalToConstant: 30),
            shareButton.heightAnchor.constraint(equalToConstant: 35),
              
            
            deleteButton.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: -16),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            deleteButton.widthAnchor.constraint(equalToConstant: 25),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            
            
            locationLabel.topAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            
            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            
            carouselView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 15),
            carouselView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            carouselView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
//            carouselView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
//            carouselView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            carouselView.heightAnchor.constraint(equalToConstant: 380),//carouselView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150),
            
            backgroundContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -5),
            backgroundContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            backgroundContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            backgroundContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60)
        ])
        
        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = backgroundContainer.bounds
//        gradientLayer.colors = [
//            UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.0).cgColor, // Dark gray
//            UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.0).cgColor, // Slightly lighter gray
//            //UIColor(red: 0.08, green: 0.08, blue: 0.08, alpha: 1.0).cgColor
//        ]
////        gradientLayer.locations = [0.0, 0.5, 1.0]
//        gradientLayer.locations = [0.5, 1.0]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
//        
//        backgroundContainer.layer.insertSublayer(gradientLayer, at: 0)
    }
}
