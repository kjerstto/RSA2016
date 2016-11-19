
library ieee;
use ieee.std_logic_1164.all;

entity binary_RSA is

	port(
		clk		: in std_logic;
		resetn	: in std_logic;
		M 		: in std_logic_vector(127 downto 0);
		exp 	: in std_logic_vector(127 downto 0);
		n       : in std_logic_vector(127 downto 0);
		C       : out std_logic_vector(127 downto 0);
		calcFinished : out std_logic
		
	);
	
end entity;

architecture rtl of binary_RSA is

	component blakley_RSA is
		Port(
			clk	: in std_logic;
			resetn : in std_logic;
			a	: in std_logic_vector (127 downto 0);
			b 	: in std_logic_vector (127 downto 0);
			n 	: in std_logic_vector (127 downto 0);
			R 	: out std_logic_vector (127 downto 0);
			
			
			done : out std_logic
		);
	end component;
	
	-- internal signals
	signal Cint : std_logic_vector(127 downto 0);
	constant k	 : integer := 128; 
	signal i 	: integer;
	-- internal signals for Blakley communication
	signal blResetn : std_logic;
	signal blDone	 : std_logic;
	signal bla : std_logic_vector(127 downto 0);
	signal blb : std_logic_vector(127 downto 0);
	signal blR : std_logic_vector(127 downto 0);
	
	
	--states for state machine
	type state_type is (s1_idle, s2a_modSquare, s2b_modmul, s3_done);
	
	--register to hold current state
	signal state : state_type;

begin
	process (clk, resetn)
	begin
		if (resetn = '0') then
			state <= s1_idle;
			blResetn <= '0';
			Cint <= (others => '0');
			i <= k - 2; 
			calcFinished <= '0';
		elsif (clk'event and clk='1') then
			case state is
				when s1_idle => -- set C to M or 1
					calcFinished <= '0';
					if (exp(k-1) = '1') then
						Cint <= M; 
					else
						Cint(0) <= '1';
					end if;
					state <= s2a_modSquare;
				when s2a_modSquare => -- C = C*C mod n 
					blResetn <= '1';
					bla <= Cint; 
					blb <= Cint; 
					if(blDone = '1') then
						Cint <= blR; 
						blResetn <= '0';
						state <= s2b_modmul;
					end if;
				when s2b_modmul => -- if ei=1 then C=C*M mod n
					if(exp(i) = '1') then -- run C = C*M mod n
						blResetn <= '1';
						bla <= Cint; 
						blb <= M; 
						if(blDone ='1') then 
							Cint <= blR;
							blResetn <= '0';
							if(i>0) then --check loop
								i <= i-1; 
								state <= s2a_modSquare;
							else 
								state <= s3_done;
							end if;
						end if;
					else -- no modMul
						if(i>0) then --check loop
							i <= i-1; 
							state <= s2a_modSquare;
						else 
							state <= s3_done;
						end if;
					end if;
				when s3_done => -- calcFinished
					C <= Cint;
					calcFinished <= '1'; 
			end case;
		end if; 
	end process;
	
	Blakley1 : blakley_RSA
	Port map ( 
		clk => clk,
		a => bla,
		b => blb,
		n => n,
		R => blR,
		resetn => blResetn,
		done => blDone
	);
end rtl;
						
				
					
					
				
					
	
	
