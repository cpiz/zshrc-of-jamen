# zshrc-of-jamen

这是一个`oh-my-zsh`的插件，用于统一个人常用的zsh配置和alias命令，方便集中管理、快速部署

## 安装方法

### 先一键安装`oh-my-zsh`

```bash
sh -c "$(curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh)"
```

### 安装本插件

```bash
git clone https://gitee.com/cpiz/zshrc-of-jamenzshrc-of-jamen.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zshrc-of-jamen
```

### 启用插件

编辑`~/.zshrc`，找到`plugins=(git)`，在括号中添加本插件名称`zshrc-of-jamen`，如下

```zsh
# 插件配置
plugins=(git zshrc-of-jamen)
```

或者

```zsh
plugins=(
    git

    # 其他插件
    zshrc-of-jamen
)
```

让配置生效

```zsh
source ~/.zshrc
```
