
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller_rom2 is
generic
	(
		ADDR_WIDTH : integer := 15 -- Specify your actual ROM size to save LEs and unnecessary block RAM usage.
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

architecture rtl of controller_rom2 is

	signal addr1 : integer range 0 to 2**ADDR_WIDTH-1;

	--  build up 2D array to hold the memory
	type word_t is array (0 to 3) of std_logic_vector(7 downto 0);
	type ram_t is array (0 to 2 ** ADDR_WIDTH - 1) of word_t;

	signal ram : ram_t:=
	(

     0 => (x"87",x"c4",x"5b",x"fa"),
     1 => (x"5a",x"fa",x"cc",x"c2"),
     2 => (x"bf",x"f6",x"cc",x"c2"),
     3 => (x"c1",x"9a",x"c1",x"4a"),
     4 => (x"ec",x"49",x"a2",x"c0"),
     5 => (x"48",x"fc",x"87",x"e8"),
     6 => (x"bf",x"f6",x"cc",x"c2"),
     7 => (x"87",x"ef",x"fe",x"78"),
     8 => (x"c4",x"4a",x"71",x"1e"),
     9 => (x"49",x"72",x"1e",x"66"),
    10 => (x"26",x"87",x"f9",x"e9"),
    11 => (x"c2",x"1e",x"4f",x"26"),
    12 => (x"49",x"bf",x"f6",x"cc"),
    13 => (x"c2",x"87",x"ea",x"e6"),
    14 => (x"e8",x"48",x"c9",x"e0"),
    15 => (x"e0",x"c2",x"78",x"bf"),
    16 => (x"bf",x"ec",x"48",x"c5"),
    17 => (x"c9",x"e0",x"c2",x"78"),
    18 => (x"c3",x"49",x"4a",x"bf"),
    19 => (x"b7",x"c8",x"99",x"ff"),
    20 => (x"71",x"48",x"72",x"2a"),
    21 => (x"d1",x"e0",x"c2",x"b0"),
    22 => (x"0e",x"4f",x"26",x"58"),
    23 => (x"5d",x"5c",x"5b",x"5e"),
    24 => (x"ff",x"4b",x"71",x"0e"),
    25 => (x"e0",x"c2",x"87",x"c8"),
    26 => (x"50",x"c0",x"48",x"c4"),
    27 => (x"d0",x"e6",x"49",x"73"),
    28 => (x"4c",x"49",x"70",x"87"),
    29 => (x"ee",x"cb",x"9c",x"c2"),
    30 => (x"87",x"c2",x"cb",x"49"),
    31 => (x"c2",x"4d",x"49",x"70"),
    32 => (x"bf",x"97",x"c4",x"e0"),
    33 => (x"87",x"e2",x"c1",x"05"),
    34 => (x"c2",x"49",x"66",x"d0"),
    35 => (x"99",x"bf",x"cd",x"e0"),
    36 => (x"d4",x"87",x"d6",x"05"),
    37 => (x"e0",x"c2",x"49",x"66"),
    38 => (x"05",x"99",x"bf",x"c5"),
    39 => (x"49",x"73",x"87",x"cb"),
    40 => (x"70",x"87",x"de",x"e5"),
    41 => (x"c1",x"c1",x"02",x"98"),
    42 => (x"fe",x"4c",x"c1",x"87"),
    43 => (x"49",x"75",x"87",x"c0"),
    44 => (x"70",x"87",x"d7",x"ca"),
    45 => (x"87",x"c6",x"02",x"98"),
    46 => (x"48",x"c4",x"e0",x"c2"),
    47 => (x"e0",x"c2",x"50",x"c1"),
    48 => (x"05",x"bf",x"97",x"c4"),
    49 => (x"c2",x"87",x"e3",x"c0"),
    50 => (x"49",x"bf",x"cd",x"e0"),
    51 => (x"05",x"99",x"66",x"d0"),
    52 => (x"c2",x"87",x"d6",x"ff"),
    53 => (x"49",x"bf",x"c5",x"e0"),
    54 => (x"05",x"99",x"66",x"d4"),
    55 => (x"73",x"87",x"ca",x"ff"),
    56 => (x"87",x"dd",x"e4",x"49"),
    57 => (x"fe",x"05",x"98",x"70"),
    58 => (x"48",x"74",x"87",x"ff"),
    59 => (x"0e",x"87",x"dc",x"fb"),
    60 => (x"5d",x"5c",x"5b",x"5e"),
    61 => (x"c0",x"86",x"f4",x"0e"),
    62 => (x"bf",x"ec",x"4c",x"4d"),
    63 => (x"48",x"a6",x"c4",x"7e"),
    64 => (x"bf",x"d1",x"e0",x"c2"),
    65 => (x"c0",x"1e",x"c1",x"78"),
    66 => (x"fd",x"49",x"c7",x"1e"),
    67 => (x"86",x"c8",x"87",x"cd"),
    68 => (x"cd",x"02",x"98",x"70"),
    69 => (x"fb",x"49",x"ff",x"87"),
    70 => (x"da",x"c1",x"87",x"cc"),
    71 => (x"87",x"e1",x"e3",x"49"),
    72 => (x"e0",x"c2",x"4d",x"c1"),
    73 => (x"02",x"bf",x"97",x"c4"),
    74 => (x"f6",x"c8",x"87",x"c3"),
    75 => (x"c9",x"e0",x"c2",x"87"),
    76 => (x"cc",x"c2",x"4b",x"bf"),
    77 => (x"c0",x"05",x"bf",x"f6"),
    78 => (x"fd",x"c3",x"87",x"e9"),
    79 => (x"87",x"c1",x"e3",x"49"),
    80 => (x"e2",x"49",x"fa",x"c3"),
    81 => (x"49",x"73",x"87",x"fb"),
    82 => (x"71",x"99",x"ff",x"c3"),
    83 => (x"fb",x"49",x"c0",x"1e"),
    84 => (x"49",x"73",x"87",x"ce"),
    85 => (x"71",x"29",x"b7",x"c8"),
    86 => (x"fb",x"49",x"c1",x"1e"),
    87 => (x"86",x"c8",x"87",x"c2"),
    88 => (x"c2",x"87",x"f9",x"c5"),
    89 => (x"4b",x"bf",x"cd",x"e0"),
    90 => (x"87",x"dd",x"02",x"9b"),
    91 => (x"bf",x"f2",x"cc",x"c2"),
    92 => (x"87",x"d6",x"c7",x"49"),
    93 => (x"c4",x"05",x"98",x"70"),
    94 => (x"d2",x"4b",x"c0",x"87"),
    95 => (x"49",x"e0",x"c2",x"87"),
    96 => (x"c2",x"87",x"fb",x"c6"),
    97 => (x"c6",x"58",x"f6",x"cc"),
    98 => (x"f2",x"cc",x"c2",x"87"),
    99 => (x"73",x"78",x"c0",x"48"),
   100 => (x"05",x"99",x"c2",x"49"),
   101 => (x"eb",x"c3",x"87",x"cd"),
   102 => (x"87",x"e5",x"e1",x"49"),
   103 => (x"99",x"c2",x"49",x"70"),
   104 => (x"fb",x"87",x"c2",x"02"),
   105 => (x"c1",x"49",x"73",x"4c"),
   106 => (x"87",x"cd",x"05",x"99"),
   107 => (x"e1",x"49",x"f4",x"c3"),
   108 => (x"49",x"70",x"87",x"cf"),
   109 => (x"c2",x"02",x"99",x"c2"),
   110 => (x"73",x"4c",x"fa",x"87"),
   111 => (x"05",x"99",x"c8",x"49"),
   112 => (x"f5",x"c3",x"87",x"cd"),
   113 => (x"87",x"f9",x"e0",x"49"),
   114 => (x"99",x"c2",x"49",x"70"),
   115 => (x"c2",x"87",x"d4",x"02"),
   116 => (x"02",x"bf",x"d5",x"e0"),
   117 => (x"c1",x"48",x"87",x"c9"),
   118 => (x"d9",x"e0",x"c2",x"88"),
   119 => (x"ff",x"87",x"c2",x"58"),
   120 => (x"73",x"4d",x"c1",x"4c"),
   121 => (x"05",x"99",x"c4",x"49"),
   122 => (x"f2",x"c3",x"87",x"cd"),
   123 => (x"87",x"d1",x"e0",x"49"),
   124 => (x"99",x"c2",x"49",x"70"),
   125 => (x"c2",x"87",x"db",x"02"),
   126 => (x"7e",x"bf",x"d5",x"e0"),
   127 => (x"a8",x"b7",x"c7",x"48"),
   128 => (x"6e",x"87",x"cb",x"03"),
   129 => (x"c2",x"80",x"c1",x"48"),
   130 => (x"c0",x"58",x"d9",x"e0"),
   131 => (x"4c",x"fe",x"87",x"c2"),
   132 => (x"fd",x"c3",x"4d",x"c1"),
   133 => (x"e8",x"df",x"ff",x"49"),
   134 => (x"c2",x"49",x"70",x"87"),
   135 => (x"87",x"d5",x"02",x"99"),
   136 => (x"bf",x"d5",x"e0",x"c2"),
   137 => (x"87",x"c9",x"c0",x"02"),
   138 => (x"48",x"d5",x"e0",x"c2"),
   139 => (x"c2",x"c0",x"78",x"c0"),
   140 => (x"c1",x"4c",x"fd",x"87"),
   141 => (x"49",x"fa",x"c3",x"4d"),
   142 => (x"87",x"c5",x"df",x"ff"),
   143 => (x"99",x"c2",x"49",x"70"),
   144 => (x"c2",x"87",x"d9",x"02"),
   145 => (x"48",x"bf",x"d5",x"e0"),
   146 => (x"03",x"a8",x"b7",x"c7"),
   147 => (x"c2",x"87",x"c9",x"c0"),
   148 => (x"c7",x"48",x"d5",x"e0"),
   149 => (x"87",x"c2",x"c0",x"78"),
   150 => (x"4d",x"c1",x"4c",x"fc"),
   151 => (x"03",x"ac",x"b7",x"c0"),
   152 => (x"c4",x"87",x"d1",x"c0"),
   153 => (x"d8",x"c1",x"4a",x"66"),
   154 => (x"c0",x"02",x"6a",x"82"),
   155 => (x"4b",x"6a",x"87",x"c6"),
   156 => (x"0f",x"73",x"49",x"74"),
   157 => (x"f0",x"c3",x"1e",x"c0"),
   158 => (x"49",x"da",x"c1",x"1e"),
   159 => (x"c8",x"87",x"dc",x"f7"),
   160 => (x"02",x"98",x"70",x"86"),
   161 => (x"c8",x"87",x"e2",x"c0"),
   162 => (x"e0",x"c2",x"48",x"a6"),
   163 => (x"c8",x"78",x"bf",x"d5"),
   164 => (x"91",x"cb",x"49",x"66"),
   165 => (x"71",x"48",x"66",x"c4"),
   166 => (x"6e",x"7e",x"70",x"80"),
   167 => (x"c8",x"c0",x"02",x"bf"),
   168 => (x"4b",x"bf",x"6e",x"87"),
   169 => (x"73",x"49",x"66",x"c8"),
   170 => (x"02",x"9d",x"75",x"0f"),
   171 => (x"c2",x"87",x"c8",x"c0"),
   172 => (x"49",x"bf",x"d5",x"e0"),
   173 => (x"c2",x"87",x"ca",x"f3"),
   174 => (x"02",x"bf",x"fa",x"cc"),
   175 => (x"49",x"87",x"dd",x"c0"),
   176 => (x"70",x"87",x"c7",x"c2"),
   177 => (x"d3",x"c0",x"02",x"98"),
   178 => (x"d5",x"e0",x"c2",x"87"),
   179 => (x"f0",x"f2",x"49",x"bf"),
   180 => (x"f4",x"49",x"c0",x"87"),
   181 => (x"cc",x"c2",x"87",x"d0"),
   182 => (x"78",x"c0",x"48",x"fa"),
   183 => (x"ea",x"f3",x"8e",x"f4"),
   184 => (x"5b",x"5e",x"0e",x"87"),
   185 => (x"1e",x"0e",x"5d",x"5c"),
   186 => (x"e0",x"c2",x"4c",x"71"),
   187 => (x"c1",x"49",x"bf",x"d1"),
   188 => (x"c1",x"4d",x"a1",x"cd"),
   189 => (x"7e",x"69",x"81",x"d1"),
   190 => (x"cf",x"02",x"9c",x"74"),
   191 => (x"4b",x"a5",x"c4",x"87"),
   192 => (x"e0",x"c2",x"7b",x"74"),
   193 => (x"f3",x"49",x"bf",x"d1"),
   194 => (x"7b",x"6e",x"87",x"c9"),
   195 => (x"c4",x"05",x"9c",x"74"),
   196 => (x"c2",x"4b",x"c0",x"87"),
   197 => (x"73",x"4b",x"c1",x"87"),
   198 => (x"87",x"ca",x"f3",x"49"),
   199 => (x"c7",x"02",x"66",x"d4"),
   200 => (x"87",x"da",x"49",x"87"),
   201 => (x"87",x"c2",x"4a",x"70"),
   202 => (x"cc",x"c2",x"4a",x"c0"),
   203 => (x"f2",x"26",x"5a",x"fe"),
   204 => (x"00",x"00",x"87",x"d9"),
   205 => (x"00",x"00",x"00",x"00"),
   206 => (x"00",x"00",x"00",x"00"),
   207 => (x"71",x"1e",x"00",x"00"),
   208 => (x"bf",x"c8",x"ff",x"4a"),
   209 => (x"48",x"a1",x"72",x"49"),
   210 => (x"ff",x"1e",x"4f",x"26"),
   211 => (x"fe",x"89",x"bf",x"c8"),
   212 => (x"c0",x"c0",x"c0",x"c0"),
   213 => (x"c4",x"01",x"a9",x"c0"),
   214 => (x"c2",x"4a",x"c0",x"87"),
   215 => (x"72",x"4a",x"c1",x"87"),
   216 => (x"1e",x"4f",x"26",x"48"),
   217 => (x"bf",x"cc",x"ce",x"c2"),
   218 => (x"c2",x"b9",x"c1",x"49"),
   219 => (x"ff",x"59",x"d0",x"ce"),
   220 => (x"ff",x"c3",x"48",x"d4"),
   221 => (x"48",x"d0",x"ff",x"78"),
   222 => (x"ff",x"78",x"e1",x"c0"),
   223 => (x"78",x"c1",x"48",x"d4"),
   224 => (x"78",x"71",x"31",x"c4"),
   225 => (x"c0",x"48",x"d0",x"ff"),
   226 => (x"4f",x"26",x"78",x"e0"),
   227 => (x"00",x"00",x"00",x"00"),
		others => (others => x"00")
	);
	signal q1_local : word_t;

	-- Altera Quartus attributes
	attribute ramstyle: string;
	attribute ramstyle of ram: signal is "no_rw_check";

begin  -- rtl

	addr1 <= to_integer(unsigned(addr(ADDR_WIDTH-1 downto 0)));

	-- Reorganize the read data from the RAM to match the output
	q(7 downto 0) <= q1_local(3);
	q(15 downto 8) <= q1_local(2);
	q(23 downto 16) <= q1_local(1);
	q(31 downto 24) <= q1_local(0);

	process(clk)
	begin
		if(rising_edge(clk)) then 
			if(we = '1') then
				-- edit this code if using other than four bytes per word
				if (bytesel(3) = '1') then
					ram(addr1)(3) <= d(7 downto 0);
				end if;
				if (bytesel(2) = '1') then
					ram(addr1)(2) <= d(15 downto 8);
				end if;
				if (bytesel(1) = '1') then
					ram(addr1)(1) <= d(23 downto 16);
				end if;
				if (bytesel(0) = '1') then
					ram(addr1)(0) <= d(31 downto 24);
				end if;
			end if;
			q1_local <= ram(addr1);
		end if;
	end process;
  
end rtl;

