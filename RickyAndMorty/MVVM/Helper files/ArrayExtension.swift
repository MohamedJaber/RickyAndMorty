//
//  ArrayExtension.swift
//  RickyAndMorty
//
//  Created by Mohamed Jaber on 12/04/2026.
//


extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
