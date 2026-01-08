# 产品实现说明

**"当我犹豫、退缩、想逃的时候，用一句毛选逼我站直的工具。"**

---

## 📱 核心流程（单页状态机）

```
idle（空闲） → selectingSituation（选择处境） → showingQuote（展示语录） → selectingAction（选择行动） → completed（完成） → 自动返回 idle
```

| 阶段 | 说明 |
|------|------|
| 1. idle | 首页显示"给我一句 现在能站住的话"，同时展示最近一次记录 |
| 2. selectingSituation | 选择处境：犹豫 / 退缩 / 硬撑 / 被动挨打 |
| 3. showingQuote | 冷处理展示语录，不解释，不煽情 |
| 4. selectingAction | 选择行动：照做了 / 没照做 / 逃避了 |
| 5. completed | "已记录。去做你的事。" 2秒后自动返回 idle |

---

## 🏗 架构设计

### 单页面状态流程

所有核心交互都在 `HomeView.swift` 中完成，使用 `FlowPhase` 枚举管理状态：

```swift
enum FlowPhase: Equatable {
    case idle                           // 初始状态
    case selectingSituation             // 选择处境
    case showingQuote(Situation)        // 展示语录
    case selectingAction(Quote, Situation)  // 选择行动
    case completed                      // 完成
}
```

### 触觉反馈

- 开始按钮：中等力度反馈（impactMedium）
- 选项切换：选择反馈（selectionFeedback）
- 记录完成：成功通知（notificationFeedback）

---

## 📁 文件结构

```
instructor/
├── instructorApp.swift              # App 入口
├── Models/
│   ├── QuoteModel.swift             # 数据模型（Situation, Quote, ActionChoice, QuoteRecord）
│   └── SharedModels.swift           # Widget 共享模型（副本，与 Shared/ 同步）
├── Services/
│   └── QuoteDataManager.swift       # 数据管理器（协议 + 实现）
└── Views/
    ├── HomeView.swift               # 首页（单页流程核心）
    ├── MyRecordsView.swift          # 我的记录（Sheet 模式）
    ├── QuotePoolView.swift          # 语录池（Sheet 模式）
    └── AppSettingsView.swift        # 设置页面

Shared/
└── SharedModels.swift               # Widget 共享数据模型

InstructorWidget/
├── InstructorWidget.swift           # 桌面小组件（小/中/大）
├── LockScreenWidget.swift           # 锁屏小组件（圆形/矩形/内联）
└── InstructorWidgetBundle.swift     # Widget 入口

Archived/                            # 已归档的旧版多页面实现
├── SituationSelectionView.swift
├── QuoteDisplayView.swift
├── ActionConfirmationView.swift
└── CompletionView.swift
```

---

## 📊 数据模型

| 模型 | 说明 |
|------|------|
| `Situation` | 4种处境：犹豫/退缩/硬撑/被动挨打（含 emoji） |
| `Quote` | 语录：内容 + 出处 + 所属处境 |
| `ActionChoice` | 3种选择：照做了/没照做/逃避了（含 emoji） |
| `QuoteRecord` | 记录：日期 + 处境 + 语录 + 行动 |

### 共享模型（Widget 专用）

| 模型 | 说明 |
|------|------|
| `SharedSituation` | 处境（简化版，含颜色） |
| `SharedActionChoice` | 行动选择（含颜色标识） |
| `SharedQuote` | 语录（简化版） |
| `SharedLastRecord` | 最近记录（供 Widget 显示） |
| `SharedDataManager` | App Group 数据共享管理器 |

---

## 📚 语录库（20条）

| 处境 | 数量 | 示例 |
|------|------|------|
| 🤔 犹豫 | 5条 | "没有调查，就没有发言权。" |
| 😰 退缩 | 5条 | "革命不是请客吃饭..." |
| 💪 硬撑 | 5条 | "星星之火，可以燎原。" |
| 😔 被动 | 5条 | "敌进我退，敌驻我扰，敌疲我打，敌退我追。" |

---

## 🎨 视觉设计

### 配色主题

```swift
// 温暖渐变背景
LinearGradient(
    colors: [
        Color(red: 0.98, green: 0.97, blue: 0.95),  // 温暖的奶油白
        Color(red: 0.96, green: 0.94, blue: 0.91)   // 淡米色
    ],
    startPoint: .top,
    endPoint: .bottom
)

// 文字色阶
themeTextPrimary: Color(red: 0.20, green: 0.20, blue: 0.18)   // 主文字
themeTextSecondary: Color(red: 0.45, green: 0.43, blue: 0.40) // 次要文字
themeTextTertiary: Color(red: 0.60, green: 0.58, blue: 0.55)  // 辅助文字

// 按钮色
buttonColor: Color(red: 0.35, green: 0.35, blue: 0.32)        // 温暖的深灰褐色
```

### 动画过渡

- 阶段切换：0.4s ease-in-out
- 选项反馈：0.3s ease-in-out
- 使用 asymmetric transition 实现进入/退出不同动画

---

## 📲 页面导航

| 入口 | 方式 | 目标页面 |
|------|------|----------|
| 首页左上角 📖 | Sheet | 语录池 |
| 首页右上角 🕐 | Sheet | 我的记录 |

---

## ✅ 设计原则

| 原则 | 实现 |
|------|------|
| 极简 | 无 logo，单页流程，无多余文字 |
| 冷处理 | 不煽情，不解释，不美化 |
| 无社交 | 无登录，无云端，无分享 |
| 本地化 | UserDefaults 存储记录 |
| 防沉迷 | 完成后 2 秒自动返回首页 |
| 触觉反馈 | 关键操作提供振动反馈 |

---

## 🔧 数据存储

| 数据 | 存储方式 | Key |
|------|----------|-----|
| 用户记录 | UserDefaults.standard | "quoteRecords" |
| Widget数据 | App Group UserDefaults | "lastQuoteRecord" |

App Group ID: `group.com.edge.instructor`

---

## 🚀 运行

```bash
open instructor.xcodeproj
# 选择 instructor target → 运行
```

---

**站直了，去做你的事。**
