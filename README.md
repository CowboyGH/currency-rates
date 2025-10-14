# 📈 Rates

A mobile application for fetching and displaying currency exchange rates.

---

## 🎥 Preview

<p align="left">
  <img src="assets/images/preview/rates_app.gif" alt="Rates app preview" width="300"/>
</p>

---

## 🔗 API

The app uses the official CBR (Central Bank of Russia) XML API:  
[http://www.cbr.ru/scripts/XML_daily.asp](http://www.cbr.ru/scripts/XML_daily.asp)

---

## 🧱 Architecture

The application follows **Clean Architecture** principles with clear separation of responsibilities between layers:  
`Data`, `Domain`, and `Presentation`.

- **State management:** `BLoC` / `Cubit`
- **Global DI:** `get_it`
- **Local DI (per feature):** `provider`
- **HTTP client:** `dio` + `retrofit`
- **Routing:** `go_router` (`core/router/router.dart`)
- **Local storage:** `hive`
- **Connectivity tracking:** `connectivity_plus`

The project uses a **feature-first** structure — each feature is an isolated module.

---

## 📁 Project Structure

The application code is located in the `lib` directory and is organized as follows:

- **lib/**
  - `api/`: API interaction layer (DTO models, Retrofit clients).
  - `assets/`: String constants, asset paths, route names.
  - `core/`: Core layer with reusable services, error handling, base classes, and router configuration.
    - `router/`: GoRouter navigation setup.
  - `features/`: Main application features.
    - `app/`: Root widget and DI initialization (`initDi`).
    - `common/`: Shared widgets, entities, repositories, DTOs, etc.
    - `feature_name/`: Individual feature module.
      - `data/`: Repositories, data sources, DTOs, mappers.
      - `domain/`: Business logic, entities, use cases, interfaces.
      - `presentation/`: UI layer, Cubits/BLoCs, screens, widgets.
  - `uikit/`: Reusable UI components (buttons, themes, custom widgets).
  - `main.dart`: Entry point for the production environment.
  - `runner.dart`: App initialization and launch.

---

## 🧭 Layer Structure

Each feature consists of three layers: `UI`, `Domain`, and `Data`.

- **Data Layer**  
  Responsible for fetching and storing data (network, local DB).  
  Contains repository implementations, DTOs, and mappers.

- **Domain Layer**  
  Contains business logic, use cases, and repository contracts.  
  Independent from other layers.

- **UI Layer**  
  Displays data and handles user interaction.  
  Uses Cubits/BLoCs to communicate with the domain layer.

---

## 🛠 Tech Stack

- Flutter / Dart
- BLoC / Cubit
- Retrofit + Dio
- GoRouter
- Hive
- Connectivity Plus
- Feature-First + Clean Architecture

---

## 📜 License

This project is released under the [MIT License](LICENSE).

---

## ✨ Author

Developed by [Ryan Delaney](https://github.com/CowboyGH)