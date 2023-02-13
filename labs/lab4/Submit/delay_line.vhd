LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY delay_line IS
    PORT (
        a : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        q : OUT STD_LOGIC);
END delay_line;

ARCHITECTURE rtl OF delay_line IS
    SIGNAL m, n, p : STD_LOGIC;
BEGIN
    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            m <= a;
        END IF;
    END PROCESS;
    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            n <= m;
        END IF;
    END PROCESS;
    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            p <= n;
        END IF;
    END PROCESS;
    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            q <= p;
        END IF;
    END PROCESS;
END rtl;