
SHELL ?= $(DEFAULT_SHELL)
CPP ?= $(DEFAULT_CPP)
FC ?= $(DEFAULT_FC)

HYPRE ?= $(DEFAULT_HYPRE)

CPPFLAGS ?= $(DEFAULT_CPPFLAGS)

FFLAGS ?= $(DEFAULT_FFLAGS)
FFLAGS_HOT ?= $(DEFAULT_FFLAGS_HOT)
FFLAGS_ACC ?= $(DEFAULT_FFLAGS_ACC)
FFLAGS_HYPRE ?= $(DEFAULT_FFLAGS_HYPRE)

LDFLAGS ?= $(DEFAULT_LDFLAGS)
LIBS ?= $(DEFAULT_LIBS)

BIN_NAME ?= $(DEFAULT_BIN_NAME)

OPTIONS += -DDOUBLE_PRECISION
OPTIONS += -DPARALLEL
OPTIONS += -DLANDSLIDE
OPTIONS += -DSALINITY
OPTIONS += -DTEMPERATURE
OPTIONS += -DBUBBLE
OPTIONS += -DSEDIMENT
OPTIONS += -DVEGETATION
OPTIONS += -DINTEL
OPTIONS += -DBALANCE2D
OPTIONS += -DTWOLAYERSLIDE
OPTIONS += -DCORALREEF
