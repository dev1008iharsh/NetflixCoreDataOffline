//
//  DownlodsVC.swift
//  Netflix Harsh Clone
//
//  Created by My Mac Mini on 19/12/23.
//

import UIKit

class DownlodsVC: UIViewController {

    //MARK: -  Properties
    
    var arrDownload : [TitleItem] = [TitleItem]()
    
    public let tblDownload : UITableView = {
        
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(MoviesTVC.self, forCellReuseIdentifier: MoviesTVC.identifier)
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        return table
        
    }()
    
    
    //MARK: -  ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Downloads"
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.tintColor = .systemRed
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
         
        view.addSubview(tblDownload)
         
        tblDownload.dataSource = self
        tblDownload.delegate = self
        
        fetchSavaDataFromCoreData()
        
        //set up notification celter observer for automatically reload downlod tab bar
        NotificationCenter.default.addObserver(forName: NSNotification.Name(Constants.keyReloadTablDownload), object: nil, queue: nil) { _ in
            self.fetchSavaDataFromCoreData()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tblDownload.frame = view.bounds
        
    }
    
    //MARK: - Fetch CoreData
    //getting downloded data from coredata
    private func fetchSavaDataFromCoreData(){
        
        DataPersistenceManager.shared.fetingTitleFromDataBase { [weak self] result in
            switch result{
            case .success(let titles):
                
                self?.arrDownload = titles
                self?.tblDownload.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
 

}

//MARK: -  UITableViewDelegate, UITableViewDataSource
extension DownlodsVC : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDownload.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviesTVC.identifier, for: indexPath) as? MoviesTVC else { return UITableViewCell() }
         
        let title = arrDownload[indexPath.row]
       
        let avgVote = Double(round(10 * (title.vote_average)) / 10)
        let img = (Constants.IMAGE_URL + (title.poster_path ?? "") )
        
        cell.configure(with: MovieViewModel(movieTitleName: ((title.original_title ?? title.original_name) ?? "Unknown Title" ), movieImgUrl: img, movieAvgVote: "Average Voting : \( "\(avgVote)/10" )"))
        cell.btnDownload.isHidden = true
        return cell
        
    }

     
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        DispatchQueue.main.async { [weak self] in
            
            let vc = MovieDetailVC()
            
            // converting coredata model into my model
            guard let titleItemModel = self?.arrDownload[indexPath.row] else{
                return
            }
            /*
            Conversion Failed for this i commented this code and used diffent logic
            var title1 : MovieModel? // my model
            var titleItem1 : TitleItem?// core data model
            titleItem1 = titleItemModel
            
            let coreName : String = titleItem1?.original_name ?? ""
            title1?.original_name = coreName
            
            let coreTitle : String = titleItem1?.original_title ?? ""
            title1?.original_title = coreTitle
            
            let coreOverview : String = titleItem1?.overview ?? ""
            title1?.overview = coreOverview
             
            let coreId : Int = NSNumber(value: (titleItem1?.id ?? 0)).intValue
            title1?.id = coreId
           
            print("*** title1 : \(title1)")
            */
            vc.titleItem = titleItemModel
            vc.isFromDownload = true
             
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //MARK: -  Left swipe to delete saved data
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
       
        case .delete:
            
            DataPersistenceManager.shared.deleteTitleWith(model: arrDownload[indexPath.row]) { result in
                switch result{
                case .success():
                    print("deleteed from database")
                    self.arrDownload.remove(at: indexPath.row)
                    self.tblDownload.deleteRows(at: [indexPath], with: .fade)
                    
                    UtilityManager().postAllNotificationForReloadDownloadData()
                    
                    
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    
        default:
            print("default")
        }
    }
    
     
    
}
