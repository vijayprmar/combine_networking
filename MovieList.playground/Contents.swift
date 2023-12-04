import UIKit
import Combine

/*
 
 struct Post:Codable{

     let userId:Int
     let id: Int
     let title:String
     let body:String
 }

 func fetchPost()->AnyPublisher<[Post],Error>{

     let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

     return URLSession.shared.dataTaskPublisher(for: url)
         .map(\.data)
         .decode(type: [Post].self, decoder: JSONDecoder())
         .receive(on: DispatchQueue.main)
         .eraseToAnyPublisher()

 }


 var cancellables:Set<AnyCancellable> = []

 fetchPost().sink { completion in
     switch completion{

     case .finished : print("Update UI")
     case .failure(let error):print("Got an Error : ",error)

     }
 } receiveValue: { posts in
     print(posts)
 }.store(in: &cancellables)
 
 */


/*

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


*/

//Custome Operator
/*
extension Publisher where Output == Int{
    func filterEvenNumbers()->AnyPublisher<Int,Failure>{
        return self.filter {$0 % 2 == 0}
            .eraseToAnyPublisher()
    }
    
    func filterNumberGreaterThen(_ value:Int)->AnyPublisher<Int,Failure>{
        return self.filter {
            $0 > value
        }.eraseToAnyPublisher()
    }
    
}

let publisher = [1,2,3,4,5,6,7,8,9].publisher

//let cancellable = publisher.filterEvenNumbers()
//    .sink { value in
//        print(value)
//    }

let _ = publisher.filterNumberGreaterThen(5)
    .sink { value in
        print(value)
    }
*/


extension Publisher{
    func mapAndFilter<T>(_ transform:@escaping (Output) -> T, _ isIncluded:@escaping (T) -> Bool) -> AnyPublisher<T,Failure>{
        return self
            .map{transform($0)}
            .filter { isIncluded($0)}
            .eraseToAnyPublisher()
    }
}

let publisher = [1,2,3,4,5,6,7,8,9,10].publisher

let cancellable = publisher.mapAndFilter({$0*2}){ value in
    return value % 2 == 0
}
.sink { value in
    print(value)
}
