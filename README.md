# Interactive Map Demo

A comprehensive Flutter application showcasing advanced interactive map implementations with multiple use cases including cruise destinations, ship deck plans, and route-based itinerary maps.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Technical Details](#technical-details)
- [Backend Integration](#backend-integration)
- [AI Digest](#ai-digest)
- [Contributing](#contributing)

## 🌟 Overview

This Flutter demo application demonstrates three distinct interactive map implementations, each designed for different use cases:

1. **Interactive Destination Map** - Great Stirrup Cay with POI markers and filtering
2. **Multi-Deck Ship Map** - Norwegian Aqua deck plans with interactive polygon areas
3. **Cruise Itinerary Map** - **Backend-driven** Caribbean route with automatic day positioning and path generation

The project serves as a comprehensive reference for implementing complex interactive maps in Flutter applications, with a **special focus on backend integration**. The itinerary map demonstrates how to receive day-by-day location data from an API and automatically generate map markers, route paths, and interactive navigation.

### 🔄 **Backend-Driven Map Concept**
The core innovation is a **dynamic itinerary system** where:
- **Backend provides**: Daily locations as `[x, y]` pixel coordinates on the map image
- **App automatically**: Positions day markers, draws connecting paths, enables day navigation
- **No hardcoding**: All positioning is data-driven and updates dynamically

## ✨ Features

### 🏝️ Interactive Destination Map (Great Stirrup Cay)
- **Pan & Zoom**: Full gesture support with `InteractiveViewer`
- **Marker System**: POI markers with category-based filtering
- **Responsive Zoom Tiers**: Markers appear/disappear based on zoom level
- **Smooth Animations**: Selected markers scale with pulsing glow effects
- **Detail Views**: Bottom sheet dialogs with marker information
- **Gesture Handling**: Double-tap zoom, long-press reset, map tap deselection

### 🚢 Multi-Deck Ship Map (Norwegian Aqua)
- **Deck Navigation**: Browse 16 decks (Decks 5-20) with mini-map
- **Interactive Polygons**: Clickable areas for ship facilities
- **Legend System**: Swipeable bottom sheet with facility categories
- **Multi-Ship Support**: Extensible architecture for different ship classes
- **Responsive Design**: Adapts to different screen sizes and orientations

### 🗺️ Cruise Itinerary Map (Multiple Routes) - **Backend-Driven**
- **Multi-Itinerary Support**: Caribbean (7-day) and Transatlantic (15-night) cruise routes
- **Dynamic Route Generation**: Routes automatically generated from backend itinerary data
- **Automatic Marker Positioning**: Day markers placed using backend-provided coordinates
- **Smart Path Drawing**: Curved route paths automatically connect each day's location
- **Auto-Scrolling Day Indicators**: Day selector automatically scrolls to highlight current day
- **Bidirectional Route Animation**: Smooth forward/backward animations between days
- **Day-by-Day Navigation**: Swipeable cards with auto-centering day indicators
- **Port Information**: Detailed port data with arrival/departure times
- **Sea Day Interpolation**: Smart positioning for consecutive sea days between ports
- **Real-Time Updates**: Map updates automatically when backend data changes
- **Zero Hardcoding**: All positioning driven by backend coordinate data
- **Custom Route Painter**: Extracted route visualization into dedicated widget component
- **Draggable Bottom Sheet**: Collapsible 250px sheet with snap-to-position behavior
- **Smart Layout Management**: Automatic padding prevents bottom sheet from covering map content
- **No White Space Guarantee**: Calculated minimum scale ensures map always fills viewport
- **Responsive Design**: Works flawlessly across different screen sizes and orientations

## 🏗️ Architecture

### Design Patterns
- **Repository Pattern**: Data persistence and management
- **Widget Composition**: Small, focused, reusable widgets
- **State Management**: Local state with `StatefulWidget` and `setState`
- **Extension Methods**: Code reusability and clean APIs
- **SOLID Principles**: Modular, maintainable, and extensible code

### Key Architectural Decisions
- **Backend-Driven Positioning**: All map elements positioned using backend-provided coordinate data
- **Image-Based Coordinate System**: Coordinates are `[x, y]` pixels on map images, enabling backend integration
- **Dynamic Route Generation**: Route paths automatically calculated from itinerary day positions
- **Single Source of Truth**: `_getDayPosition(dayIndex)` method controls all positioning logic
- **Modular Data Architecture**: Cruise itineraries separated into dedicated data files for maintainability
- **Auto-Scrolling Navigation**: Day indicators automatically center on selected day with smooth animations
- **Clean Model Separation**: Pure model classes separated from sample data implementations
- **Performance Optimization**: Cached image sizes, efficient marker rendering, ScrollController management
- **Theme Integration**: Consistent Material 3 design system usage
- **Responsive Design**: Safe area handling and dynamic sizing

## 📁 Project Structure

```
lib/
├── main.dart                           # App entry point and navigation
├── interactive_map/                    # Great Stirrup Cay destination map
│   ├── interactive_map.dart           # Main interactive map widget
│   ├── models/
│   │   └── interactive_map_marker_data.dart
│   ├── pages/
│   │   └── marker_details_page.dart
│   └── widgets/
│       ├── interactive_map_error.dart
│       ├── interactive_map_filter.dart
│       ├── interactive_map_legend.dart
│       ├── interactive_map_marker.dart
│       └── interactive_map_marker_detail.dart
├── deck_plan/                          # Ship deck plan maps
│   ├── multi_deck_ship_map.dart       # Core deck map widget
│   ├── norwegian_aqua_deck_map.dart   # Norwegian Aqua implementation
│   ├── models/
│   │   ├── deck_polygon_data.dart
│   │   └── ship_deck_data.dart
│   └── widgets/
│       ├── deck_key_legend.dart
│       ├── deck_mini_map.dart
│       └── deck_polygon_overlay.dart
└── itinerary/                          # Cruise itinerary and route maps
    ├── data/                           # Sample itinerary data files
    │   ├── caribbean_cruise.dart       # Norwegian Aqua 7-day Caribbean cruise
    │   └── transatlantic_cruise.dart   # Norwegian Pearl 15-night Transatlantic cruise
    ├── models/
    │   └── cruise_itinerary.dart       # Core models (CruiseItinerary, PortData, ItineraryDay)
    ├── pages/
    │   └── cruise_itinerary_page.dart
    └── widgets/
        ├── itinerary_map.dart          # Main route map widget
        ├── cruise_route_painter.dart   # Custom route visualization painter
        ├── itinerary_bottom_section.dart  # Draggable bottom sheet with auto-scrolling day indicators
        ├── itinerary_table.dart
        ├── port_marker.dart            # Extracted marker widget with complex styling
        ├── sea_day_info.dart
        ├── port_day_info.dart
        └── info_tile.dart

assets/
├── images/
│   ├── map.jpg                         # Great Stirrup Cay map (1.8MB)
│   ├── caribbean_cruise_map.png        # Caribbean route map (20KB)
│   └── norwegian_pearl_transatlantic_map.png  # Transatlantic route map (20KB)
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ^3.7.2
- Dart SDK ^3.7.2
- iOS Simulator / Android Emulator / Physical Device

### Dependencies
```yaml
dependencies:
  flutter: sdk
  cupertino_icons: ^1.0.8
  vector_math: ^2.1.4

dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^5.0.0
```

### Installation
1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd interactive_map_demo
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## 📱 Usage

### Navigation Flow
1. **Home Screen**: Choose from three map types
2. **Interactive Maps**: Each demonstrates different interaction patterns
3. **Detail Views**: Tap markers/areas for additional information

### Map Controls
- **Pan**: Drag to move around the map
- **Zoom**: Pinch to zoom in/out or double-tap
- **Reset**: Long press to return to initial view
- **Selection**: Tap markers/areas for details

## 🔧 Technical Details

### Backend-Ready Coordinate System
The project uses an **image-based coordinate system** designed for seamless backend integration. All positions are defined as `[x, y]` pixel coordinates relative to the source map images:

```dart
// Backend provides itinerary days with coordinates
ItineraryDay(
  port: PortData(
    name: 'Miami',
    coordinates: [100, 50], // x=100px, y=50px on map image
  ),
);

// App automatically positions everything
final position = _getDayPosition(dayIndex); // → Offset(100, 50)
// ✅ Marker appears at (100, 50)
// ✅ Route starts/ends at (100, 50)  
// ✅ Tap detection at (100, 50)
```

**Benefits:**
- **Direct Backend Integration**: APIs provide coordinates, app displays immediately
- **Scalability**: Independent of device screen sizes
- **Zero Configuration**: No manual positioning or calibration needed
- **Precision**: Pixel-perfect positioning on map images
- **Dynamic Updates**: Change backend data, map updates automatically

### Route Animation System
The itinerary map features an advanced **bidirectional animation system** that provides intuitive visual feedback during navigation:

```dart
// Forward Navigation (Day 3 → Day 4)
// ✅ Blue route "fills" from Day 3 to Day 4
void _animateRouteProgress(ItineraryDay fromDay, ItineraryDay toDay) {
  final fromProgress = _calculateDayProgress(fromDay);  // 0.6 (Day 3)
  final toProgress = _calculateDayProgress(toDay);      // 0.8 (Day 4)
  
  // Animation fills: 0.6 → 0.8 (forward expansion)
}

// Reverse Navigation (Day 4 → Day 3)  
// ✅ Blue route "unfills" from Day 4 back to Day 3
void _animateRouteProgress(ItineraryDay fromDay, ItineraryDay toDay) {
  final fromProgress = _calculateDayProgress(fromDay);  // 0.8 (Day 4)
  final toProgress = _calculateDayProgress(toDay);      // 0.6 (Day 3)
  
  // Animation unfills: 0.8 → 0.6 (backward retraction)
}
```

**Animation Features:**
- **Forward Animation**: Route visually "draws itself" from previous to current day
- **Reverse Animation**: Route visually "erases itself" from previous back to current day
- **Curved Path Support**: Animations follow Bézier curves, maintaining visual continuity
- **Incremental Progress**: Only animates the segment between days, not the entire route
- **Performance Optimized**: Dedicated `CruiseRoutePainter` handles all rendering logic

### Layout Management & UI Architecture
The itinerary map features an advanced **dual-viewport layout system** that prevents UI collisions while maintaining smooth interactions:

```dart
// 1. Calculate scale to fill entire viewport (prevents white space)
final double minScale = _getMinScale(viewportSize, imageSize);

// 2. Add bottom padding to image dimensions (prevents content overlap)
child: SizedBox(
  width: imageSize.width,
  height: imageSize.height + 250.0, // Natural padding for bottom sheet
)

// 3. Update all calculations to use padded dimensions
final double paddedImageHeight = imageSize.height + 250.0;
final double scaleToFillHeight = viewportSize.height / paddedImageHeight;
```

**Layout Benefits:**
- **No White Space**: Map always fills entire screen with calculated minimum scale
- **Content Protection**: 250px of natural padding prevents bottom sheet overlap  
- **Clean Architecture**: No manual offsets or complex positioning calculations
- **Responsive Behavior**: Works seamlessly across all device sizes
- **Natural Boundaries**: InteractiveViewer constraints work with padded coordinate system

### Performance Optimizations
- **Image Size Caching**: Prevents repeated asset loading
- **Efficient Marker Rendering**: Single-pass rendering with natural ordering
- **Zoom-Based Visibility**: Markers appear/disappear based on zoom level
- **Minimal Rebuilds**: Strategic `setState` usage for optimal performance
- **Optimized Scaling**: Single scale calculation prevents redundant computations
- **Smart Boundary Logic**: Efficient constraint checking with padded dimensions

### Animation System
- **Smooth Transitions**: Easing curves for natural movement
- **Scale Animations**: Selected markers with pulsing effects
- **Camera Movements**: Animated focusing on selected elements
- **Bidirectional Route Animation**: Forward and backward route path animations
- **Progress-Based Animation**: Route fills/unfills based on navigation direction
- **Curved Path Support**: Animations follow quadratic Bézier curve paths
- **Smart Animation Logic**: Detects direction and animates appropriately

### State Management
- **Local State**: `StatefulWidget` with `setState` for component-level state
- **Controller Pattern**: `TransformationController` for map interactions
- **Animation Controllers**: Dedicated controllers for different animation types
- **Cached Data**: Strategic caching to prevent redundant calculations

## 🔗 Backend Integration

### How It Works
The itinerary map is designed to receive cruise day data from a backend API and automatically generate the complete map experience:

#### **1. Backend Data Structure**
```json
{
  "cruise": {
    "name": "7-Day Caribbean Cruise",
    "days": [
      {
        "dayNumber": 1,
        "port": {
          "name": "Miami",
          "coordinates": [100, 50]
        }
      },
      {
        "dayNumber": 2,
        "type": "sea"
      },
      {
        "dayNumber": 3,
        "port": {
          "name": "Puerto Plata", 
          "coordinates": [660, 360]
        }
      }
    ]
  }
}
```

#### **2. Automatic Map Generation**
```dart
// Backend provides itinerary data
final itinerary = CruiseItinerary.fromApi(apiResponse);

// App automatically:
// ✅ Places day markers at exact coordinates
// ✅ Draws curved route paths connecting each day
// ✅ Enables day-by-day navigation with smooth animations
// ✅ Handles sea day interpolation
// ✅ Provides forward/backward route animations
// ✅ Updates when data changes

ItineraryMap(
  itinerary: itinerary, // That's it! Map is fully functional
)
```

#### **3. Coordinate Mapping Process**
1. **Backend provides**: Day locations as `[x, y]` pixels on map image
2. **App receives**: Itinerary data with embedded coordinates
3. **System calculates**: 
   - Day markers positioned at exact coordinates
   - Route paths connecting sequential days
   - Sea day positions interpolated between ports
4. **User sees**: Fully interactive map with navigation

#### **4. Dynamic Updates**
```dart
// Update itinerary data from backend
setState(() {
  widget.itinerary = newItineraryFromApi;
});
// ✅ Markers move to new positions
// ✅ Route paths redraw automatically with animations
// ✅ Navigation updates with smooth transitions
// ✅ All interactions work immediately
```

#### **5. Advanced Layout Management**
The system uses a **dual-viewport approach** to handle UI overlays without compromising map functionality:

```dart
// Problem: Bottom sheet covers map content
// Solution: Add natural padding to coordinate system

// 1. Extend image dimensions by bottom sheet height
child: SizedBox(
  width: imageSize.width,
  height: imageSize.height + 250.0, // Creates natural bottom padding
)

// 2. Update scale calculations for padded dimensions
double _getMinScale(Size viewportSize, Size imageSize) {
  final double paddedImageHeight = imageSize.height + 250.0;
  final double scaleToFillHeight = viewportSize.height / paddedImageHeight;
  return math.max(scaleToFillWidth, scaleToFillHeight);
}

// Result: 
// ✅ Map always fills entire viewport (no white space)
// ✅ Bottom 250px naturally protected from content overlap
// ✅ All interactions work seamlessly within extended coordinate system
```

### Integration Benefits
- **Rapid Development**: No manual map configuration needed
- **Content Management**: Non-technical staff can update coordinates via backend
- **Multi-Route Support**: Same code works for any cruise itinerary (Caribbean, Transatlantic, etc.)
- **Modular Data Architecture**: Each cruise type in separate data files for maintainability
- **Auto-Scrolling Navigation**: Day indicators automatically center on selected day
- **Real-Time Updates**: Push new coordinates, map updates instantly
- **Scalability**: Add new destinations without app updates
- **Layout Resilience**: UI overlays handled automatically without manual positioning
- **Cross-Platform Consistency**: Same layout behavior across all device sizes

## 🤖 AI Digest

### Quick Project Understanding
**Purpose**: Flutter demo showcasing three interactive map implementations, with **primary focus on backend-driven itinerary maps** that automatically generate from API data.

**Key Innovation**: **Backend-Driven Map System**
- Backend provides daily itinerary locations as `[x, y]` pixel coordinates
- App automatically positions markers, draws route paths, enables navigation
- Zero hardcoding - all positioning is data-driven and updates dynamically

**Key Components**:
- `InteractiveMap`: POI-based map with markers and filtering
- `MultiDeckShipMap`: Deck plans with polygon interactions  
- `ItineraryMap`: **Backend-driven** route map with automatic positioning

**Coordinate System**: Image-based `[x, y]` pixel coordinates designed for backend integration.
- Coordinates are pixel positions on map images (e.g., `[100, 50]`)
- Backend APIs provide coordinates, app displays immediately
- Single source of truth: `_getDayPosition(dayIndex)` controls all positioning

**Architecture**: Backend-driven positioning with unified coordinate system.
- All map elements (markers, routes, taps) use same position calculation
- `_generateRoutePositions()` creates paths from day coordinates
- Dynamic updates when backend data changes

**Recent Updates**: 
- **Data Architecture Refactoring**: Separated cruise itineraries into dedicated data files (`caribbean_cruise.dart`, `transatlantic_cruise.dart`)
- **Model Separation**: Moved `PortData` and `ItineraryDay` models into core `cruise_itinerary.dart` for clean architecture
- **Auto-Scrolling Day Indicators**: Implemented smooth auto-centering for day selection with ScrollController management
- **Multi-Itinerary Support**: Added Norwegian Pearl 15-night Transatlantic cruise alongside Caribbean route
- **Layout Management Revolution**: Implemented dual-viewport system that prevents white space while protecting content from bottom sheet overlap
- **Smart Padding Architecture**: Added 250px natural padding to image dimensions, eliminating manual offset calculations
- **InteractiveViewer Optimization**: Fixed scale configuration to guarantee viewport filling without white space
- **Draggable Bottom Sheet**: Enhanced with snap-to-position behavior and proper height constraints
- Advanced bidirectional route animation system with forward/backward navigation
- Extracted `CruiseRoutePainter` widget for modular route visualization
- Fixed visual consistency issues (unified gray colors, removed overlapping paths)
- Enhanced animation performance with dedicated animation controllers

**File Structure**: Three main modules (`interactive_map/`, `deck_plan/`, `itinerary/`) with models, pages, and widgets subdirectories.

**Entry Point**: `main.dart` → `MapSelectionScreen` → Individual map implementations.

**Dependencies**: Minimal Flutter setup with `vector_math` for transformations.

**Images**: `assets/images/map.jpg` (1.8MB Great Stirrup Cay), `caribbean_cruise_map.png` (20KB Caribbean route), `norwegian_pearl_transatlantic_map.png` (20KB Transatlantic route).

**Performance**: Cached image sizes, efficient rendering, zoom-based visibility, minimal rebuilds.

**State**: Local `StatefulWidget` state, `TransformationController` for map interactions, `AnimationController` for transitions.

**Backend Integration & Animation**: 
- JSON API provides itinerary days with embedded coordinates
- `CruiseItinerary.fromApi()` parses backend data
- Modular data architecture with separate files per cruise type (`CaribbeanCruiseData`, `TransatlanticCruiseData`)
- `_getDayPosition()` converts coordinates to screen positions
- `_generateRoutePositions()` creates curved route paths from day coordinates
- `CruiseRoutePainter` handles all route visualization and animations
- Auto-scrolling day indicators with smooth ScrollController animations
- Bidirectional route animations (forward fill, backward unfill)
- Automatic map generation with smooth navigation transitions
- **Advanced Layout Management**: Dual-viewport system with 250px natural padding prevents UI overlay conflicts
- **No White Space Guarantee**: Calculated minimum scale ensures map always fills entire viewport
- **Smart Boundary Logic**: Padded coordinate system maintains proper constraints and interactions

## 🤝 Contributing

### Development Guidelines
- Follow the established project structure
- Use descriptive commit messages with conventional format
- Maintain consistent code style (dart format)
- Add comprehensive documentation for new features
- Test on multiple screen sizes and orientations

### Code Style
- **Classes**: PascalCase
- **Variables/Functions**: camelCase  
- **Files/Directories**: snake_case
- **Constants**: UPPERCASE
- **Private members**: Leading underscore `_`

### Adding New Maps
1. Create new module directory under `lib/`
2. Follow existing structure: `models/`, `pages/`, `widgets/`
3. Implement coordinate system using image pixels
4. Add entry point in `main.dart`
5. Include appropriate assets in `assets/images/`

---

**Flutter Version**: ^3.7.2 | **Material Design**: 3 | **Latest**: Route Animations & Widget Extraction | **License**: Private
