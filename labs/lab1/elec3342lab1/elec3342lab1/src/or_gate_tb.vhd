LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE std.env.finish;

ENTITY or_gate_tb IS
END or_gate_tb;

ARCHITECTURE tb OF or_gate_tb IS
    COMPONENT or_gate IS
        PORT (
            a : IN STD_LOGIC;
            b : IN STD_LOGIC;
            c : OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL in_0, in_1, out_0, out_real : STD_LOGIC;
BEGIN
    or_0 : or_gate PORT MAP(in_0, in_1, out_0);

    PROCESS BEGIN
        in_0 <= '0';
        in_1 <= '0';
        out_real <= '0';
        WAIT FOR 10 ns;
        ASSERT (out_real = out_0) REPORT "00 failed!" SEVERITY error;
        REPORT "00 passed." SEVERITY note;

        in_0 <= '1';
        in_1 <= '0';
        out_real <= '1';
        WAIT FOR 10 ns;
        ASSERT (out_real = out_0) REPORT "01 failed!" SEVERITY error;
        REPORT "01 passed." SEVERITY note;

        in_0 <= '0';
        in_1 <= '1';
        out_real <= '1';
        WAIT FOR 10 ns;
        ASSERT (out_real = out_0) REPORT "10 failed!" SEVERITY error;
        REPORT "10 passed." SEVERITY note;
        in_0 <= '1';
        in_1 <= '1';
        out_real <= '1';
        WAIT FOR 10 ns;
        ASSERT (out_real = out_0) REPORT "11 failed!" SEVERITY error;
        REPORT "11 passed." SEVERITY note;

        REPORT "Simulation done." SEVERITY note;
        finish;

    END PROCESS;

END tb;
