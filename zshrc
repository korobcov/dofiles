# загружаем дефолтный профиль оболочки 
source /etc/profile
# 
# Настраиваем безполезные клавиши плюс бекспей 
# 
# алиас ибо на некоторых машинах нихера чё-то без алиаса на загружается 
#alias zkbd='zsh /usr/share/zsh/functions/Misc/zkbd'
#autoload zkbd
#[[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
#[[ ! -f ~/.zkbd/$TERM-$VENDOR-$OSTYPE ]] && zkbd 
setopt clobber


bindkey "\e[1~" beginning-of-line # Home
bindkey "\e[4~" end-of-line # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "\e[2~" quoted-insert # Ins
bindkey "\e[3~" delete-char # Del
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[Z" reverse-menu-complete # Shift+Tab
# for rxvt
bindkey "\e[7~" beginning-of-line # Home
bindkey "\e[8~" end-of-line # End
# for non RH/Debian xterm, can't hurt for RH/Debian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

# в новых версях пути поменялись, после вызова zkbd пишет новые, 
# просто у мну старые файлы до сих пор валяются и работают 
#source  ~/.zkbd/$TERM-$VENDOR-$OSTYPE
[[ -n ${key[Home]}    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n ${key[End]}     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n ${key[Insert]}  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n ${key[Delete]}  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n ${key[Up]}      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n ${key[Down]}    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n ${key[Left]}    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n ${key[Right]}   ]]  && bindkey  "${key[Right]}"   forward-char
[[ -n ${key[Backspace]}   ]]  && bindkey  "${key[Backspace]}"   backward-delete-char

# PageUp PageDown(в арче лоханулись, забыли прописать) 
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history

# 
# тут немного всякой хери, смысл которой я сам не особо понимаю 
# 
# Use hard limits, except for a smaller stack and no core dumps 

unlimit
limit stack 8192
limit core 0
limit -s

# Установка атрибутов доступа для вновь создаваемых файлов 
umask 022

# Shell functions 
setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }  # csh compatibility
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }

# Autoload zsh modules when they are referenced 
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile

# Completions 
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~''*?.old' '*?.pro'
zstyle ':completion:*:functions' ignored-patterns '_*'

# менюшку нам для астокомплита 
zstyle ':completion:*' menu yes select

# 
# различные опцие шела 
# 
# Позволяем разворачивать сокращенный ввод, к примеру cd /u/sh в /usr/share 
autoload -U compinit && compinit

# файл истории команд 
HISTFILE=~/.zhistory

# Число команд, сохраняемых в HISTFILE 
SAVEHIST=10000

# Дополнение файла истории 
setopt  APPEND_HISTORY

# Игнорировать все повторения команд 
setopt  HIST_IGNORE_ALL_DUPS

# Игнорировать лишние пробелы 
setopt  HIST_IGNORE_SPACE

# не пищать при дополнении или ошибках 
setopt NO_BEEP

# если набрали путь к директории без комманды CD, то перейти 
setopt AUTO_CD

# исправлять неверно набранные комманды 
setopt CORRECT_ALL

# zsh будет обращаться с пробелами так же, как и bash 
setopt SH_WORD_SPLIT

# последние комманды в начале файла и не хранить дубликаты 
setopt histexpiredupsfirst histfindnodups

# ещё всякая херь про истоию 
setopt histignoredups histnostore histverify histignorespace extended_history  share_history

# Установка и снятие различных опций шелла 
setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent noclobber
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash

# Не считать Control+D за выход из оболочки 
#setopt  IGNORE_EOF

# автоматическое удаление одинакового из этого массива 
typeset -U path cdpath fpath manpath

# загружаем список цветов 
autoload colors && colors

# 
# Установка PROMT 
# 
# левый 
PROMPT="%{$fg_bold[grey]%}>>%{$reset_color%}"

# когда всё гуд хороший смайлик, когда ошибка то грусный, ну и цветные ясен фиг 
RPROMPT="%{$fg_bold[grey]%}%~/ %{$reset_color%}% %(?,%{$fg[green]%}:%)%{$reset_color%},%{$fg[red]%}:(%{$reset_color%}"

# вопрос на автокоррекцию 
SPROMPT='zsh: Заменить '\''%R'\'' на '\''%r'\'' ? [Yes/No/Abort/Edit] '

