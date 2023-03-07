//
//  APICaller.swift
//  FilmApplication
//
//  Created by Yildirim on 15.02.2023.
//

import Foundation
import Alamofire

enum APIError: Error{
    case failedToGetData
}

class APICaller{
    static let shared = APICaller()
    
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void){
        let url = ApiKey.baseURLMDB + "/3/trending/all/day?api_key=" + ApiKey.APIKeyMDB
        let task = AF.request(url, method: .get).response { response in
            guard let data = response.data else {
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
    func getTrendingTv(completion: @escaping (Result<[Title], Error>) -> Void){
        let url = ApiKey.baseURLMDB + "3/trending/tv/day?api_key=" + ApiKey.APIKeyMDB
        let task = AF.request(url, method: .get).response{
            response in
            guard let data = response.data else { return }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title],Error>) -> Void){
        let url = ApiKey.baseURLMDB + "/3/movie/upcoming?api_key=" + ApiKey.APIKeyMDB + "&language=en-US&page=1"
        let task = AF.request(url, method: .get).response {
            response in
            guard let data = response.data else { return }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Title], Error>) -> Void){
        let url = ApiKey.baseURLMDB + "/3/movie/top_rated?api_key=" + ApiKey.APIKeyMDB
        let task = AF.request(url, method: .get).response{
            result in
            guard let data = result.data else { return }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getPopularMovies(complation: @escaping (Result<[Title], Error>) -> Void){
        let url = ApiKey.baseURLMDB + "/3/movie/popular?api_key=" + ApiKey.APIKeyMDB
        let task = AF.request(url, method:.get).response{
            response in
            guard let data = response.data else { return }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                complation(.success(results.results))
            }catch{
                complation(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getDiscover(completion: @escaping (Result<[Title], Error>) -> Void){
        let url = ApiKey.baseURLMDB + "/3/discover/movie?api_key=" + ApiKey.APIKeyMDB + "&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        let task = AF.request(url, method: .get).response{
            response in
            guard let data = response.data else {return}
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                print(APIError.failedToGetData)
            }
        }
        task.resume()
    }
    
    
    func getSearch(with query: String, completion: @escaping (Result<[Title], Error>) -> Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed) else {return}
        let url = ApiKey.baseURLMDB + "/3/search/movie?api_key=" + ApiKey.APIKeyMDB + "&query=" + query
        let task = AF.request(url, method: .get).response{
            response in
            guard let data = response.data else {return}
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void){
       //-- guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        //--let url = "https://youtube.googleapis.com/youtube/v3/search?q=" + query + "&key=" + ApiKey.API_Key_Youtube
        //--let task = AF.request(url, method: .get).response{
            //--response in
            //--guard let data = response.data else { return }
        
            //** Mock Part Begin
            let url = "/Users/r00th/Code/MovieApplication/MovieApplication/Network/@MockYoutubeResponse.json"
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: url)) else {return}
            //** Mock Part End
        
            do{
                let result = try JSONDecoder().decode(YoutubeContent.self , from: data)
                completion(.success(result.items[0]))
            }catch{
                completion(.failure(error))
                print(error.localizedDescription)
            }
        //--}
        //--task.resume()
        
    }
    
}
 
