//
//  Todo.swift
//  Todoey Twoey
//
//  Created by Arya Venkatesan on 4/11/25.
//
import SwiftUI

struct NewTodo: Codable {
    let title: String
}

struct Todo: Identifiable, Codable {
    let id: UUID
    let title: String
    var isCompleted: Bool
}
