LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY top IS
    PORT (
        clk : IN STD_LOGIC;
        btn1 : IN STD_LOGIC;
        btn2 : IN STD_LOGIC;
        btn3 : IN STD_LOGIC;
        clr : IN STD_LOGIC;
        locked : OUT STD_LOGIC
    );
END top;

ARCHITECTURE rtl OF top IS
    COMPONENT btn_debounce IS
        PORT (
            clk : IN STD_LOGIC;
            btn_in : IN STD_LOGIC;
            btn_out : OUT STD_LOGIC
        );
    END COMPONENT btn_debounce;
    COMPONENT lock IS
        PORT (
            clk : IN STD_LOGIC;
            btn1 : IN STD_LOGIC;
            btn2 : IN STD_LOGIC;
            btn3 : IN STD_LOGIC;
            clr : IN STD_LOGIC;
            locked : OUT STD_LOGIC
        );
    END COMPONENT lock;
    SIGNAL btn1_p, btn2_p, btn3_p : STD_LOGIC;
BEGIN
    BTN1_DEBOUNCE : btn_debounce PORT MAP(clk, btn1, btn1_p);
    BTN2_DEBOUNCE : btn_debounce PORT MAP(clk, btn2, btn2_p);
    BTN3_DEBOUNCE : btn_debounce PORT MAP(clk, btn3, btn3_p);
    lock_inst : lock PORT MAP(clk, btn1_p, btn2_p, btn3_p, clr, locked);
END rtl;