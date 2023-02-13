LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY full_adder_4b IS
    PORT (
        ci : IN STD_LOGIC;
        a : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        co : OUT STD_LOGIC;
        s : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END full_adder_4b;

ARCHITECTURE rtl OF full_adder_4b IS
    COMPONENT full_adder_1b IS
        PORT (
            ci : IN STD_LOGIC;
            a : IN STD_LOGIC;
            b : IN STD_LOGIC;
            co : OUT STD_LOGIC;
            s : OUT STD_LOGIC);
    END COMPONENT full_adder_1b;
    signal co_0: STD_LOGIC;
    signal co_1: STD_LOGIC;
    signal co_2: STD_LOGIC;
BEGIN
    FA_0_inst: full_adder_1b port map(
        ci => ci,
        a => a(0),
        b => b(0),
        co => co_0,
        s => s(0)
    );
    FA_1_inst: full_adder_1b port map(
        ci => co_0,
        a => a(1),
        b => b(1),
        co => co_1,
        s => s(1)
    );
    FA_2_inst: full_adder_1b port map(
        ci => co_1,
        a => a(2),
        b => b(2),
        co => co_2,
        s => s(2)
    );
    FA_3_inst: full_adder_1b port map(
        ci => co_2,
        a => a(3),
        b => b(3),
        co => co,
        s => s(3)
    );
END rtl;