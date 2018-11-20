library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity fulladder_1 is
	port ( 
		x, y, cin	: in std_logic;
		z, cout		: out std_logic
	);
end entity fulladder_1;

architecture structural of fulladder_1 is
	signal xor0, and0, and1 : std_logic;
	
	begin
		xor0_map : xor_gate port map (x => x, y => y, z => xor0);
		xor1_map : xor_gate port map (x => xor0, y => cin, z => z);
		and0_map : and_gate port map (x => x, y => y, z => and0);
		and1_map : and_gate port map (x => xor0, y => cin, z => and1);
		or0_map	: or_gate port map (x => and0, y => and1, z => cout);
		
end architecture structural;
		