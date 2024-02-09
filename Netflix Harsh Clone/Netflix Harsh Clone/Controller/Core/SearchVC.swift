//
//  SearchVC.swift
//  Netflix Harsh Clone
//
//  Created by My Mac Mini on 19/12/23.
//

import UIKit
 

class SearchVC: UIViewController, UISearchResultsUpdating, ProtocolSearchResult {
  
    //MARK: -  Properties
    var arrDiscover : [MovieModel] = [MovieModel]()
     
    private let searchControllerObj : UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultVC())
        controller.searchBar.placeholder = "Search for a Movie for Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private let tblDiscover : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(MoviesTVC.self, forCellReuseIdentifier: MoviesTVC.identifier)
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
         
        return table
    }()
    
    
    //MARK: -  ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
         
        title = "Search"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .systemRed
       
        navigationItem.searchController = searchControllerObj
        
        view.addSubview(tblDiscover)
         
        tblDiscover.dataSource = self
        tblDiscover.delegate = self
        
        searchControllerObj.searchResultsUpdater = self
        
        fetchApiData()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(Constants.keyReloadTablDiscover), object: nil, queue: nil) { _ in
            self.tblDiscover.reloadData()
        }
            
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tblDiscover.frame = view.bounds
    }
    
    //MARK: -  API Call Functions
    func fetchApiData(){
        
        ApiCaller.shared.getDiscoverMovies { result in
            switch result {
            case .success(let title):
                self.arrDiscover = title
                DispatchQueue.main.async {[weak self] in
                    self?.tblDiscover.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    //MARK: -  SearchMoview Api and Open SearchResult Controller
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchbar = searchController.searchBar
        
        guard let query = searchbar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count > 3,
              let resultVC = searchController.searchResultsController as? SearchResultVC  else {return}
        resultVC.delegateSearchTapCell = self
        ApiCaller.shared.searchMovies(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let title):
                    resultVC.arrSearch = title
                    resultVC.collvSearch.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: -  Manage SearchResult Controller Did Tap Cell Delegate
    func didTapSearchFunc(_ viewModel: MovieModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = MovieDetailVC()
            
            vc.titleModel = viewModel
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: -  Save Data to coreData on did tap cell
    func downloadTitleAt(rowNumber : Int){
         
        print("Downloading Title : \(arrDiscover[rowNumber].original_title ?? "") & Name \(arrDiscover[rowNumber].original_name ?? "")")
        
        DataPersistenceManager.shared.downlodTitleWith(model: arrDiscover[rowNumber]) { result in
        
            switch result{
            case .success():
                print("downlod coredata")
                UtilityManager().postAllNotificationForReloadDownloadData()
                /*
                NotificationCenter.default.post(name: NSNotification.Name(Constants.keyReloadTablDownload), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(Constants.keyReloadTablUpcoming), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(Constants.keyReloadTablHome), object: nil)
                self.tblDiscover.reloadData()*/
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

//MARK: -  UITableViewDelegate, UITableViewDataSource
extension SearchVC : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDiscover.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviesTVC.identifier, for: indexPath) as? MoviesTVC else { return UITableViewCell() }
         
        cell.btnDownload.tag = indexPath.row
        cell.btnDownload.addTarget(self, action: #selector(self.btnDownlodtapped(sender:)), for: .touchUpInside)
        
        let title = arrDiscover[indexPath.row]
       
        let avgVote = Double(round(10 * (title.vote_average)) / 10)
        let img = (Constants.IMAGE_URL + (title.poster_path ?? "") )
        cell.tag = indexPath.row
        cell.configure(with: MovieViewModel(movieTitleName: ((title.original_title ?? title.original_name) ?? "Unknown Title" ), movieImgUrl: img, movieAvgVote: "Average Voting : \( "\(avgVote)/10" )"))
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
            guard let model = self?.arrDiscover[indexPath.row] else{
                return
            }
            vc.titleModel = model
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
