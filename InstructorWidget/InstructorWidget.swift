//
//  InstructorWidget.swift
//  InstructorWidget
//
//  Created by edge on 2025/12/26.
//

import WidgetKit
import SwiftUI

// MARK: - Widget Entry
struct WidgetEntry: TimelineEntry {
    let date: Date
    let hasRecord: Bool
    let quote: String
    let source: String
    let action: SharedActionChoice?
    let recordDate: String
}

// MARK: - Timeline Provider
struct Provider: TimelineProvider {
    private let dataManager = SharedDataManager.shared
    
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(
            date: Date(),
            hasRecord: true,
            quote: "没有调查，就没有发言权。",
            source: "《反对本本主义》",
            action: .did,
            recordDate: "01.07"
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> Void) {
        let entry = createEntry()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        let entry = createEntry()
        // 每15分钟刷新一次
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
    
    private func createEntry() -> WidgetEntry {
        if let record = dataManager.getLastRecord() {
            return WidgetEntry(
                date: Date(),
                hasRecord: true,
                quote: record.quote.content,
                source: record.quote.source,
                action: record.action,
                recordDate: record.dateString
            )
        } else {
            return WidgetEntry(
                date: Date(),
                hasRecord: false,
                quote: "去抽一句",
                source: "",
                action: nil,
                recordDate: ""
            )
        }
    }
}

// MARK: - 桌面小组件视图 - 小尺寸
struct SmallWidgetView: View {
    let entry: WidgetEntry
    
    var body: some View {
        if entry.hasRecord {
            VStack(alignment: .leading, spacing: 6) {
                // 行动状态
                if let action = entry.action {
                    Text(action.shortName)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(action.color)
                }
                
                Spacer()
                
                // 语录
                Text(entry.quote)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.primary)
                    .lineLimit(4)
                    .minimumScaleFactor(0.8)
            }
            .padding(14)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        } else {
            VStack(spacing: 8) {
                Image(systemName: "hand.point.up.left")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Text("去抽一句")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - 桌面小组件视图 - 中尺寸
struct MediumWidgetView: View {
    let entry: WidgetEntry
    
    var body: some View {
        if entry.hasRecord {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    // 行动状态 + 日期
                    if let action = entry.action {
                        HStack(spacing: 8) {
                            Text(action.shortName)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(action.color)
                            
                            Text(entry.recordDate)
                                .font(.system(size: 11))
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    // 语录
                    Text(entry.quote)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.primary)
                        .lineLimit(3)
                    
                    Spacer()
                    
                    // 出处
                    Text("——《\(entry.source)》")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        } else {
            HStack(spacing: 12) {
                Image(systemName: "hand.point.up.left")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Text("去抽一句，站直了")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - 桌面小组件视图 - 大尺寸
struct LargeWidgetView: View {
    let entry: WidgetEntry
    
    var body: some View {
        if entry.hasRecord {
            VStack(alignment: .leading, spacing: 16) {
                // 行动状态 + 日期
                if let action = entry.action {
                    HStack(spacing: 12) {
                        Text(action.shortName)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(action.color)
                        
                        Text(entry.recordDate)
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
                // 语录
                Text(entry.quote)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(.primary)
                    .lineSpacing(6)
                
                // 出处
                Text("——《\(entry.source)》")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        } else {
            VStack(spacing: 16) {
                Image(systemName: "hand.point.up.left")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                Text("去抽一句")
                    .font(.system(size: 18))
                    .foregroundStyle(.secondary)
                Text("站直了")
                    .font(.system(size: 15))
                    .foregroundStyle(.tertiary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - Widget Configuration
struct InstructorWidget: Widget {
    let kind: String = "InstructorWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("站直")
        .description("显示最近一次抽取的语录和你的选择")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct WidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: WidgetEntry
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

#Preview(as: .systemSmall) {
    InstructorWidget()
} timeline: {
    WidgetEntry(date: .now, hasRecord: true, quote: "没有调查，就没有发言权。", source: "反对本本主义", action: .avoided, recordDate: "01.07")
    WidgetEntry(date: .now, hasRecord: false, quote: "去抽一句", source: "", action: nil, recordDate: "")
}

#Preview(as: .systemMedium) {
    InstructorWidget()
} timeline: {
    WidgetEntry(date: .now, hasRecord: true, quote: "没有调查，就没有发言权。", source: "反对本本主义", action: .did, recordDate: "01.07")
}
