os := $(shell uname -o)

export user_name := Fujii Hironori
export user_email := fujii.hironori@gmail.com
export http_proxy :=
export smtp_server :=
export imap_server :=

-include local.mk

define targets
    .aspell.conf
    .emacs.el
    .gitconfig
    .wl.el
    .zshrc
endef

ifneq (${os},Cygwin)
define targets +=
    .Xmodmap
    .Xresources
endef
endif

addition_depends := $(MAKEFILE_LIST) $(wildcard local.mk)

ifeq (${HOME},)
    $(error HOME is not defined)
endif

define gen_targets_rules
$(foreach i,${1},${blank_line}$(call gen_target_rules,$(strip $i)))
endef

define gen_target_rules
$(call gen_target_rules_1,${HOME}/$1,$(patsubst .%,%,$1))
endef

define gen_target_rules_1
$(call gen_target_rules_2,$1,$2,$(wildcard $2.sh),$(wildcard $2*) ${addition_depends})
endef

# $1: ${HOME}/.foo
# $2: foo
# $3: foo.sh
# $4: foo* ${addition_depends}
define gen_target_rules_2
all : $1
$1 : $4
$(if $3,$(call gen_target_rules_sh,$3),$(call gen_target_rules_simple,$2))

endef

define gen_target_rules_sh
	-$$(RM) $$@
	$$(SHELL) $1 > $$@
	chmod 400 $$@
endef

define gen_target_rules_simple
	install -T -m 400 $1 $$@
endef

define blank_line


endef

all:

ifdef dump_rules
$(info $(call gen_targets_rules,${targets}))
else
$(eval $(call gen_targets_rules,${targets}))
endif
