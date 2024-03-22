import SwiftUI

struct FloatingButton: View {
    let text: String
    var action: () -> Void
    @State private var randomX: CGFloat = CGFloat.random(in: 50...300) // Initial random position
    @State private var randomY: CGFloat = CGFloat.random(in: 50...600) // Initial random position
    @Binding var isSelected: Bool // Tracks if the button is selected

    var body: some View {
        Button(action: {
            if !isSelected {
                moveToRandomPosition() // This could be used to reposition before selection if needed
            }
            action()
            isSelected = true // Mark as selected to move to the center
        }) {
            Text(text)
                .blur(radius: text.contains("Revealed") ? 0 : 5)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
        .position(x: isSelected ? UIScreen.main.bounds.width / 2 : randomX,
                  y: isSelected ? UIScreen.main.bounds.height / 3 : randomY)
        .animation(.easeInOut, value: isSelected)
    }
    
    private func moveToRandomPosition() {
        // Randomly reposition if needed before selection
        randomX = CGFloat.random(in: 50...300) // Adjust this range based on your actual view size
        randomY = CGFloat.random(in: 50...600) // Adjust this range based on your actual view size
    }
}


struct ResultsView: View {
    @ObservedObject var viewModel: EntryViewModel
    @State private var selectedIndices = Set<Int>() // Tracks selected buttons

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ForEach(Array(viewModel.selectedNames.indices), id: \.self) { index in
                    FloatingButton(text: viewModel.explanations[index], action: {
                        withAnimation {
                            viewModel.explanations[index] += " Revealed"
                        }
                        selectedIndices.insert(index) // Mark this button as selected
                    }, isSelected: .constant(selectedIndices.contains(index))) // Use binding to pass isSelected
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
        }
    }
}

struct ResultsViewPreview: PreviewProvider {
    static var previews: some View {
        ResultsView(viewModel: EntryViewModel())
            .preferredColorScheme(.dark)
    }
}



//
//  ResultsView.swift

//import SwiftUI
//
//
//struct ResultsView: View {
//    @ObservedObject var viewModel: EntryViewModel
//    
//    var body: some View {
//        VStack {
//            ForEach(Array(zip(viewModel.selectedNames.indices, viewModel.selectedNames)), id: \.0) { index, name in
//                Button(action: {
//                    withAnimation {
//                        viewModel.explanations[index] += " Revealed"
//                    }
//                }) {
//                    Text(viewModel.explanations[index])
//                        .blur(radius: viewModel.explanations[index].contains("Revealed") ? 0 : 5)
//                        .animation(.easeIn, value: viewModel.explanations[index])
//                }
//            }
//        }
//    }
//}
//
//struct ResultsViewPreview: PreviewProvider  {
//    
//    static var previews: some View {
//        ResultsView(viewModel: EntryViewModel())
//            .preferredColorScheme(.dark)
//    }
//    
//}

