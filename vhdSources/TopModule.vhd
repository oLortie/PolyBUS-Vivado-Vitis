----------------------------------------------------------------------------------
-- Exercice1 Atelier #3 S4 G�nie informatique - H21
-- Larissa Njejimana
-- v.3 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity TopModule is
port (
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC; 

    sys_clock       : in std_logic;
    o_leds          : out std_logic_vector ( 3 downto 0 );
    i_sw            : in std_logic_vector ( 3 downto 0 );
    i_btn           : in std_logic_vector ( 3 downto 0 );
    o_ledtemoin_b   : out std_logic;
    
    Pmod_8LD        : inout std_logic_vector ( 7 downto 0 );  -- port JD
    Pmod_OLED       : inout std_logic_vector ( 7 downto 0 );  -- port_JE
    
    -- Pmod_AD1 - port_JC haut
    o_ADC_NCS       : out std_logic;  
    i_ADC_D0        : in std_logic;
    i_ADC_D1        : in std_logic;
    o_ADC_CLK       : out std_logic;
    
    -- Pmod_DAC - port_JD haut
    o_DAC_NCS       : out std_logic;  
    o_DAC_D0        : out std_logic;
    o_DAC_D1        : out std_logic;
    o_DAC_CLK       : out std_logic
);
end TopModule;

