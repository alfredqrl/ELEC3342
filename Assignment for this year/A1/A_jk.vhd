LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY JK IS
    PORT (
        j : IN STD_LOGIC;
        k : IN STD_LOGIC;
        en : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        q : OUT STD_LOGIC );
END JK;

architecture rtl of JK is
    signal  temp1 : std_logic;
    signal  temp2 : std_logic;
begin
    temp1 <= (j and not temp2) or (not k and temp2);
    q <= temp2;
    process (clk)
    begin
        IF rising_edge(clk) THEN
            IF (en = '1') THEN                   
                temp2 <= temp1;             
            END IF;
        END IF;
    end process;
    
end rtl;