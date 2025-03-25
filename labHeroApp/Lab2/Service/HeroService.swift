import Foundation

protocol HeroService {
    func fetchHeroes() async throws -> [HeroEntity]
    // fetchHeroById(id: Int) -> HeroEntity
}

struct HeroServiceImpl: HeroService {
    func fetchHeroes() async throws -> [HeroEntity] {
        let urlString = Constants.baseUrl + "all.json"
        guard let url = URL(string: urlString) else {
            throw HeroError.wrongUrl
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse?.statusCode ?? 0)

            let heroes = try JSONDecoder().decode([HeroEntity].self, from: data)
            return heroes
        } catch {
            print(error)
            throw HeroError.somethingWentWrong
        }
    }

    
}

enum HeroError: Error {
    case wrongUrl
    case somethingWentWrong
}

private enum Constants {
    static let baseUrl: String = "https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/"
}
