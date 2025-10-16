# 将个人常用的zsh配置提取为一个公共插件，方便快速同步到多个Linux环境，统一维护
# .oh-my-zsh/custom/plugins/zshrc-of-jamen/zshrc-of-jamen

PLUGIN_NAME="zshrc-of-jamen"

# 设置系统默认编辑器为vi/vim
# 推荐的设置，确保良好兼容性
export EDITOR=vi
export VISUAL=vi

# 函数：获取阿里云实例名称（优先从元数据接口获取，失败则用主机名）
get_instance_name() {
    # 实例名称请求地址（元数据地址）
    local META_DATA_URL="http://100.100.100.200/latest/meta-data/instance/instance-name"

    # 超时时间（单位：秒，0.5秒即500毫秒）
    local TIMEOUT=0.1
    
    # 使用curl请求元数据：
    # -s：静默模式（不输出进度条等冗余信息）
    # -m $TIMEOUT：设置超时时间（秒）
    # -f：请求失败（如HTTP 4xx/5xx）时返回非0状态码，便于判断
    # -w "%{http_code}"：输出HTTP响应码（用于辅助判断请求是否成功）
    # 捕获curl的输出（实例名称）和HTTP响应码
    local curl_output
    local http_code
    curl_output=$(curl -s -m "$TIMEOUT" -f "$META_DATA_URL" -w "\n%{http_code}")
    http_code=$(echo "$curl_output" | tail -1)  # 提取最后一行的HTTP响应码
    local instance_name=$(echo "$curl_output" | head -1)  # 提取前面的实例名称内容

    # 判断请求是否成功：
    # 1. curl退出状态码为0（无超时、无网络错误）
    # 2. HTTP响应码为200（接口正常返回数据）
    # 3. 实例名称非空（排除接口返回空值的情况）
    if [ $? -eq 0 ] && [ "$http_code" -eq 200 ] && [ -n "$instance_name" ]; then
        echo "$instance_name"
    else
        # 备用实例名称（本机hostname）
        BACKUP_INSTANCE_NAME=$(hostname)
        # 分析失败原因（便于调试）
        # if [ $? -eq 28 ]; then
        #     echo "警告：元数据接口请求超时（超时时间：$TIMEOUT 秒），使用备用名称：$BACKUP_INSTANCE_NAME"
        # elif [ "$http_code" -ne 200 ]; then
        #     echo "警告：元数据接口返回异常（HTTP响应码：$http_code），使用备用名称：$BACKUP_INSTANCE_NAME"
        # else
        #     echo "警告：元数据接口返回空值，使用备用名称：$BACKUP_INSTANCE_NAME"
        # fi
        echo "$BACKUP_INSTANCE_NAME"
    fi
}

# 导出实例名称
export INSTANCE_NAME=$(get_instance_name)


# 设置命令行提示符，显示用户名和实例名称
# 要在.zshrc中禁用oh-my-zsh的默认主题才能生效
# 参考自默认主体~/.oh-my-zsh/themes/robbyrussell.zsh-theme
PROMPT="%(?:%{$fg_bold[green]%}%n@$INSTANCE_NAME %1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# ls快捷
alias lart="ls -lart"
alias lat="ls -lart"
alias ll="ls -lrt"
alias l="ls -lrt"

# 其他快捷
alias h="history"
alias tf="tail -f"
alias fd="find . -name"
alias size='du -c -h -d 1 | sort -h'

# ~/.zshrc快捷
alias catsrc="cat ~/.zsrhc"
alias visrc="vi ~/.zshrc"
alias vimrc="vi ~/.vimrc"
alias sc="source ~/.zshrc"

alias cdsrc2="cd ~/.oh-my-zsh/custom/plugins/$PLUGIN_NAME"
# 修改插件配置
alias visrc2='vi ~/.oh-my-zsh/custom/plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh'
# 提交插件配置
alias savsrc2='cd ~/.oh-my-zsh/custom/plugins/$PLUGIN_NAME && git add . && git commit -m "update $PLUGIN_NAME" && git push && cd - && sc'
# 更新插件配置
alias upsrc2='cd ~/.oh-my-zsh/custom/plugins/$PLUGIN_NAME && git pull && cd - && sc'

# host快捷
alias cathost="cat /etc/hosts"
alias vihost="sudo vi /etc/hosts"

# ~/.ssh快捷
alias cdssh="cd ~/.ssh"
alias catssh="cat ~/.ssh/config"
alias vissh="vi ~/.ssh/config"

# 在当前目录启动一个简易HTTP服务器
alias serve='python3 -m http.server 8000'

# 快捷文本搜索函数
sea() {
  # 同时排除.git和node_modules目录，使用-print0确保特殊字符正确处理
  find . \( -type d -name .git -o -type d -name node_modules \) -prune -o \
  -type f -print0 |
  # 使用--max-args=1限制每次传递一个文件给grep，避免参数过长
  xargs -0 -n 1 grep --color=auto -- "$1" |
  # 过滤掉长度超过500字符的行
  awk 'length($0) <= 500'
}

