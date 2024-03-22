//
//  TextToImage.swift
//  advocAR

// potential usage: generate UIImage for USDZ images downloaded from Sketchfab?

import Foundation

func performRequest() {
    let headers = [
      "accept": "application/json",
      "content-type": "application/json",
      "Authorization": "\(Secrets.accessKey)"
    ]
    let parameters = [
      "messages": "Give me an image of a cute, phantom, cockapoo. Very cute, not too fluffy",
      "model": "cortext-image",
      "size": "1024x1024",
      "quality": "standard",
      "provider": "OpenAI",
      "steps": 30,
      "cfg_scale": 8,
      "style": "vivid"
    ] as [String : Any]
    
    let semaphore = DispatchSemaphore(value: 0) // Semaphore for waiting
    
    do {
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.corcel.io/v1/image/cortext/text-to-image")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          defer { semaphore.signal() } // Signal to end waiting when request completes
          
          if let error = error {
            print("Error: \(error)")
            return
          }
          
          if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Response: \(httpResponse)")
          }
          
          if let data = data {
            // Assuming the response is JSON, adjust as necessary
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) {
                print("JSON Response: \(jsonResponse)")
            }
          }
        })
        
        dataTask.resume()
        semaphore.wait() // Wait for the completion handler to signal
    } catch {
        print("Error serializing JSON: \(error)")
    }
}

// execute this: performRequest()
