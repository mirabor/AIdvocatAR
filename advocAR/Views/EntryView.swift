import Foundation
import SwiftUI

class EntryViewModel: ObservableObject {
    @Published var jsonResponse: String = ""
    @Published var selectedNames: [String] = []
    @Published var explanations: [String] = []
    
    
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
    
    func performChatRequest(userInput: String, completion: @escaping () -> Void) {
        let url = NSURL(string: "https://api.corcel.io/v1/text/cortext/chat")!
        print("Request URL: \(url)")
        
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
                    "content": "Here is a list of items: \(self.searchableUsdzFileNames). Pick three strings that are most reminiscent of this creative writing excerpt: \(userInput). End of excerpt. Output an hashtable of an array with the key 'selectedNames' and an array with the key 'explanation': The first array is of those three strings, all with the .usdz ending. Do not elaborate in the first array. The second array is the 3 explanations of why those three objects were selected, but do not say the names of the objects; instead, reference them as 'your first/second/third custom object'. Do not include extraneous text outside the array or string."
                ]
            ]
        ] as [String : Any]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Failed to serialize post data")
            return
        }
        
        let request = NSMutableURLRequest(url: url as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        print("Request Headers: \(headers)")
        print("Request Body: \(String(data: postData, encoding: .utf8) ?? "Invalid body")")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Network request error: \(error)")
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            
            print("Response Data: \(String(data: data, encoding: .utf8) ?? "Invalid data encoding")")
            
            if let jsonObject = try? JSONSerialization.jsonObject(with: data),
               let responseDict = jsonObject as? [String: Any],
               let choices = responseDict["choices"] as? [[String: Any]],
               let firstChoice = choices.first,
               let delta = firstChoice["delta"] as? [String: Any],
               let content = delta["content"] as? String,
               let contentData = content.data(using: .utf8),
               let contentJson = try? JSONSerialization.jsonObject(with: contentData) as? [String: Any],
               let selectedNames = contentJson["selectedNames"] as? [String],
               let explanations = contentJson["explanations"] as? [String] {
                
                DispatchQueue.main.async {
                    self.selectedNames = selectedNames
                    self.explanations = explanations
                    print("Selected Names: \(selectedNames), Explanations: \(explanations)")
                    completion()
                }
            } else {
                print("Failed to parse JSON response")
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
        dataTask.resume()
    }
}

    struct EntryView: View {
        @State private var userInput = ""
        @State private var showResults = false
        @StateObject private var viewModel = EntryViewModel()
        @State private var isRequestInProgress = false

        
        let indigoColor = UIColor(red: 45/255.0,
                                  green: 80/255.0,
                                  blue: 207/255.0,
                                  alpha: 1)
        
        var body: some View {
            VStack {
                TextField("Enter text here", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disabled(isRequestInProgress)
                
                Text("User input: \(userInput)")
                    .padding()
                
                Button(action: {
                    isRequestInProgress = true
                    viewModel.performChatRequest(userInput: userInput) {
                        isRequestInProgress = false
                        // This block is executed after the network request is complete
                        showResults = true
                    }
                }) {
                    Text("Submit")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(indigoColor))
                        .cornerRadius(10)
                }
                .disabled(isRequestInProgress)
                .padding()
                
                NavigationLink(destination: ResultsView(viewModel: viewModel), isActive: $showResults) { EmptyView() }
                
                if !viewModel.jsonResponse.isEmpty {
                    Text(viewModel.jsonResponse)
                        .padding()
                }
                
                Spacer()
            }
            .background(Color(.systemBackground))
            .cornerRadius(7)
            .padding()
            .navigationBarTitle("Enter Text", displayMode: .inline)
        }
    }
    
    struct EntryViewPreview: PreviewProvider  {
        
        static var previews: some View {
            EntryView()
                .preferredColorScheme(.dark)
        }
        
    }
    

