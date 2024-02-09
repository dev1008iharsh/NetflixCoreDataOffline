//
//  MovieDetailVC.swift
//  Netflix Harsh Clone
//
//  Created by My Mac Mini on 20/12/23.
//

import UIKit
import WebKit

class MovieDetailVC: UIViewController {
    
    //MARK: -  Properties
    
    var titleModel : MovieModel?
    var titleItem : TitleItem?
    var isFromDownload = false
    
    private let lblTitle: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = ""
        label.numberOfLines = 2
        return label
    }()
    
    private let lblOverView: UILabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    /*
     private let downloadButton: UIButton = {
     
     let button = UIButton()
     button.translatesAutoresizingMaskIntoConstraints = false
     button.backgroundColor = .red
     button.setTitle("Download", for: .normal)
     button.setTitleColor(.white, for: .normal)
     button.layer.cornerRadius = 8
     button.layer.masksToBounds = true
     
     return button
     }()*/
    
    private let webViewYoutube: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .systemBackground
        webView.scrollView.isScrollEnabled = false
        return webView
    }()
    
    
    //MARK: -  ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webViewYoutube)
        view.addSubview(lblTitle)
        view.addSubview(lblOverView)
        //view.addSubview(downloadButton)
        
        configureConstraints()
        
        fetDataApi()
        //self.tabBarController?.tabBar.backgroundColor = .systemBackground
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UINavigationBar.appearance().isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureConstraints()
    }
    
    
    func configureConstraints() {
        
        let webViewConstraints = [
            webViewYoutube.topAnchor.constraint(equalTo: view.topAnchor, constant: -48),
            webViewYoutube.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webViewYoutube.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webViewYoutube.heightAnchor.constraint(equalToConstant: 400)
        ]
        
        let titleLabelConstraints = [
            lblTitle.topAnchor.constraint(equalTo: webViewYoutube.bottomAnchor, constant: 10),
            lblTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            lblTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ]
        
        let overviewLabelConstraints = [
            lblOverView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 5),
            lblOverView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            lblOverView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ]
        /*
         let downloadButtonConstraints = [
         downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 15),
         downloadButton.widthAnchor.constraint(equalToConstant: 140),
         downloadButton.heightAnchor.constraint(equalToConstant: 40)
         ]*/
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        //NSLayoutConstraint.activate(downloadButtonConstraints)
        //downloadButton.isHidden = true
    }
    
    //MARK: -  API Call Functions
    func fetDataApi(){
        
        
        var titleForYt = ""
        if !(isFromDownload){
            titleForYt = self.titleModel?.original_name ?? ""
            if titleForYt == ""{
                titleForYt = self.titleModel?.original_title ?? ""
            }
            self.lblTitle.text = titleForYt
            self.lblOverView.text = self.titleModel?.overview
        }else{
            titleForYt = self.titleItem?.original_name ?? ""
            if titleForYt == ""{
                titleForYt = self.titleItem?.original_title ?? ""
            }
            self.lblTitle.text = titleForYt
            self.lblOverView.text = self.titleItem?.overview
        }
        
        ApiCaller.shared.getYoutube(with: titleForYt + " official trailer"){[weak self] result in
            
            switch result {
            case .success(let videoElement):
                
                DispatchQueue.main.async {[weak self] in
                     
                    guard let url = URL(string: "https://www.youtube.com/embed/\(videoElement.id.videoId)") else {
                        return
                    }
                    self?.webViewYoutube.load(URLRequest(url: url))
                    //self?.downloadButton.isHidden = false
                    
                }
                
                
            case .failure(let error):
                print(error.localizedDescription)
                
                DispatchQueue.main.async {[weak self] in
                    UtilityManager().showAlertHandler(title: "Coun't get data from server", message: "", view: self!) { (UIAlertAction) in
                        
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
                
            }
            
        }
    }
    
}
