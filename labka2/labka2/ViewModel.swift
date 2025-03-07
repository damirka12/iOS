//
//  ViewModel.swift
//  labka2
//
//  Created by Дамир Алимжан on 07.03.2025.
//

import Foundation

struct Hero: Decodable {
    let id: Int
    let name: String
    let powerstats: PowerStats
    let appearance: Appearance
    let biography: Biography
    let images: Images

    var imageUrl: URL? {
        URL(string: images.md)
    }

    struct PowerStats: Decodable {
        let intelligence, strength, speed, durability, power, combat: Int
    }

    struct Appearance: Decodable {
        let gender, race, eyeColor, hairColor: String?
    }

    struct Biography: Decodable {
        let fullName, publisher: String?
    }

    struct Images: Decodable {
        let md: String
    }
}


final class ViewModel: ObservableObject {
    @Published var selectedHero: Hero?

    // MARK: - Methods
    func fetchHero() async {
        guard let url = URL(string: "https://akabab.github.io/superhero-api/api/all.json") else {
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let heroes = try JSONDecoder().decode([Hero].self, from: data)
            let randomHero = heroes.randomElement()

            await MainActor.run {
                selectedHero = randomHero
            }

            print(selectedHero)
        }
        catch {
            print("Ошибка загрузки: \(error)")
        }
    }
}
