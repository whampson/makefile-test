local_src := $(addprefix $(subdirectory)/,test.c)

# $(eval $(call make-library, $(subdirectory)/libtest.a,$(local_src)))
libraries += src/kernel/libkernel.a src/mm/libmm.a

$(eval $(call make-program, test,$(local_src)))

