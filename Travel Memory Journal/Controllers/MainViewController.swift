//
//  MainViewController.swift
//  Travel Memory Journal
//
//  Created by Shamil Bayramli on 23.01.24.
//

import UIKit
import ImagePicker

class Post : Codable
{
    var city: String?
    var country: String?
    var travelName: String?
    var date: String?
    
    init(city: String? = nil, country: String? = nil, travelName: String? = nil, date: String? = nil) {
        self.city = city
        self.country = country
        self.travelName = travelName
        self.date = date
    }
}

class MainViewController: UIViewController, AddViewControllerDelegateForMain, CarouselTableViewCellDelegateDelete, AddViewControllerDelegateForPicture, AddViewControllerWillMoveDelegate, ImagePickerDelegate {
    
    
    var posts = [Post]()
    var PostImages = [[UIImage]]()
    var carouselDict = [CarouselView: [UIImage]]()
    var imagesForPost = [UIImage]()
    {
        didSet
        {
            if (imagesForPost.count != 0)
            {
                //posts[0].images = imagesForPost
                PostImages[0] = imagesForPost
            }
        }
    }
    
    lazy var titleStackView: TitleStackView = {
        let titleStackView = TitleStackView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width,height: 44.0)))
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        return titleStackView
    }()

    lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height:60)))
        tableHeaderView.addSubview(titleStackView)
        titleStackView.leadingAnchor.constraint(equalTo: tableHeaderView.leadingAnchor, constant: 16.0).isActive = true
        titleStackView.topAnchor.constraint(equalTo: tableHeaderView.topAnchor).isActive = true
        titleStackView.trailingAnchor.constraint(equalTo: tableHeaderView.trailingAnchor, constant: -16.0).isActive = true
        //titleStackView.bottomAnchor.constraint(equalTo: tableHeaderView.bottomAnchor).isActive = true
        titleStackView.backgroundColor = .backgroundMain
        return tableHeaderView
    }()
    
    let tableView: UITableView =
    {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(CarouselTableViewCell.self, forCellReuseIdentifier: CarouselTableViewCell.identifier)
        tableView.backgroundColor = .backgroundMain
        return tableView
    }()
    
    let noPostLabel: UILabel =
    {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "No Post"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UserDefaults.standard.removeObject(forKey: "posts")
//        
//        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            let archiveURL = documentDirectory.appendingPathComponent("PostImages")
//            
//            // Remove the existing file if it exists
//            do {
//                try FileManager.default.removeItem(at: archiveURL)
//            } catch {
//                print("Error removing existing file: \(error.localizedDescription)")
//            }
//        }
        

//        let gradient = CAGradientLayer()
//
//        gradient.frame = view.bounds
//        gradient.colors = [UIColor.blue.cgColor, UIColor.systemPink.cgColor]
//        
//        view.layer.addSublayer(gradient)
        
        DispatchQueue.global().async {
            
            guard let posts_ = self.loadPostItems(key: "posts") else {return}
            self.posts = posts_
            
            if let loadedImages = self.loadArrayOfArrays(filename: "PostImages")
            {
                self.PostImages = loadedImages
            }
            
            DispatchQueue.main.async {
                print(self.posts.count)
                print(self.PostImages.count)
                self.tableView.reloadData()
            }
        }
    
        
        tableView.frame = view.bounds.inset(by: UIEdgeInsets(top: view.safeAreaInsets.top, left: 0, bottom: view.safeAreaInsets.bottom + 80, right: 0))
        //tableView.frame = view.bounds
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        view.addSubview(tableView)
        view.addSubview(noPostLabel)
        
        var post = Post()
        PostImages.insert([UIImage](), at: 0)
        posts.insert(post, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // MARK: Navigation Bar Configuration
        title = nil
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .backgroundMain
        navigationController?.setStatusBar(backgroundColor: .backgroundMain)
        navigationController?.navigationBar.shadowImage = UIImage()
        tableView.tableHeaderView = tableHeaderView
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        view.backgroundColor = .backgroundMain
        
        titleStackView.button.addTarget(self, action: #selector(firstAddButtonTapped), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            noPostLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noPostLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        noPostLabel.isHidden = tableView.visibleCells.count == 0 ? false : true
    }
    
    @objc func firstAddButtonTapped()
    {
        let pickerConfiguration = PickerConfiguration()
        pickerConfiguration.doneButtonTitle = "Done"
        pickerConfiguration.noImagesTitle = "Sorry! There are no images here!"
        pickerConfiguration.recordLocation = false
        pickerConfiguration.allowVideoSelection = true

        let imagePicker = ImagePickerController(pickerConfiguration: pickerConfiguration)
        imagePicker.delegate = self

        present(imagePicker, animated: true, completion: nil)
        
//        navigationController?.pushViewController(AddViewController(), animated: true)
//        if let addController = navigationController?.topViewController as? AddViewController
//        {
//            addController.delegateForPicture = self
//            addController.delegateForMain = self
//            addController.delegateRemovePictures = self
//        }
    }
    
    func wrapperDidPress(_ imagePicker: ImagePicker.ImagePickerController, images: [UIImage]) {
        DispatchQueue.main.async {
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePicker.ImagePickerController, images: [UIImage]) {
        if let navigationController = navigationController {
            let imagesToPass = images // Your array of images to pass
            let addViewController = AddViewController(images: imagesToPass)
            addViewController.delegateForPicture = self
            addViewController.delegateForMain = self
            addViewController.delegateRemovePictures = self
            navigationController.pushViewController(addViewController, animated: true)
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
        /*
        navigationController?.pushViewController(AddViewController(images: images, imageSelected: true), animated: true)
        if let addController = navigationController?.topViewController as? AddViewController
        {
            addController.delegateForPicture = self
            addController.delegateForMain = self
            addController.delegateRemovePictures = self
        }
            
        imagePicker.dismiss(animated: true, completion: nil)
         */
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePicker.ImagePickerController) {
        DispatchQueue.main.async {
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    func removeImages() {
        imagesForPost.removeAll()
        //posts[0].images.removeAll()
        PostImages[0].removeAll()
    }
    
    func addPictureToMain(image: UIImage) {
        imagesForPost.append(image)
    }
    
    func fromAddToMainController(cityName: String?, countryName: String?, travelName: String?, date: String?) {
        //posts[0].images = imagesForPost
        posts[0].city = cityName
        posts[0].country = countryName
        posts[0].travelName = travelName
        posts[0].date = date
    
        noPostLabel.isHidden = true
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.beginUpdates()
        DispatchQueue.main.async {
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            //self.tableView.reloadData()
            self.tableView.endUpdates()
        }
        
        imagesForPost.removeAll()
        var post = Post()
        PostImages.insert([UIImage](), at: 0)
        posts.insert(post, at: 0)
        
        DispatchQueue.global().async {
            self.savePostItems(items: self.posts, key: "posts")
            self.saveArrayOfArrays(imagesArrays: self.PostImages, filename: "PostImages")
        }
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        for carouselView in carouselDict.keys
//        {
//            if (traitCollection.userInterfaceStyle == .dark)
//            {
//                carouselView.colorModeChanged(color: .white)
//            } else
//            {
//                carouselView.colorModeChanged(color: .black)
//            }
//        }
//    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CarouselTableViewCell.identifier, for: indexPath) as? CarouselTableViewCell else {return UITableViewCell()}
        
        
        DispatchQueue.main.async {
            guard let travelName = self.posts[indexPath.row + 1].travelName else {return}
            guard let cityName = self.posts[indexPath.row + 1].city else {return}
            guard let countryName = self.posts[indexPath.row + 1].country else {return}
            guard let date = self.posts[indexPath.row + 1].date else {return}
            
            cell.configureDateLabel(date: date)
            cell.configureUserImageView(travelName: travelName)
            cell.configureLocationLabel(cityName: cityName, countryName: countryName)
            cell.deleteButton.postIndex = indexPath.row
//            cell.shareButton.images = self.posts[self.posts.count - 2 - indexPath.row].images as! [UIImage]
            cell.shareButton.images = self.PostImages[self.posts.count - 2 - indexPath.row]
            cell.delegateDelete = self
            cell.shareButton.addTarget(self, action: #selector(self.shareImages(_:)), for: .touchUpInside)
//            cell.configureCarouselView(pageCount: self.imagesForPost.count, frame: CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.width, height: cell.frame.height-200), carouselImages: self.imagesForPost)
            //cell.configureCarouselView(pageCount: self.posts[indexPath.row + 1].images.count, frame: CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.width, height: cell.frame.height-200), carouselImages: (self.posts[indexPath.row + 1].images as! [UIImage]))
            
            
            cell.configureCarouselView(pageCount: self.PostImages[indexPath.row + 1].count, frame: CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.width-20, height: cell.frame.height-200), carouselImages: self.PostImages[indexPath.row + 1])
            
//            cell.configureCarouselView(pageCount: self.PostImages[indexPath.row + 1].count, carouselImages: self.PostImages[indexPath.row + 1])
            
            
            self.carouselDict[cell.carouselView] = cell.carouselImages
            
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .backgroundMain
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxTitlePoint = tableView.convert(CGPoint(x: titleStackView.titleLabel.bounds.minX, y: titleStackView.titleLabel.bounds.maxY), from: titleStackView.titleLabel)
        title = scrollView.contentOffset.y > maxTitlePoint.y ? "Travel Memory Journal" : nil
        scrollView.backgroundColor = .backgroundMain
        
    }
    
    
    
    @objc func shareImages(_ sender: ShareButton)
    {
        let vc = UIActivityViewController(activityItems: sender.images, applicationActivities: [])
        present(vc, animated: true)
    }
    
    func deleteButtonTapped(cell: CarouselTableViewCell) {
        let ac = UIAlertController(title: "Are you sure?", message: "Do you want to delete post?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive)
        {
            [weak self] action in
            let indexPath = self?.tableView.indexPath(for: cell)
            self?.posts.remove(at: ((self?.posts.count)! - 1 - indexPath!.row))
            self?.tableView.beginUpdates()
            DispatchQueue.main.async {
                self?.tableView.deleteRows(at: [indexPath!], with: .automatic)
                self?.noPostLabel.isHidden = self?.posts.count == 1 ? false : true
                self?.tableView.endUpdates()
            }
            
            DispatchQueue.global().async {
                self?.savePostItems(items: self!.posts, key: "posts")
                self?.saveArrayOfArrays(imagesArrays: self!.PostImages, filename: "PostImages")
            }
        })
        present(ac, animated: true)
    }
}


// Status Bar Color Configuration
extension UINavigationController {

func setStatusBar(backgroundColor: UIColor) {
    let statusBarFrame: CGRect
    if #available(iOS 13.0, *) {
        statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
    } else {
        statusBarFrame = UIApplication.shared.statusBarFrame
    }
    let statusBarView = UIView(frame: statusBarFrame)
    statusBarView.backgroundColor = backgroundColor
    view.addSubview(statusBarView)
  }
}


class ShareButton: UIButton
{
    var images = [UIImage]()
}

class DeleteButton: UIButton
{
    var postIndex: Int?
}

extension MainViewController
{
    func saveArrayOfArrays(imagesArrays: [[UIImage]], filename: String) {
        // Convert array of arrays of UIImage to array of arrays of Data
        let imageDataArrays: [[Data]] = imagesArrays.map { imagesArray in
            return imagesArray.compactMap { image in
                return image.pngData()
            }
        }

        // Get the document directory
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let archiveURL = documentDirectory.appendingPathComponent(filename)

            // Remove the existing file if it exists
            do {
                try FileManager.default.removeItem(at: archiveURL)
            } catch {
                print("Error removing existing file: \(error.localizedDescription)")
            }

            // Encode the array of arrays to Data and save it
            do {
                let imageData = try PropertyListEncoder().encode(imageDataArrays)
                try imageData.write(to: archiveURL)
                print("Arrays of images saved successfully.")
            } catch {
                print("Error saving arrays of images: \(error.localizedDescription)")
            }
        }
    }


    
    func loadArrayOfArrays(filename: String) -> [[UIImage]]? {
        // Get the document directory
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let archiveURL = documentDirectory.appendingPathComponent(filename)

            // Decode the Data back to array of arrays
            if let imageData = try? Data(contentsOf: archiveURL),
                let imageDataArrays = try? PropertyListDecoder().decode([[Data]].self, from: imageData) {

                // Convert array of arrays of Data back to array of arrays of UIImage
                let imagesArrays: [[UIImage]] = imageDataArrays.map { imageDataArray in
                    return imageDataArray.compactMap { imageData in
                        return UIImage(data: imageData)
                    }
                }

                return imagesArrays
            }
        }

        return nil
    }
    
    func savePostItems(items: [Post], key: String) {
        // Convert array of CustomItem to Data
        do {
            let encodedData = try JSONEncoder().encode(items)
            UserDefaults.standard.set(encodedData, forKey: key)
            print("Custom items saved successfully.")
        } catch {
            print("Error saving custom items: \(error.localizedDescription)")
        }
    }
    
    func loadPostItems(key: String) -> [Post]? {
        // Retrieve Data from UserDefaults
        if let encodedData = UserDefaults.standard.data(forKey: key) {
            // Decode Data back to array of CustomItem
            do {
                let decodedItems = try JSONDecoder().decode([Post].self, from: encodedData)
                return decodedItems
            } catch {
                print("Error loading custom items: \(error.localizedDescription)")
                return nil
            }
        }
        return nil
    }
}
