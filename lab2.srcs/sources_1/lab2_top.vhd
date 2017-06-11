----------------------------------------------------------------------------------
--
-- Author: Todd Blackmon
--
-- Description:
-- Top level module that implements a 7-segment display based on switch and
-- button inputs. This version uses processes instead of CSA.
--
-- Requirements:     
-- 1. The input to the seg7_hex component should be the four slider switches 
--    SW3-SW0 or all zero's (depending on the push buttons below). SW3 is 
--    considered the most significant bit (msb) of the binary number and SW0 is
--    the least (lsb).
-- 2. Normally, with none of the push buttons pressed, the displays will be 
--    active depending on the state of SW11 through SW4, which will form an 
--    8-bit binary number. Each switch determines which digit on the seven 
--    segment display is active. SW11 makes the left-most digit active, SW10
--    makes the next digit active, and continues to SW4 which activates the 
--    right-most digit.
-- 3. When the UP BTN is pressed (BTNU), only the upper four digits will be
--    active and showing the SW3 to SW0 value, independent of the values of SW11
--    through SW4.
-- 4. When the DOWN BTN is pressed (BTND), only the bottom four digits will be 
--    active and showing the SW3 to SW0 value, independent of the values of SW11
--    through SW4.
-- 5. When the CENTER BTN is pressed (BTNC), all eight digits will be active and 
--    showing all zeros, independent of the values of SW11 through SW4 and 
--    independent of the digit selection of SW3 to SW0.
-- 6. The green LEDs, labeled LD15 through LD0 should light up on the board 
--    based on which switch SW15 through SW0 is set to the HIGH position. This 
--    should occur ALL the time.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;

entity lab2_top is
    Port (
        -- Push buttons 
        BTNC : in STD_LOGIC;
        BTND : in STD_LOGIC;
        BTNU : in STD_LOGIC;
        
        -- Switches (16 switches)
        SW : in STD_LOGIC_VECTOR (15 downto 0);
        
        -- LEDs (16 LEDs)
        LED : out STD_LOGIC_VECTOR (15 downto 0);
        
        -- 7-Segment display
        SEG7_CATH : out STD_LOGIC_VECTOR (7 downto 0);
        AN : out STD_LOGIC_VECTOR (7 downto 0));
end lab2_top;

architecture Behavioral of lab2_top is
    signal digit_to_disp : std_logic_vector(3 downto 0);
begin
    -- BTNC overrides 7 segment value to all 0s.
    dig_sel : process (BTNC, SW)
    begin
        if (BTNC = '1') then
            digit_to_disp <= "0000";
        else
            digit_to_disp <= SW(3 downto 0);
        end if;
    end process dig_sel;

    s7_hex : entity seg7_hex port map (
        digit => digit_to_disp,
        seg7 => SEG7_CATH
    );
  
    -- Use the anodes to make the 7-segment digits active (or not)
    -- Note: the anodes are active-low and switches are active-high.
    an_sel : process (BTNU, BTND, BTNC, SW)
    begin
        if (BTNU = '1') then
            AN <= "00001111";
        elsif (BTND = '1') then
            AN <= "11110000";
        elsif (BTNC = '1') then
            AN <= "00000000";
        else
            AN <= not SW(11 downto 4);
        end if;
    end process an_sel;
   
    -- Each LED is on if the respective SW is on.
    LED <= SW;

end Behavioral;
