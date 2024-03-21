//
//  NewPostService.swift

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestoreInternal
import FirebaseFirestore

class NewPostService: ObservableObject {
    
    @Published var list = [NewPostModel]()
    
  
    func addData(name: String, notes: String, imageName: String, time: Double){
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Get a document to the collection
        // the first parameter is the data input to the document, the scond is the result
        db.collection("newPost").addDocument(data: ["name": name, "post": notes, "imageName": imageName, "time": time]) { error in
            
            // Check for errors
            if error == nil {
                
                // No errors
                
                // Call get Data to retreive latest data (update the UI after having new data)
                self.getData()
            }
            else {
                // Handle the error
            }
        }
    }
    
    func getData(){
        // Get a reference to the database
        let db = Firestore.firestore()
        
        
        // Read the documents at a specific path
        db.collection("newPost").getDocuments { snapshot, error in

            // Check for errors
            if error == nil {
                // No errors
                
                if let snapshot = snapshot {
                    
                    // Update the list property in the main thread
                    DispatchQueue.main.async {
                        
                        // Get all the documents and create Todos
                        self.list = snapshot.documents.map { d in
                            
                            // Create our class item (object) for each document returned
                            return NewPostModel(id: d.documentID,
                                        // we don't know what the type of data is so cast as string
                                        name: d["name"] as? String ?? "",
                                        post: d["post"] as? String ?? "",
                                                imageName: d["imageName"] as? String ?? "", time: d["time"] as? Double ?? 0.0)
                        }
                    }
                }
            }
            else {
                // Handle the error
                print("Listen for query at failed: Missing or insufficient permissions :(")
            }
        }
    }
}

