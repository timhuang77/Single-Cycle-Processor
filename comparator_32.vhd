library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity comparator_32 is
	port (
		X, y	: in std_logic_vector(31 downto 0);
		sign	: in std_logic;
		z		: out std_logic_vector(31 downto 0)
	);
end entity comparator_32;

architecture structural of comparator_32 is
	signal mux0, mux1	: std_logic;
	signal temp			: std_logic_vector;
	
	begin
		temp(0) <= '0';
		
		compare_loop : for i in 0 to 30 generate begin
			comparator_map	: comparator_1 port map (x => x(i), y => y(i), cin => temp(i), z => z(i + 1));
		end generate compare_loop;
		
		mux0_map			: mux port map (sel => sign, src0 => X(31), src2 => y(31), z => mux0);
		mux1_map			: mux port map (sel => sign, src0 => y(31), src2 => x(31), z => mux1);
		comparator_map	: comparator_1 port map (x => mux0, y => mux1, cin => temp(31), z => temp(32));
		
		z <= "000000000000000000000000000000" & temp(32);

end architecture structural;