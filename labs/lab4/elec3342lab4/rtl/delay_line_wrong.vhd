LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY delay_line IS
    PORT (
        a : IN STD_LOGIC;
        en : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        q : OUT STD_LOGIC);
END delay_line;

ARCHITECTURE rtl OF delay_line IS
BEGIN
    PROCESS (clk)
        VARIABLE m, n, p : STD_LOGIC;
    BEGIN
        IF (rising_edge(clk)) THEN
            m := a;
            n := m;
            p := n;
            q <= p;
        END IF;
    END PROCESS;
END rtl;