local_src := $(addprefix $(subdirectory)/,mm.c)

$(eval $(call make-library, $(subdirectory)/libmm.a,$(local_src)))
