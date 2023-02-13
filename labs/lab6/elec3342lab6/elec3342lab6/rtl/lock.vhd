LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY lock IS
    PORT (
        clk : IN STD_LOGIC;
        btn1 : IN STD_LOGIC;
        btn2 : IN STD_LOGIC;
        btn3 : IN STD_LOGIC;
        clr : IN STD_LOGIC;
        locked : OUT STD_LOGIC
    );
END lock;

ARCHITECTURE rtl OF lock IS
    COMPONENT btn_debounce IS
        PORT (
            clk : IN STD_LOGIC;
            btn_in : IN STD_LOGIC;
            btn_out : OUT STD_LOGIC
        );
    END COMPONENT btn_debounce;
    TYPE state_type IS (s_locked, s_open);
    TYPE btn_type IS (t_btnx, t_btn1, t_btn2, t_btn3);
    TYPE last_4btn_type IS ARRAY (0 TO 3) OF btn_type;
    SIGNAL state, next_state : state_type;
    CONSTANT last_4btn_golden : last_4btn_type := (t_btn1, t_btn3, t_btn2, t_btn1);
    SIGNAL new_btn : btn_type := t_btnx;
    SIGNAL last_4btn : last_4btn_type := (OTHERS => t_btnx);
    SIGNAL next_last_4btn : last_4btn_type;
BEGIN

    SYNC_PROC : PROCESS (clr, clk)
    BEGIN
        IF (clr = '1') THEN
            state <= s_locked;
            last_4btn <= (OTHERS => t_btnx);
        ELSIF rising_edge(clk) THEN
            state <= next_state;
            last_4btn <= next_last_4btn;
        END IF;
    END PROCESS;

    NEXT_STATE_DECODE : PROCESS (state, btn1, btn2, btn3, last_4btn)
    BEGIN
        next_state <= state;
        next_last_4btn <= last_4btn;
        CASE (state) IS
            WHEN s_locked =>
                -- shift in new pressed button
                IF (btn1 = '1' AND btn2 = '0' AND btn3 = '0') THEN
                    next_last_4btn <= last_4btn(1 TO 3) & t_btn1;
                ELSIF (btn1 = '0' AND btn2 = '1' AND btn3 = '0') THEN
                    next_last_4btn <= last_4btn(1 TO 3) & t_btn2;
                ELSIF (btn1 = '0' AND btn2 = '0' AND btn3 = '1') THEN
                    next_last_4btn <= last_4btn(1 TO 3) & t_btn3;
                END IF;
                -- check if last 4 buttons match golden
                IF (last_4btn = last_4btn_golden) THEN
                    -- open the lock and reset the last_4btn_reg
                    next_state <= s_open;
                    next_last_4btn <= (OTHERS => t_btnx);
                END IF;
            WHEN OTHERS => NULL; -- do nothing
        END CASE;
    END PROCESS;

    OUTPUT_DECODE : PROCESS (state)
    BEGIN
        IF state = s_open THEN
            locked <= '0';
        ELSE
            locked <= '1';
        END IF;
    END PROCESS;

END rtl;