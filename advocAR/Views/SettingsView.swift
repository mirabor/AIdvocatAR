//

import SwiftUI
import MessageUI
//import FirebaseAuth
import SafariServices

/// Main View
struct SettingsView: View {
    
    @State var showLink = false
    @State var link = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    
    let indigoColor = UIColor(red: 45/255.0,
                              green: 80/255.0,
                              blue: 207/255.0,
                              alpha: 1)
    
    var body: some View {
        
        ZStack{
            VStack {
                    Text("About")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(width: 300)
                        .foregroundColor(Color(indigoColor))
                        .padding()
                
                    Text("This app was built using SwiftUI, ARKit, RealityKit, FocusEntity, and the Corcel API. Thank you to the Corcel developer team for providing upgraded key access free of charge!")
                        .padding()
                
                Text("Help")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: 300)
                    .foregroundColor(Color(indigoColor))
                    .padding()
                Button(action: {
                    self.showLink = true
                }) {
                    Text("If you encounter any issues or have suggestions for features, please reach out to mirayu@college.harvard.edu. This repo can be found at https://github.com/mirabor/AIdvocatAR, and pull requests are welcome.")
                        .foregroundColor(.primary)
                        .padding(.bottom)
                        .padding(.horizontal)
                }.sheet(isPresented: $showLink) {
                    SafariView(url: URL(string: self.link) ?? URL(string: "https://github.com/mirabor/AIdvocatAR")!)
                }
                Spacer()
            }
        }
    }
}
            
            

struct SettingsViewPreview: PreviewProvider  {
    
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.light)
    }
    
}
