LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY or_gate IS
    PORT (
        a : IN STD_LOGIC;
        b : IN STD_LOGIC;
        c : OUT STD_LOGIC);
END or_gate;

ARCHITECTURE rtl OF or_gate IS
BEGIN
    c <= a OR b;
END rtl;
