import SwiftUI

struct SplashView: View {

    @State private var isActive = false
    @State private var scale = 0.7
    @State private var opacity = 0.5

    var body: some View {
        if isActive {
            //            ContentView()
            Testing()
        } else {
            ZStack {
                HeartsBackgroundView()
                VStack {
                    Text("السلام علیکم!\n میری جان")
                        .font(.custom("NotoNastaliqUrdu-Regular", size: 24))
                        .multilineTextAlignment(.center)
                }
            }.onAppear {
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 7,
                    execute: {
                        isActive = true
                    }
                )
            }
        }

    }
}

#Preview {
    SplashView()
}
