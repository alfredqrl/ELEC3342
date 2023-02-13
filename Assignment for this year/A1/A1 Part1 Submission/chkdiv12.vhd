LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY chkdiv12 IS
    PORT (
        n : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        f : OUT STD_LOGIC );
END chkdiv12;

architecture rtl of chkdiv12 is
    signal temp : std_logic := '0';
    component chkdiv3 is
        port (
            n : std_logic_vector (4 downto 0);
            d : out std_logic );
    end component chkdiv3;
    signal temp_1 : std_logic; 
begin
    C1 : chkdiv3 port map(
        n => n,
        d => temp_1
    );
   temp <= (not n(0)) and (not n(1));
   f <= temp_1 and temp;
end rtl;