import Foundation
import PlaygroundSupport

// Allow playground to run indefinitely
PlaygroundPage.current.needsIndefiniteExecution = true

// Define your model structs
struct NewsObject: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source?
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: ID?
    let name: String
}

enum ID: String, Codable {
    case businessInsider = "business-insider"
    case dieZeit = "die-zeit"
    case wired = "wired"
}

// Define a type alias for an array of objects
var apiKey = "Put your api key here."

// Define the URL of the API
guard let url = URL(string: "https://newsapi.org/v2/everything?apiKey=\(apiKey)&q=bitcoin") else {
    print("Invalid URL")
    PlaygroundPage.current.finishExecution()
}

// Create a URLSession data task
let task = URLSession.shared.dataTask(with: url) { data, response, error in
    // Handle errors
    if let error = error {
        print("Error: \(error.localizedDescription)")
        PlaygroundPage.current.finishExecution()
        return
    }

    // Ensure there is data
    guard let data = data else {
        print("No data")
        PlaygroundPage.current.finishExecution()
        return
    }

    // Decode the JSON data into your custom model
    do {
        let decoder = JSONDecoder()
        let newsObject = try decoder.decode(NewsObject.self, from: data)
      
        for item in newsObject.articles {
            print("article : \(item.source?.name ?? "")\nauthor: \(item.author ?? "")\ntitle: \(item.title)")
        }
    } catch {
        print("Error decoding JSON: \(error.localizedDescription)")
    }

    // Finish Playground execution
    PlaygroundPage.current.finishExecution()
}

// Start the data task
task.resume()
