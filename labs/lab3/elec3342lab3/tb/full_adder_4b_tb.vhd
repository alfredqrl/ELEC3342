LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE std.env.finish;

ENTITY full_adder_4b_tb IS
END full_adder_4b_tb;

ARCHITECTURE tb OF full_adder_4b_tb IS
    COMPONENT full_adder_4b IS
        PORT (
            ci : IN STD_LOGIC;
            a : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            co : OUT STD_LOGIC;
            s : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
    END COMPONENT full_adder_4b;
    SIGNAL ci : STD_LOGIC;
    SIGNAL a, b : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL co : STD_LOGIC;
    SIGNAL s : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL test_value : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL co_error : STD_LOGIC;
    SIGNAL s_error : STD_LOGIC;
    SIGNAL sim_finish : STD_LOGIC;
BEGIN
    fa_4b : full_adder_4b PORT MAP(ci => ci, a => a, b => b, co => co, s => s);
    test_value <= STD_LOGIC_VECTOR(to_unsigned(
        to_integer(unsigned'("" & ci))
        + to_integer(unsigned(a)) + to_integer(unsigned(b))
        , 5));
    co_error <= co XOR test_value(4);
    s_error <=
        '0' WHEN s = test_value(3 DOWNTO 0) ELSE
        '1';
    sim_finish <=
        '1' WHEN (ci = '1') AND (a = "1111") AND (b = "1111") ELSE
        '0';
    PROCESS BEGIN
        FOR i_ci IN STD_LOGIC RANGE '0' TO '1' LOOP
            ci <= i_ci;
            FOR i_a IN 0 TO 15 LOOP
                a <= STD_LOGIC_VECTOR(to_unsigned(i_a, 4));
                FOR i_b IN 0 TO 15 LOOP
                    b <= STD_LOGIC_VECTOR(to_unsigned(i_b, 4));
                    WAIT FOR 10 ns;
                END LOOP;
            END LOOP;
        END LOOP;
        finish;
    END PROCESS;

END tb;