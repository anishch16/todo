# todo
Assessment round task

This is a modern and lightweight Todo List application built with Flutter, following Clean Architecture principles. It ensures a maintainable codebase by clearly separating the presentation, domain, and data layers. The app includes essential features such as task creation, filtering, updating, deletion, local persistence, and a responsive UI optimized for both mobile and tablet devices.

# Architecture

1. Clean Architecture: Enforces separation of concerns and direction of dependencies.

2. BLoC: Manages state by converting UI Events into business logic and emitting new States.

3. Hive: Used for fast, local, and persistent storage of Task data.

4. dartz (Either): Provides explicit Error Handling by representing results as Either<Failure, Success>.

5. GetIt: Used as a Service Locator for dependency injection (DI).

# Follow these steps to set up and run the application locally.

## Prerequisites

- Flutter SDK (Stable Channel)

- Dart SDK

## Setup Instructions

1. Clone the Repository:
- git clone https://github.com/anishch16/todo.git
- cd "to your cloned directory" 

2. Install Dependencies:
- flutter pub get

3. Generate Code (Hive Adapters):
- dart run build_runner build --delete-conflicting-outputs

4. Run the Application:
- flutter run

## Design Decisions

1. Explicit Error Handling: All Repository and Use Case methods return Either from dartz, forcing developers to explicitly handle success and failure paths.

2. Encapsulated Logic: Complex filtering and sorting logic (by Due Date, then Creation Date) is fully isolated in the GetFilteredTasks Use Case, keeping the BLoC thin.

3. Dependency Injection: GetIt is used throughout the ```core/di/service_locator.dart``` to manage dependencies, making it simple to swap out implementations (e.g., change the local data source).
