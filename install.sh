!/bin/bash

PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zshrc-of-jamen"

# 检查目录是否不存在
if [ ! -d "$PLUGIN_DIR" ]; then
  git clone https://gitee.com/cpiz/zshrc-of-jamen.git "$PLUGIN_DIR"
fi

sed_cmd='s/plugins=(git)/plugins=(git zshrc-of-jamen)/'
# 根据操作系统执行不同的 sed 命令
if [[ $(uname) == "Darwin" ]]; then
  # macOS (BSD sed)
  sed -i '' $sed_cmd $HOME/.zshrc
else
  # Linux (GNU sed) 或其他系统
  sed -i $sed_cmd $HOME/.zshrc
fi

source $HOME/.zshrc
