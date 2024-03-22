//
//  MailView.swift

import SwiftUI
import MessageUI
import FirebaseAuth

/// Main View
struct SettingsView: View {

    /// The delegate required by `MFMailComposeViewController`
    private let mailComposeDelegate = MailDelegate()

    /// The delegate required by `MFMessageComposeViewController`
    private let messageComposeDelegate = MessageDelegate()

    
    @EnvironmentObject var viewModel: AppViewModel
    
    let auth = Auth.auth()
    
    func signOut() {
        try? auth.signOut()
        
        viewModel.signedIn = false
    }

    var body: some View {
        ScrollView{


            ZStack{
        VStack {
        
            Spacer()
            HStack{
            Text("About Us")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: 300)
                    .foregroundColor(Color(.orange))
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
                    .foregroundColor(Color(.orange))
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
                        self.presentMailCompose()
                    }
                
                Spacer()


                Image(systemName: "message")

                    .resizable()
                    .frame(width: 45, height: 45)
                    .foregroundColor(Color(.lightGray))
                    .onTapGesture{
                        self.presentMessageCompose()
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
                
//                Button(action: {
//                    viewModel.signOut()
//                }, label: {
//                    Text("Sign Out")
//                        .frame(width: 300, height: 40)
//                        .foregroundColor(.black)
//                        .background(.orange)
//                        .cornerRadius(15)
//                })
            }
            Spacer()
    }
        
    }
}

// MARK: The mail part
extension SettingsView {

    /// Delegate for view controller as `MFMailComposeViewControllerDelegate`
    private class MailDelegate: NSObject, MFMailComposeViewControllerDelegate {

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {

            controller.dismiss(animated: true)
        }

    }

    /// Present an mail compose view controller modally in UIKit environment
    private func presentMailCompose() {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let vc = UIApplication.shared.keyWindow?.rootViewController

        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = mailComposeDelegate


        vc?.present(composeVC, animated: true)
    }
}

// MARK: The message part
extension SettingsView {

    /// Delegate for view controller as `MFMessageComposeViewControllerDelegate`
    private class MessageDelegate: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            // Customize here
            controller.dismiss(animated: true)
        }

    }

    /// Present an message compose view controller modally in UIKit environment
    private func presentMessageCompose() {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        let vc = UIApplication.shared.keyWindow?.rootViewController

        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = messageComposeDelegate


        vc?.present(composeVC, animated: true)
    }
}
