library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity ALU_1 is
	port (
		A, B, cin	: in std_logic;
		sel			: in std_logic_vector(1 downto 0);
		cout, R		: out std_logic
	);
end entity ALU_1;

architecture structural of ALU_1 is
	signal and0, or0, xor0, add0, cout0	: std_logic;
	
	begin
		and0_map	: and_gate port map (x => A, y => B, z => and0);
		or0_map	: or_gate port map (x => A, y => B, z => or0);
		xor0_map : xor_gate port map (x => sel(0), y => B, z => xor0);
		add0_map	: fulladder_1 port map (x => A, y => xor0, cin => cin, cout => cout0, z => add0);
		and1_map	: and_gate port map (x => cout0, y => sel(1), z => cout);
		mux_map	: mux_1_4 port map (src0 => and0, src1 => or0, src2 => add0, src3 => add0, sel => sel, z => R);
		
end architecture structural;

-- sel(0,0): and
-- sel(0,1): or
-- sel(1,0): add
-- sel(1,1): subtrac