#!/bin/zsh

# 统一插件配置
declare -A PLUGINS=(
    ["zshrc-of-jamen"]="https://gitee.com/cpiz/zshrc-of-jamen.git"
    ["zsh-syntax-highlighting"]="https://gitee.com/mirrors/zsh-syntax-highlighting.git"
    ["zsh-autosuggestions"]="https://gitee.com/mirrors/zsh-autosuggestions.git"
)

# 需要在.zshrc中启用的插件列表（按顺序）
PLUGIN_ORDER=("z" "zsh-autosuggestions" "zsh-syntax-highlighting" "zshrc-of-jamen")

# 基础配置
PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
ZSHRC_FILE="$HOME/.zshrc"

# 安装或更新单个插件
install_or_update_plugin() {
    local plugin_name="$1"
    local git_url="$2"
    local plugin_path="$PLUGIN_DIR/$plugin_name"

    echo "正在处理插件: $plugin_name"

    if [ ! -d "$plugin_path" ]; then
        echo "  插件目录不存在，正在克隆仓库..."
        git clone "$git_url" "$plugin_path"
        if [ $? -eq 0 ]; then
            echo "  ✓ $plugin_name 克隆成功"
        else
            echo "  ✗ $plugin_name 克隆失败"
            return 1
        fi
    else
        echo "  插件目录已存在，正在更新仓库..."
        git -C "$plugin_path" pull
        if [ $? -eq 0 ]; then
            echo "  ✓ $plugin_name 更新成功"
        else
            echo "  ✗ $plugin_name 更新失败"
            return 1
        fi
    fi
}

# 检查插件是否已在.zshrc中启用
is_plugin_enabled() {
    local plugin="$1"
    if [ -f "$ZSHRC_FILE" ]; then
        grep -q "\b$plugin\b" "$ZSHRC_FILE" 2>/dev/null
    else
        return 1
    fi
}

# 添加插件到.zshrc
add_plugin_to_zshrc() {
    local plugin="$1"

    if is_plugin_enabled "$plugin"; then
        echo "  ✓ $plugin 已在.zshrc中启用"
        return 0
    fi

    echo "  正在将 $plugin 添加到.zshrc..."

    # 使用awk处理，逻辑更清晰
    awk -v plugin="$plugin" '
        /^[[:space:]]*plugins=[[:space:]]*\(.*\)[[:space:]]*$/ {
            if ($0 ~ "[( ]" plugin "[ )]") {
                print $0
            } else {
                sub(/\)/, " " plugin ")")
                print $0
            }
            next
        }
        { print }
    ' "$ZSHRC_FILE" > "$ZSHRC_FILE.tmp" && mv "$ZSHRC_FILE.tmp" "$ZSHRC_FILE"

    if [ $? -eq 0 ]; then
        echo "  ✓ $plugin 已添加到.zshrc"
        return 0
    else
        echo "  ✗ 添加 $plugin 到.zshrc失败"
        return 1
    fi
}

# 主安装流程
main() {
    echo "开始安装 Oh My Zsh 插件..."
    echo "插件目录: $PLUGIN_DIR"
    echo "配置文件: $ZSHRC_FILE"
    echo ""

    # 检查插件目录
    if [ ! -d "$PLUGIN_DIR" ]; then
        echo "创建插件目录: $PLUGIN_DIR"
        mkdir -p "$PLUGIN_DIR"
    fi

    # 备份.zshrc文件
    if [ -f "$ZSHRC_FILE" ]; then
        cp "$ZSHRC_FILE" "$ZSHRC_FILE.backup.$(date +%Y%m%d_%H%M%S)"
        echo "已备份 .zshrc 文件"
    fi

    echo ""
    echo "=== 安装/更新插件 ==="

    # 逐个安装或更新插件
    local failed_plugins=()
    for plugin_name git_url in ${(kv)PLUGINS}; do
        install_or_update_plugin "$plugin_name" "$git_url"
        if [ $? -ne 0 ]; then
            failed_plugins+=("$plugin_name")
        fi
    done

    echo ""
    echo "=== 配置 .zshrc ==="

    # 添加插件到.zshrc
    local config_failed_plugins=()
    for plugin_name in "${PLUGIN_ORDER[@]}"; do
        # z 插件是 Oh My Zsh 内置的，不需要安装目录
        if [ "$plugin_name" = "z" ]; then
            add_plugin_to_zshrc "$plugin_name"
            if [ $? -ne 0 ]; then
                config_failed_plugins+=("$plugin_name")
            fi
        # 检查插件是否已经安装
        elif [ -d "$PLUGIN_DIR/$plugin_name" ]; then
            add_plugin_to_zshrc "$plugin_name"
            if [ $? -ne 0 ]; then
                config_failed_plugins+=("$plugin_name")
            fi
        else
            echo "  ⚠ 跳过 $plugin_name（插件未安装）"
        fi
    done

    echo ""
    echo "=== 安装完成 ==="

    if [ ${#failed_plugins[@]} -eq 0 ] && [ ${#config_failed_plugins[@]} -eq 0 ]; then
        echo "✓ 所有插件安装和配置完成！"
        echo ""
        echo "请新启动终端或运行以下命令以应用更改："
        echo "  source ~/.zshrc"
    else
        echo "⚠ 安装过程中遇到一些问题："
        [ ${#failed_plugins[@]} -gt 0 ] && echo "  安装失败的插件: ${failed_plugins[*]}"
        [ ${#config_failed_plugins[@]} -gt 0 ] && echo "  配置失败的插件: ${config_failed_plugins[*]}"
        echo ""
        echo "请检查错误信息并手动处理失败的插件。"
    fi
}

# 运行主程序
main
