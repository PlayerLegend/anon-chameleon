BLENDER       ?= blender
OBJ_EXPORT_SCRIPT ?= blender-obj-export.py
GLB_EXPORT_SCRIPT ?= blender-glb-export.py

OBJ_BLEND_FILES ?= \

GLB_BLEND_FILES ?= \
	PinkiePie.blend

OBJ_FILES := $(OBJ_BLEND_FILES:.blend=.obj)
GLB_FILES := $(GLB_BLEND_FILES:.blend=.glb)

all: $(OBJ_FILES) $(GLB_FILES)
	@echo $(OBJ_FILES)

%.obj: %.blend $(EXPORT_SCRIPT)
	$(BLENDER) --background "$<" --python $(OBJ_EXPORT_SCRIPT) -- "$@"

%.glb: %.blend $(EXPORT_SCRIPT)
	$(BLENDER) --background "$<" --python $(GLB_EXPORT_SCRIPT) -- "$@"
