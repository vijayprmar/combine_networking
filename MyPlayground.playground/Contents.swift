import UIKit
import Combine

struct Post:Codable{
    
    let userId:Int
    let id: Int
    let title:String
    let body:String
}

enum NetworkError:Error{
    case badServerResponse
}


func fetchPost()->AnyPublisher<[Post],Error>{
    
    let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    return URLSession.shared.dataTaskPublisher(for: url)
        //.map(\.data)
        .tryMap({ data,response in
            //print("retries")
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NetworkError.badServerResponse
            }
            return data
        })
        .decode(type: [Post].self, decoder: JSONDecoder())
        .retry(3)
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

