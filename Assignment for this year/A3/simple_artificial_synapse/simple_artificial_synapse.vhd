LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE ieee.math_real.ALL;

ENTITY simple_artificial_synapse IS
    PORT (
        clk : IN STD_LOGIC;
        s : IN STD_LOGIC;
        F : OUT STD_LOGIC
    );
END ENTITY simple_artificial_synapse;

ARCHITECTURE rtl OF simple_artificial_synapse IS
    SIGNAL potential : unsigned(31 DOWNTO 0) := (OTHERS => '0');
BEGIN
    check_output : PROCESS (clk, potential)
    BEGIN
        
            -- when potential is greater than 160 in decimal, the synapse fires
            IF potential > 160 THEN
                F <= '1';
            ELSE
                F <= '0';
            END IF;

        
    END PROCESS;

    update_potential : PROCESS (clk, potential)
    BEGIN
        -- when the synapse fires, the potential is reset to 0
        IF rising_edge(clk) THEN
            IF potential > 160 THEN
                potential <= (OTHERS => '0');
            ELSE
                -- when input is present, the potential is incremented by 100
                IF s = '1' THEN
                    potential <= potential + 100;
                ELSE
                    -- floor division of potential by 2
                    potential <= potential / 2;

                END IF;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE rtl;