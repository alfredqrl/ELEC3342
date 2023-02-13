LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY dff2 IS
    PORT (
        a : IN STD_LOGIC;
        b : IN STD_LOGIC;
        en : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        m : OUT STD_LOGIC;
        n : OUT STD_LOGIC);
END dff2;

ARCHITECTURE rtl OF dff2 IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF en = '1' THEN
                m <= a;
            END IF;
        END IF;
    END PROCESS;
    
    process (clk)
    begin 
        if rising_edge(clk) then
            n <= b;
        end if;
    end process;
END rtl;