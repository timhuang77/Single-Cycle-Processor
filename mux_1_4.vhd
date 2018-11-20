library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity mux_1_4 is
	port (
		sel 							: in std_logic_vector (1 downto 0);
		src0, src1, src2, src3	: in std_logic;
		z								: out std_logic
	);
end entity mux_1_4;

architecture structural of mux_1_4 is
	
	signal mux0, mux1	: std_logic;
	
	begin
		mux0_map	: mux port map (src0 => src0, src1 => src1, sel => sel(0), z=> mux0);
		mux1_map	: mux port map (src0 => src2, src1 => src3, sel => sel(0), z=> mux1);
		mux2_map	: mux port map (src0 => mux0, src1 => mux1, sel => sel(1), z=> z);

end architecture structural;

