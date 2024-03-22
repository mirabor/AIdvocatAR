import SwiftUI


struct ResultsView: View {
    @ObservedObject var viewModel: EntryViewModel
    @State private var blurRadius: [Double] = [10, 10, 10] // Initial blur for each button
    
    var body: some View {
        VStack(spacing: 20) {
            Text("hi")
            Text("\(viewModel.explanations[1])")
            ForEach(viewModel.explanations.indices, id: \.self) { index in
                Button(action: {
                    withAnimation(.easeOut(duration: 1.5)) {
                        blurRadius[index] = 0 // Remove blur to reveal text
                    }
                }) {
                    Text(viewModel.explanations[index])
                        .blur(radius: blurRadius[index]) // Apply dynamic blur
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding()
    }
}

struct ResultsViewPreview: PreviewProvider  {
    
    static var previews: some View {
        ResultsView(viewModel: EntryViewModel())
            .preferredColorScheme(.dark)
    }
    
}

