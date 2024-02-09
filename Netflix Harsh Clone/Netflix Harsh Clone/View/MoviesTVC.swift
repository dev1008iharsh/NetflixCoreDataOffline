//
//  MoviesTVC.swift
//  Netflix Harsh Clone
//
//  Created by My Mac Mini on 20/12/23.
//

import UIKit

//MARK: -  Used on UpcomingVC, SearchVC, DownlodVC

class MoviesTVC: UITableViewCell {
    
    //MARK: -  Properties
    static let identifier = "MoviesTVC"
    
    var arrIdOfDownlodedMovies : [Int] = []
    
    private let lblTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    private let lblAvgVote: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    private let imgMovie: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        return imgView
    }()
    
    public let btnDownload: UIButton = {
        
        let button = UIButton()
        let image = UIImage(systemName: "arrow.down.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
        button.setImage(image, for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
     
    //MARK: -  LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(imgMovie)
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblAvgVote)
        contentView.addSubview(btnDownload)
        appplyConstrain()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgMovie.frame = contentView.bounds
    }
    
    
    
    
    //MARK: -  SetUp Screen
    private func appplyConstrain(){
        
        let imgMovieConstrains = [
            imgMovie.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            imgMovie.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imgMovie.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            imgMovie.widthAnchor.constraint(equalToConstant: 80),
             
        ]
        
        let btnPlayConstrains = [
            btnDownload.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            btnDownload.centerYAnchor.constraint(equalTo: imgMovie.centerYAnchor),
            btnDownload.widthAnchor.constraint(equalToConstant: 50),
            btnDownload.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let lblTitleConstrains = [
            lblTitle.leadingAnchor.constraint(equalTo: imgMovie.trailingAnchor,constant: 15),
            lblTitle.trailingAnchor.constraint(equalTo: btnDownload.leadingAnchor,constant: 5),
            lblTitle.centerYAnchor.constraint(equalTo: imgMovie.centerYAnchor,constant: -10)
        ]
        
        let lblAvgVoteConstrains = [
            lblAvgVote.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor),
            lblAvgVote.trailingAnchor.constraint(equalTo: btnDownload.trailingAnchor,constant: -5),
            lblAvgVote.topAnchor.constraint(equalTo: lblTitle.bottomAnchor,constant: 5)
            
        ]
        
        
        NSLayoutConstraint.activate(imgMovieConstrains)
        NSLayoutConstraint.activate(lblTitleConstrains)
        NSLayoutConstraint.activate(lblAvgVoteConstrains)
        NSLayoutConstraint.activate(btnPlayConstrains)
    }
    
    public func configure(with model : MovieViewModel){
        guard let myUrl = URL(string: model.movieImgUrl) else {
            return
        }
        imgMovie.sd_setImage(with: myUrl)
        lblTitle.text = model.movieTitleName
        lblAvgVote.text = model.movieAvgVote
        
    }
    
    //MARK: - Fetch CoreData
    //getting downloded data from coredata
    public func fetchSavedDataFromCoreData(){
        self.arrIdOfDownlodedMovies.removeAll()
        DataPersistenceManager.shared.fetingTitleFromDataBase { [weak self] result in
            switch result{
            case .success(let titles):
                
                var arrDownload : [TitleItem] = [TitleItem]() // coredata model array
                arrDownload = titles
                
                for downlod in arrDownload{
                    let int64Value: Int64 = downlod.id
                    let intValue = NSNumber(value: int64Value).intValue
                    self?.arrIdOfDownlodedMovies.append(intValue)
                    //print("arrIdOfDownlodedMovies : \(self?.arrIdOfDownlodedMovies ?? [])****")
                }
             
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
 
    public func showHideDownlodButton(cellMoviewID : Int){
        if arrIdOfDownlodedMovies.contains(cellMoviewID){
            self.btnDownload.isHidden = true
        }else{
            self.btnDownload.isHidden = false
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
