//
//  ARViewScreen.swift

import Foundation
import SwiftUI
import RealityKit
import ARKit
import FocusEntity

struct ARViewScreen : View {
    @State private var isPlacementEnabled = false
    @State private var selectedModelImage: Model3D?
    @State private var modelImageConfirmedForPlacement: Model3D?
    
    @EnvironmentObject var viewModel: EntryViewModel
    @State var modelImages: [Model3D] = []
    

    
    var body: some View {
//        NavigationView {
        ZStack(alignment: .bottom) {
            
            ARViewContainer(modelImageConfirmedForPlacement: self.$modelImageConfirmedForPlacement)
            
            if self.isPlacementEnabled {
                PlacementButtonsView(isPlacementEnabled: self.$isPlacementEnabled, selectedModelImage: $selectedModelImage, modelImageConfirmedForPlacement: self.$modelImageConfirmedForPlacement)
            } else {
                // Check if selectedNames is empty and display instructions accordingly
                if viewModel.selectedNames.isEmpty {
                    Text("No objects selected. Please go to the Generate page to get objects.")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                } else {
                    ModelPickerView(isPlacementEnabled: self.$isPlacementEnabled, selectedModelImage: self.$selectedModelImage, modelImages: self.modelImages)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                populateModelImages()
            }
        }
        .onReceive(viewModel.$selectedNames) { newValue in
            print("selectedNames changed to: \(newValue)")
            populateModelImages()
        }
    }
    
    private func populateModelImages() {
           let fileManager = FileManager.default
        print("Failed to get resource path.")
           guard let path = Bundle.main.resourcePath, let files = try? fileManager.contentsOfDirectory(atPath: path) else {
               print("Failed to get contents of directory at path.")
               return
           }
        print("Files in bundle: \(files)")
           
           modelImages = files.filter { filename in
               filename.hasSuffix("usdz") && viewModel.selectedNames.contains(filename)
           }.map { filename in
               let modelImageName = filename.replacingOccurrences(of: ".usdz", with: "")
               print("Populated modelImages: \(modelImages.map { $0.model3DName })")
               return Model3D(model3DName: modelImageName)
           }
        print("Populated modelImages: \(modelImages.map { $0.model3DName })")
       }
    
}
    

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelImageConfirmedForPlacement: Model3D?
    
    func makeUIView(context: Context) -> FocusARView {
      FocusARView(frame: .zero)
    }

    func updateUIView(_ uiView: FocusARView, context: Context) {
        if let model3D = self.modelImageConfirmedForPlacement {
            
            if let model3DEntity = model3D.model3DEntity {
                print("DEBUG: adding model to scene - \(model3D.model3DName)")
                
                let anchorEntity = AnchorEntity()
             //   let anchorEntity = AnchorEntity(plane: .any)
                // Configure your AR session to detect planes (horizontal, vertical, or both).
//                Implement the ARSessionDelegate method(s) to respond to detected planes.
//                Create and add an AnchorEntity to your scene based on detected ARPlaneAnchors from the delegate methods.
                
                anchorEntity.addChild(model3DEntity)
                anchorEntity.addChild(model3DEntity.clone(recursive: true))
                
                uiView.scene.addAnchor(anchorEntity)
                
            } else {
                print("DEBUG: Unable to load model3DEntity for \(model3D.model3DName)")
            }

            
            
            /* If we assign the value to variable here -> error b/c assigned inside same var which view is still processing, so wrap the var to dispach queue to asychronoous block.*/
            // self.modelImageConfirmedForPlacement = nil
            DispatchQueue.main.async {
                self.modelImageConfirmedForPlacement = nil
            }
        }
    }
}

struct ModelPickerView: View {
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModelImage: Model3D?
    
    var modelImages: [Model3D]
    let placeholderImage = UIImage(systemName: "photo")!
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                
                ForEach(modelImages, id: \.id) { modelImage in
                    Button(action: {
                        print("DEBUG: selected model with name: \(modelImage.model3DName)")
                        
                        self.selectedModelImage = modelImage
                        
                        self.isPlacementEnabled = true
                    }) {
                        Image(uiImage: modelImage.image!)
                            .resizable()
                            .frame(height: 80)
                            .aspectRatio(1/1, contentMode: .fit)
                            .background(Color.white)
                            .cornerRadius(12)
                        
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.5))
        .onAppear {
            print("ModelPickerView appeared with modelImages count: \(modelImages.count)")
        }
    }
}

struct PlacementButtonsView: View {
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModelImage: Model3D?
    @Binding var modelImageConfirmedForPlacement: Model3D?
    
    var body: some View {
        HStack {
            // Cancel Button
            Button(action: {
                print("DEBUG: Model image placement cancel.")
                
                self.resetPlacementParameters()
            }) {
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
            
            // Confirm Button
            Button(action: {
                print("DEBUG: Model image placement confirmed.")
                
                self.modelImageConfirmedForPlacement = self.selectedModelImage
                
                self.resetPlacementParameters()
            }) {
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
        }
    }
    
    func resetPlacementParameters() {
        self.isPlacementEnabled = false
        self.selectedModelImage = nil
    }
}
