import SwiftUI

struct Testing: View {

    @State private var isAnimated: Bool = false
    @State private var fadeHeart: Bool = false
    @StateObject var vm = QuoteViewModel()
    @State private var showSecondScreen: Bool = false

    var body: some View {
        NavigationStack {
            ZStack(
                alignment: .center,
                content: {
                    NavigationLink(
                        destination: SecondScreen(),
                        isActive: $showSecondScreen
                    ) {
                        EmptyView()
                    }
                    HeartsBackgroundView()

                    VStack(alignment: .center, spacing: 20) {
                        Image(systemName: "heart.fill").font(.system(size: 40))
                            .foregroundColor(
                                .white
                            ).background(
                                Circle().fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            .purple, .pink,
                                        ]
                                        ),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                ).frame(width: 100, height: 100).shadow(
                                    color: .red,
                                    radius: 20,
                                    x: 5.0,
                                    y: 10.0
                                )
                            ).offset(x: -10, y: fadeHeart ? -100 : 0).animation(
                                .spring(duration: 0.5).delay(1),
                                value: fadeHeart
                            )

                        Text("Akasha Jabeen 💕")
                            .font(.title)
                            .fontWeight(.light)
                            .opacity(fadeHeart ? 1 : 0)
                            .padding(.top, fadeHeart ? -20 : 0)
                            .animation(
                                .spring(duration: 0.5).delay(1),
                                value: fadeHeart
                            )
                            .onLongPressGesture {
                                showSecondScreen = true
                            }

                        Text(vm.quote)
                            .font(.system(size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black).opacity(fadeHeart ? 1 : 0)
                            .animation(
                                .default.delay(1.5),
                                value: fadeHeart
                            )
                            .padding(20)
                            .frame(width: 300)
                            .background(
                                RoundedRectangle(cornerRadius: 26)
                                    .fill(Color.white).opacity(
                                        fadeHeart ? 1 : 0
                                    )
                            )
                            .onAppear {
                                vm.fetchQuote()
                            }

                        Button(action: {

                            withAnimation(.default) {
                                isAnimated = false
                                fadeHeart = false
                            }

                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 0.6
                            ) {
                                vm.fetchQuote()

                                withAnimation(.default) {
                                    isAnimated = true
                                    fadeHeart = true
                                }
                            }
                        }) {
                            RoundedRectangle(cornerRadius: 20).frame(
                                width: 100,
                                height: 100,
                                alignment: .center
                            ).foregroundStyle(.purple).opacity(
                                fadeHeart ? 1 : 0
                            )
                            .overlay(content: {
                                Text("💝").font(.largeTitle).opacity(
                                    fadeHeart ? 1 : 0
                                )
                            })
                        }.animation(.spring().delay(3), value: fadeHeart)
                            .padding(.top, 40)

                    }

                    HStack(
                        spacing: 0,
                        content: {
                            RoundedRectangle(cornerRadius: 30).fill(.pink)
                                .frame(
                                    width: 350,
                                    height: 600
                                ).shadow(radius: 20).offset(
                                    x: isAnimated ? -190 : 0
                                )
                                .rotationEffect(
                                    Angle(degrees: isAnimated ? 0 : 20)
                                )
                            RoundedRectangle(cornerRadius: 30).fill(.pink)
                                .frame(
                                    width: 350,
                                    height: 600
                                ).shadow(radius: 20).offset(
                                    x: isAnimated ? 190 : 0
                                )
                                .rotationEffect(
                                    Angle(degrees: isAnimated ? 0 : -20)
                                )
                        }
                    )
                    .onTapGesture {
                        withAnimation(.default) {
                            isAnimated.toggle()
                            fadeHeart.toggle()
                        }
                    }

                }
            )
        }
    }
}

struct HeartsBackgroundView: View {

    let hearts = [
        "❤️", "💗", "💖", "💕", "💘", "💝", "❤️‍🔥", "♥️", "💙", "💜", "❤️‍🩹", "💛", "💚", "❣️",
        "🤍", "🩶", "🤎", "💟", "🩷", "🫀", "🩵", "🫰", "❤️‍🔥",
    ]
    

    var body: some View {
        ZStack {

            // Cute background color
            LinearGradient(
                colors: [
                    Color.pink.opacity(0.3),
                    Color.purple.opacity(0.2),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Floating hearts
            ForEach(0..<25, id: \.self) { _ in
                FloatingHeart(heart: hearts.randomElement()!)
            }
        }
    }
}

struct FloatingHeart: View {

    let heart: String

    @State private var yPosition: CGFloat = UIScreen.main.bounds.height + 50

    var body: some View {
        Text(heart)
            .font(.system(size: CGFloat.random(in: 25...45)))
            .position(
                x: CGFloat.random(in: 0...400),
                y: yPosition
            )
            .opacity(Double.random(in: 0.6...1))
            .onAppear {
                withAnimation(
                    .linear(duration: Double.random(in: 6...12))
                        .repeatForever(autoreverses: false)
                ) {
                    yPosition = -100
                }
            }
    }
}

#Preview {
    Testing()
}
