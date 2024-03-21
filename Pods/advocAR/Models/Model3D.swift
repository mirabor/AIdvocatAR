import UIKit
import RealityKit
import Combine

class Model3D: Identifiable {
    let id = UUID()
    var model3DName: String
    var image: UIImage?
    var model3DEntity: ModelEntity?
    private var cancellables = Set<AnyCancellable>()

    init(model3DName: String) {
        self.model3DName = model3DName

        // Attempt to load the image
        if let loadedImage = UIImage(named: model3DName) {
            self.image = loadedImage
            print("DEBUG: Successfully loaded image for modelName: \(model3DName)")
        } else {
            // Log failure if the image doesn't exist
            print("ERROR: Unable to load image for modelName: \(model3DName)")
        }

        // Load the model entity asynchronously
        ModelEntity.loadModelAsync(named: model3DName + ".usdz")
            .sink(receiveCompletion: { loadCompletion in
                switch loadCompletion {
                case .finished:
                    // This is called after successful loading
                    break // No action needed here
                case .failure(let error):
                    // Handle and log the error case
                    print("ERROR: Unable to load model3DEntity for modelName: \(model3DName), error: \(error)")
                }
            }, receiveValue: { [weak self] modelEntity in
                self?.model3DEntity = modelEntity
                print("DEBUG: Successfully loaded modelEntity for modelName: \(model3DName)")
            }).store(in: &cancellables)
    }
}
