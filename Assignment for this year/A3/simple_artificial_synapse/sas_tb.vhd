library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sas_tb is
end sas_tb;

architecture tb of sas_tb is
    component simple_artificial_synapse is
        port (S : in std_logic;
              clk : in std_logic;
              F : out std_logic);
    end component simple_artificial_synapse;

    constant clk_period : time := 2 ns;
    constant seq_length : integer := 32;
    signal clk : std_logic := '1';
    signal seq_idx : integer := 0;

    signal S, F : std_logic;
--                                                              01234567890123456789012345678901
    signal S_seq : std_logic_vector (0 to (seq_length - 1)) := "00010001010101010010010100000000";

    signal sim_finish : std_logic;

begin
    sas_inst : simple_artificial_synapse port map(S, clk, F);

    clk <= not clk after clk_period/2;
    sim_finish <= '1' when (seq_idx = seq_length) else '0';
    process (clk) begin
        if rising_edge(clk) then
            if (seq_idx < seq_length) then
                S <= S_seq(seq_idx);
                seq_idx <= seq_idx + 1;
            end if;
            if (seq_idx = seq_length) then
                std.env.finish;
            end if;
        end if;
    end process;
end tb;