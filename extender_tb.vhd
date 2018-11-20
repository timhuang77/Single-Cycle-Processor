library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity extender_tb is
	port (
		z : out std_logic_vector(31 downto 0)
	);
end entity extender_tb;

architecture structural of extender_tb is

	component extender is 
		port (
			A	: in std_logic_vector(15 downto 0);
			R	: out std_logic_vector(31 downto 0)
		);
	end component extender;

	signal x : std_logic_vector(15 downto 0);

	begin
	
		extender_map : extender port map (A => x, R => z);
	
		testbench : progress
		begin
		x <= "0000000000000011";

		wait for 5 ns;

		x <= "1111111111111100";
		wait for 5 ns;
		wait;
	end process;
end architecture structural;