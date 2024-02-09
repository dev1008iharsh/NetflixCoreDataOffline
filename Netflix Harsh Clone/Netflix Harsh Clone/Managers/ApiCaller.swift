//
//  ApiCaller.swift
//  Netflix Harsh Clone
//
//  Created by My Mac Mini on 19/12/23.
//

import UIKit

struct Constants{
    //tmdb manage backend
    static let API_KEY = "771e4afd69be18409aaa3cf6969dd94b"
    static let BASE_URL = "https://api.themoviedb.org"
    static let IMAGE_URL = "https://image.tmdb.org/t/p/w500"
    
    static let YOUTUBE_API_KEY = "AIzaSyD5u58625W6pc3XHuH8qQ9q9hjnrznhgAU" // key from youtubeapi
    
    static let YOUTUBE_BASE_URL = "https://youtube.googleapis.com/youtube/v3/search?"
    
    static let keyReloadTablUpcoming = "reloadUpcoming"
    static let keyReloadTablDiscover = "reloadDiscover"
    static let keyReloadTablDownload = "reloadDownlod"
    static let keyReloadTablHome = "homeDownlod"
     
    
}

class UtilityManager: NSObject {
    
    public func showAlert(title:String, message: String, view:UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    public func showAlertHandler(title:String, message: String, view:UIViewController,okAction:@escaping ((UIAlertAction) -> Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: okAction))
        view.present(alert, animated: true, completion: nil)
    }
    
    public func showConfirmAlert(title:String, message: String, view:UIViewController,YesAction:@escaping ((UIAlertAction) -> Void),NoAction:@escaping ((UIAlertAction) -> Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: YesAction))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: NoAction))
        view.present(alert, animated: true, completion: nil)
    }
    
    public func postAllNotificationForReloadDownloadData(){
        NotificationCenter.default.post(name: NSNotification.Name(Constants.keyReloadTablUpcoming), object: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(Constants.keyReloadTablDiscover), object: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(Constants.keyReloadTablHome), object: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(Constants.keyReloadTablDownload), object: nil)
    }
    
    func showLoader(_ show: Bool, loadingText : String = "") {
        
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return }
            guard let _ = windowScene.windows.last else { return }
            windowScene.keyWindow?.viewWithTag(1200)
            //UIApplication.shared.window[0].viewWithTag(1200)
            let existingView = windowScene.keyWindow?.viewWithTag(1200)
            
            if show {
                if existingView != nil {
                    return
                }
                let loadingView =  self.makeLoadingView(withFrame: UIScreen.main.bounds, loadingText: loadingText)
                loadingView?.tag = 1200
                windowScene.keyWindow?.addSubview(loadingView!)
            } else {
                existingView?.removeFromSuperview()
            }
        }
        

    }



    func makeLoadingView(withFrame frame: CGRect, loadingText text: String?) -> UIView? {
        let loadingView = UIView(frame: frame)
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        //activityIndicator.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1)
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.center = loadingView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        activityIndicator.tag = 100 // 100 for example

        loadingView.addSubview(activityIndicator)
        if !text!.isEmpty {
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
            let cpoint = CGPoint(x: activityIndicator.frame.origin.x + activityIndicator.frame.size.width / 2, y: activityIndicator.frame.origin.y + 80)
            lbl.center = cpoint
            lbl.textColor = UIColor.white
            lbl.textAlignment = .center
            lbl.text = text
            lbl.tag = 1234
            loadingView.addSubview(lbl)
        }
        return loadingView
    }

}


enum ApiError : Error {
    case failedToGetData
}

class ApiCaller{
    
    static let shared = ApiCaller()
    //let resultsJsonseral = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
    //print(results.result[0].original_name)
    
