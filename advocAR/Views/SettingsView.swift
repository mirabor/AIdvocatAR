//
//  MailView.swift

import SwiftUI
import MessageUI
//import FirebaseAuth

/// Main View
struct SettingsView: View {
    
    let indigoColor = UIColor(red: 45/255.0,
                               green: 80/255.0,
                               blue: 207/255.0,
                               alpha: 1)

    var body: some View {
        ScrollView{


            ZStack{
        VStack {
        
            Spacer()
            HStack{
            Text("About")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: 300)
                    .foregroundColor(Color(indigoColor))
            }
                .padding()

            HStack{
            Text("hi")
                    .padding()
            }
            
            HStack{
            Text("Help")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: 300)
                    .foregroundColor(Color(indigoColor))
            }
                .padding()
            
            
            VStack{
                HStack{
                    Text("Home Screen")
                            .fontWeight(.bold)
                            .padding()
                    Spacer()
                }

                HStack{
                    Text("Hi.")
                            .padding()
                    Spacer()
                }
                
                HStack{
                    Text("Products Screen")
                            .fontWeight(.bold)
                            .padding()
                    Spacer()
                }

                HStack{
            Text("HI.")
                    .padding()
                    Spacer()
                }
                
                HStack{
                    Text("Post Screen")
                            .fontWeight(.bold)
                            .padding()
                    Spacer()
                }

                
                HStack{
            Text("Heyy.")
                    .padding()
                    Spacer()
                }

                
                HStack{
                    Text("Reality Screen")
                            .fontWeight(.bold)
                            .padding()
                    Spacer()
                }

                HStack{
            Text("hi.")
                    .padding()
                    Spacer()
                }
                
                HStack{
                    Text("Setting Screen")
                            .fontWeight(.bold)
                            .padding()
                    Spacer()
                }

                HStack{
            Text("hi.")
                    .padding()
                    Spacer()
                }

            }

            
            HStack{
                Text("Contact Us")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(width: 300)
                        .foregroundColor(Color(.orange))
                        .padding()
            }
            HStack {
                Spacer()
                Image(systemName: "envelope")

                    .resizable()
                    .frame(width: 45, height: 35)
                    .foregroundColor(Color(.lightGray))
                    .onTapGesture{
                   
                    }
                
                Spacer()


                Image(systemName: "message")

                    .resizable()
                    .frame(width: 45, height: 45)
                    .foregroundColor(Color(.lightGray))
                    .onTapGesture{
                        
                    }
                Spacer()
            }
            .padding()
            
            Spacer()
            
            
            HStack{
                Text("Follow Us")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(width: 300)
                        .foregroundColor(Color(.orange))
                        .padding()
            }
            
            HStack{
                Spacer()
                Button(action: {
                    guard let url = URL(string: "") else {
                      return
                    }

                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }) {
                    Image("InstagramIcon")

                        .resizable()
                        .frame(width: 45, height: 45)
                }
                Spacer()
                Button(action: {
                    guard let url = URL(string: "") else {
                      return //be safe
                    }

                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }) {
                    Image("")

                        .resizable()
                        .frame(width: 45, height: 45)
                        .foregroundColor(Color(.orange))
                }
                Spacer()
            }
            .padding()

        }
    }
            Spacer()
            Spacer()
            VStack {
                
                HStack{
                    Text("Sign Out")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(width: 300)
                            .foregroundColor(Color(.orange))
                            .padding()
                }
            
            }
            Spacer()
    }
        
    }
}

struct SettingsViewPreview: PreviewProvider  {
    
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
    
}
