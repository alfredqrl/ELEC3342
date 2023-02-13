LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY btn_debounce IS
    PORT (
        clk : IN STD_LOGIC;
        btn_in : IN STD_LOGIC;
        btn_out : OUT STD_LOGIC := '0'
    );
END btn_debounce;

ARCHITECTURE rtl OF btn_debounce IS
    CONSTANT CNT_ZERO : unsigned(31 DOWNTO 0) := (OTHERS => '0'); -- 0
    CONSTANT CNT_THR : unsigned(31 DOWNTO 0) := x"000F4240"; -- 10 ms in 100MHz clk
    CONSTANT CNT_MAX : unsigned(31 DOWNTO 0) := x"05F5E100"; -- 1 sec in 100MHz clk
    SIGNAL cnt : unsigned(31 DOWNTO 0) := CNT_ZERO;
    SIGNAL btn_in_r1, btn_in_r2 : STD_LOGIC := '0';
BEGIN

    BTN_REG_PROC : PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            btn_in_r1 <= btn_in;
            btn_in_r2 <= btn_in_r1;
        END IF;
    END PROCESS BTN_REG_PROC;

    CNT_PROC : PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF (cnt <= CNT_MAX AND btn_in_r1 = '1' AND btn_in_r2 = '1') THEN
                cnt <= cnt + 1;
            ELSE
                cnt <= CNT_ZERO;
            END IF;
        END IF;
    END PROCESS CNT_PROC;

    OUTPUT_PROC : PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF (cnt = CNT_THR) THEN
                btn_out <= '1';
            ELSE
                btn_out <= '0';
            END IF;
        END IF;
    END PROCESS OUTPUT_PROC;
END rtl;