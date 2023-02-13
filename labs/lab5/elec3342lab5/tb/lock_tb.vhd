LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY lock_tb IS
END lock_tb;

ARCHITECTURE tb OF lock_tb IS
    COMPONENT lock IS
        PORT (
            btn1 : IN STD_LOGIC;
            btn2 : IN STD_LOGIC;
            btn3 : IN STD_LOGIC;
            engage : IN STD_LOGIC;
            clr : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            locked : OUT STD_LOGIC;
            error : OUT STD_LOGIC);
    END COMPONENT lock;
    CONSTANT clk_period : TIME := 2 ns;
    CONSTANT SEQ_LENGTH : INTEGER := 10;
    SIGNAL btn1, btn2, btn3, engage : STD_LOGIC := '0';
    SIGNAL btn1_seq : STD_LOGIC_VECTOR (0 TO (SEQ_LENGTH - 1)) := "0101110010";
    SIGNAL btn2_seq : STD_LOGIC_VECTOR (0 TO (SEQ_LENGTH - 1)) := "0000000100";
    SIGNAL btn3_seq : STD_LOGIC_VECTOR (0 TO (SEQ_LENGTH - 1)) := "0010101000";
    SIGNAL engage_seq : STD_LOGIC_VECTOR (0 TO (SEQ_LENGTH - 1)) := "1000000000";
    SIGNAL clr : STD_LOGIC := '1';
    SIGNAL clk : STD_LOGIC := '1';
    SIGNAL locked : STD_LOGIC;
    SIGNAL error : STD_LOGIC;
    SIGNAL seq_idx : INTEGER := 0;
    SIGNAL sim_finish : STD_LOGIC;
BEGIN
    lock_inst : lock PORT MAP(btn1, btn2, btn3, engage, clr, clk, locked, error);
    clk <= NOT clk AFTER clk_period/2;
    clr <= '0' AFTER clk_period;
    sim_finish <= '1' WHEN (seq_idx = SEQ_LENGTH) ELSE
        '0';
    PROCESS (clk) BEGIN
        IF rising_edge(clk) THEN
            IF (seq_idx < SEQ_LENGTH) THEN
                btn1 <= btn1_seq(seq_idx);
                btn2 <= btn2_seq(seq_idx);
                btn3 <= btn3_seq(seq_idx);
                engage <= engage_seq(seq_idx);
                seq_idx <= seq_idx + 1;
            END IF;
            IF (seq_idx = SEQ_LENGTH) THEN
                std.env.finish;
            END IF;
        END IF;
    END PROCESS;

END tb;