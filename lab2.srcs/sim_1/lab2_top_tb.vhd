----------------------------------------------------------------------------------
--
-- Author: Todd Blackmon
--
-- Description:
-- Top level testbench module for lab2_top.
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.all;

entity lab2_top_tb is
end lab2_top_tb;

architecture testbench of lab2_top_tb is
    type sample is record
        btnc : std_logic;
        btnd : std_logic;
        btnu : std_logic;
        sw : std_logic_vector (15 downto 0);
        seg7_cath : std_logic_vector (7 downto 0);
        an : std_logic_vector (7 downto 0);
        
    end record;
    type sample_array is array (natural range <>) of sample;
    constant test_data : sample_array :=
        ( --  C   D   U   SW       SEG7_CATH    AN
            ('0','0','0',X"0000", "11000000", "11111111"),
            ('0','0','0',X"0001", "11111001", "11111111"),
            ('0','0','0',X"0002", "10100100", "11111111"),
            ('0','0','0',X"0003", "10110000", "11111111"),
            ('0','0','0',X"0004", "10011001", "11111111"),
            ('0','0','0',X"0005", "10010010", "11111111"),
            ('0','0','0',X"0006", "10000010", "11111111"),
            ('0','0','0',X"0007", "11111000", "11111111"),
            ('0','0','0',X"0008", "10000000", "11111111"),
            ('0','0','0',X"0009", "10010000", "11111111"),
            ('0','0','0',X"000A", "10001000", "11111111"),
            ('0','0','0',X"000B", "10000011", "11111111"),
            ('0','0','0',X"000C", "11000110", "11111111"),
            ('0','0','0',X"000D", "10100001", "11111111"),
            ('0','0','0',X"000E", "10000110", "11111111"),
            ('0','0','0',X"000F", "10001110", "11111111"),
            -- Test btnc for 0 override
            ('1','0','0',X"1475", "11000000", "00000000"),
            ('1','0','0',X"258B", "11000000", "00000000"),
            ('1','0','0',X"3690", "11000000", "00000000"),
            -- Test btnd for anode
            ('0','1','0',X"5437", "11111000", "11110000"),
            ('0','1','0',X"235A", "10001000", "11110000"),
            ('0','1','0',X"127C", "11000110", "11110000"),
            -- Test btnu for anode
            ('0','0','1',X"F026", "10000010", "00001111"),
            ('0','0','1',X"405E", "10000110", "00001111"),
            ('0','0','1',X"918F", "10001110", "00001111"),
            -- Test no btns
            ('0','0','0',X"68B5", "10010010", "01110100"),
            ('0','0','0',X"123B", "10000011", "11011100"),
            ('0','0','0',X"9000", "11000000", "11111111"),
            ('0','0','0',X"5437", "11111000", "10111100"),
            ('0','0','0',X"235A", "10001000", "11001010"),
            ('0','0','0',X"127C", "11000110", "11011000"),
            ('0','0','0',X"F026", "10000010", "11111101"),
            ('0','0','0',X"405E", "10000110", "11111010"),
            ('0','0','0',X"918F", "10001110", "11100111")
        );
    signal btnc, btnd, btnu : std_logic;
    signal sw : std_logic_vector (15 downto 0);
    signal LED : std_logic_vector (15 downto 0);
    signal SEG7_CATH : std_logic_vector (7 downto 0);
    signal AN : std_logic_vector (7 downto 0);
begin
    process
    begin
        for i in test_data'range loop
            btnc <= test_data(i).btnc;
            btnd <= test_data(i).btnd;
            btnu <= test_data(i).btnu;
            sw <= test_data(i).sw; 
            wait for 10 ns;
            assert std_match(seg7_cath, test_data(i).seg7_cath)
                report "iteration " & integer'image(i) & ": output seg7_cath is wrong!" severity failure;
            assert std_match(an, test_data(i).an)
                report "iteration " & integer'image(i) & ": output an is wrong!" severity failure;
            assert std_match(led, sw)
                report "iteration " & integer'image(i) & ": output led is wrong!" severity failure;
        end loop;
        report "Simulation successful";
        wait;
    end process;

    CUT: entity lab2_top port map (BTNC, BTND, BTNU, SW, LED, SEG7_CATH, AN);

end testbench;
