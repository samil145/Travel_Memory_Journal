//
//  AddViewController.swift
//  Travel Memory Journal
//
//  Created by Shamil Bayramli on 24.01.24.
//

import UIKit
import MapKit
import ImagePicker

protocol AddViewControllerDelegate: AnyObject {
    func addViewControllerAddImage(image: UIImage)
}

protocol AddViewControllerDelegateForMain: AnyObject
{
    func fromAddToMainController(cityName: String?, countryName: String?, travelName: String?, date: String?)
}

protocol AddViewControllerDelegateForPicture: AnyObject
{
    func addPictureToMain(image :UIImage)
}

protocol AddViewControllerWillMoveDelegate: AnyObject
{
    func removeImages()
}

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MapViewControllerDelegate, ImagePickerDelegate {
    
    func wrapperDidPress(_ imagePicker: ImagePicker.ImagePickerController, images: [UIImage]) {
        DispatchQueue.main.async {
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePicker.ImagePickerController, images: [UIImage]) {
        DispatchQueue.main.async {
            images.forEach
            { image in
                
                    self.images_.append(image)
                    self.delegateForPicture?.addPictureToMain(image: image)
                    self.delegate?.addViewControllerAddImage(image: image)
                
            }
            
            self.imageSelected = true
            self.createPostButton.isEnabled = self.shouldCreatePost()
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePicker.ImagePickerController) {
        DispatchQueue.main.async {
            self.backToMain()
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    var images_: [UIImage] = [UIImage]()
    
    let imagePicker = UIImagePickerController()
    
    weak var delegate: AddViewControllerDelegate?
    weak var delegateForMain: AddViewControllerDelegateForMain?
    weak var delegateForPicture: AddViewControllerDelegateForPicture?
    weak var delegateRemovePictures: AddViewControllerWillMoveDelegate?
    
    let textInput = TextFieldWithPadding()
    //let textInput = UITextField()
    let dateTextInput = UITextField()
    let datePicker = UIDatePicker()
    
    static var selectedAnnotation: MKPointAnnotation?
    static var cityName: String?
    static var countryName: String?
    
    var imageSelected = false
    var textWrittenName = false
    var textWrittenDate = false
    var coordinatesDefined = false
    
    let tableView: UITableView =
    {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LocationCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DateCell")
        tableView.backgroundColor = .backgroundMain
        tableView.separatorColor = .secondary
        return tableView
    }()
    
    let createPostButton: UIButton =
    {
        let button = UIButton()
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.configuration?.title = "Create Post"
        button.overrideUserInterfaceStyle = .dark
        
        return button
    }()
    
    init(images: [UIImage]) {
        self.images_ = images
        super.init(nibName: nil, bundle: nil)
        DispatchQueue.main.async {
            images.forEach
            { image in
                self.delegateForPicture?.addPictureToMain(image: image)
                self.delegate?.addViewControllerAddImage(image: image)
            }
            self.imageSelected = true
            self.createPostButton.isEnabled = self.shouldCreatePost()
        }
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textInput.tag = 0
        dateTextInput.tag = 1
        textInput.autocorrectionType = .no
        dismissKeyboard()
        view.backgroundColor = .backgroundMain
        tableView.frame = view.bounds
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.addSubview(tableView)
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular, scale: .large)), style: .done, target: self, action: #selector(addPicture))
//        navigationItem.rightBarButtonItem?.tintColor = .label
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .default)), style: .done, target: self, action: #selector(backToMain))
        navigationItem.leftBarButtonItem?.tintColor = .white
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPicture))
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(createPostButton)
        
        NSLayoutConstraint.activate([
            createPostButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            createPostButton.heightAnchor.constraint(equalToConstant: 55),
            createPostButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createPostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        createPostButton.addTarget(self, action: #selector(createPost), for: .touchUpInside)
        
    }
    
    @objc func backToMain()
    {
        images_.removeAll()
        delegateRemovePictures?.removeImages()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func createPost()
    {
        delegateForMain?.fromAddToMainController(cityName: AddViewController.cityName, countryName: AddViewController.countryName, travelName: textInput.text, date: dateTextInput.text)
        navigationController?.popViewController(animated: true)
    }
    
//    @objc func addPicture() {
//        let pickerConfiguration = PickerConfiguration()
//        pickerConfiguration.doneButtonTitle = "Finish"
//        pickerConfiguration.noImagesTitle = "Sorry! There are no images here!"
//        pickerConfiguration.recordLocation = false
//        pickerConfiguration.allowVideoSelection = true
//
//        let imagePicker = ImagePickerController(pickerConfiguration: pickerConfiguration)
//        imagePicker.delegate = self
//
//        present(imagePicker, animated: true, completion: nil)
//        
////        self.imagePicker.delegate = self
////        self.imagePicker.allowsEditing = false
////        self.imagePicker.mediaTypes = ["public.image"]
////        
////        DispatchQueue.main.async { [weak self] in
////            guard let self = self else { return }
////            self.present(self.imagePicker, animated: true, completion: nil)
////        }
//    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            
//            if info[.mediaType] as? String == "public.image" {
//                self.handlePhoto(info)
//            }
//        
//            DispatchQueue.main.async { [weak self] in
//                self?.dismiss(animated: true, completion: nil)
//            }
//    }
    
//    private func handlePhoto(_ info: [UIImagePickerController.InfoKey : Any]) {
//
//        if let image = info[.originalImage] as? UIImage {
//            images_.append(image)
//            delegateForPicture?.addPictureToMain(image: image)
//            delegate?.addViewControllerAddImage(image: image)
//            imageSelected = true
//            createPostButton.isEnabled = shouldCreatePost()
//        }
//    }
    
    private func shouldCreatePost() -> Bool
    {
        return textWrittenName && imageSelected && coordinatesDefined && textWrittenDate
    }
    
    internal func backFromMapView()
    {
        coordinatesDefined = true
        createPostButton.isEnabled = shouldCreatePost()
        tableView.reloadData()
        
    }
    

}

extension AddViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.section
        {
        case 0:
            
            guard let cell_ = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell else {
                return UITableViewCell()
            }
            delegate = cell_
            cell = cell_

        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
            
            
            let attributes = [
                NSAttributedString.Key.font :  UIFont.systemFont(ofSize: 19),
                NSAttributedString.Key.foregroundColor: UIColor.secondary
            ]
            
            textInput.placeholder = "Travel Name"
            textInput.attributedPlaceholder = NSAttributedString(string: "Travel Name", attributes: attributes)
            textInput.borderStyle = .none
            textInput.textAlignment = .left
            textInput.contentVerticalAlignment = .top
            textInput.delegate = self
            textInput.textColor = .white
            textInput.tintColor = .white
            
            
            let separatorView = UIView.init(frame: CGRect(x: 0, y: cell.frame.size.height - 5, width: cell.frame.size.width, height: 1))
            separatorView.backgroundColor = tableView.separatorColor//UIColor(red: 224, green: 224, blue: 224)
            
            cell.addSubview(textInput)
            cell.addSubview(separatorView)
            
            textInput.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                textInput.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
                textInput.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
                textInput.widthAnchor.constraint(equalToConstant: view.bounds.width),
                textInput.heightAnchor.constraint(equalToConstant: 90),
                
            ])
            
            cell.separatorInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
            
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
//            guard let cell_ = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier, for: indexPath) as? LocationCell else {
//                return UITableViewCell()
//            }
            
            let disclosureImage = UIImage(systemName: "chevron.right")?.withTintColor(.secondary, renderingMode: .alwaysOriginal)
            
            cell.accessoryView = UIImageView(image: disclosureImage)
            
            //cell.accessoryType = .disclosureIndicator
        
            cell.imageView?.image = UIImage(systemName: "map", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default))
            cell.imageView?.tintColor = .white
            
            
            
            if let cityName = AddViewController.cityName, let countryName = AddViewController.countryName
            {
                cell.textLabel?.text =  "\(cityName), \(countryName)"
            }
            else
            {
                cell.textLabel?.text = "Add Location"
            }
            
            
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath)
            
            
            cell.imageView?.image = UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default))
            cell.imageView?.tintColor = .white
            
            dateTextInput.placeholder = "13 June 2020"
            dateTextInput.attributedPlaceholder = NSAttributedString( 
                string: "13 June 2020",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondary]
            )
            dateTextInput.borderStyle = .none
            dateTextInput.textAlignment = .left
            dateTextInput.delegate = self
            dateTextInput.textColor = .white
            dateTextInput.tintColor = .white
            
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
            toolbar.setItems([doneButton], animated: true)
            dateTextInput.inputAccessoryView = toolbar
            dateTextInput.inputView = datePicker
            
            datePicker.preferredDatePickerStyle = .inline
            datePicker.datePickerMode = .date
            datePicker.maximumDate = Date()
            
            cell.addSubview(dateTextInput)
            
            dateTextInput.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                dateTextInput.leadingAnchor.constraint(equalTo: cell.imageView!.trailingAnchor, constant: 15),
                dateTextInput.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
                dateTextInput.widthAnchor.constraint(equalToConstant: 150),
                dateTextInput.heightAnchor.constraint(equalToConstant: 50),
            ])
            
            
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .backgroundMain
        cell.textLabel?.tintColor = .white
        cell.textLabel?.textColor = .white
        
        cell.tintColor = .white
        return cell
    }
    
    @objc func donePressed()
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        dateTextInput.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section
        {
        case 0:
            return 200
        case 2:
            return 50
        case 3:
            return 50
        default:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 2)
        {
            navigationController?.pushViewController(MapViewController(), animated: true)
            if let mapController = navigationController?.topViewController as? MapViewController
            {
                mapController.delegate = self
            }
        }
    }
    
}

extension AddViewController: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.tag == 1)
        {
            textWrittenDate = (textField.text != "")
            createPostButton.isEnabled = shouldCreatePost()
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if (textField.tag == 0)
        {
            textWrittenName = (updatedText != "")
        }
        
        //textWritten = (updatedText != "")
        createPostButton.isEnabled = shouldCreatePost()
        
        return updatedText.count <= 30
    }
}

extension UIViewController {
func dismissKeyboard() {
       let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action:    #selector(UIViewController.dismissKeyboardTouchOutside))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
       view.endEditing(true)
    }
}


class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 10,
        left: 10,
        bottom: 10,
        right: 10
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
