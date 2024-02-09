//
//  DataPersistenceManager.swift
//  Netflix Harsh Clone
//
//  Created by My Mac Mini on 23/12/23.
//

import UIKit
import CoreData

enum DatabaseError : Error {
    
    case faildToSaveData
    case faildToFetchData
    case faildToDeleteData
    
}

class DataPersistenceManager{
    static let shared = DataPersistenceManager()
    
    //MARK: -  Save Movie in Downlod Menu using coredata
    
    func downlodTitleWith (model : MovieModel, completion : @escaping(Result<Void,Error>) -> Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let contex = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: contex)
        item.id = Int64(model.id)
        item.media_type = model.media_type
        item.original_name = model.original_name
        item.original_title = model.original_title
        item.poster_path = model.poster_path
        item.overview = model.overview
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        
        do{
            try contex.save()
            completion(.success(()))
        }catch{
            print(error.localizedDescription)
            completion(.failure(DatabaseError.faildToSaveData))
        }
    }
    
    func saveOfflineMovies(arrModel : [MovieModel]){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let contex = appDelegate.persistentContainer.viewContext
        
        for index in 0..<arrModel.count {
            let item2 = OfflineMovie(context: contex)
            item2.id = Int64(arrModel[index].id)
            item2.media_type = arrModel[index].media_type
            print("index*****",arrModel[index].poster_path!)
            item2.original_name = arrModel[index].original_name
            item2.original_title = arrModel[index].original_title
            item2.poster_path = arrModel[index].poster_path
            item2.overview = arrModel[index].overview
            item2.release_date = arrModel[index].release_date
            item2.vote_average = arrModel[index].vote_average
            print(item2)
            // Code to execute for each item
        }
        
        do{
            try contex.save()
            print("Saved in coredata")
        }catch{
            print(error.localizedDescription)
        }
       
        
    }
    
    func fetchOfflineMovies(completion : @escaping(Result<[OfflineMovie],Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<OfflineMovie>
        request = OfflineMovie.fetchRequest()
        
        
        do{
            let titlesData = try context.fetch(request)
            completion(.success(titlesData))
        }catch{
            print(error.localizedDescription)
        }
    }
    //MARK: -  Fetch movies from coredata
    func fetingTitleFromDataBase(completion : @escaping(Result<[TitleItem],Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        
        do{
            let titles = try context.fetch(request)
            completion(.success(titles))
        }catch{
            print(error.localizedDescription)
        }
    }
    
   
    
    func deleteAllData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OfflineMovie")
        
        do {
            let entities = try context.fetch(fetchRequest) as! [NSManagedObject]
            for entity in entities {
                context.delete(entity)
            }
            
            try context.save()
            print("dddddddeleting all data")
        } catch let error {
            print("Error deleting all data: \(error)")
        }
    }
   
    /*
    func fetchOfflineMovies(completion : @escaping(Result<[MovieModel],Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<OfflineMovie>
        request = OfflineMovie.fetchRequest()
        
        
        do{
            let titles = try context.fetch(request)
            var arrMovieModel = [MovieModel]()
            
            for i in 0..<titles.count {
                
                //print("index*****",titles[i].poster_path!)
                
                let model = MovieModel(id: Int(titles[i].id), media_type: titles[i].media_type, original_name: titles[i].original_name, original_title: titles[i].original_title, poster_path: titles[i].poster_path, overview: titles[i].overview, release_date: titles[i].release_date, vote_average: titles[i].vote_average)
                  
                arrMovieModel.append(model)
                // Code to execute for each item
            }
            completion(.success(arrMovieModel))
        }catch{
            print(error.localizedDescription)
        }
    }
     
     func fetchOfflineMoviesDataOkDoneGoodBye() -> [MovieModel]{
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
             return []
         }
         
         let context = appDelegate.persistentContainer.viewContext
         let request : NSFetchRequest<OfflineMovie>
         request = OfflineMovie.fetchRequest()
          
         do{
             let titles = try context.fetch(request)
             var arrMovieModel = [MovieModel]()
             
             for i in 0..<titles.count {
                 
                 //print("index*****",titles[i].poster_path!)
                 
                 let model = MovieModel(id: Int(titles[i].id), media_type: titles[i].media_type, original_name: titles[i].original_name, original_title: titles[i].original_title, poster_path: titles[i].poster_path, overview: titles[i].overview, release_date: titles[i].release_date, vote_average: titles[i].vote_average)
                   
                 arrMovieModel.append(model)
                 // Code to execute for each item
             }
             return arrMovieModel
         }catch{
             return []
         }
     }
    //MARK: -  Fetch movies from coredata
    func fetingTitleFromDataBase(completion : @escaping(Result<[TitleItem],Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        
        do{
            let titles = try context.fetch(request)
            completion(.success(titles))
        }catch{
            print(error.localizedDescription)
        }
    }*/
    
    
    
    //MARK: -  delete from coredata for downlod menu
    func deleteTitleWith(model : TitleItem, completion :@escaping(Result<Void,Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let contex = appDelegate.persistentContainer.viewContext
        contex.delete(model)
        
        do{
            try contex.save()
            completion(.success(()))
        }catch{
            print(error.localizedDescription)
            completion(.failure(DatabaseError.faildToDeleteData))
        }
    }
    
    //MARK: -  delete from coredata for downlod menu
    func deleteTitleUsingIDWith(id : Int, completion :@escaping(Result<Void,Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let contex = appDelegate.persistentContainer.viewContext
     
        let request : NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        if let result = try? contex.fetch(request) {
            for object in result {
                if object.id == id{
                    contex.delete(object)
                }
            }
        }
 
        do{
            try contex.save()
            completion(.success(()))
        }catch{
            print(error.localizedDescription)
            completion(.failure(DatabaseError.faildToDeleteData))
        }
    }
}
