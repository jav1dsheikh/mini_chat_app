# Mini Chat App - Assignment

## Completed Requirements

### 1. Home & Navigation
*   **3 Tabs**: Home (Active), Offers & Settings (Placeholder).
*   **Sliver AppBar**: Floats on scroll up, hides on scroll down.
*   **State**: Scroll positions preserved independently per tab.

### 2. Users Tab
*   **List**: Scrollable mock user list.
*   **Action**: Floating Button adds new users instantly.

### 3. Chat Screen
*   **API**: Receiver messages fetched live from `dummyjson.com`.
*   **Architecture**: "Newest-at-bottom" layout.

### Bonus: Dictionary
*   **Feature**: Long-press any word in chat.
*   **Result**: Bottom sheet shows Definition & Phonetics (via Free Dictionary API).

## Tech Stack
*   **Architecture**: MVVM with `Provider`.
*   **Error Handling**: Graceful `SnackBars` for network/server failures.
*   **Testing**: Full Unit & Widget test suite (4 passing tests).

## Run Project


```
# Get Packages
flutter pub get

# Run Tests
flutter test

# Run App
flutter run
```