architecture Behavioral of TopModule is

    constant freq_sys_MHz: integer := 125;  -- MHz
    
    ----------------------------------------------
    -- Respiration 0.25 Hz
    ----------------------------------------------
    
    type table_forme_respi is array (integer range 0 to 399) of std_logic_vector(11 downto 0);
    constant mem_respi025Hz : table_forme_respi := (
    -- 
    x"7FF",
    x"820",
    x"840",
    x"860",
    x"880",
    x"8A0",
    x"8C0",
    x"8E0",
    x"900",
    x"920",
    x"940",
    x"960",
    x"97F",
    x"99F",
    x"9BE",
    x"9DE",
    x"9FD",
    x"A1C",
    x"A3B",
    x"A5A",
    x"A78",
    x"A97",
    x"AB5",
    x"AD3",
    x"AF1",
    x"B0F",
    x"B2D",
    x"B4A",
    x"B67",
    x"B84",
    x"BA1",
    x"BBE",
    x"BDA",
    x"BF6",
    x"C12",
    x"C2D",
    x"C49",
    x"C64",
    x"C7F",
    x"C99",
    x"CB3",
    x"CCD",
    x"CE7",
    x"D00",
    x"D19",
    x"D31",
    x"D4A",
    x"D62",
    x"D79",
    x"D91",
    x"DA8",
    x"DBE",
    x"DD4",
    x"DEA",
    x"E00",
    x"E15",
    x"E29",
    x"E3E",
    x"E52",
    x"E65",
    x"E78",
    x"E8B",
    x"E9D",
    x"EAF",
    x"EC1",
    x"ED2",
    x"EE2",
    x"EF2",
    x"F02",
    x"F11",
    x"F20",
    x"F2F",
    x"F3C",
    x"F4A",
    x"F57",
    x"F63",
    x"F70",
    x"F7B",
    x"F86",
    x"F91",
    x"F9B",
    x"FA5",
    x"FAE",
    x"FB7",
    x"FBF",
    x"FC7",
    x"FCE",
    x"FD5",
    x"FDB",
    x"FE1",
    x"FE6",
    x"FEB",
    x"FEF",
    x"FF3",
    x"FF6",
    x"FF9",
    x"FFB",
    x"FFD",
    x"FFE",
    x"FFF",
    x"FFF",
    x"FFF",
    x"FFE",
    x"FFD",
    x"FFB",
    x"FF9",
    x"FF6",
    x"FF3",
    x"FEF",
    x"FEB",
    x"FE6",
    x"FE1",
    x"FDB",
    x"FD5",
    x"FCE",
    x"FC7",
    x"FBF",
    x"FB7",
    x"FAE",
    x"FA5",
    x"F9B",
    x"F91",
    x"F86",
    x"F7B",
    x"F70",
    x"F63",
    x"F57",
    x"F4A",
    x"F3C",
    x"F2F",
    x"F20",
    x"F11",
    x"F02",
    x"EF2",
    x"EE2",
    x"ED2",
    x"EC1",
    x"EAF",
    x"E9D",
    x"E8B",
    x"E78",
    x"E65",
    x"E52",
    x"E3E",
    x"E29",
    x"E15",
    x"E00",
    x"DEA",
    x"DD4",
    x"DBE",
    x"DA8",
    x"D91",
    x"D79",
    x"D62",
    x"D4A",
    x"D31",
    x"D19",
    x"D00",
    x"CE7",
    x"CCD",
    x"CB3",
    x"C99",
    x"C7F",
    x"C64",
    x"C49",
    x"C2D",
    x"C12",
    x"BF6",
    x"BDA",
    x"BBE",
    x"BA1",
    x"B84",
    x"B67",
    x"B4A",
    x"B2D",
    x"B0F",
    x"AF1",
    x"AD3",
    x"AB5",
    x"A97",
    x"A78",
    x"A5A",
    x"A3B",
    x"A1C",
    x"9FD",
    x"9DE",
    x"9BE",
    x"99F",
    x"97F",
    x"960",
    x"940",
    x"920",
    x"900",
    x"8E0",
    x"8C0",
    x"8A0",
    x"880",
    x"860",
    x"840",
    x"820",
    x"7FF",
    x"7DF",
    x"7BF",
    x"79F",
    x"77F",
    x"75F",
    x"73F",
    x"71F",
    x"6FF",
    x"6DF",
    x"6BF",
    x"69F",
    x"680",
    x"660",
    x"641",
    x"621",
    x"602",
    x"5E3",
    x"5C4",
    x"5A5",
    x"587",
    x"568",
    x"54A",
    x"52C",
    x"50E",
    x"4F0",
    x"4D2",
    x"4B5",
    x"497",
    x"47A",
    x"45E",
    x"441",
    x"425",
    x"409",
    x"3ED",
    x"3D1",
    x"3B6",
    x"39B",
    x"380",
    x"366",
    x"34C",
    x"332",
    x"318",
    x"2FF",
    x"2E6",
    x"2CD",
    x"2B5",
    x"29D",
    x"286",
    x"26E",
    x"257",
    x"241",
    x"22B",
    x"215",
    x"1FF",
    x"1EA",
    x"1D5",
    x"1C1",
    x"1AD",
    x"19A",
    x"187",
    x"174",
    x"162",
    x"150",
    x"13E",
    x"12D",
    x"11D",
    x"10D",
    x"0FD",
    x"0EE",
    x"0DF",
    x"0D0",
    x"0C2",
    x"0B5",
    x"0A8",
    x"09B",
    x"08F",
    x"084",
    x"079",
    x"06E",
    x"064",
    x"05A",
    x"051",
    x"048",
    x"040",
    x"038",
    x"031",
    x"02A",
    x"024",
    x"01E",
    x"019",
    x"014",
    x"010",
    x"00C",
    x"009",
    x"006",
    x"004",
    x"002",
    x"001",
    x"000",
    x"000",
    x"000",
    x"001",
    x"002",
    x"004",
    x"006",
    x"009",
    x"00C",
    x"010",
    x"014",
    x"019",
    x"01E",
    x"024",
    x"02A",
    x"031",
    x"038",
    x"040",
    x"048",
    x"051",
    x"05A",
    x"064",
    x"06E",
    x"079",
    x"084",
    x"08F",
    x"09B",
    x"0A8",
    x"0B5",
    x"0C2",
    x"0D0",
    x"0DF",
    x"0EE",
    x"0FD",
    x"10D",
    x"11D",
    x"12D",
    x"13E",
    x"150",
    x"162",
    x"174",
    x"187",
    x"19A",
    x"1AD",
    x"1C1",
    x"1D5",
    x"1EA",
    x"1FF",
    x"215",
    x"22B",
    x"241",
    x"257",
    x"26E",
    x"286",
    x"29D",
    x"2B5",
    x"2CD",
    x"2E6",
    x"2FF",
    x"318",
    x"332",
    x"34C",
    x"366",
    x"380",
    x"39B",
    x"3B6",
    x"3D1",
    x"3ED",
    x"409",
    x"425",
    x"441",
    x"45E",
    x"47A",
    x"497",
    x"4B5",
    x"4D2",
    x"4F0",
    x"50E",
    x"52C",
    x"54A",
    x"568",
    x"587",
    x"5A5",
    x"5C4",
    x"5E3",
    x"602",
    x"621",
    x"641",
    x"660",
    x"680",
    x"69F",
    x"6BF",
    x"6DF",
    x"6FF",
    x"71F",
    x"73F",
    x"75F",
    x"77F",
    x"79F",
    x"7BF",
    x"7DF" 
    -- 
    );
    
    ----------------------------------------------
    -- Pression sanguine 120/80
    ----------------------------------------------
    type table_forme_pre is array (integer range 0 to 99) of std_logic_vector(11 downto 0);
    constant mem_pre12080 : table_forme_pre := (
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"001",
    x"002",
    x"005",
    x"00C",
    x"018",
    x"02E",
    x"055",
    x"095",
    x"0F9",
    x"18D",
    x"25E",
    x"372",
    x"4CB",
    x"65E",
    x"814",
    x"9CC",
    x"B5A",
    x"C94",
    x"D54",
    x"D86",
    x"D28",
    x"C4E",
    x"B1B",
    x"9BE",
    x"865",
    x"739",
    x"654",
    x"5C6",
    x"590",
    x"5A8",
    x"5FD",
    x"67E",
    x"715",
    x"7B0",
    x"83F",
    x"8B3",
    x"904",
    x"92A",
    x"921",
    x"8EA",
    x"887",
    x"7FE",
    x"757",
    x"69B",
    x"5D3",
    x"508",
    x"442",
    x"388",
    x"2DF",
    x"249",
    x"1C8",
    x"15D",
    x"105",
    x"0BF",
    x"089",
    x"061",
    x"043",
    x"02D",
    x"01E",
    x"013",
    x"00C",
    x"007",
    x"004",
    x"002",
    x"001",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000"
        );
    
    ----------------------------------------------
    -- Pouls 70BPM
    ----------------------------------------------
    type table_forme_pouls is array (integer range 0 to 85) of std_logic_vector(11 downto 0);
    constant mem_pouls70 : table_forme_pouls := (
    x"187",
    x"1CF",
    x"29D",
    x"3DD",
    x"57C",
    x"762",
    x"96E",
    x"B7B",
    x"D66",
    x"EFA",
    x"FF0",
    x"FFF",
    x"EE8",
    x"CBD",
    x"9BD",
    x"627",
    x"245",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"097",
    x"26F",
    x"372",
    x"39B",
    x"31F",
    x"230",
    x"103",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"013",
    x"081",
    x"0C4",
    x"0CE",
    x"0A9",
    x"06A",
    x"028",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"004",
    x"01F",
    x"034",
    x"040",
    x"046",
    x"048",
    x"04A",
    x"04C",
    x"04F",
    x"053",
    x"059",
    x"05F",
    x"065",
    x"06A",
    x"06D",
    x"06D",
    x"06B",
    x"067",
    x"061",
    x"05A",
    x"051",
    x"046",
    x"03A",
    x"02D",
    x"01E",
    x"00D",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000"
    );
    
    ----------------------------------------------
    -- Perspiration 1
    ----------------------------------------------
    type table_forme_persp is array (integer range 0 to 499) of std_logic_vector(11 downto 0);
    constant mem_persp1 : table_forme_persp := (
    x"6A7",
    x"63E",
    x"5D5",
    x"56B",
    x"502",
    x"561",
    x"5C1",
    x"620",
    x"67F",
    x"6DF",
    x"759",
    x"7D4",
    x"84F",
    x"8C9",
    x"944",
    x"936",
    x"928",
    x"91A",
    x"90C",
    x"8FE",
    x"94D",
    x"99C",
    x"9EA",
    x"A39",
    x"A88",
    x"A30",
    x"9D8",
    x"980",
    x"929",
    x"8D1",
    x"92C",
    x"987",
    x"9E1",
    x"A3C",
    x"A97",
    x"A8C",
    x"A81",
    x"A76",
    x"A6B",
    x"A60",
    x"A6B",
    x"A77",
    x"A82",
    x"A8E",
    x"A9A",
    x"ADC",
    x"B1E",
    x"B60",
    x"BA2",
    x"BE3",
    x"BB8",
    x"B8D",
    x"B61",
    x"B36",
    x"B0A",
    x"AAE",
    x"A51",
    x"9F4",
    x"998",
    x"93B",
    x"9A4",
    x"A0D",
    x"A76",
    x"ADF",
    x"B48",
    x"B4E",
    x"B54",
    x"B5B",
    x"B61",
    x"B68",
    x"AEE",
    x"A74",
    x"9FA",
    x"981",
    x"907",
    x"8FA",
    x"8EC",
    x"8DF",
    x"8D2",
    x"8C5",
    x"8A1",
    x"87D",
    x"859",
    x"836",
    x"812",
    x"836",
    x"85A",
    x"87E",
    x"8A2",
    x"8C6",
    x"8BC",
    x"8B1",
    x"8A7",
    x"89D",
    x"892",
    x"8F0",
    x"94E",
    x"9AC",
    x"A0A",
    x"A68",
    x"AD6",
    x"B43",
    x"BB1",
    x"C1E",
    x"C8C",
    x"CC0",
    x"CF3",
    x"D27",
    x"D5B",
    x"D8E",
    x"DB9",
    x"DE5",
    x"E10",
    x"E3B",
    x"E66",
    x"E9D",
    x"ED3",
    x"F0A",
    x"F40",
    x"F77",
    x"F32",
    x"EED",
    x"EA8",
    x"E62",
    x"E1D",
    x"E76",
    x"ECE",
    x"F27",
    x"F80",
    x"FD8",
    x"F6F",
    x"F06",
    x"E9D",
    x"E34",
    x"DCB",
    x"E41",
    x"EB6",
    x"F2C",
    x"FA2",
    x"FFF",
    x"FE8",
    x"FD1",
    x"FBA",
    x"FA2",
    x"F8B",
    x"F79",
    x"F66",
    x"F54",
    x"F41",
    x"F2F",
    x"F2C",
    x"F29",
    x"F26",
    x"F24",
    x"F21",
    x"F6B",
    x"FB6",
    x"FFF",
    x"FFF",
    x"FFF",
    x"FFE",
    x"FFC",
    x"FFA",
    x"FF8",
    x"FF7",
    x"FC9",
    x"F9C",
    x"F6F",
    x"F42",
    x"F14",
    x"EEA",
    x"EBF",
    x"E94",
    x"E69",
    x"E3E",
    x"E01",
    x"DC4",
    x"D87",
    x"D4A",
    x"D0D",
    x"D39",
    x"D66",
    x"D92",
    x"DBF",
    x"DEB",
    x"DA3",
    x"D5B",
    x"D13",
    x"CCB",
    x"C83",
    x"C69",
    x"C50",
    x"C37",
    x"C1D",
    x"C04",
    x"BC0",
    x"B7C",
    x"B38",
    x"AF4",
    x"AB0",
    x"A6A",
    x"A23",
    x"9DD",
    x"997",
    x"950",
    x"96E",
    x"98B",
    x"9A9",
    x"9C6",
    x"9E4",
    x"9B2",
    x"97F",
    x"94D",
    x"91A",
    x"8E8",
    x"8F3",
    x"8FD",
    x"908",
    x"913",
    x"91E",
    x"8DE",
    x"89E",
    x"85F",
    x"81F",
    x"7DF",
    x"83F",
    x"89E",
    x"8FD",
    x"95D",
    x"9BC",
    x"98A",
    x"958",
    x"926",
    x"8F4",
    x"8C2",
    x"8AB",
    x"893",
    x"87B",
    x"863",
    x"84C",
    x"85C",
    x"86C",
    x"87D",
    x"88D",
    x"89D",
    x"836",
    x"7CE",
    x"766",
    x"6FF",
    x"697",
    x"65A",
    x"61D",
    x"5E1",
    x"5A4",
    x"567",
    x"57C",
    x"592",
    x"5A7",
    x"5BC",
    x"5D1",
    x"57E",
    x"52B",
    x"4D8",
    x"486",
    x"433",
    x"407",
    x"3DC",
    x"3B1",
    x"386",
    x"35B",
    x"370",
    x"385",
    x"399",
    x"3AE",
    x"3C3",
    x"422",
    x"481",
    x"4E1",
    x"540",
    x"59F",
    x"5E7",
    x"630",
    x"678",
    x"6C0",
    x"708",
    x"6A6",
    x"644",
    x"5E2",
    x"581",
    x"51F",
    x"4F5",
    x"4CC",
    x"4A3",
    x"47A",
    x"450",
    x"3E8",
    x"380",
    x"318",
    x"2B0",
    x"248",
    x"2A6",
    x"304",
    x"361",
    x"3BF",
    x"41D",
    x"412",
    x"407",
    x"3FB",
    x"3F0",
    x"3E5",
    x"36A",
    x"2EF",
    x"274",
    x"1FA",
    x"17F",
    x"1A1",
    x"1C3",
    x"1E5",
    x"207",
    x"229",
    x"285",
    x"2E2",
    x"33F",
    x"39B",
    x"3F8",
    x"3D4",
    x"3AF",
    x"38B",
    x"367",
    x"343",
    x"33C",
    x"335",
    x"32E",
    x"327",
    x"320",
    x"378",
    x"3D0",
    x"427",
    x"47F",
    x"4D7",
    x"48A",
    x"43E",
    x"3F2",
    x"3A5",
    x"359",
    x"308",
    x"2B7",
    x"265",
    x"214",
    x"1C3",
    x"1A9",
    x"18F",
    x"175",
    x"15B",
    x"141",
    x"1B1",
    x"221",
    x"291",
    x"301",
    x"371",
    x"3C0",
    x"40F",
    x"45F",
    x"4AE",
    x"4FD",
    x"4B5",
    x"46D",
    x"425",
    x"3DD",
    x"394",
    x"3BB",
    x"3E2",
    x"409",
    x"430",
    x"457",
    x"44B",
    x"43F",
    x"434",
    x"428",
    x"41C",
    x"441",
    x"467",
    x"48C",
    x"4B1",
    x"4D6",
    x"4AE",
    x"486",
    x"45F",
    x"437",
    x"40F",
    x"3A7",
    x"33F",
    x"2D6",
    x"26E",
    x"206",
    x"208",
    x"20A",
    x"20D",
    x"20F",
    x"211",
    x"1E9",
    x"1C0",
    x"197",
    x"16E",
    x"146",
    x"10F",
    x"0D9",
    x"0A3",
    x"06D",
    x"037",
    x"044",
    x"051",
    x"05D",
    x"06A",
    x"077",
    x"092",
    x"0AD",
    x"0C9",
    x"0E4",
    x"0FF",
    x"0D0",
    x"0A1",
    x"072",
    x"043",
    x"014",
    x"025",
    x"036",
    x"047",
    x"058",
    x"06A",
    x"0CD",
    x"131",
    x"194",
    x"1F8",
    x"25C",
    x"2B1",
    x"306",
    x"35B",
    x"3B1",
    x"406",
    x"3C7",
    x"388",
    x"349",
    x"30A",
    x"2CB",
    x"29F",
    x"272",
    x"246",
    x"21A",
    x"1EE",
    x"236",
    x"27F",
    x"2C7",
    x"310",
    x"359",
    x"306",
    x"2B4",
    x"261",
    x"20E",
    x"1BC",
    x"186",
    x"150",
    x"11A",
    x"0E4",
    x"0AD",
    x"0C0",
    x"0D2",
    x"0E5",
    x"0F7",
    x"10A",
    x"09D",
    x"030",
    x"000",
    x"000",
    x"000",
    x"042",
    x"084",
    x"0C6",
    x"108",
    x"14A",
    x"138",
    x"126",
    x"115",
    x"103",
    x"0F1",
    x"10A",
    x"123",
    x"13C",
    x"156",
    x"16F",
    x"0FE",
    x"08C",
    x"01B",
    x"000",
    x"000",
    x"065",
    x"0CB",
    x"130",
    x"196",
    x"1FB"
    );
    
    component PolyBUSBlockDesign_wrapper is
        port (
            DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
            DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
            DDR_cas_n : inout STD_LOGIC;
            DDR_ck_n : inout STD_LOGIC;
            DDR_ck_p : inout STD_LOGIC;
            DDR_cke : inout STD_LOGIC;
            DDR_cs_n : inout STD_LOGIC;
            DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
            DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
            DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
            DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
            DDR_odt : inout STD_LOGIC;
            DDR_ras_n : inout STD_LOGIC;
            DDR_reset_n : inout STD_LOGIC;
            DDR_we_n : inout STD_LOGIC;
            FIXED_IO_ddr_vrn : inout STD_LOGIC;
            FIXED_IO_ddr_vrp : inout STD_LOGIC;
            FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
            FIXED_IO_ps_clk : inout STD_LOGIC;
            FIXED_IO_ps_porb : inout STD_LOGIC;
            FIXED_IO_ps_srstb : inout STD_LOGIC;
            Pmod_8LD_pin10_io : inout STD_LOGIC;
            Pmod_8LD_pin1_io : inout STD_LOGIC;
            Pmod_8LD_pin2_io : inout STD_LOGIC;
            Pmod_8LD_pin3_io : inout STD_LOGIC;
            Pmod_8LD_pin4_io : inout STD_LOGIC;
            Pmod_8LD_pin7_io : inout STD_LOGIC;
            Pmod_8LD_pin8_io : inout STD_LOGIC;
            Pmod_8LD_pin9_io : inout STD_LOGIC;
            Pmod_OLED_pin10_io : inout STD_LOGIC;
            Pmod_OLED_pin1_io : inout STD_LOGIC;
            Pmod_OLED_pin2_io : inout STD_LOGIC;
            Pmod_OLED_pin3_io : inout STD_LOGIC;
            Pmod_OLED_pin4_io : inout STD_LOGIC;
            Pmod_OLED_pin7_io : inout STD_LOGIC;
            Pmod_OLED_pin8_io : inout STD_LOGIC;
            Pmod_OLED_pin9_io : inout STD_LOGIC;
            i_data_echantillon1 : in STD_LOGIC_VECTOR ( 11 downto 0 );
            i_data_echantillon2 : in STD_LOGIC_VECTOR ( 11 downto 0 );
            i_data_echantillon3 : in STD_LOGIC_VECTOR ( 11 downto 0 );
            i_data_echantillon4 : in STD_LOGIC_VECTOR ( 11 downto 0 );
            i_sw_tri_i : in STD_LOGIC_VECTOR ( 3 downto 0 );
            o_data_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
            o_leds_tri_o : out STD_LOGIC_VECTOR ( 3 downto 0 )
            );
    end component;

    component Ctrl_DAC
    Port (
        reset                       : in    std_logic;  
        clk_DAC                     : in    std_logic; 						-- Horloge � fournir � l'ADC
        i_data                      : in    std_logic_vector (11 downto 0); -- �chantillon � envoyer        
        i_DAC_Strobe                : in    std_logic;                      -- Synchronisation: strobe d�clencheur de la s�quence de r�ception
        
        o_DAC_nCS                   : out   std_logic;                      -- Signal Chip select vers le DAC  
        o_bit_value                 : out   std_logic                       -- valeur du bit � envoyer
        );
    end component;
    
    component Ctrl_AD1
    port ( 
        reset                       : in    std_logic;  
        clk_ADC                     : in    std_logic; 						-- Horloge � fournir � l'ADC
        i_DO                        : in    std_logic;                      -- Bit de donn�e en provenance de l'ADC         
        o_ADC_nCS                   : out   std_logic;                      -- Signal Chip select vers l'ADC 
        
        i_ADC_Strobe                : in    std_logic;                      -- Synchronisation: strobe d�clencheur de la s�quence de r�ception    
        o_echantillon_pret_strobe   : out   std_logic;                      -- strobe indicateur d'une r�ception compl�te d'un �chantillon  
        o_echantillon               : out   std_logic_vector (11 downto 0)  -- valeur de l'�chantillon re�u
    );
    end component;
   
    component Synchro_Horloges is
    generic (const_CLK_syst_MHz: integer := freq_sys_MHz);
    Port ( 
        clkm        : in  std_logic;  -- Entr�e  horloge maitre   (50 MHz soit 20 ns ou 100 MHz soit 10 ns)
        o_S_5MHz    : out std_logic;  -- source horloge divisee          (clkm MHz / (2*constante_diviseur_p +2) devrait donner 5 MHz soit 200 ns)
        o_CLK_5MHz  : out std_logic;
        o_S_100Hz   : out  std_logic; -- source horloge 100 Hz : out  std_logic;   -- (100  Hz approx:  99,952 Hz) 
        o_stb_100Hz : out  std_logic; -- strobe 100Hz synchro sur clk_5MHz 
        o_S_1Hz     : out  std_logic  -- Signal temoin 1 Hz
    );
    end component;  
    
    signal clk_5MHz                     : std_logic;
    signal d_S_5MHz                     : std_logic;
    signal d_strobe_100Hz               : std_logic := '0';  -- cadence echantillonnage AD1
    signal d_strobe_100Hz_ADC           : std_logic := '0';
    
    signal reset                        : std_logic; 
    
    signal o_echantillon_pret_strobe    : std_logic;
    signal d_ADC_Dselect                : std_logic;
    signal d_DAC_data1                  : std_logic_vector (11 downto 0);
    signal d_DAC_data2                  : std_logic_vector (11 downto 0);
    signal d_echantillon1               : std_logic_vector (11 downto 0);
    signal d_echantillon2               : std_logic_vector (11 downto 0); 
    signal d_echantillon3               : std_logic_vector (11 downto 0); 
    signal d_echantillon4               : std_logic_vector (11 downto 0);  
    
    signal d_compteurRespiration : integer range 0 to 500 := 0;
    signal d_compteurPression : integer range 0 to 500 := 0;
    signal d_compteurPouls : integer range 0 to 500 := 0;
    signal d_compteurPerspiration : integer range 0 to 500 := 0;
    
    signal d_compteurDelaiStrobe : integer range 0 to 501 := 0;
    signal d_compteDelai : std_logic := '0';

