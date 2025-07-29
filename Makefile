BUILD_DIR		:= build
CXX				?= c++
CXXFLAGS		?= -std=c++11 -Wall -O2

SOURCES			:= $(wildcard *.cpp)
OBJS			:= $(addprefix $(BUILD_DIR)/, $(SOURCES:.cpp=.o))
EXECUTABLE		:= $(BUILD_DIR)/eradicate2

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

print-message-compile-cpp:
	@echo -e "\nCompiling C++ files..."

print-message-link-cpp:
	@echo -e "\nLinking executable..."

$(EXECUTABLE): $(OBJS) | compile print-message-link-cpp
	@printf "  "
	$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS)

$(BUILD_DIR)/%.o: %.cpp | print-message-compile-cpp
	@mkdir -p $(@D)
	@printf "  "
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	@echo -en "Cleaning '$(BUILD_DIR)/'...\n  "
	rm -rf $(BUILD_DIR)
	@echo "  ✅ done"
