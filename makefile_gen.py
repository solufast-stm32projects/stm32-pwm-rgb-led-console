# makefile_gen.py - Modern STM32 Makefile Generator using config.yaml
# -------------------------------------------------------------
# Generates robust Makefiles with CMSIS/HAL support from a YAML config file.

import os
import yaml

MAKEFILE_TEMPLATE = """
# Auto-generated Makefile for STM32 project
# =========================================

TARGET  = {project_name}
CPU     = {cpu}
FPU     = {fpu}
FLOAT_ABI = {float_abi}

# Toolchain
CC      = {compiler}
AS      = {compiler}
CP      = {objcopy}
SZ      = {size}

# Build directory
BUILD_DIR = {build_dir}

# C flags
CFLAGS  = -mcpu=$(CPU) -mthumb -mfpu=$(FPU) -mfloat-abi=$(FLOAT_ABI)
CFLAGS += {cflags}
CFLAGS += {defines}
CFLAGS += {includes}

# Assembler flags
ASFLAGS = -mcpu=$(CPU) -mthumb -mfpu=$(FPU) -mfloat-abi=$(FLOAT_ABI)
ASFLAGS += {asflags}

# Linker flags
LDFLAGS = -mcpu=$(CPU) -mthumb -mfpu=$(FPU) -mfloat-abi=$(FLOAT_ABI)
LDFLAGS += -T{linker} {ldflags} -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# Libraries
LIBS = {libs}
LDFLAGS += $(LIBS)

# Sources
CSRCS = \\
  {c_src_list}

ASRCS = \\
  {asm_src_list}

# Object files with explicit paths
OBJS = {obj_list}
AS_OBJS = {asm_obj_list}

all: $(BUILD_DIR)/$(TARGET).elf

{c_compile_rules}

{asm_compile_rules}

$(BUILD_DIR)/$(TARGET).elf: $(OBJS) $(AS_OBJS)
	$(CC) $(LDFLAGS) $^ -o $@
	$(SZ) $@

$(BUILD_DIR):
	mkdir -p $@

flash: all
	STM32_Programmer_CLI -c port=SWD -w $(BUILD_DIR)/$(TARGET).elf 0x08000000 -v -rst

debug: all
	@echo "Starting OpenOCD and GDB for debugging..."
	@echo "OpenOCD will run in background. Use 'make debug-gdb' in another terminal to start GDB."
	@echo "Or use VS Code with Cortex-Debug extension."
	openocd -f openocd_stm32u585.cfg &

debug-gdb: all
	@echo "Starting GDB..."
	gdb-multiarch $(BUILD_DIR)/$(TARGET).elf

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all flash debug debug-gdb clean
"""

def list_sources(paths):
    src_files = []
    for p in paths:
        p = p.strip().rstrip('\\').strip()
        if os.path.isdir(p):
            for root, _, files in os.walk(p):
                for file in files:
                    if file.endswith(".c"):
                        rel_path = os.path.join(root, file).replace('\\', '/')
                        src_files.append(rel_path)
        elif os.path.isfile(p):
            if p.endswith(".c"):
                src_files.append(p.replace('\\', '/'))

    # Exclude all files from template folders or with "template" in the name
    src_files = [f for f in src_files if 'template' not in f.lower()]

    return sorted(list(set(src_files)))

def quote_and_join(items, prefix):
    if not items:
        return ""
    return " \\\n          ".join(f"{prefix}{item}" for item in items)

def generate_makefile(config_file: str):
    with open(config_file, 'r') as f:
        cfg = yaml.safe_load(f)

    toolchain = cfg['toolchain']
    paths = cfg['paths']
    project = cfg['project']
    build = cfg['build']
    board = cfg['board']
    flags = cfg['flags']

    c_src_list = list_sources(paths['source'])
    c_src_list.append(board['system'])
    c_src_list = sorted(list(set(c_src_list)))

    all_sources = c_src_list + [board['startup']]

    includes = quote_and_join(paths['includes'], "-I")
    defines = quote_and_join(flags.get('defines', []), "-D")
    
    cflags = " ".join(flags.get('cflags', []))
    asflags = " ".join(flags.get('asflags', []))
    
    ldflags_list = flags.get('ldflags', [])
    libs = [f for f in ldflags_list if f.startswith("-l")]
    ldflags_filtered = [f for f in ldflags_list if not f.startswith("-l")]
    
    libs_str = " ".join(libs)
    ldflags_str = " ".join(ldflags_filtered)

    # Generate object file list with explicit paths
    obj_list = []
    c_compile_rules = []
    for src in c_src_list:
        obj_name = os.path.basename(src).replace('.c', '.o')
        obj_path = f"$(BUILD_DIR)/{obj_name}"
        obj_list.append(obj_path)
        c_compile_rules.append(f"$(BUILD_DIR)/{obj_name}: {src} Makefile | $(BUILD_DIR)")
        c_compile_rules.append(f"\t$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/{obj_name.replace('.o', '.lst')} -o $@ $<")
        c_compile_rules.append("")

    # Generate assembly object file list
    asm_obj_list = []
    asm_compile_rules = []
    asm_name = os.path.basename(board['startup']).replace('.s', '.o')
    asm_obj_path = f"$(BUILD_DIR)/{asm_name}"
    asm_obj_list.append(asm_obj_path)
    asm_compile_rules.append(f"$(BUILD_DIR)/{asm_name}: {board['startup']} Makefile | $(BUILD_DIR)")
    asm_compile_rules.append(f"\t$(AS) -c $(ASFLAGS) -o $@ $<")
    asm_compile_rules.append("")

    makefile_content = MAKEFILE_TEMPLATE.format(
        compiler=toolchain['compiler'],
        objcopy=toolchain['objcopy'],
        size=toolchain['size'],
        cpu=toolchain['cpu'],
        fpu=board['fpu'],
        float_abi=board['float-abi'],
        project_name=project['name'],
        build_dir=build['output_dir'],
        
        includes=includes,
        defines=defines,
        
        cflags=cflags,
        asflags=asflags,
        ldflags=ldflags_str,
        libs=libs_str,

        linker=paths['linker'],

        c_src_list=" \\\n  ".join(c_src_list),
        asm_src_list=board['startup'],
        
        obj_list=" \\\n  ".join(obj_list),
        asm_obj_list=" \\\n  ".join(asm_obj_list),
        
        c_compile_rules="\n".join(c_compile_rules),
        asm_compile_rules="\n".join(asm_compile_rules),
    )

    with open("Makefile", "w") as f:
        f.write(makefile_content)

    print("✅ Makefile generated successfully.")

if __name__ == "__main__":
    generate_makefile("config.yaml")

