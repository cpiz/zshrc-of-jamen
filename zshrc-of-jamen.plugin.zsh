# 将个人常用的zsh配置提取为一个公共插件，方便快速同步到多个Linux环境，统一维护
# .oh-my-zsh/custom/plugins/zshrc-of-jamen/zshrc-of-jamen

plugin_name="zshrc-of-jamen"

# PROMPT前面增加主机名
PROMPT="%F{242}%n@%m":%f$PROMPT

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
alias sc="source ~/.zshrc"

# 修改插件配置
alias visrc2='vi ~/.oh-my-zsh/custom/plugins/$plugin_name/$plugin_name.plugin.zsh'
# 提交插件配置
alias savsrc2='cd ~/.oh-my-zsh/custom/plugins/$plugin_name && git add . && git commit -m "update $plugin_name" && git push && cd - && sc'
# 更新插件配置
alias upsrc2='cd ~/.oh-my-zsh/custom/plugins/$plugin_name && git pull && cd - && sc'

# host快捷
alias cathost="cat /etc/hosts"
alias vihost="sudo vi /etc/hosts"

# ~/.ssh快捷
alias cdssh="cd ~/.ssh"
alias catssh="cat ~/.ssh/config"
alias vissh="vi ~/.ssh/config"

# 在当前目录启动一个简易HTTP服务器
alias serve='python3 -m http.server 8000'

