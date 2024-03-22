//  HomeScreen.swift//

import SwiftUI
//import FirebaseStorage
import SDWebImageSwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}

struct HomeScreen: View {
    
    @State private var imageURL = URL(string: "") 
    let indigoColor = UIColor(red: 45/255.0,
                               green: 80/255.0,
                               blue: 207/255.0,
                               alpha: 1)
    
    @State var showSafari = false
    @State var urlString = "https://theharvardadvocate.com/"
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    
                    Text("Home")
                        .foregroundColor(Color(indigoColor))
                        .font(.system(size: 28, weight: .bold, design: .default))
                    
                    Spacer()
                    
                    Image("logo")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 45, height: 45, alignment: .center)
                        .foregroundColor(Color(.secondaryLabel))
                    
                }
                .padding()
                
                Text("Welcome to **AI**dvocat**AR**")
                    .foregroundColor(Color(indigoColor))
                    .dynamicTypeSize(.xxLarge)
                Text("_An AI- and AR-powered app developed for the Harvard Advocate_")
                    .padding(.horizontal)
                    .padding(.bottom)
                    .padding(.top, 1)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary.opacity(0.75))
                TabView {
                    Button(action: {
                        self.showSafari = true
                    }) {
                        CardView(title: "Browse", subtitle: "Click to browse our site, then select and copy lines from your favorite passage")
                    }
                    .sheet(isPresented: $showSafari) {
                        SafariView(url: URL(string: self.urlString) ?? URL(string: "https://www.theharvardadvocate.com")!)
                    }
                    
                    CardView(title: "Generate", subtitle: "Paste in the lines you'd highlight in a book and see what AI imagines for you")
                    CardView(title: "Explore", subtitle: "Place 3 objects picked by AI based on your passage in the world around you with AR")
                    CardView(title: "Let's go!")
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: geometry.size.height * 2 / 3)
            
                Spacer()
            }
        }
    }
}

struct CardView: View {
    
    var title: String
    var subtitle: String?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [.blue, .indigo]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(radius: 5)
        VStack{
                Text(title)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding()
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.title)
                        .foregroundColor(.white.opacity(0.75))
                        .padding()
                }
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
        .padding()
    }
}

struct HomeScreenPreview: PreviewProvider  {
    
    static var previews: some View {
        HomeScreen()
            .preferredColorScheme(.dark)
    }
    
}
