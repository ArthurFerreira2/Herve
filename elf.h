#define EI_NIDENT 16

typedef struct {
  uint8_t     e_ident[EI_NIDENT];  // magic #, class, encoding, version, ABI, ABI version
  uint16_t    e_type;              // type : none, relocatable, executable, shared, core
  uint16_t    e_machine;           // x86, mips, amd64, riscv ...
  uint32_t    e_version;           // always 1
  uint32_t    e_entry;             // entry point virtual address
  uint32_t    e_phoff;             // offset of segment tables (from start of file)
  uint32_t    e_shoff;             // offset of section tables (from start of file)
  uint32_t    e_flags;             // flags (=0, unused)
  uint16_t    e_ehsize;            // this header size - should be 0x34
  uint16_t    e_phentsize;         // segment headers table lenght - should be a multiple of e_phnum
  uint16_t    e_phnum;             // numbers of entries in the segment table
  uint16_t    e_shentsize;         // section headers table lenght - should be a multiple of e_shnum
  uint16_t    e_shnum;             // numbers of entries in the section table
  uint16_t    e_shstrndx;          // section header string table index
} Elf32Header;

typedef struct {
  uint32_t  type;                  // type of the segment : null, load, dyn, interp, note, shlib, phdr, tls
  uint32_t  offset;                // offset after this header
  uint32_t  vaddr;                 // virtual memory address
  uint32_t  paddr;                 // physical memory address
  uint32_t  filesz;                // file segment size
  uint32_t  memsz;                 // memory segment size might be bigger than the above for un-initialized data
  uint32_t  flags;                 // flags : read, write and executable
  uint32_t  align;                 // alignment
} Elf32ProgramHeader;


int loadElf(char* filename);
