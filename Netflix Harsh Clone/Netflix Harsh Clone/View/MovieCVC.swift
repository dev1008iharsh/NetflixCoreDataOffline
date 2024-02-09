//
//  TitleCVC.swift
//  Netflix Harsh Clone
//
//  Created by My Mac Mini on 20/12/23.
//

import UIKit
import SDWebImage


//MARK: -  Used on Home TabBar and Search Controller
class MovieCVC: UICollectionViewCell {
    
    
    static let identifier = "MovieCVC"
    
    private let imgMovie: UIImageView = {
        let imgView = UIImageView() 
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 8
        return imgView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imgMovie)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgMovie.frame = contentView.bounds
    }
    
    public func configure(with model : String){
        guard let url = URL(string: Constants.IMAGE_URL + model) else {return}
        imgMovie.sd_setImage(with: url)
    }
}
