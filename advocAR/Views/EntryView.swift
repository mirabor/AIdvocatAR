import Foundation
import SwiftUI

class EntryViewModel: ObservableObject {
    @Published var jsonResponse: String = ""
    
    var searchableUsdzFileNames: [String] {
        let fileManager = FileManager.default
        
        guard let path = Bundle.main.resourcePath else {
            return []
        }
        
        guard let files = try? fileManager.contentsOfDirectory(atPath: path) else {
            return []
        }
        
        return files.compactMap { filename -> String? in
            guard filename.hasSuffix(".usdz") else {
                return nil
            }
            return filename
        }
    }
    
    func performChatRequest(userInput: String) {
        let headers = [
          "accept": "application/json",
          "content-type": "application/json",
          "Authorization": "f8ee38c2-12cb-4db9-901d-e67574b69441"
        ]
        let parameters = [
          "model": "cortext-ultra",
          "stream": false,
          "top_p": 1,
          "temperature": 0.0001,
          "max_tokens": 4096,
          "messages": [
            [
              "role": "system",
              "content": "Here is a list of items: \(self.searchableUsdzFileNames). Ignore the .usdz ending. Pick three strings that are most logically relevant to the following text: \(userInput). Only output those three strings, all with the .usdz ending Do not elaborate."
            ]
          ]
        ] as [String : Any]

        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.corcel.io/v1/text/cortext/chat")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
          
          if let error = error {
            DispatchQueue.main.async {
                self.jsonResponse = "Error: \(error.localizedDescription)"
            }
            return
          }
          
          if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) {
                DispatchQueue.main.async {
                    self.jsonResponse = "Response: \(jsonResponse)"
                }
            }
        }
        
        dataTask.resume()
    }
}

struct EntryView: View {
    @State private var userInput = ""
    @StateObject private var viewModel = EntryViewModel()
    
    let indigoColor = UIColor(red: 45/255.0,
                               green: 80/255.0,
                               blue: 207/255.0,
                               alpha: 1)
    
    var body: some View {
        VStack {
            TextField("Enter text here", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("User input: \(userInput)")
                .padding()
            
            Button(action: {
                viewModel.performChatRequest(userInput: userInput)
            }) {
                Text("Submit")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(indigoColor))
                    .cornerRadius(10)
            }
            .padding()
            
            if !viewModel.jsonResponse.isEmpty {
                Text(viewModel.jsonResponse)
                    .padding()
            }

            Spacer()
        }
        .background(Color(.systemBackground))
        .cornerRadius(7)
        .padding()
    }
}

struct EntryViewPreview: PreviewProvider  {
    
    static var previews: some View {
        EntryView()
            .preferredColorScheme(.dark)
    }
    
}

