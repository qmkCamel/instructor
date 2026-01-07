# 小组件文件结构

## 📁 项目文件结构

```
instructor/
├── instructor/                          # 主应用
│   ├── Assets.xcassets/
│   ├── ContentView.swift
│   ├── DataManager.swift                # ✏️ 已更新：使用共享数据
│   ├── SettingsView.swift               # ✨ 新增：设置页面
│   ├── instructorApp.swift
│   └── instructor.entitlements          # ✨ 新增：App Groups 权限
│
├── InstructorWidget/                    # ✨ Widget Extension（新增）
│   ├── InstructorWidget.swift           # 桌面小组件实现
│   ├── LockScreenWidget.swift           # 锁屏小组件实现
│   ├── InstructorWidgetBundle.swift     # Widget Bundle 入口
│   ├── Info.plist                       # Widget 配置
│   ├── InstructorWidget.entitlements    # App Groups 权限
│   └── Assets.xcassets/                 # Widget 资源文件
│       ├── Contents.json
│       ├── AccentColor.colorset/
│       ├── AppIcon.appiconset/
│       └── WidgetBackground.colorset/
│
├── Shared/                              # ✨ 共享代码（新增）
│   └── CardModel.swift                  # 主应用和小组件共享的数据模型
│
├── WIDGET_SETUP_GUIDE.md                # 📖 详细配置指南
└── WIDGET_FILE_STRUCTURE.md             # 📖 文件结构说明（本文件）
```

## 🎯 文件说明

### 主应用文件（instructor/）

#### ContentView.swift ✏️ 已更新
- 添加了 NavigationStack
- 添加了设置按钮（左上角齿轮图标）
- 支持打开设置页面

#### SettingsView.swift ✨ 新增
- 设置页面 UI
- 包含通用、外观、关于三个分组
- 模态视图展示

#### DataManager.swift ✏️ 已更新
- 使用 `SharedDataManager` 获取数据
- 支持数据更新和持久化
- 与小组件共享数据源

#### instructor.entitlements ✨ 新增
- 配置 App Groups: `group.com.edge.instructor`
- 允许主应用与小组件共享数据

### Widget Extension 文件（InstructorWidget/）

#### InstructorWidget.swift ✨ 核心文件
```swift
关键组件：
├── WidgetEntry              # 数据模型
├── Provider                 # Timeline 提供者
├── SmallWidgetView          # 小尺寸视图
├── MediumWidgetView         # 中等尺寸视图
├── LargeWidgetView          # 大尺寸视图
└── InstructorWidget         # Widget 配置
```

支持的小组件尺寸：
- 📱 systemSmall - 小尺寸（2x2）
- 📱 systemMedium - 中等尺寸（4x2）
- 📱 systemLarge - 大尺寸（4x4）

#### LockScreenWidget.swift ✨ 锁屏小组件
```swift
关键组件：
├── CircularLockScreenView      # 圆形视图
├── RectangularLockScreenView   # 矩形视图
├── InlineLockScreenView        # 内联视图
└── LockScreenWidget            # Widget 配置
```

支持的锁屏样式：
- 🔒 accessoryCircular - 圆形小组件
- 🔒 accessoryRectangular - 矩形小组件
- 🔒 accessoryInline - 内联文本小组件

**横屏支持**: 所有锁屏小组件自动适配横屏模式 ✅

#### InstructorWidgetBundle.swift ✨ 入口文件
- Widget Bundle 主入口
- 统一管理所有小组件
- 使用 `@main` 标记

#### Info.plist ✨ 配置文件
- Widget Extension 基本信息
- Extension Point 配置

#### InstructorWidget.entitlements ✨ 权限文件
- 配置 App Groups: `group.com.edge.instructor`
- 允许小组件访问共享数据

### 共享文件（Shared/）

#### CardModel.swift ✨ 数据模型
```swift
关键组件：
├── CardData               # 可编码的卡片数据模型
└── SharedDataManager      # 数据管理单例
    ├── getCards()         # 获取卡片列表
    ├── saveCards()        # 保存卡片数据
    └── getCurrentCard()   # 获取当前卡片
```

**重要**: 此文件必须同时添加到两个 target:
- ✅ instructor (主应用)
- ✅ InstructorWidget (小组件)

## 🔄 数据流

```
主应用 (instructor)
    ↓
SharedDataManager.shared
    ↓
UserDefaults(suiteName: "group.com.edge.instructor")
    ↑
    Provider (Timeline)
    ↑
小组件 (InstructorWidget)
```

## 📊 小组件更新策略

- **更新间隔**: 每小时自动轮换一次卡片内容
- **Timeline 策略**: `.atEnd` - 在所有条目显示完后重新生成
- **数据源**: 从共享的 UserDefaults 读取

## 🎨 视觉设计特点

### 桌面小组件
- 使用渐变背景 (`.gradient`)
- 圆角矩形 (20pt)
- 图标 + 文字组合
- 响应式布局

### 锁屏小组件
- 系统原生样式
- 简洁信息展示
- 符合 iOS 设计规范
- 自动适配浅色/深色模式

## 🚀 下一步操作

请查看 `WIDGET_SETUP_GUIDE.md` 文件，按照步骤在 Xcode 中完成 Widget Extension 的配置。

配置完成后，你将拥有：
- ✅ 3 种桌面小组件尺寸
- ✅ 3 种锁屏小组件样式
- ✅ 横屏和竖屏自动适配
- ✅ 主应用和小组件数据实时同步

