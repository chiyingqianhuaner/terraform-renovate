
TF      = terraform
TF_LOCK = -lock=false

ifdef SUPPRESS_STDOUT
STDOUT = /dev/null
else
STDOUT = /dev/stdout
endif

TF_REFRESH     = -refresh=false
TF_GET_PLUGINS =
TF_GET_BACKEND = -backend=true
TF_ASK_INPUT   = -input=false
PLAN.o         = ./plan.out
TF_LOCK.hcl    = .terraform.lock.hcl
TF.d           = ./.terraform

INIT_CMD  = $(strip $(TF) init -get=true $(TF_GET_BACKEND) $(TF_GET_PLUGINS) $(TF_COLOR))
FMT_CMD   = $(strip $(TF) fmt -diff -write=false -list=true -check)
PLAN_CMD  = $(strip $(TF) plan $(TF_FLAGS) $(TF_LOCK) $(TF_ASK_INPUT) $(TF_COLOR) -out=$(PLAN.o))
APPLY_CMD = $(strip $(TF) apply $(TF_FLAGS)  $(TF_ASK_INPUT) $(TF_REFRESH) $(TF_COLOR) $(PLAN.o))

plan: FORCE
	$(FMT_CMD)
	$(PLAN_CMD)

apply:
	$(APPLY_CMD) || rm $(PLAN.o)

init: FORCE
	$(INIT_CMD)

get: FORCE
	$(TF) get -update

clean:
	rm -rf $(PLAN.o) $(TF.d) $(TF_LOCK.hcl) $(HELM_REPOSITORY_ROOT)

FORCE:
