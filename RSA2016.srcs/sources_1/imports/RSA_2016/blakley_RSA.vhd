
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blakley_RSA is

	port(
		clk 	: in std_logic;
		resetn 	: in std_logic;
		a 		: in std_logic_vector(127 downto 0);
		b 		: in std_logic_vector(127 downto 0);
		n 		: in std_logic_vector(127 downto 0);
		R		: out std_logic_vector(127 downto 0);
		done 	: out std_logic
	);
end entity;

architecture rtl of blakley_RSA is

	-- internal signals
	signal Rint : std_logic_vector(129 downto 0);
	signal i : integer;
	constant k : integer := 128;
	-- states of state machine
	type state_type is (s0_idle, s1_shiftAdd, s2_sub, s3_done);
	
	--register to hold current state
	signal state : state_type;

	
begin
    R <= Rint(127 downto 0);

	process(clk, resetn)
	begin
		if (resetn = '0') then --reset
			state <= s0_idle;
			Rint <= (others => '0');
			i <= 0;
			done <= '0';
		elsif (clk'event and clk='1') then
		  done <= '0';
			case state is
				when s0_idle => --Set R to 0
						Rint <= (others => '0');
						state <= s1_shiftAdd;
				when s1_shiftAdd => --R=2R + a(k-1-i)*b
					if (a(k-1-i) = '1') then
						Rint <= std_logic_vector((unsigned(Rint) sll 1) + unsigned(b));
					else
					   Rint <= std_logic_vector(unsigned(Rint) sll 1); 
                    end if;
					state <= s2_sub;
				when s2_sub => --R mod n
					if (unsigned(Rint) >= unsigned(n)) then
						Rint <= std_logic_vector(unsigned(Rint) - unsigned(n));
					else 
						if(i < (k-1)) then
							state <= s1_shiftAdd;
							i <= i + 1; 
						else 
							state <= s3_done; 
						end if; 
					end if; 
				when s3_done => --return result
					
					done <= '1'; 
			end case; 
		end if; 
	end process; 
end rtl; 
						
					
			
			
			
			
			