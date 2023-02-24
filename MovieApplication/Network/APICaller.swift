//
//  APICaller.swift
//  FilmApplication
//
//  Created by Yildirim on 15.02.2023.
//

import Foundation
import Alamofire


struct Constants{
    static let API_Key = "cbc1274753a04c163039ce80483a66a1"
    static let baseURL = "https://api.themoviedb.org/"
    static let API_Key_Youtube = "AIzaSyDNQmYLjwr-zx9PJGPSMzSSSpv6BALkLZ4"
}
enum APIError: Error{
    case failedToGetData
}

class APICaller{
    static let shared = APICaller()
    
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void){
        let url = Constants.baseURL + "/3/trending/all/day?api_key=" + Constants.API_Key
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
        let url = Constants.baseURL + "3/trending/tv/day?api_key=" + Constants.API_Key
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
        let url = Constants.baseURL + "/3/movie/upcoming?api_key=" + Constants.API_Key + "&language=en-US&page=1" //https://api.themoviedb.org/3/movie/upcoming?api_key=cbc1274753a04c163039ce80483a66a1&language=en-US&page=1
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
        let url = Constants.baseURL + "/3/movie/top_rated?api_key=" + Constants.API_Key
        //https://api.themoviedb.org/3/movie/top_rated?api_key=cbc1274753a04c163039ce80483a66a1&language=en-US&page=1
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
        let url = Constants.baseURL + "/3/movie/popular?api_key=" + Constants.API_Key
        //https://api.themoviedb.org/3/movie/popular?api_key=cbc1274753a04c163039ce80483a66a1&language=en-US&page=1
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
        let url = Constants.baseURL + "/3/discover/movie?api_key=" + Constants.API_Key + "&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
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
        let url = Constants.baseURL + "/3/search/movie?api_key=" + Constants.API_Key + "&query=" + query
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
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        let url = "https://youtube.googleapis.com/youtube/v3/search?q=" + query + "&key=" + Constants.API_Key_Youtube
        let task = AF.request(url, method: .get).response{
            response in
            guard let data = response.data else { return }
            do{
                let result = try JSONDecoder().decode(YoutubeContent.self , from: data)
                completion(.success(result.items[0]))
            }catch{
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    
//    func getMovie(with query: String){
//        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
//        let url = "https://youtube.googleapis.com/youtube/v3/search?q=" + query + "&key=" + Constants.API_Key_Youtube
//        let task = AF.request(url, method: .get).response{
//            response in
//           guard let data = response.data else { return }
//            print(data)
//            guard let data = response.data else { return }
//            do{
//                let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                print(result)
//                //completion(.success(result.item[0]))
//            }catch{
//                print(error.localizedDescription)
//            }
//        }
//
//    }

}
 