# симпотное добавления для kill 
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=$color[cyan]=$color[red]"

# заголовки и прочее. 

precmd() {
	 [[ -t 1 ]] || return
	case $TERM in
	*xterm*|rxvt|(dt|k|E|a)term*) print -Pn "\e]0;[%~] %m\a"	;;
	screen(-bce|.linux)) print -Pn "\ek[%~]\e\" && print -Pn "\e]0;[%~] %m (screen)\a" ;;  #заголовок для скрина
	esac
}
preexec() {
	[[ -t 1 ]] || return
	case $TERM in
	*xterm*|rxvt|(dt|k|E|a)term*) print -Pn "\e]0;<$1> [%~] %m\a" ;;
	screen(-bce|.linux)) print -Pn "\ek<$1> [%~]\e\" && print -Pn "\e]0;<$1> [%~] %m (screen)\a" ;; #заголовок для скрина
	esac
}
typeset -g -A key

# 
# экранируем спецсимволы в url, например &, ?, ~ и так далее 
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# 
# мои хоткеи 
# 
# дополнение по истории, ^X^Z включить ^Z выключить 
autoload -U predict-on
zle -N predict-on
zle -N predict-off
bindkey -M emacs "^X^Z" predict-on
bindkey -M emacs "^Z" predict-off

# peжuм нaвuгaцuu в cтuлe emacs 
bindkey -e

# режим редактирования команды, вызывает для этого то что в $EDITOR 
autoload -U edit-command-line

# Вызов редактора для редактирования строки ввода (хоткей в стиле emacs) 
# bindkey -M vicmd v edit-command-line для командного режима vi 
zle -N  edit-command-line
bindkey -M emacs "^X^E" edit-command-line

#завершить слово команду 
bindkey -M emacs "^N" complete-word

#вызов диалога удаления файлов в папке 
function dialogrun; { rm -rf $(dialog --separate-output --checklist file 100 100 100 $(for l in $(ls -A); do echo "$l" "$(test -d $l && echo "dir" || echo "file")" 0; done) --stdout); clear  }
zle -N dialogrun
bindkey -M emacs "^X^O" dialogrun

# куда же мы без калькулятора 
autoload -U zcalc

# 
# мои функции 
# 
ccd() { cd && ls}

# создать директорию и перейти в нее 
mcd(){ mkdir $1; cd $1 }

# если текущая директория пустая, то удалить ее и перейти в родительскую директорию 
rcd(){ local P="`pwd`"; cd .. && rmdir "$P" || cd "$P"; }

# быстрое переименование 
name() {
    name=$1
    vared -c -p 'rename to: ' name
    command mv $1 $name
}

# распаковка архива 
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1        ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1       ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1     ;;
            *.tar)       tar xf $1        ;;
            *.tbz2)      tar xjf $1      ;;
            *.tgz)       tar xzf $1       ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1    ;;
            *)           echo "я не в курсе как распаковать '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# упаковка в архив 
pk () {
    if [ $1 ] ; then
        case $1 in
            tbz)   	tar cjvf $2.tar.bz2 $2      ;;
            tgz)   	tar czvf $2.tar.gz  $2   	;;
            tar)  	tar cpvf $2.tar  $2       ;;
			bz2)	bzip $2 ;;
            gz)		gzip -c -9 -n $2 > $2.gz ;;
			zip)   	zip -r $2.zip $2   ;;
            7z)    	7z a $2.7z $2    ;;
            *)     	echo "'$1' cannot be packed via pk()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# мой cd 
cdpath=( . ~ /mnt/MLIVE )

# mp3 в нормальную кодировку 
mp32utf() { find -iname '*.mp3' -print0 | xargs -0 mid3iconv -eCP1251 --remove-v1 }

# конвертируем всякую дурь 
mpg2flv() { ffmpeg -i $1 -ar 22050 -ab 32 -f flv -s 320x240 `echo $1 | awk -F . '{print $1}'`.flv }
flv2xvid() { mencoder "$1" -vf scale=320:240  -ovc xvid -xvidencopts bitrate=250:autoaspect -vf pp=lb -oac mp3lame  -lameopts fast:preset=standard -o  "./basename $1.avi" }
flv2divx() { mencoder "$1" --vf scale=320:240  -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=250:mbd=2:v4mv:autoaspect -vf pp=lb -oac mp3lame  -lameopts fast:preset=standard -o  "./basename $1.avi" }

