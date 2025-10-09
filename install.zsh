#!/bin/zsh

PLUGIN_NAME="zshrc-of-jamen"
PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$PLUGIN_NAME"

# 检查目录是否不存在
echo "正在安装或更新 $PLUGIN_NAME 插件..."
if [ ! -d "$PLUGIN_DIR" ]; then
    echo "插件目录不存在，正在克隆仓库..."
    git clone https://gitee.com/cpiz/zshrc-of-jamen.git "$PLUGIN_DIR"
else
    echo "插件目录已存在，正在更新仓库..."
    git -C "$PLUGIN_DIR" pull
fi
echo "插件安装或更新完成。"

# 修改 .zshrc 文件，添加插件
sed_cmd='s/plugins=(git)/plugins=(git $PLUGIN_NAME)/'
echo "正在配置 .zshrc 文件以启用 $PLUGIN_NAME 插件..."
# 根据操作系统执行不同的 sed 命令
if [[ $(uname) == "Darwin" ]]; then
  # macOS (BSD sed)
  sed -i '' $sed_cmd $HOME/.zshrc
else
  # Linux (GNU sed) 或其他系统
  sed -i $sed_cmd $HOME/.zshrc
fi

echo "$PLUGIN_NAME 插件安装和配置完成！请新启动终端或运行 'source ~/.zshrc' 以应用更改。"
