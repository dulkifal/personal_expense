# MMAS Money Tracker

**MMAS Money Tracker** is an optimized, modern mobile application built with **Flutter** for tracking daily expenses and managing financial tasks. It features a cool, dark-themed UI with vibrant accents, ensuring a premium user experience.

## ✨ Features

### 💸 Expense Tracking
- **Add Expenses**: Quickly log expenses with title, amount, date, and category.
- **Categorization**: Visual icons and color-coded categories (Food, Transport, Shopping, etc.).
- **History**: View a chronological list of all your expenses.
- **Delete**: Swipe-to-delete functionality for managing entries.

### ✅ Financial Tasks
- **Task Management**: Create financial goals or tasks (e.g., "Pay credit card bill", "Save for vacation").
- **Priorities**: Assign High, Medium, or Low priority to tasks.
- **Deadlines**: Set due dates to stay organized.
- **Status**: Mark tasks as completed with a simple checkbox.

### 📊 Dashboard & Analytics
- **Spending Summary**: See your total spending at a glance.
- **Task Overview**: Track the number of pending financial tasks.
- **Visual Charts**: Interactive **Pie Chart** breakdown of expenses by category.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: [Riverpod](https://riverpod.dev/)
- **Local Database**: [Hive](https://docs.hivedb.dev/) (NoSQL, fast & offline-first)
- **Charts**: [fl_chart](https://pub.dev/packages/fl_chart)
- **Icons**: Material Icons (optimized)
- **Typography**: Google Fonts (Poppins)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed on your machine.
- A physical device or emulator (Android/iOS).

### Installation

1.  **Clone the repository** (if applicable) or navigate to the project folder:
    ```bash
    cd mmas_money_tracker
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run Code Generation** (Important for Hive):
    If you modify any models (`Expense` or `FinancialTask`), you must regenerate the adapters. I have already included the generated files, but if you need to re-run:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the App**:
    Connect your device and run:
    ```bash
    flutter run
    ```

## 📂 Project Structure

The project follows a **Feature-First** architecture:

```
lib/
├── core/
│   ├── theme/          # App Theme (Colors, Typography)
│   └── ...
├── features/
│   ├── dashboard/      # Dashboard UI & Logic
│   ├── expenses/       # Expense Models, Repositories, UI
│   └── tasks/          # Task Models, Repositories, UI
└── main.dart           # App Entry Point
```

## 🎨 Design

The app uses a custom `AppTheme` with:
- **Dark Mode** support (defaulting to system settings).
- **Vibrant Colors**: Violet Primary (`#6C63FF`) and Teal Secondary (`#03DAC6`).
- **Glassmorphism**: Subtle transparency and gradients on cards.
- **Rounded UI**: Modern, friendly shapes.
