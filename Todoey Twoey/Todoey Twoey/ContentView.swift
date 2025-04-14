//
//  ContentView.swift
//  Todoey Twoey
//
//  Created by Arya Venkatesan on 4/11/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var vm = TodoListViewModel()
    @State private var newTodoTitle: String = ""

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Title", text: $newTodoTitle)
                        .onSubmit {
                            Task {
                                await vm.createTodo(title: newTodoTitle)
                                newTodoTitle = ""
                                await vm.fetchTodos()
                            }
                        }
                }
                switch vm.state {
                case .idle: Text("Make a request")
                case .loading: Text("Loading...")
                case .success(let todos): todoListView(todos: todos)
                case .error(let message): Text("Error: \(message)")
                }
            }
            .navigationTitle("Todoey Twoey")
            .refreshable {
                await vm.fetchTodos()
            }
        }
        .task {
            await vm.fetchTodos()
        }
    }

    @ViewBuilder
    private func todoListView(todos: [Todo]) -> some View {
        if !todos.isEmpty {
            ForEach(todos) { todo in
                Button {
                    Task {
                        await vm.toggleCompletion(for: todo)
                        await vm.fetchTodos()
                    }
                } label: {
                    HStack {
                        Image(
                            systemName: todo.isCompleted
                                ? "circle.fill" : "circle")
                        Text(todo.title)
                            .foregroundStyle(Color.black)
                    }
                }
                .swipeActions {
                    Button(role: .destructive) {
                        Task {
                            await vm.delete(todo: todo)
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
            }
        } else {
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    Image(systemName: "checklist.checked")
                        .font(.system(size: 50))
                    Text("There is nothing to do right now!")
                }
                Spacer()
            }
        }
    }
}
