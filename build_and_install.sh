#!/bin/bash

# 构建并安装 instructor 到 iPhone
# 用法: ./build_and_install.sh [device_id]

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCHEME="instructor"
CONFIGURATION="Debug"
BUILD_DIR="$PROJECT_DIR/build"
ARCHIVE_PATH="$BUILD_DIR/$SCHEME.xcarchive"
APP_PATH="$BUILD_DIR/$SCHEME.app"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

echo_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

echo_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查连接的设备
check_devices() {
    echo_info "检查已连接的设备..."
    
    DEVICES=$(xcrun devicectl list devices 2>/dev/null | grep -E "iPhone|iPad" || true)
    
    if [ -z "$DEVICES" ]; then
        echo_error "没有找到已连接的 iOS 设备"
        echo "请确保:"
        echo "  1. iPhone 已通过 USB 连接"
        echo "  2. 已信任此电脑"
        echo "  3. 设备已解锁"
        exit 1
    fi
    
    echo "$DEVICES"
}

# 获取设备 ID
get_device_id() {
    if [ -n "$1" ]; then
        DEVICE_ID="$1"
    else
        # 获取第一个连接的设备（将表格输出重定向到 /dev/null）
        xcrun devicectl list devices -j /tmp/devices.json >/dev/null 2>&1
        DEVICE_ID=$(python3 -c "import json; d=json.load(open('/tmp/devices.json')); devs=[x for x in d.get('result',{}).get('devices',[]) if x.get('connectionProperties',{}).get('transportType')=='wired']; print(devs[0]['identifier'] if devs else '')" 2>/dev/null || true)
        
        if [ -z "$DEVICE_ID" ]; then
            echo_error "无法获取设备 ID"
            exit 1
        fi
    fi
    
    echo_info "目标设备: $DEVICE_ID"
}

# 构建应用
build_app() {
    echo_info "开始构建 $SCHEME..."
    
    # 清理旧的构建
    rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"
    
    # 构建
    xcodebuild \
        -project "$PROJECT_DIR/instructor.xcodeproj" \
        -scheme "$SCHEME" \
        -configuration "$CONFIGURATION" \
        -destination "generic/platform=iOS" \
        -derivedDataPath "$BUILD_DIR/DerivedData" \
        -allowProvisioningUpdates \
        build \
        2>&1 | tee "$BUILD_DIR/build.log"
    
    # 查找生成的 .app
    APP_BUNDLE=$(find "$BUILD_DIR/DerivedData" -name "*.app" -type d | grep -v "\.dSYM" | head -1)
    
    if [ -z "$APP_BUNDLE" ] || [ ! -d "$APP_BUNDLE" ]; then
        echo_error "构建失败，未找到 .app 文件"
        echo "查看详细日志: $BUILD_DIR/build.log"
        exit 1
    fi
    
    echo_info "构建成功: $APP_BUNDLE"
    APP_PATH="$APP_BUNDLE"
}

# 安装到设备
install_app() {
    echo_info "正在安装到设备..."
    
    xcrun devicectl device install app \
        --device "$DEVICE_ID" \
        "$APP_PATH" \
        2>&1
    
    if [ $? -eq 0 ]; then
        echo_info "✅ 安装成功!"
    else
        echo_error "安装失败"
        exit 1
    fi
}

# 启动应用
launch_app() {
    echo_info "正在启动应用..."
    
    BUNDLE_ID="com.edge.instructor"
    
    xcrun devicectl device process launch \
        --device "$DEVICE_ID" \
        "$BUNDLE_ID" \
        2>&1 || echo_warn "启动应用失败，请手动打开"
}

# 主流程
main() {
    echo "========================================"
    echo "  Instructor 构建安装脚本"
    echo "========================================"
    echo ""
    
    cd "$PROJECT_DIR"
    
    check_devices
    get_device_id "$1"
    build_app
    install_app
    launch_app
    
    echo ""
    echo_info "🎉 全部完成!"
}

main "$@"
