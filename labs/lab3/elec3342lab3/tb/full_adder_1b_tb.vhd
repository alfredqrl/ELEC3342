LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE std.env.finish;

ENTITY full_adder_1b_tb IS
END full_adder_1b_tb;

ARCHITECTURE tb OF full_adder_1b_tb IS
    COMPONENT full_adder_1b IS
        PORT (
            ci : IN STD_LOGIC;
            a : IN STD_LOGIC;
            b : IN STD_LOGIC;
            co : OUT STD_LOGIC;
            s : OUT STD_LOGIC);
    END COMPONENT full_adder_1b;
    SIGNAL ci, a, b, co, s : STD_LOGIC;
    SIGNAL test_value : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL co_error : STD_LOGIC;
    SIGNAL s_error : STD_LOGIC;
    SIGNAL sim_finish : STD_LOGIC;
BEGIN
    fa_1b : full_adder_1b PORT MAP(ci => ci, a => a, b => b, co => co, s => s);
    test_value <= STD_LOGIC_VECTOR(to_unsigned(
        to_integer(unsigned'("" & ci))
        + to_integer(unsigned'("" & a))
        + to_integer(unsigned'("" & b))
        , 2));
    co_error <= co XOR test_value(1);
    s_error <= s XOR test_value(0);
    sim_finish <= (ci XNOR '1') AND (a XNOR '1') AND (b XNOR '1');
    PROCESS BEGIN
        FOR i_ci IN STD_LOGIC RANGE '0' TO '1' LOOP
            ci <= i_ci;
            FOR i_a IN STD_LOGIC RANGE '0' TO '1' LOOP
                a <= i_a;
                FOR i_b IN STD_LOGIC RANGE '0' TO '1' LOOP
                    b <= i_b;
                    WAIT FOR 10 ns;
                END LOOP;
            END LOOP;
        END LOOP;
        finish;
    END PROCESS;

END tb;