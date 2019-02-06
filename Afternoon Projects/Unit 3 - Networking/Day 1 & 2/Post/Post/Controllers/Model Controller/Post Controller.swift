//
//  Post Controller.swift
//  Post
//
//  Created by Deniz Tutuncu on 2/4/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class PostController {
    
    let baseURL = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
    var posts: [Post] = []
    
    func fetchPosts(reset: Bool = true, completion: @escaping () -> Void) {
        let queryEndInterval = reset ? Date().timeIntervalSince1970 : posts.last?.timestamp ?? Date().timeIntervalSince1970
        
        let urlParameters = [
            "orderBy": "\"timestamp\"",
            "endAt": "\(queryEndInterval)",
            "limitToLast": "15",
            ]
        
        let queryItems = urlParameters.compactMap( { URLQueryItem(name: $0.key, value: $0.value) } )
        
        guard let unwrappedURL = baseURL else { completion(); return }
        
        var urlComponents = URLComponents(url: unwrappedURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { completion(); return }
        
        let getterEndpoint = url.appendingPathExtension("json")
        
        var urlRequest = URLRequest(url: getterEndpoint)
        print(urlRequest)
        urlRequest.httpBody = nil
        urlRequest.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            do {
                if let downloadError = error { throw downloadError }
                guard let data = data else { throw NSError() }
                //Decode
                let jsonDecoder = JSONDecoder()
                let postsDictionary = try! jsonDecoder.decode([String:Post].self, from: data)
                let posts  = postsDictionary.compactMap({ $0.value })
                let sortedPosts = posts.sorted(by: { $0.timestamp > $1.timestamp })
                if reset {
                    self.posts = sortedPosts
                } else {
                    self.posts.append(contentsOf: sortedPosts)
                }
                completion()
                
            } catch {
                print("\(error.localizedDescription)")
                completion()
                return
            }
        }
        dataTask.resume()
    }
    
    func addNewPostWith(username: String, text: String, completion: @escaping () -> Void) {
        let post = Post(text: text, username: username)
        var postData: Data
        do {
            //Encoder
            let jsonEncoder = JSONEncoder()
            postData = try jsonEncoder.encode(post)
            completion()
            
        } catch {
            print("\(error.localizedDescription)")
            completion()
            return
        }
        guard let unwrappedURL = baseURL else { fatalError("URL optional is having some problems") }
        let getterEndpoint = unwrappedURL.appendingPathExtension("json")
        var urlRequest = URLRequest(url: getterEndpoint)
        urlRequest.httpBody = postData
        urlRequest.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                print("Error Fetching Post from API: \(error) : \(error.localizedDescription)")
            }
            guard let data = data, let repsonseBack = String(data: data, encoding: .utf8) else {
                print("No data found from API")
                completion()
                return
            }
            NSLog(repsonseBack)
            self.fetchPosts(completion: {
                completion()
            })
        }
        dataTask.resume()
    }
}
