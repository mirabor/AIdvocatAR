//
//  NewPostModel.swift

import Foundation

struct NewPostModel: Identifiable,Hashable {
    
    // Mirror data and data types in firebase database (if implemented)
    var id: String
    var name: String
    var post: String
    var imageName: String
    var time: Double
}
