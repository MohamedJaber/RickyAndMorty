# RickyAndMorty

`RickyAndMorty` is a SwiftUI iOS app that explores the Rick and Morty universe using the public [Rick and Morty API](https://rickandmortyapi.com/). The app is organized around three main tabs: characters, locations, and episodes. Each section loads live API data, supports navigation into detail screens, and uses lightweight MVVM separation to keep networking, state management, and UI responsibilities clear.

## Project overview

This project is a multi-tab reference app built with modern SwiftUI patterns:

- `Characters`: browsable list of characters with pagination and a detail screen.
- `Locations`: paginated locations list, pull-to-refresh, and a details screen that also loads the residents of a location.
- `Episodes`: scrollable list of episodes with pagination and an episode details screen that loads the featured characters.

The app launches into a dark-themed `TabView` and uses `NavigationStack` inside each feature flow.

## Features

- SwiftUI-based iOS interface
- MVVM-style structure
- Async/await networking
- Actor-based network service
- In-memory response caching
- In-flight request deduplication
- Pagination for list-based screens
- Detail views for characters, locations, and episodes
- Resident loading for locations
- Episode character loading in batches
- Unit tests for view models using a mock network service
- UI test target scaffolded in the project

## Architecture

The app follows a simple MVVM split:

- `MVVM/App`
  - App entry point and tab bar setup
- `MVVM/Views`
  - SwiftUI screens for characters, locations, and episodes
- `MVVM/ViewModel`
  - Feature-specific state and async loading logic
- `MVVM/Model`
  - Decodable models matching API responses
- `MVVM/Network`
  - Endpoint definitions and the shared network service
- `MVVM/Helper files`
  - Small reusable helpers such as array chunking

### Networking

`NetworkService` is implemented as an `actor`, which helps protect shared mutable state used for:

- response caching by `URL`
- deduplicating repeated in-flight requests
- retrying failed requests with a small backoff

All feature view models depend on `NetworkServiceProtocol`, which makes the app easier to test with mocks.

## Screens

### Characters

- Loads paginated character data from the API
- Displays character avatars and names in a list
- Navigates to a detail screen showing gender, species, status, origin, and current location

### Locations

- Displays a paginated list of locations
- Supports pull-to-refresh
- Opens a detail screen with location metadata
- Loads and shows resident information for each location

### Episodes

- Displays episodes in a custom scrollable list
- Supports pagination as the user reaches the last episode row
- Opens a detail screen for episode metadata
- Loads episode characters by extracting character IDs from the API URLs and fetching them in chunks

## Tests

The repository already includes view model tests built with Swift Testing:

- `CharactersViewModelTests`
- `LocationsViewModelTests`
- `LocationDetailViewModelTests`
- `EpisodeViewModelTests`
- `EpisodeDetailViewModelTests`

These tests use a `MockNetworkService` to validate loading, error handling, refresh behavior, and pagination-related logic without hitting the live API.

## Requirements

- Xcode with SwiftUI and Swift Concurrency support
- iOS Simulator or physical iPhone/iPad target

Current project settings include:

- Swift version: `5.0`
- Marketing version: `1.0`
- Deployment target in the project file: `iOS 26.4`

## Getting started

1. Open `RickyAndMorty.xcodeproj` in Xcode.
2. Select the `RickyAndMorty` scheme.
3. Choose an iOS Simulator.
4. Build and run the app.

## Running tests

In Xcode:

1. Open the project.
2. Select the test navigator or use Product > Test.
3. Run the unit tests and UI tests for the selected simulator.

## API

This project uses the public Rick and Morty API:

- Base URL: `https://rickandmortyapi.com/api`

The app currently fetches:

- characters
- locations
- single locations
- episodes
- character records by direct URL
- character records by ID batches

## Notes

- The app uses a dark color scheme at launch.
- Some feature screens use `List`, while others use custom `ScrollView` layouts.
- The networking layer is reusable and already structured for dependency injection in tests.

