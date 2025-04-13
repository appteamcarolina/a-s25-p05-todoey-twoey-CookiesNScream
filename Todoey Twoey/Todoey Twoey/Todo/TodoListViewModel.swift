//
//  TodoListViewModel.swift
//  Todoey Twoey
//
//  Created by Arya Venkatesan on 4/11/25.
//
import SwiftUI

enum TodoListLoadingState {
    // TODO: Implement TodoListLoadingState
    // with success, error, loading, and idle states
    case idle
    case loading
    case success([Todo])
    case error(String)
}


@MainActor
class TodoListViewModel: ObservableObject {
    @Published var state: TodoListLoadingState = .idle
    
    func fetchTodos() async {
        do {
            let todos = try await TodoListService.getTodos()
            // TODO: Set state to success
            await MainActor.run {
                state = .success(todos)
            }

        } catch {
            // TODO: Set state to error
            await MainActor.run {
                state = .error("Eror")
            }
        }
    }

    func createTodo(title: String) async {
                // TODO: Implement createTodo using TodoListService.create() (see fetchTodos)
        do {
            _ = try await TodoListService.create(newTodo: NewTodo(title: title))
        } catch {
            print("Something bad happened")
        }
    }

    func delete(todo: Todo) async {
                // TODO: Implement delete
        do {
            try await TodoListService.delete(todo: todo)
        } catch {
            print("Something bad happened")
        }
    }

    func toggleCompletion(for todo: Todo) async {
                // TODO: Implement toggleCompletion
        do {
            try await TodoListService.updateCompletion(for: todo, isCompleted: !todo.isCompleted)
        } catch {
            print("Something bad happened")
        }
    }
}
