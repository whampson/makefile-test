local_src := $(addprefix $(subdirectory)/,init.c kmain.c)

$(eval $(call make-library, $(subdirectory)/libkernel.a,$(local_src)))
