//  HomeScreen.swift//

import SwiftUI
//import FirebaseStorage
import SDWebImageSwiftUI
import SafariServices


// Convert variable to hashable bc whenever a for loop executes it needs to be able to specify an unique id for the actual element
struct PostModel: Hashable {
    let name: String
    let post: String
    let imageName: String
}

struct HomeScreen: View {
    
    @State private var imageURL = URL(string: "")

    @ObservedObject var model = NewPostService()

    @State var sortedPosts = NewPostService()

//    let posts: [NewPostModel] = [
//        NewPostModel(id: "1111", name: "Mira Yu", post: "Hello, welcome:)", imageName: "person1")]
    
    let orangeColor = UIColor(red: 255/255.0,
                               green: 145/255.0,
                               blue: 0/255.0,
                               alpha: 1)
    
    var body: some View {
        // Vertical stack
        VStack {
            // Horizontal stack
            HStack {
                // Assigne for grround color of text
                // Assign Font size

                Text("Hi")
                    .foregroundColor(Color(orangeColor))
                    .font(.system(size: 28, weight: .bold, design: .default))

                // make a spacer to seprate text and sf symbol
                Spacer()
                
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 45, height: 45, alignment: .center)
                    .foregroundColor(Color(.secondaryLabel))
                    //  .background(Color.red)
                
            }
            .padding()
            
            // First parameter is placeholder
            // $ is for update the UI based on the text in real time

            ZStack {
                Color(.secondarySystemBackground)
                
                ScrollView(.vertical) {
                    VStack {
                    
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                

                            }
                            .onAppear()
                            .padding()
                        }
                        
                        
                        ForEach (model.list.sorted {$0.time < $1.time}.reversed()) { item in
                            
                            HStack {
                                PostView(model: item)
                                Spacer()

                            }
                        }

                    }
                }
            }
            Spacer()
        }
        .onAppear(perform: model.getData)
            }
    
    func sortPosts(){
        self.sortedPosts.list = model.list.sorted {
            $0.time < $1.time
        }
    }

}
