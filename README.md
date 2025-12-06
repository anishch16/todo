# TODO APP

This is a modern and lightweight Todo List application built with Flutter, following strict Clean Architecture principles. It ensures a highly maintainable and testable codebase by clearly separating the presentation, domain, and data layers. 

The app includes essential features such as:

- Task Creation, Filtering, Updating, and Deletion

- Fast, Local Persistence (using Hive)

- Responsive UI optimized for both mobile and tablet devices.

# Architecture

## Clean Architecture

Enforces strict separation of concerns and a clear direction of dependencies (Presentation, Domain, Data), leading to a testable and scalable system.

## BLoC

Manages state by converting UI Events into business logic and emitting new States, keeping the UI layer purely declarative.

## Hive

Used for fast, local, and persistent storage of Task data, offering excellent performance for mobile applications.

## dartz (Either)

Provides explicit and robust Error Handling by representing all potential results as ```Either<Failure, Success>```, eliminating null-checks for errors.

## GetIt

Used as a Service Locator for simple and effective dependency injection (DI), centralizing dependency management.

# Follow these steps to set up and run the application locally.

## Prerequisites

- Flutter SDK (Stable Channel)

- Dart SDK

## Setup Instructions

### Clone the Repository:

```git clone https://github.com/anishch16/todo.git```
```cd "to your cloned directory" ```

### Install Dependencies:

```flutter pub get```

### Generate Code (Hive Adapters):

```dart run build_runner build --delete-conflicting-outputs```

### Run the Application:

```flutter run```

## Design Decisions

### Explicit Error Handling

All Repository and Use Case methods are strongly typed to return ```Either``` from ```dartz```, forcing developers to explicitly handle both success and failure paths at the Presentation layer. This prevents runtime errors from unhandled exceptions.

### Encapsulated Logic

Complex filtering and sorting logic (by Due Date, then Creation Date) is fully isolated within the GetFilteredTasks Use Case. This design choice keeps the BLoC thin and makes the core business logic independently testable.

### Dependency Injection

GetIt is used consistently throughout the ```core/di/service_locator.dart``` to manage dependencies. This central configuration makes it simple and low-effort to swap out implementations (e.g., changing the local data source from Hive to $\text{sqflite}$ or a remote API).
