//
//  SwiftUIView.swift
//  labka2
//
//  Created by Дамир Алимжан on 07.03.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var isBouncing = false

    var body: some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            let screenWidth = geometry.size.width
            ZStack{
                Color(hex: "#ABD7EB").ignoresSafeArea()
                VStack {
                    if let hero = viewModel.selectedHero {
                        Text(hero.name)
                            .font(.largeTitle)
                        
                        Text("Publisher: \(hero.biography.publisher ?? "Unknown")")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        AsyncImage(url: hero.imageUrl) { phase in
                            switch phase {
                            case .empty:
                                Image("yandexmusic")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: screenWidth * 0.5, height: screenWidth * 0.5)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.brown, lineWidth: 5))
                                    .shadow(radius: 5)
                                
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: screenWidth * 0.5, height: screenWidth * 0.5)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.brown, lineWidth: 5))
                                    .shadow(radius: 5)
                                
                            case .failure:
                                Image("yandexmusic")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: screenWidth * 0.5, height: screenWidth * 0.5)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.brown, lineWidth: 5))
                                    .shadow(radius: 5)
                            }
                        }
                        .padding(16)
                        HStack{
                            Text("Внешний вид")
                                .font(.headline)
                                .padding(.top, 8)
                            
                            Rectangle()
                                .frame(width: 2, height: screenHeight * 0.1)
                                .foregroundColor(.black)
                            
                            Text("Характеристики")
                                .font(.headline)
                                .padding(.top, 8)
                        }
                        HStack{
                            Spacer()
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Gender: \(hero.appearance.gender ?? "Unknown")")
                                Text("Race: \(hero.appearance.race ?? "Unknown")")
                                Text("Eye Color: \(hero.appearance.eyeColor ?? "Unknown")")
                                Text("Hair Color: \(hero.appearance.hairColor ?? "Unknown")")
                            }
                            .cornerRadius(10)
                            Spacer()
                            Rectangle()
                                .frame(width: 2, height: screenHeight * 0.1)
                                .foregroundColor(.black)
                            Spacer()
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Intelligence: \(hero.powerstats.intelligence)")
                                Text("Strength: \(hero.powerstats.strength)")
                                Text("Speed: \(hero.powerstats.speed)")
                                Text("Durability: \(hero.powerstats.durability)")
                                Text("Power: \(hero.powerstats.power)")
                                Text("Combat: \(hero.powerstats.combat)")
                            }
                            .padding()
                            .cornerRadius(10)
                            Spacer()
                        }
                        
                    } else {
                        VStack {
                            Image("yandexmusic")
                                .resizable()
                                .scaledToFill()
                                .frame(width: screenWidth * 0.5, height: screenWidth * 0.5)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.brown, lineWidth: 5))
                                .shadow(radius: 5)
                            
                            Text("Выбери героя!")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    Text("⬇️")
                        .font(.largeTitle)
                        .offset(y: isBouncing ? -10 : 0)
                        .animation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isBouncing)
                        .onAppear { isBouncing = true }
                    
                    Button {
                        Task {
                            await viewModel.fetchHero()
                        }
                    } label: {
                        Text("Roll Hero")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


#Preview {
    let viewModel = ViewModel()
    ContentView(viewModel: viewModel)
}
