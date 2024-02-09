//
//  TopHeaderView.swift
//  Netflix Harsh Clone
//
//  Created by My Mac Mini on 19/12/23.
//

import UIKit

//MARK: -  Used on Home TabBar
class HomeTopHeaderView: UIView {
    /*
     private let downloadButton: UIButton = {
     let button = UIButton()
     button.setTitle ("Downlod", for: .normal)
     button.layer.borderColor = UIKit.UIColor.white.cgColor
     button.layer.borderWidth = 1
     button.translatesAutoresizingMaskIntoConstraints = false
     button.layer.cornerRadius = 10
     return button
     }()
     
     private let playButton: UIButton = {
     let button = UIButton()
     button.setTitle ("Play", for: .normal)
     button.layer.borderColor = UIKit.UIColor.white.cgColor
     button.layer.borderWidth = 1
     button.translatesAutoresizingMaskIntoConstraints = false
     button.layer.cornerRadius = 10
     return button
     }()*/
    
    private let imgHeaderTopHome: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        
        setColorsOfGradient(gradient : gradientLayer)
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            
            self.setColorsOfGradient(gradient : gradientLayer)
            
        })
        
        
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    // mananging dark mode light mode
    func setColorsOfGradient(gradient : CAGradientLayer){
        if self.traitCollection.userInterfaceStyle == .light {
            gradient.colors = [UIKit.UIColor.clear.cgColor,UIKit.UIColor.systemBackground.cgColor]
        } else {
            gradient.colors = [UIKit.UIColor.clear.cgColor,UIKit.UIColor.black.cgColor]
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imgHeaderTopHome)
        addGradient()
        //addSubview(playButton)
        //addSubview(downloadButton)
        //applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgHeaderTopHome.frame = bounds
    }
    
    func configureHeaderView(with selectedModel : MovieModel) {
        
        guard let url = URL(string: Constants.IMAGE_URL + (selectedModel.poster_path ?? "")) else {return}
        imgHeaderTopHome.sd_setImage(with: url)
        
    }
    
    
    /*
     func applyConstraints(){
     let playButtonConstraints = [
     playButton.leadingAnchor.constraint (equalTo: leadingAnchor, constant: 20),
     playButton.bottomAnchor.constraint (equalTo: bottomAnchor, constant: -50),
     playButton.widthAnchor.constraint (equalToConstant: 100)
     ]
     
     
     let downloadButtonConstraints = [
     downloadButton.leadingAnchor.constraint (equalTo: leadingAnchor, constant: 140),
     downloadButton.bottomAnchor.constraint (equalTo: bottomAnchor, constant: -50),
     downloadButton.widthAnchor.constraint (equalToConstant: 100)
     ]
     
     NSLayoutConstraint.activate(playButtonConstraints)
     NSLayoutConstraint.activate(downloadButtonConstraints)
     
     }*/
    
    
}
