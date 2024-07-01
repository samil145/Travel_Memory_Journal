//
//  CarouselView.swift
//  Travel Memory Journal
//
//  Created by Shamil Bayramli on 05.02.24.
//

import UIKit

class CarouselView: UIView {
    
    var carouselImages = [UIImage]()
    
    // MARK: - Subviews
    
    private lazy var carouselCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.dataSource = self
        collection.delegate = self
        collection.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.cellId)
        collection.backgroundColor = .clear
        return collection
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        if (self.traitCollection.userInterfaceStyle == .dark)
        {
            pageControl.pageIndicatorTintColor = .gray
            pageControl.currentPageIndicatorTintColor = .white
        } else
        {
            pageControl.pageIndicatorTintColor = .lightGray
            pageControl.currentPageIndicatorTintColor = .black
        }
        return pageControl
    }()
    
    
    // MARK: - Properties
    
    public var pages: Int
    private var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    public var frameCell: CGRect
    
    // MARK: - Initializers

    init(pages: Int, frame: CGRect) {
        self.pages = pages
        self.frameCell = frame
        super.init(frame: .zero)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //print(frameCell)
        //self.frame = frameCell//CGRect(x: 0, y: 40, width: frameCell.width, height: 300)
        carouselCollectionView.frame = CGRect(x: 0, y: 50, width: frameCell.width, height: 400)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setups

extension CarouselView {
    public func setupUI() {
        backgroundColor = .clear
        setupCollectionView()
        setupPageControl()
    }
    
    func setupCollectionView() {
        
        let cellPadding = (frameCell.width - 300) / 2
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: frameCell.width, height: 400)
        carouselLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        carouselLayout.minimumLineSpacing = 0
        carouselCollectionView.collectionViewLayout = carouselLayout
        
        addSubview(carouselCollectionView)
//        carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        carouselCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        carouselCollectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        carouselCollectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        carouselCollectionView.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    func setupPageControl() {
        addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: 16).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.numberOfPages = pages
    }
}

// MARK: - UICollectionViewDataSource

extension CarouselView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.cellId, for: indexPath) as? CarouselCell else { return UICollectionViewCell() }
        
        let image = carouselImages[indexPath.row]
        
        cell.configure(image: image)
        
        return cell
    }
}

// MARK: - UICollectionView Delegate

extension CarouselView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentPage = getCurrentPage()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
}

// MARK: - Public

extension CarouselView {
    public func configureView(images: [UIImage]) {
        //let cellPadding = (frameCell.width - 300) / 2
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: frameCell.width, height: 400)
        //carouselLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        //carouselLayout.minimumLineSpacing = cellPadding * 2
        carouselLayout.minimumLineSpacing = 0
        carouselCollectionView.collectionViewLayout = carouselLayout
        
        carouselImages = images
        carouselCollectionView.reloadData()
    }
    
    public func colorModeChanged(color: UIColor)
    {
        pageControl.currentPageIndicatorTintColor = color
    }
    
    public func pageControlIsHidden(bool: Bool)
    {
        pageControl.isHidden = bool
    }
}

// MARKK: - Helpers

private extension CarouselView {
    func getCurrentPage() -> Int {
        
        let visibleRect = CGRect(origin: carouselCollectionView.contentOffset, size: carouselCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = carouselCollectionView.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath.row
        }
        
        return currentPage
    }
}