begin
    reset    <= i_btn(0);    
    
    inst_Ctrl_DAC : Ctrl_DAC
    Port Map (
        reset => reset,  
        clk_DAC => clk_5MHz,
        i_data => d_DAC_data1,      
        i_DAC_Strobe => d_strobe_100Hz,
        o_DAC_nCS => o_DAC_NCS,
        o_bit_value => o_DAC_D0
        );
    
    inst_Ctrl_AD1 : Ctrl_AD1
    port Map ( 
        reset => reset,
        clk_ADC => clk_5MHz,
        i_DO => i_ADC_D0,       
        o_ADC_nCS => o_ADC_NCS,
        i_ADC_Strobe => d_strobe_100Hz_ADC,
        o_echantillon_pret_strobe => o_echantillon_pret_strobe,
        o_echantillon => d_echantillon1
    );
    
    
     mux_select_Entree_AD1 : process (i_btn(3), i_ADC_D0, i_ADC_D1)
     begin
          if (i_btn(3) ='0') then 
            d_ADC_Dselect <= i_ADC_D0;
          else
            d_ADC_Dselect <= i_ADC_D1;
          end if;
     end process;


      
   Synchronisation : Synchro_Horloges
    port map (
           clkm         =>  sys_clock,
           o_S_5MHz     =>  o_ADC_CLK,
           o_CLK_5MHz   => clk_5MHz,
           o_S_100Hz    => open,
           o_stb_100Hz  => d_strobe_100Hz,
           o_S_1Hz      => o_ledtemoin_b
    );
    
    o_DAC_CLK <= clk_5MHz;
    
    BlockDesign : PolyBUSBlockDesign_wrapper
        port map(
            DDR_addr => DDR_addr,
            DDR_ba => DDR_ba,
            DDR_cas_n => DDR_cas_n,
            DDR_ck_n => DDR_ck_n,
            DDR_ck_p => DDR_ck_p,
            DDR_cke => DDR_cke,
            DDR_cs_n => DDR_cs_n,
            DDR_dm => DDR_dm,
            DDR_dq => DDR_dq,
            DDR_dqs_n => DDR_dqs_n,
            DDR_dqs_p => DDR_dqs_p,
            DDR_odt => DDR_odt,
            DDR_ras_n => DDR_ras_n,
            DDR_reset_n => DDR_reset_n,
            DDR_we_n => DDR_we_n,
            FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
            FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
            FIXED_IO_mio =>FIXED_IO_mio ,
            FIXED_IO_ps_clk => FIXED_IO_ps_clk,
            FIXED_IO_ps_porb => FIXED_IO_ps_porb,
            FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
            Pmod_8LD_pin1_io => Pmod_8LD(0),
            Pmod_8LD_pin2_io => Pmod_8LD(1),
            Pmod_8LD_pin3_io => Pmod_8LD(2),
            Pmod_8LD_pin4_io => Pmod_8LD(3),
            Pmod_8LD_pin7_io => Pmod_8LD(4),
            Pmod_8LD_pin8_io => Pmod_8LD(5),
            Pmod_8LD_pin9_io => Pmod_8LD(6),
            Pmod_8LD_pin10_io => Pmod_8LD(7),
            Pmod_OLED_pin1_io => Pmod_OLED(0),
            Pmod_OLED_pin2_io => Pmod_OLED(1),
            Pmod_OLED_pin3_io => Pmod_OLED(2),
            Pmod_OLED_pin4_io => Pmod_OLED(3),
            Pmod_OLED_pin7_io => Pmod_OLED(4),
            Pmod_OLED_pin8_io => Pmod_OLED(5),
            Pmod_OLED_pin9_io => Pmod_OLED(6),
            Pmod_OLED_pin10_io => Pmod_OLED(7),
            i_data_echantillon1 => d_echantillon1,
            i_data_echantillon2 => d_echantillon2,
            i_data_echantillon3 => d_echantillon3,
            i_data_echantillon4 => d_echantillon4,
            i_sw_tri_i => i_sw,
            o_data_out => open,
            o_leds_tri_o => o_leds
        );
        
    main_process : process (d_strobe_100Hz)
    begin
        if rising_edge(d_strobe_100Hz) then
            d_DAC_data1 <= mem_pouls70(d_compteurPouls);
            d_DAC_data2 <= mem_pre12080(d_compteurPression);
            d_echantillon3 <= mem_respi025Hz(d_compteurRespiration);
            d_echantillon4 <= mem_persp1(d_compteurPerspiration);
            
            if d_compteurPouls = mem_pouls70'length-1 then
                d_compteurPouls <= 0;
            else
                d_compteurPouls <= d_compteurPouls + 1;
            end if;
            
            if d_compteurPression = mem_pre12080'length-1 then
                d_compteurPression <= 0;
            else
                d_compteurPression <= d_compteurPression + 1;
            end if;
            
            if d_compteurRespiration = mem_respi025Hz'length-1 then
                d_compteurRespiration <= 0;
            else
                d_compteurRespiration <= d_compteurRespiration + 1;
            end if;
            
            if d_compteurPerspiration = mem_persp1'length-1 then
                d_compteurPerspiration <= 0;
            else
                d_compteurPerspiration <= d_compteurPerspiration + 1;
            end if;
        end if;
    end process;
    
    DAC_ADC_Strobe : process (d_strobe_100Hz, clk_5MHz)
    begin
        if rising_edge(clk_5MHz) then
            if (d_strobe_100Hz = '1') then
                d_compteDelai <= '1';
            end if;
            if (d_compteDelai = '1') then
                if (d_compteurDelaiStrobe = 500) then
                    d_compteDelai <= '0';
                    d_compteurDelaiStrobe <= 0;
                    d_strobe_100Hz_ADC <= '1';
                else
                    d_compteurDelaiStrobe <= d_compteurDelaiStrobe + 1;
                    d_strobe_100Hz_ADC <= '0';
                end if;
            else
                d_strobe_100Hz_ADC <= '0';
            end if;
        end if;
    end process;
      
end Behavioral;

