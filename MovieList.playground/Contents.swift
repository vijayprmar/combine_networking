import UIKit
import Combine

struct MovieResponse:Decodable{
    let search:[Movie]
}

struct Movie:Decodable{
    
    let title :String
    
    private enum CodingKeys:String,CodingKey{
        case title = "Title"
    }
    
}


func fetchMovies(_ searchTerm:String)->AnyPublisher<MovieResponse,Error>{
    
    let url = URL(string: "https://www.omdbapi.com/?s=\(searchTerm)&page=2&apiKey=564727fa")!
    
    return URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: MovieResponse.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    
}

var cancellables:Set<AnyCancellable> = []


Publishers.CombineLatest(fetchMovies("Batman"), fetchMovies("Spiderman"))
    .sink { _ in
        
    } receiveValue: { value1,value2 in
        print(value1.search)
        print(value2.search)
    }.store(in: &cancellables)