# top по имени процесса, правда только по полному 
pidtop() {top -p `pidof $@ | tr ' ' ','`}

# простой калькулятор 
calc() {echo "${1}"|bc -l;}

# мой айпишник 
myip() {lynx --source http://www.formyip.com/ |grep The | awk {'print $5'}}

# великий рандом для перемешивания строк в файле 
rand() { awk '{print rand()"\t"$0}'|sort|awk -F'\t' '{print $2}'  }

# копипаст в консоли 
ccopy(){ cp $1 /tmp/ccopy.$1; }
alias cpaste="ls /tmp/ccopy.* | sed 's|/tmp/ccopy.||' | xargs -I % mv /tmp/ccopy.% ./%"

# 
# переменные окружения и прочая чушь 
# 
# перенаправляем
READNULLCMD=${PAGER}

#оформим подсветку в grep 
export GREP_COLOR="1;33"
#тут всё и так ясно
export MANPATH="/usr/share/man/ru:/usr/man:/usr/share/man:/usr/local/man:/usr/X11R6/man:/opt/qt/doc"
# если стоит most то заюзаем в качестве $PAGER 
[[ -x $(whence -p most) ]] && export PAGER=$(whence -p most)

# XCompose
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim 

# системные переменные 
export EDITOR=nano
export BROWSER=chromium
#export PATH="$PATH:~/soft/bin/"
export OOO_FORCE_DESKTOP=gnom=
export LESSCHARSET=UTF-8
export LS_COLORS='no=00;37:fi=00;37:di=01;36:ln=04;36:pi=33:so=01;35:do=01;35:bd=33;01:cd=33;01:or=31;01:su=37:sg=30:tw=30:ow=34:st=37:ex=01;31:*.cmd=01;31:*.exe=01;31:*.com=01;31:*.btm=01;31:*.sh=01;31:*.run=01;31:*.tar=33:*.tgz=33:*.arj=33:*.taz=33:*.lzh=33:*.zip=33:*.z=33:*.Z=33:*.gz=33:*.bz2=33:*.deb=33:*.rpm=33:*.jar=33:*.rar=33:*.jpg=32:*.jpeg=32:*.gif=32:*.bmp=32:*.pbm=32:*.pgm=32:*.ppm=32:*.tga=32:*.xbm=32:*.xpm=32:*.tif=32:*.tiff=32:*.png=32:*.mov=34:*.mpg=34:*.mpeg=34:*.avi=34:*.fli=34:*.flv=34:*.3gp=34:*.mp4=34:*.divx=34:*.gl=32:*.dl=32:*.xcf=32:*.xwd=32:*.flac=35:*.mp3=35:*.mpc=35:*.ogg=35:*.wav=35:*.m3u=35:';
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# значение цветов	 #30 черный текст	 #40 черный фон 
#00 восстановление цвета по умолчанию	#31 красный текст	 #41 красный фон 
#01 включить яркие цвета	 #32 зеленый текст	 #42 зеленый фон 
#04 подчеркнутый текст	 #33 желтый (или коричневый) текст	#43 желтый (или коричневый) фон 
#05 мигающий текст	 #34 синий текст	 #44 синий фон 
# ну или color юзать	 #35 фиолетовый текст	 #45 фиолетовый фон 
#	 #36 cyan текст	 #46 cyan фон 
# алиасы	 #37 белый (или серый) текст	 #47 белый (или серый) фон 
# 
# цветной grep 
alias grep='grep --color=auto'

# более человекочитаемые df и du 
alias df='df -h'
alias du='du -h'
alias tmuxs='tmux attach'
# переименование-перемещение c пogтвepжgeнueм без коррекции 
alias mv='nocorrect mv -i'

#при загруске на ompload.org не показывать прогрес бар
#alias -g ompload=`ompload -u`

# рекурсивное копирование с подтверждением без коррекции 
alias cp='nocorrect cp -iR'

# удаление с подтверждением без коррекции 
alias rm='nocorrect rm -i'

# принудимтельное удаление без коррекции 
alias rmf='nocorrect rm -f'

# принудительное рекурсивное удаление без коррекции 
alias rmrf='nocorrect rm -fR'

# создание каталогов без коррекции 
alias mkdir='nocorrect mkdir'

# показ файлов в цвете 
alias ls='ls -F --color=auto'

# разукрашиваем некоторые команды с помощью grc 
[[ -f /usr/bin/grc ]] && {
  alias ping="grc --colour=auto ping"
  alias traceroute="grc --colour=auto traceroute"
  alias make="grc --colour=auto make"
  alias diff="grc --colour=auto diff"
  alias cvs="grc --colour=auto cvs"
  alias netstat="grc --colour=auto netstat"
}

# разукрашиваем логи с помощью grc 
alias logc="grc cat"
alias logt="grc tail"
alias logh="grc head"

# 
# запуск программ 
# 
# везде 
alias -s {avi,mpeg,mpg,mov,m2v,flv}=mplayer
alias -s {zip,fb2}=fbless
alias -s txt=$PAGER
alias -s py=python
alias -s {ogg,mp3,wav,wma}=mplayer

# в иксах 
#alias -s {xls,doc,,rtf,ppt,odt,sxw}=soffice
alias -s {png,gif,jpg,jpeg}=feh
alias -s {pdf,djvu}=evince

# без иксов 
[[ -z $DISPLAY ]] && {
	alias -s {odt,doc,sxw,xls,doc,rtf}=catdoc
	alias -s {png,gif,jpg,jpeg}="fbi -a"
	alias -s {pdf,djvu}=evince
}

# html сам пусть соображает чё запускать 
autoload -U pick-web-browser
alias -s {html,htm}=pick-web-browser

# 
# глобальные алиасы 
# 
alias -g H="| head"
alias -g T="| tail"
alias -g G="| grep"
alias -g L="| less"
alias -g M="| most"
alias -g B="&|"
alias -g HL="--help"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"

#конвертим вывод в utf8, а то достало 
alias -g KU="| iconv -c -f koi8r -t utf8"
alias -g CU="| iconv -c -f cp1251 -t utf8"

#ну и обратно тоже 
alias -g UK="| iconv -c -f utf8 -t koi8r"
alias -g UC="| iconv -c -f utf8 -t cp1251"

# 
# куча алиасов 
# 
# sudo 
alias spacman="sudo pacman"
#alias gparted="sudo gparted"
alias -g reboot="systemctl reboot"
alias -g poweroff="systemctl poweroff"
#alias -g halt="systemctl halt"
#alias -g suspend="suspend"
#alias -g hibernate="hibernate"

# родной скрин 
alias screen="screen -DR"


# lastfm 
alias shell-fm="shell-fm lastfm://user/korobcov"

# список удаленных файлов с NTFS, FAT, UFS1/2, FFS, Ext2 и Ext3 
# пакет sleuthkit, утилита icat для восстановления 
alias fls="fls -rd"

# 
# хитрожопые алиасы 
# 
# пишем диски 
alias iso2cd="cdrecord -s dev=`cdrecord --devices 2>&1 | grep "\(rw\|dev=\)" | awk {'print $2'} | cut -f'2' -d'=' | head -n1` gracetime=1 driveropts=burnfree -dao -overburn -v"

# nrg2iso 
alias nrg2iso="dd bs=1k if=$1 of=$2 skip=300"

# ls -l с цифровым видом прав 
alias lls="ls -l | sed -e 's/--x/1/g' -e 's/-w-/2/g' -e 's/-wx/3/g' -e 's/r--/4/g'  -e 's/r-x/5/g' -e 's/rw-/6/g' -e 's/rwx/7/g' -e 's/---/0/g'"

# показываев дерево директорий 
alias dirf='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"'

# grep по ps aux 
alias psgrep='ps aux | grep $(echo $1 | sed "s/^\(.\)/[\1]/g")'

# удаляем пустые строки и комментарии 
alias delspacecomm="sed '/ *#/d; /^ *$/d' $1"

# создаем пароль из 6символов 
alias mkpass="head -c6 /dev/urandom | xxd -ps"
alias pcmanfm="ck-launch-session dbus-launch pcmanfm"