    //MARK: -  TMDB Api for varios categorised movies data
    func getTrendingMovies(completion: @escaping (Result<[MovieModel],Error>) -> Void){
        UtilityManager().showLoader(true)
        guard let url = URL(string: "\(Constants.BASE_URL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            UtilityManager().showLoader(false)
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TitleShowResponcse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                print("getTrendingMovies Error ",error.localizedDescription)
                completion(.failure(ApiError.failedToGetData))
            }
        }
        task.resume()
        
    }
    
    
    func getTrendingTVshows(completion : @escaping(Result<[MovieModel],Error>) -> Void){
        UtilityManager().showLoader(true)
        guard let url = URL(string: "\(Constants.BASE_URL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data,_,error in
            UtilityManager().showLoader(false)
            guard let data = data, error == nil else { return }
            do{
                let results = try JSONDecoder().decode(TitleShowResponcse.self, from: data)
                completion(.success(results.results))
            }catch{
                print("getTrendingTVshows Error ",error.localizedDescription)
                completion(.failure(ApiError.failedToGetData))
            }
        }
        task.resume()
        
    }
     
    //https://api.themoviedb.org/3/tv/top_rated
    //https://api.themoviedb.org/3/movie/top_rated
    
    func getTopRatedMovies(completion: @escaping (Result<[MovieModel],Error>) -> Void){
        UtilityManager().showLoader(true)
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/top_rated?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            UtilityManager().showLoader(false)
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TitleShowResponcse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                print("getTopRatedMovies Error ",error.localizedDescription)
                completion(.failure(ApiError.failedToGetData))
            }
        }
        task.resume()
        
    }
    
    
    func getPopularMovies(completion: @escaping (Result<[MovieModel],Error>) -> Void){
        UtilityManager().showLoader(true)
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/popular?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            UtilityManager().showLoader(false)
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TitleShowResponcse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                print("getPopularMovies Error ",error.localizedDescription)
                completion(.failure(ApiError.failedToGetData))
            }
        }
        task.resume()
        
    }
    
    //https://api.themoviedb.org/3/movie/now_playing
    
    func getScreeningInTheaterMovies(completion: @escaping (Result<[MovieModel],Error>) -> Void){
        UtilityManager().showLoader(true)
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/now_playing?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            UtilityManager().showLoader(false)
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TitleShowResponcse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                print("getInTheaterMovies Error ",error.localizedDescription)
                completion(.failure(ApiError.failedToGetData))
            }
        }
        task.resume()
        
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[MovieModel],Error>) -> Void){
        UtilityManager().showLoader(true)
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/upcoming?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            UtilityManager().showLoader(false)
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TitleShowResponcse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                print("getUpcomingMovies Error ",error.localizedDescription)
                completion(.failure(ApiError.failedToGetData))
            }
        }
        task.resume()
        
    }
    
    
    func getDiscoverMovies(completion: @escaping (Result<[MovieModel],Error>) -> Void){
        
        UtilityManager().showLoader(true)
        
        guard let url = URL(string: "\(Constants.BASE_URL)/3/discover/movie?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            UtilityManager().showLoader(false)
            
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TitleShowResponcse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                print("getDiscoverMovies Error ",error.localizedDescription)
                completion(.failure(ApiError.failedToGetData))
            }
        }
        task.resume()
        
    }
    
    func searchMovies(with query : String, completion : @escaping(Result<[MovieModel],Error>) -> Void){
        
        UtilityManager().showLoader(true)
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let urlSearch = URL(string: "\(Constants.BASE_URL)/3/search/movie?query=\(query)&api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: urlSearch)) {data, _, error in
            
            UtilityManager().showLoader(false)
            guard let data = data, error == nil else{
                return
            }
            do {
                let results = try JSONDecoder().decode(TitleShowResponcse.self, from: data)
                completion(.success(results.results))
            } catch  {
                print("getDiscoverMovies Error ",error.localizedDescription)
                completion(.failure(ApiError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    
    //https://youtube.googleapis.com/youtube/v3/search?q=dunkiofficialtrailer&key=AIzaSyDqX8axTGeNpXRiISTGL7Tya7fjKJDYi4g
    
    //MARK: -  Youtube Data Api which showed on detail screen
    func getYoutube(with query : String, completion : @escaping(Result<VideoElement,Error>) -> Void){
        
        UtilityManager().showLoader(true)
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let urlSearch = URL(string: "\(Constants.YOUTUBE_BASE_URL)q=\(query)&key=\(Constants.YOUTUBE_API_KEY)") else { return }
        print("***",urlSearch)
        let task = URLSession.shared.dataTask(with: URLRequest(url: urlSearch)) {data, _, error in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UtilityManager().showLoader(false)
            }
            
            
            guard let data = data, error == nil else{
                return
            }
            do {
                let results = try JSONDecoder().decode(YoutubeModel.self, from: data)
                completion(.success(results.items[0]))
            } catch  {
                print("getYoutube Error ",error.localizedDescription)
                completion(.failure(ApiError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    
}
