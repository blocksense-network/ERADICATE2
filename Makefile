BUILD_DIR		:= build
CXX				?= c++
CXXFLAGS		?= -DCL_TARGET_OPENCL_VERSION=120 -std=c++11 -Wall -O2 -I$(BUILD_DIR)

SOURCES			:= $(wildcard *.cpp)
OBJS			:= $(addprefix $(BUILD_DIR)/, $(SOURCES:.cpp=.o))
EXECUTABLE		:= $(BUILD_DIR)/eradicate2

EMBED_SCRIPT	:= ./embed-in-cpp.sh
OCL_SOURCES		:= $(wildcard *.cl)
OCL_HEADERS		:= $(addprefix $(BUILD_DIR)/, $(OCL_SOURCES:=.h))

ifeq ($(shell uname -s),Darwin)
	LDFLAGS		:= -framework OpenCL
	LDLIBS		:=
else
	LDFLAGS		:= -s
	LDLIBS		:= -lOpenCL
endif

.PHONY: clean

re: clean all
all: link
	@echo -e "\nSuccessfully built:\n  $(EXECUTABLE)"

link: $(EXECUTABLE)
	@echo "  ✅ done"

compile: $(OBJS)
	@echo "  ✅ done"

embed-kernels: $(OCL_HEADERS)
	@echo "  ✅ done"

print-message-embed-kernels:
	@echo -e "\nEmbedding OpenCL kernels..."

print-message-compile-cpp:
	@echo -e "\nCompiling C++ files..."

print-message-link-cpp:
	@echo -e "\nLinking executable..."

$(EXECUTABLE): $(OBJS) | compile print-message-link-cpp
	@printf "  "
	$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS)

$(BUILD_DIR)/%.o: %.cpp $(OCL_HEADERS) | embed-kernels print-message-compile-cpp
	@mkdir -p $(@D)
	@printf "  "
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/%.cl.h: %.cl $(EMBED_SCRIPT) | print-message-embed-kernels
	@mkdir -p $(@D)
	@printf "  "
	$(EMBED_SCRIPT) $< $@

clean:
	@echo -en "Cleaning '$(BUILD_DIR)/'...\n  "
	rm -rf $(BUILD_DIR)
	@echo "  ✅ done"
