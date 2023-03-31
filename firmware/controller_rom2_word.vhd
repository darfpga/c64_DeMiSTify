library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller_rom2 is
generic	(
	ADDR_WIDTH : integer := 8; -- ROM's address width (words, not bytes)
	COL_WIDTH  : integer := 8;  -- Column width (8bit -> byte)
	NB_COL     : integer := 4  -- Number of columns in memory
	);
port (
	clk : in std_logic;
	reset_n : in std_logic := '1';
	addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
	q : out std_logic_vector(31 downto 0);
	-- Allow writes - defaults supplied to simplify projects that don't need to write.
	d : in std_logic_vector(31 downto 0) := X"00000000";
	we : in std_logic := '0';
	bytesel : in std_logic_vector(3 downto 0) := "1111"
);
end entity;

architecture arch of controller_rom2 is

-- type word_t is std_logic_vector(31 downto 0);
type ram_type is array (0 to 2 ** ADDR_WIDTH - 1) of std_logic_vector(NB_COL * COL_WIDTH - 1 downto 0);

signal ram : ram_type :=
(

     0 => x"87c45bfa",
     1 => x"5afaccc2",
     2 => x"bff6ccc2",
     3 => x"c19ac14a",
     4 => x"ec49a2c0",
     5 => x"48fc87e8",
     6 => x"bff6ccc2",
     7 => x"87effe78",
     8 => x"c44a711e",
     9 => x"49721e66",
    10 => x"2687f9e9",
    11 => x"c21e4f26",
    12 => x"49bff6cc",
    13 => x"c287eae6",
    14 => x"e848c9e0",
    15 => x"e0c278bf",
    16 => x"bfec48c5",
    17 => x"c9e0c278",
    18 => x"c3494abf",
    19 => x"b7c899ff",
    20 => x"7148722a",
    21 => x"d1e0c2b0",
    22 => x"0e4f2658",
    23 => x"5d5c5b5e",
    24 => x"ff4b710e",
    25 => x"e0c287c8",
    26 => x"50c048c4",
    27 => x"d0e64973",
    28 => x"4c497087",
    29 => x"eecb9cc2",
    30 => x"87c2cb49",
    31 => x"c24d4970",
    32 => x"bf97c4e0",
    33 => x"87e2c105",
    34 => x"c24966d0",
    35 => x"99bfcde0",
    36 => x"d487d605",
    37 => x"e0c24966",
    38 => x"0599bfc5",
    39 => x"497387cb",
    40 => x"7087dee5",
    41 => x"c1c10298",
    42 => x"fe4cc187",
    43 => x"497587c0",
    44 => x"7087d7ca",
    45 => x"87c60298",
    46 => x"48c4e0c2",
    47 => x"e0c250c1",
    48 => x"05bf97c4",
    49 => x"c287e3c0",
    50 => x"49bfcde0",
    51 => x"059966d0",
    52 => x"c287d6ff",
    53 => x"49bfc5e0",
    54 => x"059966d4",
    55 => x"7387caff",
    56 => x"87dde449",
    57 => x"fe059870",
    58 => x"487487ff",
    59 => x"0e87dcfb",
    60 => x"5d5c5b5e",
    61 => x"c086f40e",
    62 => x"bfec4c4d",
    63 => x"48a6c47e",
    64 => x"bfd1e0c2",
    65 => x"c01ec178",
    66 => x"fd49c71e",
    67 => x"86c887cd",
    68 => x"cd029870",
    69 => x"fb49ff87",
    70 => x"dac187cc",
    71 => x"87e1e349",
    72 => x"e0c24dc1",
    73 => x"02bf97c4",
    74 => x"f6c887c3",
    75 => x"c9e0c287",
    76 => x"ccc24bbf",
    77 => x"c005bff6",
    78 => x"fdc387e9",
    79 => x"87c1e349",
    80 => x"e249fac3",
    81 => x"497387fb",
    82 => x"7199ffc3",
    83 => x"fb49c01e",
    84 => x"497387ce",
    85 => x"7129b7c8",
    86 => x"fb49c11e",
    87 => x"86c887c2",
    88 => x"c287f9c5",
    89 => x"4bbfcde0",
    90 => x"87dd029b",
    91 => x"bff2ccc2",
    92 => x"87d6c749",
    93 => x"c4059870",
    94 => x"d24bc087",
    95 => x"49e0c287",
    96 => x"c287fbc6",
    97 => x"c658f6cc",
    98 => x"f2ccc287",
    99 => x"7378c048",
   100 => x"0599c249",
   101 => x"ebc387cd",
   102 => x"87e5e149",
   103 => x"99c24970",
   104 => x"fb87c202",
   105 => x"c149734c",
   106 => x"87cd0599",
   107 => x"e149f4c3",
   108 => x"497087cf",
   109 => x"c20299c2",
   110 => x"734cfa87",
   111 => x"0599c849",
   112 => x"f5c387cd",
   113 => x"87f9e049",
   114 => x"99c24970",
   115 => x"c287d402",
   116 => x"02bfd5e0",
   117 => x"c14887c9",
   118 => x"d9e0c288",
   119 => x"ff87c258",
   120 => x"734dc14c",
   121 => x"0599c449",
   122 => x"f2c387cd",
   123 => x"87d1e049",
   124 => x"99c24970",
   125 => x"c287db02",
   126 => x"7ebfd5e0",
   127 => x"a8b7c748",
   128 => x"6e87cb03",
   129 => x"c280c148",
   130 => x"c058d9e0",
   131 => x"4cfe87c2",
   132 => x"fdc34dc1",
   133 => x"e8dfff49",
   134 => x"c2497087",
   135 => x"87d50299",
   136 => x"bfd5e0c2",
   137 => x"87c9c002",
   138 => x"48d5e0c2",
   139 => x"c2c078c0",
   140 => x"c14cfd87",
   141 => x"49fac34d",
   142 => x"87c5dfff",
   143 => x"99c24970",
   144 => x"c287d902",
   145 => x"48bfd5e0",
   146 => x"03a8b7c7",
   147 => x"c287c9c0",
   148 => x"c748d5e0",
   149 => x"87c2c078",
   150 => x"4dc14cfc",
   151 => x"03acb7c0",
   152 => x"c487d1c0",
   153 => x"d8c14a66",
   154 => x"c0026a82",
   155 => x"4b6a87c6",
   156 => x"0f734974",
   157 => x"f0c31ec0",
   158 => x"49dac11e",
   159 => x"c887dcf7",
   160 => x"02987086",
   161 => x"c887e2c0",
   162 => x"e0c248a6",
   163 => x"c878bfd5",
   164 => x"91cb4966",
   165 => x"714866c4",
   166 => x"6e7e7080",
   167 => x"c8c002bf",
   168 => x"4bbf6e87",
   169 => x"734966c8",
   170 => x"029d750f",
   171 => x"c287c8c0",
   172 => x"49bfd5e0",
   173 => x"c287caf3",
   174 => x"02bffacc",
   175 => x"4987ddc0",
   176 => x"7087c7c2",
   177 => x"d3c00298",
   178 => x"d5e0c287",
   179 => x"f0f249bf",
   180 => x"f449c087",
   181 => x"ccc287d0",
   182 => x"78c048fa",
   183 => x"eaf38ef4",
   184 => x"5b5e0e87",
   185 => x"1e0e5d5c",
   186 => x"e0c24c71",
   187 => x"c149bfd1",
   188 => x"c14da1cd",
   189 => x"7e6981d1",
   190 => x"cf029c74",
   191 => x"4ba5c487",
   192 => x"e0c27b74",
   193 => x"f349bfd1",
   194 => x"7b6e87c9",
   195 => x"c4059c74",
   196 => x"c24bc087",
   197 => x"734bc187",
   198 => x"87caf349",
   199 => x"c70266d4",
   200 => x"87da4987",
   201 => x"87c24a70",
   202 => x"ccc24ac0",
   203 => x"f2265afe",
   204 => x"000087d9",
   205 => x"00000000",
   206 => x"00000000",
   207 => x"711e0000",
   208 => x"bfc8ff4a",
   209 => x"48a17249",
   210 => x"ff1e4f26",
   211 => x"fe89bfc8",
   212 => x"c0c0c0c0",
   213 => x"c401a9c0",
   214 => x"c24ac087",
   215 => x"724ac187",
   216 => x"1e4f2648",
   217 => x"bfcccec2",
   218 => x"c2b9c149",
   219 => x"ff59d0ce",
   220 => x"ffc348d4",
   221 => x"48d0ff78",
   222 => x"ff78e1c0",
   223 => x"78c148d4",
   224 => x"787131c4",
   225 => x"c048d0ff",
   226 => x"4f2678e0",
   227 => x"00000000",
  others => ( x"00000000")
);

-- Xilinx Vivado attributes
attribute ram_style: string;
attribute ram_style of ram: signal is "block";

signal q_local : std_logic_vector((NB_COL * COL_WIDTH)-1 downto 0);

signal wea : std_logic_vector(NB_COL - 1 downto 0);

begin

	output:
	for i in 0 to NB_COL - 1 generate
		q((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH) <= q_local((i+1) * COL_WIDTH - 1 downto i * COL_WIDTH);
	end generate;
    
    -- Generate write enable signals
    -- The Block ram generator doesn't like it when the compare is done in the if statement it self.
    wea <= bytesel when we = '1' else (others => '0');

    process(clk)
    begin
        if rising_edge(clk) then
            q_local <= ram(to_integer(unsigned(addr)));
            for i in 0 to NB_COL - 1 loop
                if (wea(NB_COL-i-1) = '1') then
                    ram(to_integer(unsigned(addr)))((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH) <= d((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH);
                end if;
            end loop;
        end if;
    end process;

end arch;
