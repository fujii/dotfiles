a="s/(setq user-mail-address \".*\")/(setq user-mail-address \"${user_email}\")/"
b="s/(setq user-full-name \".*\")/(setq user-full-name \"${user_name}\")/"

sed -e "$a;$b" emacs.el
