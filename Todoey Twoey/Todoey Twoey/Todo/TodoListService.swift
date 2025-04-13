//
//  TodoListService.swift
//  Todoey Twoey
//
//  Created by Arya Venkatesan on 4/11/25.
//
import SwiftUI

struct TodoListService {
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    static let baseUrl = "https://learning.ryderklein.com/"
    
    static func getTodos() async throws -> [Todo] {
        // TODO: Implement. See above for request code
        let workingUrl = baseUrl + "todos/"
        guard let url = URL(string: workingUrl) else {
            fatalError("Invalid URL")
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let todo = try decoder.decode([Todo].self, from: data)
        
        return todo
    }
    
    static func create(newTodo: NewTodo) async throws -> Todo {
        // TODO: Implement
        let workingUrl = baseUrl + "todos/"
        guard let url = URL(string: workingUrl) else {
            fatalError("Invalid URL")
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let json: [String: String] = ["title": newTodo.title]
        let encoded: Data = try encoder.encode(json)
        request.httpBody = encoded
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let todo = try decoder.decode(Todo.self, from: data)
        return todo
    }
    
    static func delete(todo: Todo) async throws {
        let workingUrl = baseUrl + "todos/" + "\(todo.id)/"
        guard let url = URL(string: workingUrl) else {
            fatalError("Invalid URL")
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (_, _) = try await URLSession.shared.data(for: request)
    }
    
    static func updateCompletion(for todo: Todo, isCompleted: Bool) async throws {
        // TODO: Implement
        let workingUrl = baseUrl + "todos/" + "\(todo.id)/" + "updateCompleted?isCompleted=\(isCompleted)"
        guard let url = URL(string: workingUrl) else {
            fatalError("Invalid URL")
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }
}
