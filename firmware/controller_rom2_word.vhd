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

     0 => x"0000407e",
     1 => x"19097f7f",
     2 => x"0000667f",
     3 => x"594d6f26",
     4 => x"0000327b",
     5 => x"7f7f0101",
     6 => x"00000101",
     7 => x"40407f3f",
     8 => x"00003f7f",
     9 => x"70703f0f",
    10 => x"7f000f3f",
    11 => x"3018307f",
    12 => x"41007f7f",
    13 => x"1c1c3663",
    14 => x"01416336",
    15 => x"7c7c0603",
    16 => x"61010306",
    17 => x"474d5971",
    18 => x"00004143",
    19 => x"417f7f00",
    20 => x"01000041",
    21 => x"180c0603",
    22 => x"00406030",
    23 => x"7f414100",
    24 => x"0800007f",
    25 => x"0603060c",
    26 => x"8000080c",
    27 => x"80808080",
    28 => x"00008080",
    29 => x"07030000",
    30 => x"00000004",
    31 => x"54547420",
    32 => x"0000787c",
    33 => x"44447f7f",
    34 => x"0000387c",
    35 => x"44447c38",
    36 => x"00000044",
    37 => x"44447c38",
    38 => x"00007f7f",
    39 => x"54547c38",
    40 => x"0000185c",
    41 => x"057f7e04",
    42 => x"00000005",
    43 => x"a4a4bc18",
    44 => x"00007cfc",
    45 => x"04047f7f",
    46 => x"0000787c",
    47 => x"7d3d0000",
    48 => x"00000040",
    49 => x"fd808080",
    50 => x"0000007d",
    51 => x"38107f7f",
    52 => x"0000446c",
    53 => x"7f3f0000",
    54 => x"7c000040",
    55 => x"0c180c7c",
    56 => x"0000787c",
    57 => x"04047c7c",
    58 => x"0000787c",
    59 => x"44447c38",
    60 => x"0000387c",
    61 => x"2424fcfc",
    62 => x"0000183c",
    63 => x"24243c18",
    64 => x"0000fcfc",
    65 => x"04047c7c",
    66 => x"0000080c",
    67 => x"54545c48",
    68 => x"00002074",
    69 => x"447f3f04",
    70 => x"00000044",
    71 => x"40407c3c",
    72 => x"00007c7c",
    73 => x"60603c1c",
    74 => x"3c001c3c",
    75 => x"6030607c",
    76 => x"44003c7c",
    77 => x"3810386c",
    78 => x"0000446c",
    79 => x"60e0bc1c",
    80 => x"00001c3c",
    81 => x"5c746444",
    82 => x"0000444c",
    83 => x"773e0808",
    84 => x"00004141",
    85 => x"7f7f0000",
    86 => x"00000000",
    87 => x"3e774141",
    88 => x"02000808",
    89 => x"02030101",
    90 => x"7f000102",
    91 => x"7f7f7f7f",
    92 => x"08007f7f",
    93 => x"3e1c1c08",
    94 => x"7f7f7f3e",
    95 => x"1c3e3e7f",
    96 => x"0008081c",
    97 => x"7c7c1810",
    98 => x"00001018",
    99 => x"7c7c3010",
   100 => x"10001030",
   101 => x"78606030",
   102 => x"4200061e",
   103 => x"3c183c66",
   104 => x"78004266",
   105 => x"c6c26a38",
   106 => x"6000386c",
   107 => x"00600000",
   108 => x"0e006000",
   109 => x"5d5c5b5e",
   110 => x"4c711e0e",
   111 => x"bffdf0c2",
   112 => x"c04bc04d",
   113 => x"02ab741e",
   114 => x"a6c487c7",
   115 => x"c578c048",
   116 => x"48a6c487",
   117 => x"66c478c1",
   118 => x"ee49731e",
   119 => x"86c887df",
   120 => x"ef49e0c0",
   121 => x"a5c487ef",
   122 => x"f0496a4a",
   123 => x"c6f187f0",
   124 => x"c185cb87",
   125 => x"abb7c883",
   126 => x"87c7ff04",
   127 => x"264d2626",
   128 => x"264b264c",
   129 => x"4a711e4f",
   130 => x"5ac1f1c2",
   131 => x"48c1f1c2",
   132 => x"fe4978c7",
   133 => x"4f2687dd",
   134 => x"711e731e",
   135 => x"aab7c04a",
   136 => x"c287d303",
   137 => x"05bff2d5",
   138 => x"4bc187c4",
   139 => x"4bc087c2",
   140 => x"5bf6d5c2",
   141 => x"d5c287c4",
   142 => x"d5c25af6",
   143 => x"c14abff2",
   144 => x"a2c0c19a",
   145 => x"87e8ec49",
   146 => x"d5c248fc",
   147 => x"fe78bff2",
   148 => x"711e87ef",
   149 => x"1e66c44a",
   150 => x"e2e64972",
   151 => x"4f262687",
   152 => x"f2d5c21e",
   153 => x"c4e349bf",
   154 => x"f5f0c287",
   155 => x"78bfe848",
   156 => x"48f1f0c2",
   157 => x"c278bfec",
   158 => x"4abff5f0",
   159 => x"99ffc349",
   160 => x"722ab7c8",
   161 => x"c2b07148",
   162 => x"2658fdf0",
   163 => x"5b5e0e4f",
   164 => x"710e5d5c",
   165 => x"87c8ff4b",
   166 => x"48f0f0c2",
   167 => x"497350c0",
   168 => x"7087eae2",
   169 => x"9cc24c49",
   170 => x"cb49eecb",
   171 => x"497087cc",
   172 => x"f0f0c24d",
   173 => x"c105bf97",
   174 => x"66d087e2",
   175 => x"f9f0c249",
   176 => x"d60599bf",
   177 => x"4966d487",
   178 => x"bff1f0c2",
   179 => x"87cb0599",
   180 => x"f8e14973",
   181 => x"02987087",
   182 => x"c187c1c1",
   183 => x"87c0fe4c",
   184 => x"e1ca4975",
   185 => x"02987087",
   186 => x"f0c287c6",
   187 => x"50c148f0",
   188 => x"97f0f0c2",
   189 => x"e3c005bf",
   190 => x"f9f0c287",
   191 => x"66d049bf",
   192 => x"d6ff0599",
   193 => x"f1f0c287",
   194 => x"66d449bf",
   195 => x"caff0599",
   196 => x"e0497387",
   197 => x"987087f7",
   198 => x"87fffe05",
   199 => x"dcfb4874",
   200 => x"5b5e0e87",
   201 => x"f40e5d5c",
   202 => x"4c4dc086",
   203 => x"c47ebfec",
   204 => x"f0c248a6",
   205 => x"c178bffd",
   206 => x"c71ec01e",
   207 => x"87cdfd49",
   208 => x"987086c8",
   209 => x"ff87ce02",
   210 => x"87ccfb49",
   211 => x"ff49dac1",
   212 => x"c187fadf",
   213 => x"f0f0c24d",
   214 => x"c302bf97",
   215 => x"87c4d087",
   216 => x"bff5f0c2",
   217 => x"f2d5c24b",
   218 => x"ebc005bf",
   219 => x"49fdc387",
   220 => x"87d9dfff",
   221 => x"ff49fac3",
   222 => x"7387d2df",
   223 => x"99ffc349",
   224 => x"49c01e71",
   225 => x"7387cbfb",
   226 => x"29b7c849",
   227 => x"49c11e71",
   228 => x"c887fffa",
   229 => x"87c0c686",
   230 => x"bff9f0c2",
   231 => x"dd029b4b",
   232 => x"eed5c287",
   233 => x"ddc749bf",
   234 => x"05987087",
   235 => x"4bc087c4",
   236 => x"e0c287d2",
   237 => x"87c2c749",
   238 => x"58f2d5c2",
   239 => x"d5c287c6",
   240 => x"78c048ee",
   241 => x"99c24973",
   242 => x"c387ce05",
   243 => x"ddff49eb",
   244 => x"497087fb",
   245 => x"c20299c2",
   246 => x"734cfb87",
   247 => x"0599c149",
   248 => x"f4c387ce",
   249 => x"e4ddff49",
   250 => x"c2497087",
   251 => x"87c20299",
   252 => x"49734cfa",
   253 => x"ce0599c8",
   254 => x"49f5c387",
   255 => x"87cdddff",
   256 => x"99c24970",
   257 => x"c287d502",
   258 => x"02bfc1f1",
   259 => x"c14887ca",
   260 => x"c5f1c288",
   261 => x"87c2c058",
   262 => x"4dc14cff",
   263 => x"99c44973",
   264 => x"c387ce05",
   265 => x"dcff49f2",
   266 => x"497087e3",
   267 => x"dc0299c2",
   268 => x"c1f1c287",
   269 => x"c7487ebf",
   270 => x"c003a8b7",
   271 => x"486e87cb",
   272 => x"f1c280c1",
   273 => x"c2c058c5",
   274 => x"c14cfe87",
   275 => x"49fdc34d",
   276 => x"87f9dbff",
   277 => x"99c24970",
   278 => x"c287d502",
   279 => x"02bfc1f1",
   280 => x"c287c9c0",
   281 => x"c048c1f1",
   282 => x"87c2c078",
   283 => x"4dc14cfd",
   284 => x"ff49fac3",
   285 => x"7087d6db",
   286 => x"0299c249",
   287 => x"c287d9c0",
   288 => x"48bfc1f1",
   289 => x"03a8b7c7",
   290 => x"c287c9c0",
   291 => x"c748c1f1",
   292 => x"87c2c078",
   293 => x"4dc14cfc",
   294 => x"03acb7c0",
   295 => x"c487d1c0",
   296 => x"d8c14a66",
   297 => x"c0026a82",
   298 => x"4b6a87c6",
   299 => x"0f734974",
   300 => x"f0c31ec0",
   301 => x"49dac11e",
   302 => x"c887d2f7",
   303 => x"02987086",
   304 => x"c887e2c0",
   305 => x"f1c248a6",
   306 => x"c878bfc1",
   307 => x"91cb4966",
   308 => x"714866c4",
   309 => x"6e7e7080",
   310 => x"c8c002bf",
   311 => x"4bbf6e87",
   312 => x"734966c8",
   313 => x"029d750f",
   314 => x"c287c8c0",
   315 => x"49bfc1f1",
   316 => x"c287c0f3",
   317 => x"02bff6d5",
   318 => x"4987ddc0",
   319 => x"7087c7c2",
   320 => x"d3c00298",
   321 => x"c1f1c287",
   322 => x"e6f249bf",
   323 => x"f449c087",
   324 => x"d5c287c6",
   325 => x"78c048f6",
   326 => x"e0f38ef4",
   327 => x"5b5e0e87",
   328 => x"1e0e5d5c",
   329 => x"f0c24c71",
   330 => x"c149bffd",
   331 => x"c14da1cd",
   332 => x"7e6981d1",
   333 => x"cf029c74",
   334 => x"4ba5c487",
   335 => x"f0c27b74",
   336 => x"f249bffd",
   337 => x"7b6e87ff",
   338 => x"c4059c74",
   339 => x"c24bc087",
   340 => x"734bc187",
   341 => x"87c0f349",
   342 => x"c70266d4",
   343 => x"87da4987",
   344 => x"87c24a70",
   345 => x"d5c24ac0",
   346 => x"f2265afa",
   347 => x"000087cf",
   348 => x"00000000",
   349 => x"00000000",
   350 => x"711e0000",
   351 => x"bfc8ff4a",
   352 => x"48a17249",
   353 => x"ff1e4f26",
   354 => x"fe89bfc8",
   355 => x"c0c0c0c0",
   356 => x"c401a9c0",
   357 => x"c24ac087",
   358 => x"724ac187",
   359 => x"0e4f2648",
   360 => x"5d5c5b5e",
   361 => x"ff4b710e",
   362 => x"66d04cd4",
   363 => x"d678c048",
   364 => x"d0d8ff49",
   365 => x"7cffc387",
   366 => x"ffc3496c",
   367 => x"494d7199",
   368 => x"c199f0c3",
   369 => x"cb05a9e0",
   370 => x"7cffc387",
   371 => x"98c3486c",
   372 => x"780866d0",
   373 => x"6c7cffc3",
   374 => x"31c8494a",
   375 => x"6c7cffc3",
   376 => x"72b2714a",
   377 => x"c331c849",
   378 => x"4a6c7cff",
   379 => x"4972b271",
   380 => x"ffc331c8",
   381 => x"714a6c7c",
   382 => x"48d0ffb2",
   383 => x"7378e0c0",
   384 => x"87c2029b",
   385 => x"48757b72",
   386 => x"4c264d26",
   387 => x"4f264b26",
   388 => x"0e4f261e",
   389 => x"0e5c5b5e",
   390 => x"1e7686f8",
   391 => x"fd49a6c8",
   392 => x"86c487fd",
   393 => x"486e4b70",
   394 => x"c203a8c2",
   395 => x"4a7387f0",
   396 => x"c19af0c3",
   397 => x"c702aad0",
   398 => x"aae0c187",
   399 => x"87dec205",
   400 => x"99c84973",
   401 => x"ff87c302",
   402 => x"4c7387c6",
   403 => x"acc29cc3",
   404 => x"87c2c105",
   405 => x"c94966c4",
   406 => x"c41e7131",
   407 => x"92d44a66",
   408 => x"49c5f1c2",
   409 => x"cdfe8172",
   410 => x"49d887f6",
   411 => x"87d5d5ff",
   412 => x"c21ec0c8",
   413 => x"fd49dedf",
   414 => x"ff87f1e9",
   415 => x"e0c048d0",
   416 => x"dedfc278",
   417 => x"4a66cc1e",
   418 => x"f1c292d4",
   419 => x"817249c5",
   420 => x"87fdcbfe",
   421 => x"acc186cc",
   422 => x"87c2c105",
   423 => x"c94966c4",
   424 => x"c41e7131",
   425 => x"92d44a66",
   426 => x"49c5f1c2",
   427 => x"ccfe8172",
   428 => x"dfc287ee",
   429 => x"66c81ede",
   430 => x"c292d44a",
   431 => x"7249c5f1",
   432 => x"fdc9fe81",
   433 => x"ff49d787",
   434 => x"c887fad3",
   435 => x"dfc21ec0",
   436 => x"e7fd49de",
   437 => x"86cc87ef",
   438 => x"c048d0ff",
   439 => x"8ef878e0",
   440 => x"0e87e7fc",
   441 => x"5d5c5b5e",
   442 => x"4d711e0e",
   443 => x"d44cd4ff",
   444 => x"c3487e66",
   445 => x"c506a8b7",
   446 => x"c148c087",
   447 => x"497587e2",
   448 => x"87c2dbfe",
   449 => x"66c41e75",
   450 => x"c293d44b",
   451 => x"7383c5f1",
   452 => x"d8c5fe49",
   453 => x"6b83c887",
   454 => x"48d0ff4b",
   455 => x"dd78e1c8",
   456 => x"c349737c",
   457 => x"7c7199ff",
   458 => x"b7c84973",
   459 => x"99ffc329",
   460 => x"49737c71",
   461 => x"c329b7d0",
   462 => x"7c7199ff",
   463 => x"b7d84973",
   464 => x"c07c7129",
   465 => x"7c7c7c7c",
   466 => x"7c7c7c7c",
   467 => x"7c7c7c7c",
   468 => x"c478e0c0",
   469 => x"49dc1e66",
   470 => x"87ced2ff",
   471 => x"487386c8",
   472 => x"87e4fa26",
   473 => x"f2dec21e",
   474 => x"b9c149bf",
   475 => x"59f6dec2",
   476 => x"c348d4ff",
   477 => x"d0ff78ff",
   478 => x"78e1c048",
   479 => x"c148d4ff",
   480 => x"7131c478",
   481 => x"48d0ff78",
   482 => x"2678e0c0",
   483 => x"dec21e4f",
   484 => x"ecc21ee6",
   485 => x"c3fe49d4",
   486 => x"86c487d3",
   487 => x"c3029870",
   488 => x"87c0ff87",
   489 => x"35314f26",
   490 => x"205a484b",
   491 => x"46432020",
   492 => x"00000047",
   493 => x"00000000",
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
