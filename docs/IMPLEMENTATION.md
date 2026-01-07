# 产品实现说明

**"当我犹豫、退缩、想逃的时候，用一句毛选逼我站直的工具。"**

---

## 📱 核心流程

```
首页 → 选择处境 → 语录展示 → 行动确认 → 记录 → 退出
```

| 步骤 | 说明 |
|------|------|
| 1. 首页 | "给我一句 现在能站住的话" [开始] |
| 2. 选择处境 | 犹豫 / 退缩 / 硬撑 / 被动挨打 |
| 3. 语录展示 | 冷处理，不解释，不煽情 |
| 4. 行动确认 | 照做了 / 没照做 / 逃避了 |
| 5. 完成 | "已记录。去做你的事。" 2秒后退出 |

---

## 📁 文件结构

```
instructor/
├── instructorApp.swift              # App 入口
├── Models/QuoteModel.swift          # 数据模型
├── Services/QuoteDataManager.swift  # 数据管理
└── Views/
    ├── HomeView.swift               # 首页
    ├── SituationSelectionView.swift # 选择处境
    ├── QuoteDisplayView.swift       # 语录展示
    ├── ActionConfirmationView.swift # 行动确认
    ├── CompletionView.swift         # 完成页
    ├── MyRecordsView.swift          # 我的记录
    ├── QuotePoolView.swift          # 语录池
    └── AppSettingsView.swift        # 设置

Shared/
└── SharedModels.swift               # Widget 共享数据

InstructorWidget/
├── InstructorWidget.swift           # 桌面小组件
├── LockScreenWidget.swift           # 锁屏小组件
└── InstructorWidgetBundle.swift     # Widget 入口
```

---

## 📊 数据模型

| 模型 | 说明 |
|------|------|
| `Situation` | 4种处境：犹豫/退缩/硬撑/被动挨打 |
| `Quote` | 语录：内容 + 出处 + 处境 |
| `ActionChoice` | 3种选择：照做了/没照做/逃避了 |
| `QuoteRecord` | 记录：日期 + 处境 + 语录 + 行动 |

---

## 📚 语录库（20条）

| 处境 | 示例 |
|------|------|
| 犹豫 | "没有调查，就没有发言权。" |
| 退缩 | "革命不是请客吃饭..." |
| 硬撑 | "星星之火，可以燎原。" |
| 被动 | "敌进我退，敌驻我扰，敌疲我打，敌退我追。" |

---

## ✅ 设计原则

| 原则 | 实现 |
|------|------|
| 极简 | 无logo，无多余文字 |
| 冷处理 | 不煽情，不解释，不美化 |
| 无社交 | 无登录，无云端，无分享 |
| 本地化 | UserDefaults 存储 |
| 防沉迷 | 完成后 2 秒退出 |

---

## 🚀 运行

```bash
open instructor.xcodeproj
# 选择 instructor target → 运行
```

---

**站直了，去做你的事。**

