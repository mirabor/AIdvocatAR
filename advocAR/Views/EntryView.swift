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
    @State private var isBlurred = [true, true, true]
    @FocusState private var isTextFieldFocused: Bool
    @FocusState private var isInputFocused: Bool
    @State private var pulse = false
    @State private var showAlertForTextLength = false

    
    let indigoColor = UIColor(red: 45/255.0,
                              green: 80/255.0,
                              blue: 207/255.0,
                              alpha: 1)
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.indigo.opacity(0.7), Color.blue.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .animation(Animation.easeInOut(duration: 5).repeatForever(autoreverses: true), value: UUID())
          //      .cornerRadius(15)
            
            VStack {
                if viewModel.isLoading {
                    VStack{
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(2)
                            .padding(.top)
                        Text("Generating...")
                            .font(.largeTitle.bold())
                    //        .foregroundColor(Color(red: 45/255.0, green: 80/255.0, blue: 207/255.0))
                            .foregroundColor(.white)
                            .padding()
                    }
                } else {
                    if showResults == true {
                        ScrollView {
                            VStack(spacing: 10) {
                                Text("**AI**dvocat**AR**")
                                    .padding()
                                    
                                ForEach(viewModel.explanations.indices, id: \.self) { index in
                                    ExplanationBubble(text: viewModel.explanations[index], isBlurred: $isBlurred[index])
                                }
                            }
                            .padding(.vertical, 10)
                        }
              //          .background(Color.secondary.opacity(0.1))
                        .cornerRadius(15)
                        .padding()
                        .shadow(radius: 5)
                        .frame(maxWidth: .infinity)
                        
                    } else {
                        Text("**AIdvocatAR**")
                            .padding()
                            .font(.title)
                        Text("_Submit text to generate a set of 3 custom objects_")
                            .padding()
                            .opacity(0.75)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                    Button(action: {
                        if userInput.count > 4096 {
                            showAlertForTextLength = true
                        } else {
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
                        }
                    }) {
                        Text("Generate")
                            .foregroundColor(.white)
                            .padding()
                            .background(userInput.count > 6 ? Color(indigoColor) : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(isRequestInProgress || userInput.count <= 6 || userInput.count > 4096)
                    .padding()
                    .scaleEffect(pulse ? 1.1 : 1)
                    .animation(.easeOut(duration: 0.8).repeatForever(autoreverses: true), value: pulse)
                                           .alert(isPresented: $showAlertForTextLength) {
                                               Alert(
                                                   title: Text("Text Too Long"),
                                                   message: Text("Please shorten your text to be less than 4096 characters."),
                                                   dismissButton: .default(Text("OK"))
                                               )
                                           }
               
                    
                }
                    TextField("Enter text here", text: $userInput)
                        .padding()
                        .disabled(isRequestInProgress)
                         .background(Color(indigoColor).opacity(0.2))
                         .cornerRadius(10)
                         .padding(.horizontal)
                         .foregroundColor(.white)
                         .scaleEffect(pulse ? 1.05 : 1)
                         .animation(.easeOut(duration: 0.8).repeatForever(autoreverses: true), value: pulse)
                                                .focused($isTextFieldFocused)
                                                .onChange(of: isTextFieldFocused) { focused in
                                                    if focused {
                                                        pulse = true
                                                    } else {
                                                        pulse = false
                                                    }
                                                }
                                                .onTapGesture {
                                                    isTextFieldFocused = true
                                                }
                    
//                    if !viewModel.jsonResponse.isEmpty {
//                        Text(viewModel.jsonResponse)
//                            .padding()
//                    }
                    
                }
            }
       //     .background(Color(.systemBackground))
          .cornerRadius(7)
            .padding()
            .navigationBarTitle("Enter Text", displayMode: .inline)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }


struct ExplanationBubble: View {
    let text: String
    @Binding var isBlurred: Bool
    let indigoColor = UIColor(red: 45/255.0,
                              green: 80/255.0,
                              blue: 207/255.0,
                              alpha: 1)
    
    var body: some View {
        Text(text)
            .padding()
            .background(Color(indigoColor))
            .foregroundColor(.white)
            .cornerRadius(20)
            .frame(maxWidth: 300, alignment: .leading)
            .blur(radius: isBlurred ? 10 : 0)
            .onTapGesture {
                withAnimation {
                    isBlurred.toggle()
                }
            }
            .padding(.leading, 15)
    }
}


    struct EntryViewPreview: PreviewProvider  {
        
        static var previews: some View {
            EntryView()
                .preferredColorScheme(.dark)
        }
        
    }
    
