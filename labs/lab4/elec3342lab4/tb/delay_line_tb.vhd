LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY delay_line_tb IS
END delay_line_tb;

ARCHITECTURE rtl OF delay_line_tb IS
    COMPONENT delay_line IS
        PORT (
            a : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            q : OUT STD_LOGIC);
    END COMPONENT delay_line;
    CONSTANT clk_period : TIME := 2 ns;
    SIGNAL a_seq : STD_LOGIC_VECTOR (15 DOWNTO 0) := "1011001011000110";
    SIGNAL clk : STD_LOGIC := '1';
    SIGNAL cycle_cnt : INTEGER := 1;
    SIGNAL a : STD_LOGIC := a_seq(0);
    SIGNAL q : STD_LOGIC;
    SIGNAL sim_finish : STD_LOGIC;
BEGIN
    dl_inst : delay_line PORT MAP(a, clk, q);
    clk <= NOT clk AFTER clk_period/2;
    sim_finish <= '1' WHEN (cycle_cnt = 16) ELSE
        '0';
    PROCESS (clk) BEGIN
        IF rising_edge(clk) THEN
            IF (cycle_cnt = 16) THEN
                std.env.finish;
            END IF;
            a <= a_seq(cycle_cnt);
            cycle_cnt <= cycle_cnt + 1;
        END IF;
    END PROCESS;

END rtl;