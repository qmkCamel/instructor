//
//  LockScreenWidget.swift
//  InstructorWidget
//
//  Created by edge on 2025/12/26.
//

import WidgetKit
import SwiftUI

// MARK: - 锁屏圆形小组件
struct CircularLockScreenView: View {
    let entry: WidgetEntry
    
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            
            if entry.hasRecord, let action = entry.action {
                VStack(spacing: 1) {
                    // 行动状态图标
                    Image(systemName: actionIcon(for: action))
                        .font(.system(size: 14, weight: .medium))
                    
                    Text(action.shortName)
                        .font(.system(size: 8, weight: .medium))
                }
            } else {
                Image(systemName: "hand.point.up.left")
                    .font(.system(size: 16))
            }
        }
    }
    
    private func actionIcon(for action: SharedActionChoice) -> String {
        switch action {
        case .did: return "checkmark.circle"
        case .didNot: return "minus.circle"
        case .avoided: return "xmark.circle"
        }
    }
}

// MARK: - 锁屏矩形小组件
struct RectangularLockScreenView: View {
    let entry: WidgetEntry
    
    var body: some View {
        if entry.hasRecord {
            HStack(spacing: 8) {
                // 行动状态
                if let action = entry.action {
                    Image(systemName: actionIcon(for: action))
                        .font(.system(size: 14))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.quote)
                        .font(.system(size: 12, weight: .medium))
                        .lineLimit(1)
                    
                    if let action = entry.action {
                        Text(action.shortName)
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        } else {
            HStack(spacing: 8) {
                Image(systemName: "hand.point.up.left")
                    .font(.system(size: 14))
                
                Text("去抽一句，站直了")
                    .font(.system(size: 12))
            }
        }
    }
    
    private func actionIcon(for action: SharedActionChoice) -> String {
        switch action {
        case .did: return "checkmark.circle.fill"
        case .didNot: return "minus.circle.fill"
        case .avoided: return "xmark.circle.fill"
        }
    }
}

// MARK: - 锁屏内联小组件
struct InlineLockScreenView: View {
    let entry: WidgetEntry
    
    var body: some View {
        if entry.hasRecord, let action = entry.action {
            HStack(spacing: 4) {
                Text(action.shortName)
                Text("·")
                Text(entry.quote)
                    .lineLimit(1)
            }
            .font(.caption)
        } else {
            Text("去抽一句")
                .font(.caption)
        }
    }
}

// MARK: - 锁屏小组件配置
struct LockScreenWidget: Widget {
    let kind: String = "LockScreenWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LockScreenEntryView(entry: entry)
        }
        .configurationDisplayName("站直提醒")
        .description("在锁屏显示你的选择")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline
        ])
    }
}

struct LockScreenEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: WidgetEntry
    
    var body: some View {
        switch family {
        case .accessoryCircular:
            CircularLockScreenView(entry: entry)
        case .accessoryRectangular:
            RectangularLockScreenView(entry: entry)
        case .accessoryInline:
            InlineLockScreenView(entry: entry)
        default:
            CircularLockScreenView(entry: entry)
        }
    }
}

#Preview(as: .accessoryCircular) {
    LockScreenWidget()
} timeline: {
    WidgetEntry(date: .now, hasRecord: true, quote: "没有调查", source: "", action: .avoided, recordDate: "")
}

#Preview(as: .accessoryRectangular) {
    LockScreenWidget()
} timeline: {
    WidgetEntry(date: .now, hasRecord: true, quote: "没有调查，就没有发言权。", source: "", action: .did, recordDate: "")
}

#Preview(as: .accessoryInline) {
    LockScreenWidget()
} timeline: {
    WidgetEntry(date: .now, hasRecord: true, quote: "没有调查，就没有发言权。", source: "", action: .avoided, recordDate: "")
}
