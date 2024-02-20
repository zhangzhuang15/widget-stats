//
//  m_s.swift
//  m-s
//
//  Created by 张僮 on 2024/1/30.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        WidgetCenter.shared.reloadAllTimelines()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        var entries: [SimpleEntry] = []
        //let afterOneSecond = Calendar.current.date(byAdding: .second, value: 2, to: currentDate)!
        for i in 0...10 {
            let date = Calendar.current.date(byAdding: .second, value: i * 10, to: currentDate)!
            let entry = SimpleEntry(date: date, emoji: "😭")
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct m_sEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        // 在这里实现 CPU DISK MEMORY 的UI表现
        VStack {
            
            HStack {
                Text("Time:")
                Text(entry.date, format: Date.FormatStyle().hour(.twoDigits(amPM: .wide)).minute(.twoDigits).second(.twoDigits))
                //Text(entry.date, style: .time)
            }
            
            Rectangle()
                .frame(width: 12, height: 20)
                .background(.blue)
                .border(.blue, width: 2)

            Text("Emoj:")
            Text(entry.emoji)
        }
    }
}

struct m_s: Widget {
    let kind: String = "m_s"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                m_sEntryView(entry: entry)
                    .containerBackground(.fill.secondary, for: .widget)
            } else {
                m_sEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("M Widget")
        .description("This an example widget.")
    }
}
