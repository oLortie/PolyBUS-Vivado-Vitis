----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/26/2021 04:45:52 PM
-- Design Name: 
-- Module Name: PolyBUS_package - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package PolyBUS_package is
    
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
    
    -----------------------------------------------
    -- Respiration 0.5 Hz
    -----------------------------------------------
    type table_forme_respi2 is array (integer range 0 to 199) of std_logic_vector(11 downto 0);
    constant mem_respi05Hz : table_forme_respi2 := (
    x"7FF",
    x"840",
    x"880",
    x"8C0",
    x"900",
    x"940",
    x"97F",
    x"9BE",
    x"9FD",
    x"A3B",
    x"A78",
    x"AB5",
    x"AF1",
    x"B2D",
    x"B67",
    x"BA1",
    x"BDA",
    x"C12",
    x"C49",
    x"C7F",
    x"CB3",
    x"CE7",
    x"D19",
    x"D4A",
    x"D79",
    x"DA8",
    x"DD4",
    x"E00",
    x"E29",
    x"E52",
    x"E78",
    x"E9D",
    x"EC1",
    x"EE2",
    x"F02",
    x"F20",
    x"F3C",
    x"F57",
    x"F70",
    x"F86",
    x"F9B",
    x"FAE",
    x"FBF",
    x"FCE",
    x"FDB",
    x"FE6",
    x"FEF",
    x"FF6",
    x"FFB",
    x"FFE",
    x"FFF",
    x"FFE",
    x"FFB",
    x"FF6",
    x"FEF",
    x"FE6",
    x"FDB",
    x"FCE",
    x"FBF",
    x"FAE",
    x"F9B",
    x"F86",
    x"F70",
    x"F57",
    x"F3C",
    x"F20",
    x"F02",
    x"EE2",
    x"EC1",
    x"E9D",
    x"E78",
    x"E52",
    x"E29",
    x"E00",
    x"DD4",
    x"DA8",
    x"D79",
    x"D4A",
    x"D19",
    x"CE7",
    x"CB3",
    x"C7F",
    x"C49",
    x"C12",
    x"BDA",
    x"BA1",
    x"B67",
    x"B2D",
    x"AF1",
    x"AB5",
    x"A78",
    x"A3B",
    x"9FD",
    x"9BE",
    x"97F",
    x"940",
    x"900",
    x"8C0",
    x"880",
    x"840",
    x"7FF",
    x"7BF",
    x"77F",
    x"73F",
    x"6FF",
    x"6BF",
    x"680",
    x"641",
    x"602",
    x"5C4",
    x"587",
    x"54A",
    x"50E",
    x"4D2",
    x"497",
    x"45E",
    x"425",
    x"3ED",
    x"3B6",
    x"380",
    x"34C",
    x"318",
    x"2E6",
    x"2B5",
    x"286",
    x"257",
    x"22B",
    x"1FF",
    x"1D5",
    x"1AD",
    x"187",
    x"162",
    x"13E",
    x"11D",
    x"0FD",
    x"0DF",
    x"0C2",
    x"0A8",
    x"08F",
    x"079",
    x"064",
    x"051",
    x"040",
    x"031",
    x"024",
    x"019",
    x"010",
    x"009",
    x"004",
    x"001",
    x"000",
    x"001",
    x"004",
    x"009",
    x"010",
    x"019",
    x"024",
    x"031",
    x"040",
    x"051",
    x"064",
    x"079",
    x"08F",
    x"0A8",
    x"0C2",
    x"0DF",
    x"0FD",
    x"11D",
    x"13E",
    x"162",
    x"187",
    x"1AD",
    x"1D5",
    x"1FF",
    x"22B",
    x"257",
    x"286",
    x"2B5",
    x"2E6",
    x"318",
    x"34C",
    x"380",
    x"3B6",
    x"3ED",
    x"425",
    x"45E",
    x"497",
    x"4D2",
    x"50E",
    x"54A",
    x"587",
    x"5C4",
    x"602",
    x"641",
    x"680",
    x"6BF",
    x"6FF",
    x"73F",
    x"77F",
    x"7BF"
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
    
    --------------------------------------------
    -- Pression 130/80
    --------------------------------------------
    constant mem_pre13080 : table_forme_pre := (
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
    x"006",
    x"00D",
    x"01A",
    x"032",
    x"05C",
    x"0A1",
    x"10E",
    x"1AF",
    x"290",
    x"3BC",
    x"531",
    x"6E5",
    x"8C0",
    x"A9B",
    x"C4A",
    x"D9D",
    x"E6C",
    x"EA0",
    x"E38",
    x"D48",
    x"BF7",
    x"A76",
    x"8F8",
    x"7A9",
    x"6A7",
    x"600",
    x"5B6",
    x"5C0",
    x"60C",
    x"686",
    x"71A",
    x"7B2",
    x"840",
    x"8B4",
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
    x"001"
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
    
    ---------------------------------------------
    -- Pouls 85 BPM
    ---------------------------------------------
    type table_forme_pouls2 is array (integer range 0 to 70) of std_logic_vector(11 downto 0);
    constant mem_pouls85 : table_forme_pouls2 := (
    x"093",
    x"0EF",
    x"1F3",
    x"383",
    x"582",
    x"7CB",
    x"A2D",
    x"C78",
    x"E71",
    x"FBD",
    x"FFF",
    x"EE5",
    x"C8A",
    x"93F",
    x"557",
    x"140",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"184",
    x"31C",
    x"3B3",
    x"372",
    x"299",
    x"16A",
    x"027",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"068",
    x"0AE",
    x"0B7",
    x"086",
    x"037",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"000",
    x"017",
    x"025",
    x"02F",
    x"036",
    x"03B",
    x"03D",
    x"03D",
    x"03A",
    x"033",
    x"029",
    x"01A",
    x"00A",
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
    
    --------------------------------------------
    -- Perspiration 2
    --------------------------------------------
--    constant mem_persp2 : table_forme_persp := (
--    x"117",
--    x"139",
--    x"15C",
--    x"17E",
--    x"1A0",
--    x"1C3",
--    x"1E5",
--    x"207",
--    x"22A",
--    x"24C",
--    x"232",
--    x"218",
--    x"1FD",
--    x"1E3",
--    x"1C9",
--    x"1AF",
--    x"195",
--    x"17B",
--    x"160",
--    x"146",
--    x"10F",
--    x"0D7",
--    x"0A0",
--    x"068",
--    x"031",
--    x"000",
--    x"000",
--    x"000",
--    x"000",
--    x"000",
--    x"000",
--    x"000",
--    x"000",
--    x"000",
--    x"000",
--    x"000",
--    x"000",
--    x"000",
--    x"000",
--    x"000",
--    x"031",
--    x"063",
--    x"094",
--    x"0C6",
--    x"0F7",
--    x"129",
--    x"15B",
--    x"18C",
--    x"1BE",
--    x"1EF",
--    x"225",
--    x"25B",
--    x"292",
--    x"2C8",
--    x"2FE",
--    x"334",
--    x"36A",
--    x"3A0",
--    x"3D6",
--    x"40C",
--    x"3F8",
--    x"3E3",
--    x"3CF",
--    x"3BA",
--    x"3A6",
--    x"391",
--    x"37D",
--    x"368",
--    x"354",
--    x"33F",
--    x"34D",
--    x"35B",
--    x"369",
--    x"377",
--    x"385",
--    x"393",
--    x"3A1",
--    x"3AF",
--    x"3BD",
--    x"3CB",
--    x"3E9",
--    x"408",
--    x"426",
--    x"444",
--    x"462",
--    x"481",
--    x"49F",
--    x"4BD",
--    x"4DC",
--    x"4FA",
--    x"50C",
--    x"51E",
--    x"530",
--    x"542",
--    x"554",
--    x"566",
--    x"578",
--    x"58A",
--    x"59C",
--    x"5AE",
--    x"598",
--    x"582",
--    x"56B",
--    x"555",
--    x"53F",
--    x"529",
--    x"513",
--    x"4FC",
--    x"4E6",
--    x"4D0",
--    x"4CC",
--    x"4C7",
--    x"4C3",
--    x"4BF",
--    x"4BB",
--    x"4B6",
--    x"4B2",
--    x"4AE",
--    x"4AA",
--    x"4A6",
--    x"4E0",
--    x"51B",
--    x"556",
--    x"590",
--    x"5CB",
--    x"606",
--    x"640",
--    x"67B",
--    x"6B6",
--    x"6F0",
--    x"6B3",
--    x"675",
--    x"638",
--    x"5FB",
--    x"5BD",
--    x"580",
--    x"542",
--    x"505",
--    x"4C7",
--    x"48A",
--    x"4B6",
--    x"4E2",
--    x"50E",
--    x"53B",
--    x"567",
--    x"593",
--    x"5BF",
--    x"5EB",
--    x"617",
--    x"643",
--    x"641",
--    x"63F",
--    x"63C",
--    x"63A",
--    x"638",
--    x"635",
--    x"633",
--    x"631",
--    x"62E",
--    x"62C",
--    x"649",
--    x"667",
--    x"684",
--    x"6A1",
--    x"6BF",
--    x"6DC",
--    x"6F9",
--    x"717",
--    x"734",
--    x"751",
--    x"748",
--    x"73E",
--    x"735",
--    x"72B",
--    x"721",
--    x"718",
--    x"70E",
--    x"705",
--    x"6FB",
--    x"6F2",
--    x"72D",
--    x"769",
--    x"7A5",
--    x"7E0",
--    x"81C",
--    x"858",
--    x"894",
--    x"8CF",
--    x"90B",
--    x"947",
--    x"934",
--    x"920",
--    x"90D",
--    x"8FA",
--    x"8E7",
--    x"8D4",
--    x"8C1",
--    x"8AE",
--    x"89A",
--    x"887",
--    x"8BA",
--    x"8EC",
--    x"91F",
--    x"951",
--    x"984",
--    x"9B6",
--    x"9E9",
--    x"A1B",
--    x"A4E",
--    x"A80",
--    x"ABB",
--    x"AF6",
--    x"B30",
--    x"B6B",
--    x"BA6",
--    x"BE1",
--    x"C1B",
--    x"C56",
--    x"C91",
--    x"CCC",
--    x"CA5",
--    x"C7E",
--    x"C57",
--    x"C30",
--    x"C09",
--    x"BE2",
--    x"BBA",
--    x"B93",
--    x"B6C",
--    x"B45",
--    x"B31",
--    x"B1C",
--    x"B07",
--    x"AF2",
--    x"ADE",
--    x"AC9",
--    x"AB4",
--    x"A9F",
--    x"A8B",
--    x"A76",
--    x"A75",
--    x"A73",
--    x"A72",
--    x"A71",
--    x"A6F",
--    x"A6E",
--    x"A6D",
--    x"A6B",
--    x"A6A",
--    x"A69",
--    x"A57",
--    x"A45",
--    x"A34",
--    x"A22",
--    x"A11",
--    x"9FF",
--    x"9ED",
--    x"9DC",
--    x"9CA",
--    x"9B8",
--    x"9DA",
--    x"9FC",
--    x"A1D",
--    x"A3F",
--    x"A60",
--    x"A82",
--    x"AA3",
--    x"AC5",
--    x"AE6",
--    x"B08",
--    x"AF4",
--    x"AE0",
--    x"ACC",
--    x"AB8",
--    x"AA4",
--    x"A90",
--    x"A7C",
--    x"A68",
--    x"A54",
--    x"A40",
--    x"A2D",
--    x"A1B",
--    x"A08",
--    x"9F5",
--    x"9E3",
--    x"9D0",
--    x"9BE",
--    x"9AB",
--    x"998",
--    x"986",
--    x"949",
--    x"90B",
--    x"8CE",
--    x"891",
--    x"853",
--    x"816",
--    x"7D9",
--    x"79C",
--    x"75E",
--    x"721",
--    x"6F5",
--    x"6C8",
--    x"69C",
--    x"670",
--    x"643",
--    x"617",
--    x"5EB",
--    x"5BE",
--    x"592",
--    x"565",
--    x"58A",
--    x"5AE",
--    x"5D3",
--    x"5F7",
--    x"61C",
--    x"640",
--    x"665",
--    x"689",
--    x"6AE",
--    x"6D2",
--    x"6B3",
--    x"694",
--    x"675",
--    x"655",
--    x"636",
--    x"617",
--    x"5F8",
--    x"5D9",
--    x"5B9",
--    x"59A",
--    x"5B6",
--    x"5D1",
--    x"5ED",
--    x"608",
--    x"624",
--    x"63F",
--    x"65B",
--    x"676",
--    x"692",
--    x"6AD",
--    x"673",
--    x"638",
--    x"5FE",
--    x"5C4",
--    x"589",
--    x"54F",
--    x"515",
--    x"4DA",
--    x"4A0",
--    x"466",
--    x"438",
--    x"40A",
--    x"3DC",
--    x"3AF",
--    x"381",
--    x"353",
--    x"326",
--    x"2F8",
--    x"2CA",
--    x"29C",
--    x"287",
--    x"272",
--    x"25D",
--    x"248",
--    x"233",
--    x"21E",
--    x"209",
--    x"1F4",
--    x"1DF",
--    x"1CA",
--    x"1C3",
--    x"1BD",
--    x"1B7",
--    x"1B1",
--    x"1AB",
--    x"1A4",
--    x"19E",
--    x"198",
--    x"192",
--    x"18B",
--    x"1A8",
--    x"1C5",
--    x"1E1",
--    x"1FE",
--    x"21B",
--    x"238",
--    x"254",
--    x"271",
--    x"28E",
--    x"2AA",
--    x"297",
--    x"284",
--    x"271",
--    x"25E",
--    x"24A",
--    x"237",
--    x"224",
--    x"211",
--    x"1FE",
--    x"1EB",
--    x"201",
--    x"216",
--    x"22C",
--    x"242",
--    x"258",
--    x"26E",
--    x"284",
--    x"29A",
--    x"2B0",
--    x"2C6",
--    x"2C3",
--    x"2C0",
--    x"2BE",
--    x"2BB",
--    x"2B9",
--    x"2B6",
--    x"2B3",
--    x"2B1",
--    x"2AE",
--    x"2AC",
--    x"2E6",
--    x"320",
--    x"35A",
--    x"394",
--    x"3CE",
--    x"408",
--    x"442",
--    x"47C",
--    x"4B6",
--    x"4F0",
--    x"519",
--    x"542",
--    x"56B",
--    x"594",
--    x"5BD",
--    x"5E6",
--    x"60F",
--    x"638",
--    x"661",
--    x"68A",
--    x"689",
--    x"689",
--    x"689",
--    x"688",
--    x"688",
--    x"688",
--    x"687",
--    x"687",
--    x"687",
--    x"686",
--    x"66A",
--    x"64E",
--    x"632",
--    x"615",
--    x"5F9",
--    x"5DD",
--    x"5C1",
--    x"5A4",
--    x"588",
--    x"56C",
--    x"543",
--    x"51A",
--    x"4F1",
--    x"4C8",
--    x"49F",
--    x"476",
--    x"44D",
--    x"424",
--    x"3FB",
--    x"3D2",
--    x"3BC",
--    x"3A6",
--    x"390",
--    x"37A",
--    x"363",
--    x"34D",
--    x"337",
--    x"321",
--    x"30B",
--    x"2F5",
--    x"32E",
--    x"368",
--    x"3A2",
--    x"3DC",
--    x"416",
--    x"44F",
--    x"489",
--    x"4C3",
--    x"4FD",
--    x"537",
--    x"50F",
--    x"4E8",
--    x"4C1",
--    x"499",
--    x"472",
--    x"44B",
--    x"423",
--    x"3FC",
--    x"3D5",
--    x"3AD"
--    );
    
end package;
