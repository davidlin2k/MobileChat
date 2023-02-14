//
//  GPTService.swift
//  MobileChat
//
//  Created by David Lin on 2023-02-13.
//

import Combine
import Foundation

struct GPTResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    let usage: Usage
    
    struct Choice: Codable {
        let text: String
        let index: Int
        let finish_reason: String
    }
    
    struct Usage: Codable {
        let prompt_tokens: Int
        let completion_tokens: Int
        let total_tokens: Int
    }
}

protocol GPTService {
    func generate(prompt: String) -> AnyPublisher<String, Error>
}

struct RealGPT3Service: GPTService {
    func generate(prompt: String) -> AnyPublisher<String, Error> {
        var apiKey = ""
        
        if let path = Bundle.main.path(forResource: "Property List", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
           apiKey = dict["GPT3_API_KEY"] as? String ?? ""
        }
        
        let headers = [
          "accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer \(apiKey)"
        ]
        let parameters = [
          "model": "text-davinci-003",
          "prompt": prompt,
          "max_tokens": 2048,
          "top_p": 1,
          "frequency_penalty": 0,
          "presence_penalty": 0
        ] as [String : Any]
        

        return Deferred {
            Future<String, Error> { promise in
                do {
                    let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    
                    let request = NSMutableURLRequest(url: NSURL(string: "https://api.openai.com/v1/completions")! as URL,
                                                      cachePolicy: .useProtocolCachePolicy,
                                                      timeoutInterval: 30.0)
                    request.httpMethod = "POST"
                    request.allHTTPHeaderFields = headers
                    request.httpBody = postData as Data
                    
                    let session = URLSession.shared
                    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                        if (error != nil) {
                            print(error as Any)
                        } else {
                            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                                print("Invalid response")
                                return
                            }
                            
                            do {
                                let decoder = JSONDecoder()
                                let response = try decoder.decode(GPTResponse.self, from: data)
                                
                                let generatedText = response.choices[0].text
                                
                                promise(.success(generatedText))
                            } catch {
                                promise(.failure(error))
                            }
                        }
                    })
                    
                    dataTask.resume()
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
