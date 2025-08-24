# Cruise Countdown Widget

This feature provides a comprehensive countdown system for cruise departures with iOS home screen widget support.

## Features

- **Interactive Countdown Timer**: Real-time countdown showing days, hours, minutes, and seconds
- **iOS Home Widget**: Native iOS widget that displays selected cruise countdown on the home screen
- **Cruise Selection**: Choose from a list of upcoming cruises to track
- **Visual Indicators**: Color-coded alerts for cruises departing soon
- **Cross-Platform**: Works on both iOS and Android (widget functionality is iOS-only)

## iOS Widget Setup

### Prerequisites

- iOS 14.0 or later
- Xcode 12.0 or later
- Flutter 3.0 or later

### Setup Instructions

1. **Add Widget Extension Target**
   - Open the iOS project in Xcode: `ios/Runner.xcworkspace`
   - Go to File → New → Target
   - Select "Widget Extension" under iOS
   - Name it "CountdownWidgetExtension"
   - Make sure "Include Configuration Intent" is unchecked

2. **Configure App Groups**
   - Select the main app target (Runner)
   - Go to Signing & Capabilities
   - Add "App Groups" capability
   - Create a group: `group.com.example.interactiveMapDemo`
   - Repeat for the widget extension target

3. **Replace Widget Files**
   - Replace the generated widget files with the provided ones:
     - `ios/CountdownWidgetExtension/CountdownWidgetExtension.swift`
     - `ios/CountdownWidgetExtension/Info.plist`

4. **Plugin Registration**
   - The method channel is already registered in `ios/Runner/AppDelegate.swift`
   - The widget handler is integrated directly into the AppDelegate

### Widget Features

- **Small Widget**: Shows cruise name, ship, and days remaining
- **Medium Widget**: Includes destination and departure date
- **Auto-refresh**: Updates every hour
- **Dynamic Content**: Shows "Select a cruise" when no cruise is selected

## Usage

### In Flutter App

1. **Access Countdown Modal**
   - Tap the timer icon in the app bar
   - This opens a bottom sheet with cruise selection

2. **Select a Cruise**
   - Tap on any cruise card to select it
   - The selected cruise will appear in the "Selected for Home Widget" section
   - The iOS widget will automatically update

3. **Clear Selection**
   - Tap the close button (X) on the selected cruise
   - Or tap the selected cruise again to deselect it

### Widget Data Flow

```
Flutter App → Method Channel → iOS Plugin → UserDefaults → Widget Extension
```

1. User selects a cruise in the Flutter app
2. `IOSCountdownBridge.updateWidget()` is called
3. Data is sent via method channel to iOS plugin
4. Plugin saves data to shared UserDefaults
5. Widget extension reads data and updates display

## File Structure

```
lib/countdown_widget/
├── countdown_widget.dart          # Main countdown widget
├── simple_countdown_widget.dart   # Compact countdown widget
├── countdown_modal.dart           # Bottom sheet modal
├── countdown_page.dart            # Full page demo
├── ios_countdown_bridge.dart      # iOS communication bridge
└── models/
    └── cruise_countdown.dart      # Shared data model

ios/
├── Runner/
│   └── AppDelegate.swift          # Method channel registration and handler
└── CountdownWidgetExtension/
    ├── CountdownWidgetExtension.swift # Widget implementation
    └── Info.plist                 # Widget configuration
```

## Troubleshooting

### Widget Not Updating
- Ensure app groups are properly configured
- Check that the widget extension target is included in the build
- Verify the UserDefaults suite name matches in both app and widget

### Method Channel Errors
- Check that the plugin is registered in AppDelegate
- Verify the method channel name matches: `countdown_widget`
- Ensure iOS 14+ for widget functionality

### Build Issues
- Clean and rebuild the project
- Check that all Swift files are included in the correct targets
- Verify iOS deployment target is 14.0 or later

## Customization

### Widget Appearance
- Modify `CountdownWidgetEntryView` in the widget extension
- Adjust colors, fonts, and layout as needed
- Test different widget sizes (small/medium)

### Data Structure
- Update `CruiseData` struct to include additional fields
- Modify the Flutter bridge to pass new data
- Update UserDefaults keys accordingly

### Update Frequency
- Change the timeline update policy in `CountdownTimelineProvider`
- Options: `.atEnd`, `.after(date)`, `.never`

## Future Enhancements

- [ ] Multiple cruise support in widget
- [ ] Customizable widget themes
- [ ] Push notifications for departure reminders
- [ ] Android widget support
- [ ] Widget deep linking to app
