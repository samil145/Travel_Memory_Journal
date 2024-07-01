//
//  TitleStackView.swift
//  Travel Memory Journal
//
//  Created by Shamil Bayramli on 04.02.24.
//

import UIKit

class TitleStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        axis = .horizontal
        alignment = .center
        addArrangedSubview(titleLabel)
        addArrangedSubview(button)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle:.largeTitle).pointSize - 5, weight: .heavy)
        label.text = "Travel Memory Journal"
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.textColor = .white
        label.tintColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var button: UIButton = {
        let buttonWidth: CGFloat = 35
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: buttonWidth,height: buttonWidth)))
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .large)
               
        let largeBoldDoc = UIImage(systemName: "plus", withConfiguration: largeConfig)

        button.setImage(largeBoldDoc, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        button.imageView?.tintColor = .white
        
        return button
    }()
    
}
