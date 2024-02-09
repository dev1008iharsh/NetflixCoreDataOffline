//
//  UpComingVC.swift
//  Netflix Harsh Clone
//
//  Created by My Mac Mini on 19/12/23.
//

import UIKit

class UpComingVC: UIViewController {

    //MARK: -  Properties
    var arrUpComing : [MovieModel] = [MovieModel]()
    
    private let tblUpComing : UITableView = {
        
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(MoviesTVC.self, forCellReuseIdentifier: MoviesTVC.identifier)
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
         
        return table
    }()
    
    //MARK: -  ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Upcoming Shows"
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.tintColor = .systemRed
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(tblUpComing)
         
        tblUpComing.dataSource = self
        tblUpComing.delegate = self
          
        fetchUpcomingMoviesData()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(Constants.keyReloadTablDiscover), object: nil, queue: nil) { _ in
            self.tblUpComing.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tblUpComing.frame = view.bounds
    }

    //MARK: -  API Call Functions
    func fetchUpcomingMoviesData(){
        ApiCaller.shared.getUpcomingMovies { result in
            switch result {
            case .success(let title):
                self.arrUpComing = title
                DispatchQueue.main.async {[weak self] in
                    self?.tblUpComing.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: -  Save Data to coreData on did tap cell
    func downloadTitleAt(rowNumber : Int){
         
        print("Downloading Title : \(arrUpComing[rowNumber].original_title ?? "") & Name \(arrUpComing[rowNumber].original_name ?? "")")
        
        DataPersistenceManager.shared.downlodTitleWith(model: arrUpComing[rowNumber]) { result in
        
            switch result{
            case .success():
                print("downlod coredata")
                UtilityManager().postAllNotificationForReloadDownloadData()
                /*
                NotificationCenter.default.post(name: NSNotification.Name(Constants.keyReloadTablDownload), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(Constants.keyReloadTablDiscover), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(Constants.keyReloadTablHome), object: nil)
                self.tblUpComing.reloadData()*/
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: -  UITableViewDelegate, UITableViewDataSource
extension UpComingVC : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUpComing.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviesTVC.identifier, for: indexPath) as? MoviesTVC else { return UITableViewCell() }
        cell.btnDownload.tag = indexPath.row
        cell.btnDownload.addTarget(self, action: #selector(self.btnDownlodtapped(sender:)), for: .touchUpInside)
        let title = arrUpComing[indexPath.row]
         
        let avgVote = Double(round(10 * (title.vote_average)) / 10)
        let img = (Constants.IMAGE_URL + (title.poster_path ?? "") )
        
        cell.configure(with: MovieViewModel(movieTitleName: ((title.original_title ?? title.original_name) ?? "Unknown Title" ), movieImgUrl: img, movieAvgVote: "Excitment Level : \( "\(avgVote)/10" )"))
        cell.fetchSavedDataFromCoreData()
        cell.showHideDownlodButton(cellMoviewID: title.id)
        return cell
    }

    
    @objc func btnDownlodtapped(sender:UIButton){
        downloadTitleAt(rowNumber: sender.tag)
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        DispatchQueue.main.async { [weak self] in
            let vc = MovieDetailVC()
            guard let model = self?.arrUpComing[indexPath.row] else{
                return
            }
            vc.titleModel = model
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
   
    
}
