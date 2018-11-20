library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity register_32bit is
	port (
		clk : in std_logic;
		rst : in std_logic;
		we : in std_logicl
		d : in std_logic_vector(31 downto 0);
		z : out std_logic_vector(31 downto 0)
	);
end register_32bit;

architecture structural of register_32bit is
	signal clk_temp, not_rst, we_temp : std_logic;
	signal data_temp1, data_temp2, z_temp : std_logic_vector(31 downto 0);
	
	begin
	
		reset_wr : not_gate port map(rst, not_rst);
		get_we	: or_gate port map (we, not_rst, we_temp);
		
		gen_ffs : for i in (0 to 31) generate
			rst 		: and_gate port map(x => d(i), y => rst, z => data_temp1(i));
			mux_we 	: mux port map(sel => we_temp, src0 => z_temp(i), src1 = data_temp1(i), z => data_temp2(i));
			dffx 		: dff port map(clk => clk, d => data_temp2(i), q => z_temp(i));
		end generate gen_ffs;
		
		z <= z_temp;

end architecture structural;