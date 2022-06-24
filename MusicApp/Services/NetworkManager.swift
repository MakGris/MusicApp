//
//  NetworkManager.swift
//  MusicApp
//
//  Created by Артур Сахбиев on 17.06.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidData
    case decodeError
}

class NetworkManager {
     static let shared = NetworkManager()
    
    private let urlString = "https://itunes.apple.com/search?term=jack+johnson&limit=25"
        
    func fetchTracks(completion: @escaping (Result<MusicModel,NetworkError>) -> Void){
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                guard let data = data else {return}
                do{
                    let tracks = try JSONDecoder().decode(MusicModel.self, from: data)
                    completion(.success(tracks))
                    print(tracks)
                }catch let error{
                    print(error.localizedDescription)
                    completion(.failure(.decodeError))
                }
            }
        }.resume()
    }
    
    func fetchImage(with track: Tracks, completion: @escaping (Result<Data,NetworkError>) -> Void){
        DispatchQueue.global().async {
            guard let url = URL(string: track.artworkUrl60 ?? "" ) else {
                completion(.failure(.invalidURL))
                return
            }
            if let imageData = try? Data(contentsOf: url){
                completion(.success(imageData))
                return
            } else {
                completion(.failure(.invalidData))
                return
            }
        }
    }
    
    private init() {}
    
}
