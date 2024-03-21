//
//  ContentView.swift

import SwiftUI
import MessageUI
//import FirebaseAuth


struct ContentView: View {

    var body: some View {
    //    UserAuthentication()
        MainView()
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
          .environmentObject(AppViewModel())
        

          .phoneOnlyStackNavigationView()
    }
}

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}

struct Content_Previews: PreviewProvider  {
    
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .environmentObject(AppViewModel())
    }
    
}
