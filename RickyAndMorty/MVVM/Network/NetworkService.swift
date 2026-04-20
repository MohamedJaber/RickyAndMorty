//
//  NetworkService.swift
//  Rick&Morty
//
//  Created by Mohamed Jaber on 25/03/2026.
//

import Foundation

// MARK: - Protocol

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(
        _ endpoint: NetworkEndpoint
    ) async throws -> T
}

// MARK: - Network Errors

enum NetworkError: Error, LocalizedError {
    case statusCode(Int)
    case decoding(Error)
    case invalidURL
    case requestFailed(Error)
    case custom(String)

    var errorDescription: String? {
        switch self {
        case .statusCode(let statusCode): return "Status code: \(statusCode)"
        case .invalidURL:                 return "Invalid URL"
        case .requestFailed(let error):   return "Network error: \(error.localizedDescription)"
        case .decoding(let error):        return "Data parsing error: \(error.localizedDescription)"
        case .custom(let message):        return message
        }
    }
}

// MARK: - NetworkService

actor NetworkService: NetworkServiceProtocol {

    // MARK: - Cache
    private var cache: [URL: Data] = [:]

    // MARK: - In-flight requests (Deduplication)
    private var inFlightTasks: [URL: Task<Data, Error>] = [:]

    // MARK: - Public API

    func fetch<T: Decodable>(
        _ endpoint: NetworkEndpoint
    ) async throws -> T {

        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }

        let data = try await fetchData(from: url)

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }

    // MARK: - Data Fetching

    private func fetchData(from url: URL) async throws -> Data {

        if let cached = cache[url] {
            return cached
        }

        if let existingTask = inFlightTasks[url] {
            return try await existingTask.value
        }

        let task = Task<Data, Error> {
            try await self.performRequest(url: url)
        }

        inFlightTasks[url] = task

        do {
            let data = try await task.value
            cache[url] = data
            inFlightTasks[url] = nil
            return data
        } catch {
            inFlightTasks[url] = nil
            throw error
        }
    }

    // MARK: - Actual Network Call + Retry

    private func performRequest(url: URL) async throws -> Data {

        let maxRetries = 2
        var attempt = 0

        while true {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)

//                debugPrint("📦 Data:", String(data: data, encoding: .utf8) ?? "")
//                debugPrint("⬅️ Response:", httpResponse.statusCode)

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                guard 200..<300 ~= httpResponse.statusCode else {
                    throw NetworkError.statusCode(httpResponse.statusCode)
                }

                return data

            } catch {
                attempt += 1

                if attempt > maxRetries {
                    throw error
                }

                try await Task.sleep(nanoseconds: UInt64(500_000_000 * attempt))
            }
        }
    }
}
