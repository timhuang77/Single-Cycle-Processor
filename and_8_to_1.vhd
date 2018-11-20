library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity and_8_to_1 is
	port (
		andIn		: in std_logic_vector(7 downto 0);
		andOut	: out std_logic
	);
end entity and_8_to_1;

architecture structural of and_8_to_1 is
	signal temp : std_logic_vector(7 downto 0);
	
	begin
		temp(0) <= andIn(0);
		
		and_signal_loop : for i in (0 to 6) generate
			and_op : and_gate port map(x => temp(i), y => andIn(i + 1), z => temp(i + 1));
		end generate and_signal_loop;
		
	andOut <= temp(7);
end architecture structural;
		