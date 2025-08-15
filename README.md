# Currency Converter - Flutter Interview Project

A Flutter application demonstrating Clean Architecture principles, BLoC state management, and modern mobile development practices for currency conversion functionality.

<img width="405" height="829" alt="image" src="https://github.com/user-attachments/assets/5ca05d96-19ed-4042-ab89-2b98910b1a9d" />


### Clean Architecture Structure
```
lib/
├── core/                          # Shared functionality
│   ├── constants/                 # App-wide constants and design tokens
│   ├── di/                       # Dependency injection setup
│   ├── errors/                   # Error handling and failures
│   └── utils/                    # Helper utilities and extensions
├── data/                         # Data layer implementation
│   ├── datasources/              # Remote & local data sources
│   ├── models/                   # Data transfer objects
│   └── repositories/             # Repository implementations
├── domain/                       # Business logic layer
│   ├── entities/                 # Core business entities
│   ├── repositories/             # Repository contracts
│   └── usecases/                 # Business use cases
├── l10n/                         # Internationalization
├── presentation/                 # UI layer
│   ├── blocs/                    # BLoC state management (Cubit)
│   ├── pages/                    # Screen implementations
│   └── widgets/                  # Reusable UI components
└── main.dart                     # Application entry point
```

## 🎯 Key Features Implemented

- **Clean Architecture**: Separation of concerns with distinct layers
- **Cubit Pattern**: Simplified state management with flutter_bloc
- **Dependency Injection**: Service locator pattern with get_it
- **Internationalization**: Multi-language support with Flutter's l10n
- **Unit Testing**: Comprehensive test coverage for business logic

## 🛠️ Technical Stack

### Core Dependencies
- **flutter_bloc** `^9.1.1` - State management with Cubit pattern
- **get_it** `^8.2.0` - Dependency injection service locator
- **http** `^1.5.0` - HTTP client for API integration
- **intl** `^0.20.2` - Internationalization and localization
- **flutter_localizations** - Flutter's built-in localization support

### Development Dependencies
- **flutter_test** - Unit and widget testing framework
- **mocktail** `^1.0.4` - Modern mocking library for tests
- **flutter_lints** `^5.0.0` - Code quality and linting rules

## 🏛️ Architecture Layers Explained

### 1. **Presentation Layer**
- **Cubit**: Manages UI state and business logic coordination
- **Pages**: Screen-level widgets with state management integration
- **Widgets**: Reusable, stateless UI components with callback parameters
- **Separation of Concerns**: State management isolated from UI components

### 2. **Domain Layer** 
- **Entities**: Pure business objects (Currency, ExchangeRate)
- **Use Cases**: Single-responsibility business operations
- **Repository Interfaces**: Contracts for data access abstraction

### 3. **Data Layer**
- **Models**: Data transfer objects for API responses
- **Data Sources**: Remote API and local hardcoded data implementations
- **Repository**: Concrete implementations with error handling

### 4. **Core Layer**
- **Dependency Injection**: Centralized service registration
- **Constants**: Design tokens and configuration
- **Error Handling**: Custom failure types and error management

## 🔄 Data Flow Pattern

```
UI Event → Cubit → Use Case → Repository → Data Source → API/Local Data
                     ↓
UI Update ← Cubit ← Use Case ← Repository ← Data Source ← Response
```

## 🧪 Testing Strategy

- **Unit Tests**: Use cases, repositories, and data sources
- **Cubit Test**: State management logic with mocktail

## 🎨 UI/UX Implementation

### Design Decisions
- **Custom Design System**: Consistent design tokens and styling
- **Loading States**: Clear user feedback during operations
- **Internationalization**: Multi-language support (English/Spanish/Portuguese)
- **Error States**: Graceful error handling with localized messages

### Supported Currencies
- **USDT** (Tether - Cryptocurrency)
- **VES** (Venezuelan Bolívar)
- **BRL** (Brazilian Real)
- **COP** (Colombian Peso)
- **PEN** (Peruvian Sol)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8.1+
- Dart SDK 3.0.0+

### Installation
```bash
# Clone and setup
git clone <repository-url>
cd coin-converter
flutter pub get

# Run the application
flutter run

# Run tests
flutter test
```

