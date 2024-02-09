//
//  CollectionviewTVC.swift
//  Netflix Harsh Clone
//
//  Created by My Mac Mini on 19/12/23.
//

import UIKit

 
protocol DidTapProtocol : AnyObject {
    func cellDidTappedDelegateFunc(titleModel : MovieModel)
}

//MARK: -  Used on Home TabBar
class MovieCollectionTVC: UITableViewCell {

    //MARK: -  Properties
    
    var arrIdOfDownlodedMovies : [Int] = []
    
    static let identifier = "MovieCollectionTVC"
    
    private var arrMovies : [MovieModel] = [MovieModel]()
    
    weak var delegateCellTap : DidTapProtocol?
    
    private let collvData : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.scrollDirection = .horizontal
        let collv = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collv.register(MovieCVC.self, forCellWithReuseIdentifier: MovieCVC.identifier)
        collv.showsVerticalScrollIndicator = false
        collv.showsHorizontalScrollIndicator = false
        return collv
        
    }()
    
    //MARK: -  LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         
        contentView.addSubview(collvData)
        //fetchSavedDataFromCoreData()
        collvData.dataSource = self
        collvData.delegate = self
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(Constants.keyReloadTablHome), object: nil, queue: nil) { _ in
            self.fetchSavedDataFromCoreData()
        }
    }
   
    public func configureMovie(with modelArr : [MovieModel]){
        self.arrMovies = modelArr
        
        DispatchQueue.main.async { [weak self] in
            
            self?.collvData.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collvData.frame = contentView.bounds
    }
    
    // save data to coredata
    func downloadTitleAt(indexpath : IndexPath){
        print("Downloading Title : \(arrMovies[indexpath.row].original_title ?? "") & Name \(arrMovies[indexpath.row].original_name ?? "")")
        
        DataPersistenceManager.shared.downlodTitleWith(model: arrMovies[indexpath.row]) { result in
        
            switch result{
            case .success():
                print("downlod coredata")
                UtilityManager().postAllNotificationForReloadDownloadData()
                //self.reloadAllData()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    func deleteTitleAt(movieId : Int){
        DataPersistenceManager.shared.deleteTitleUsingIDWith(id: movieId) { result in
            switch result{
            case .success():
                print("delete coredata")
                UtilityManager().postAllNotificationForReloadDownloadData()
                //self.reloadAllData()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    func reloadAllData(){
        NotificationCenter.default.post(name: NSNotification.Name(Constants.keyReloadTablDownload), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.keyReloadTablUpcoming), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.keyReloadTablDiscover), object: nil)
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
                    //print("myyyyyy arrIdOfDownlodedMovies : \(self?.arrIdOfDownlodedMovies ?? [])****")
                }
             
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    

}

/*
let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
cell.backgroundColor = .green
return cell
*/


//MARK: -  UICollectionViewDelegate, UICollectionViewDataSource
extension MovieCollectionTVC : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCVC.identifier, for: indexPath) as? MovieCVC else { return UICollectionViewCell() }
            
        if arrMovies.count > 0{
            /*
            guard let model = arrMovies[indexPath.row].poster_path else {
                return UICollectionViewCell()
            }*/
            let model = arrMovies[indexPath.row].poster_path ?? ""
            
            cell.configure(with: model)
        } 
        
        return cell
         
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = arrMovies[indexPath.row]
       
        self.delegateCellTap?.cellDidTappedDelegateFunc(titleModel: title)
       
    }
  
    
    //MARK: -  contextMenuConfigurationForItemsAt
    // press and hold on collection view create effect and can perform action
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
         
        let confige = UIContextMenuConfiguration(actionProvider:  { [weak self] action in
            
            let indexPath = indexPaths.first
            let idOfMovie = self?.arrMovies[indexPath!.row].id
            
            let downlodAction = UIAction(title: "Download" ,image: UIImage(systemName: "arrow.down.circle")) { btnDownTap in
                
                self?.downloadTitleAt(indexpath: indexPaths.first ?? IndexPath())
                self?.fetchSavedDataFromCoreData()
            }
            
            let removeAction = UIAction(title: "Delete Download",image: UIImage(systemName: "xmark.bin"), attributes : .destructive) { btnremoveTap in
                
                self?.deleteTitleAt(movieId: idOfMovie ?? 0)
                self?.fetchSavedDataFromCoreData()
                
            }
             
           
            
            //print("*** idOfMovie\(idOfMovie ?? 0)")
            //print("*** arrIdOfDownlodedMovies\(self?.arrIdOfDownlodedMovies ?? [])")
            
            if self!.arrIdOfDownlodedMovies.contains(idOfMovie!){
                //print("*** true")
                      
                return UIMenu(options: .displayInline,children: [removeAction])
            }else{
                //print("*** false")
                
                return UIMenu(options: .displayInline,children: [downlodAction])
            }
             
             
        })
        return confige
    }
}
