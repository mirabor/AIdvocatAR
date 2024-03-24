import Foundation
import SwiftUI

struct ChatResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let delta: Delta
}

struct Delta: Codable {
    let content: String
}

struct Content: Codable {
    let selectedNames: [String]
    let explanation: [String]
}


class EntryViewModel: ObservableObject {
    @Published var jsonResponse: String = ""
    @Published var selectedNames: [String] = []
    @Published var explanations: [String] = []
    @Published var isLoading = false
    
    
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
    
    func performChatRequest(userInput: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        let url = NSURL(string: "https://api.corcel.io/v1/text/cortext/chat")!
        print("Request URL: \(url)")
        
        let headers = [
            "accept": "application/json",
            "content-type": "application/json",
            "Authorization": "\(Secrets.accessKey)"
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
                    "content": "Here is a list of items: \(self.searchableUsdzFileNames). Pick three strings that are most reminiscent of this creative writing excerpt: \(userInput). End of excerpt. Output an hashtable of an array with the key 'selectedNames' and an array with the key 'explanation': The first array is of those three strings, all with the .usdz ending. Do not elaborate in the first array. The second array is the 3 explanations of why those three objects were selected, but do not say the names of the objects; instead, reference them as 'your first/second/third custom object'. Do not include '\' or '\n'. Do not include extraneous text outside the array or string."
                ]
            ]
        ] as [String : Any]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Failed to serialize post data")
            return
        }
        
        let request = NSMutableURLRequest(url: url as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 15.0)
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
                    self.isLoading = false
                    completion(false)
                }
                return
            }
            
            guard let data = data, error == nil else {
                print(error ?? "Data fetching error")
                completion(false)
                return
            }
            print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
            
            do {
                let topLevelResponses = try JSONDecoder().decode([ChatResponse].self, from: data)
                for topLevelResponse in topLevelResponses {
                    for choice in topLevelResponse.choices {
                        if let contentData = choice.delta.content.data(using: .utf8) {
                            let content = try JSONDecoder().decode(Content.self, from: contentData)
                            
                            
                            DispatchQueue.main.async {
                                self.isLoading = false
                                self.objectWillChange.send()
                                print("Selected Names: \(content.selectedNames)")
                                print("Explanation: \(content.explanation)")
                                self.selectedNames = content.selectedNames
                                self.explanations = content.explanation
                                completion(true)
                            }
                        }
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
            completion(false)
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
        }
        dataTask.resume()
    }
}
    
    struct EntryView: View {
        @State private var userInput = ""
        @State private var showResults = false
        @EnvironmentObject var viewModel: EntryViewModel
        @State private var isRequestInProgress = false
        @State private var showAlert = false
        @State private var alertMessage = ""
        @State private var isBlurred1 = true
        @State private var isBlurred2 = true
        @State private var isBlurred3 = true
        
        
        let indigoColor = UIColor(red: 45/255.0,
                                  green: 80/255.0,
                                  blue: 207/255.0,
                                  alpha: 1)
        
        var body: some View {
            VStack {
                if viewModel.isLoading {
                    VStack{
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(2)
                            .padding(.top)
                        Text("Generating...")
                                    .font(.largeTitle.bold())
                                    .foregroundColor(Color(red: 45/255.0, green: 80/255.0, blue: 207/255.0))
                                    .padding()
                    }
                } else {
                    TextField("Enter text here", text: $userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .disabled(isRequestInProgress)
                    
                    Text("User input: \(userInput)")
                        .padding()
                    
                    Button(action: {
                        isRequestInProgress = true
                        viewModel.performChatRequest(userInput: userInput) { success in
                            isRequestInProgress = false
                            if success {
                                showResults = true
                                print("success")
                            } else {
                                print("failure")
                                alertMessage = "Failed to fetch data. Please try again."
                                showAlert = true
                            }
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
                    
                    if showResults == true {
                        ScrollView{
                            //          Text(viewModel.selectedNames.joined(separator: "\n"))
                            if viewModel.explanations.indices.contains(0) {
                                Text(viewModel.explanations[0])
                                    .blur(radius: isBlurred1 ? 10 : 0)
                                    .animation(.easeInOut, value: isBlurred1)
                                    .padding()
                                    .onTapGesture {
                                        withAnimation {
                                            isBlurred1.toggle()
                                        }
                                    }
                            }
                            if viewModel.explanations.indices.contains(1) {
                                Text(viewModel.explanations[1])
                                    .blur(radius: isBlurred2 ? 10 : 0)
                                    .animation(.easeInOut, value: isBlurred2)
                                    .padding()
                                    .onTapGesture {
                                        withAnimation {
                                            isBlurred2.toggle()
                                        }
                                    }
                            }
                            if viewModel.explanations.indices.contains(2) {
                                Text(viewModel.explanations[2])
                                    .blur(radius: isBlurred3 ? 10 : 0)
                                    .animation(.easeInOut, value: isBlurred3)
                                    .padding()
                                    .onTapGesture {
                                        withAnimation {
                                            isBlurred3.toggle()
                                        }
                                    }
                            }
                        }
                    } else {
                        Text("Submit text to generate custom objects")
                            .padding()
                            .opacity(0.75)
                    }
                    
                    if !viewModel.jsonResponse.isEmpty {
                        Text(viewModel.jsonResponse)
                            .padding()
                    }
                    
                    Spacer()
                }
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
    
