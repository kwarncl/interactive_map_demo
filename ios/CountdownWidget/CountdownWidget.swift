//
//  CountdownWidget.swift
//  CountdownWidget
//
//  Created by Khalid Warsame on 8/23/25.
//

import SwiftUI
import WidgetKit

// Data structure for cruise countdown
struct CruiseCountdownEntry: TimelineEntry {
    let date: Date
    let cruiseName: String
    let shipName: String
    let destination: String
    let departureDate: Date
    let daysRemaining: Int
    let hasData: Bool
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CruiseCountdownEntry {
        CruiseCountdownEntry(
            date: Date(),
            cruiseName: "Caribbean Cruise",
            shipName: "Norwegian Aqua",
            destination: "Miami to Caribbean",
            departureDate: Date().addingTimeInterval(15 * 24 * 60 * 60),
            daysRemaining: 15,
            hasData: true
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (CruiseCountdownEntry) -> Void) {
        let prefs = UserDefaults(suiteName: "group.com.example.interactiveMapDemo")

        let hasData = prefs?.bool(forKey: "has_data") ?? false

        if hasData {
            let cruiseName = prefs?.string(forKey: "cruise_name") ?? ""
            let shipName = prefs?.string(forKey: "ship_name") ?? ""
            let destination = prefs?.string(forKey: "destination") ?? ""
            let departureDateString = prefs?.string(forKey: "departure_date") ?? ""
            let daysRemaining = prefs?.integer(forKey: "days_remaining") ?? 0

            let dateFormatter = ISO8601DateFormatter()
            let departureDate = dateFormatter.date(from: departureDateString) ?? Date()

            let entry = CruiseCountdownEntry(
                date: Date(),
                cruiseName: cruiseName,
                shipName: shipName,
                destination: destination,
                departureDate: departureDate,
                daysRemaining: daysRemaining,
                hasData: true
            )
            completion(entry)
        } else {
            let entry = CruiseCountdownEntry(
                date: Date(),
                cruiseName: "",
                shipName: "",
                destination: "",
                departureDate: Date(),
                daysRemaining: 0,
                hasData: false
            )
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct CountdownWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        if entry.hasData {
            if family == .systemMedium {
                // Medium widget layout (2x4)
                HStack(spacing: 16) {
                    // Left side - Countdown
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "sailboat.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 20))
                            Spacer()
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(entry.daysRemaining)")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.blue)
                            Text("days to go")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                        }

                        Spacer()
                    }

                    // Right side - Cruise details
                    VStack(alignment: .leading, spacing: 8) {
                        Text(entry.cruiseName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .lineLimit(2)

                        Text(entry.shipName)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                            .lineLimit(1)

                        Text(entry.destination)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.secondary)
                            .lineLimit(2)

                        Spacer()

                        // Departure date
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                                .font(.system(size: 12))
                            Text(entry.departureDate, style: .date)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(16)
            } else {
                // Small widget layout (1x1)
                VStack(spacing: 8) {
                    // Header with ship icon
                    HStack {
                        Image(systemName: "sailboat.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 16))
                        Spacer()
                        Text("\(entry.daysRemaining)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.blue)
                    }

                    // Days remaining text
                    Text("days to go")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)

                    Spacer()

                    // Cruise name
                    Text(entry.cruiseName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)

                    // Ship name
                    Text(entry.shipName)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(1)

                    // Destination
                    Text(entry.destination)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .padding(12)
            }
        } else {
            // No data state - same for both sizes
            VStack(spacing: 8) {
                Image(systemName: "sailboat")
                    .foregroundColor(.secondary)
                    .font(.system(size: 24))

                Text("No Cruise Selected")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                Text("Tap to select a cruise")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(12)
        }
    }
}

struct CountdownWidget: Widget {
    let kind: String = "CountdownWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                CountdownWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CountdownWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Cruise Countdown")
        .description("Shows countdown to your next cruise departure.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
#Preview(as: .systemSmall) {
    CountdownWidget()
} timeline: {
    CruiseCountdownEntry(
        date: .now,
        cruiseName: "7-Day Caribbean Cruise",
        shipName: "Norwegian Aqua",
        destination: "Miami to Caribbean",
        departureDate: Date().addingTimeInterval(15 * 24 * 60 * 60),
        daysRemaining: 15,
        hasData: true
    )
}

#Preview(as: .systemMedium) {
    CountdownWidget()
} timeline: {
    CruiseCountdownEntry(
        date: .now,
        cruiseName: "7-Day Caribbean Cruise",
        shipName: "Norwegian Aqua",
        destination: "Miami to Caribbean Islands",
        departureDate: Date().addingTimeInterval(15 * 24 * 60 * 60),
        daysRemaining: 15,
        hasData: true
    )
}
