#define EI_NIDENT 16

typedef struct {
  uint8_t     e_ident[EI_NIDENT];  // magic #, class, encoding, version, ABI, ABI version
  uint16_t    e_type;              // Object file type : none, relocatable, executable, shared, core
  uint16_t    e_machine;           // Architecture :x86, mips, amd64, riscv ...
  uint32_t    e_version;           // Object file version (always 1)
  uint32_t    e_entry;             // Entry point virtual address
  uint32_t    e_phoff;             // Program header table file offset (from start of file)
  uint32_t    e_shoff;             // Section header table file offset (from start of file)
  uint32_t    e_flags;             // Processor-specific flags (=0, unused)
  uint16_t    e_ehsize;            // ELF header size in bytes (this header size - should be 0x34)
  uint16_t    e_phentsize;         // Program header table entry size - should be a multiple of e_phnum
  uint16_t    e_phnum;             // Program header table entry count : numbers of entries in the segment table
  uint16_t    e_shentsize;         // Section header table entry size - should be a multiple of e_shnum
  uint16_t    e_shnum;             // Section header table entry count - numbers of entries in the section table
  uint16_t    e_shstrndx;          // section header string table index
} Elf32Header;

typedef struct {
  uint32_t  type;                  // type of the segment : null, load, dyn, interp, note, shlib, phdr, tls
  uint32_t  offset;                // Segment file offset = offset after this header
  uint32_t  vaddr;                 // Segment virtual address
  uint32_t  paddr;                 // Segment physical address
  uint32_t  filesz;                // Segment size in file
  uint32_t  memsz;                 // Segment size in memory might be bigger than the above for un-initialized data
  uint32_t  flags;                 // flags : read, write and executable
  uint32_t  align;                 // Segment alignment
} Elf32ProgramHeader;

typedef struct {
  uint32_t  sh_name;               // Section name (string tbl index)
  uint32_t  sh_type;               // Section type
  uint32_t  sh_flags;              // Section flags
  uint32_t  sh_addr;               // Section virtual addr at execution
  uint32_t  sh_offset;             // Section file offset
  uint32_t  sh_size;               // Section size in bytes
  uint32_t  sh_link;               // Link to another section
  uint32_t  sh_info;               // Additional section information
  uint32_t  sh_addralign;          // Section alignment
  uint32_t  sh_entsize;            // Entry size if section holds table
} Elf32SectionHeader;


int loadElf(char* filename);
