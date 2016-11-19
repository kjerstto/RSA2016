library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_tb is
end binary_tb;

architecture testbench of binary_tb is

component binary_RSA
	port(
		clk		: in std_logic;
		resetn	: in std_logic;
		M 		: in std_logic_vector(127 downto 0);
		exp 	: in std_logic_vector(127 downto 0);
		n       : in std_logic_vector(127 downto 0);
		C       : out std_logic_vector(127 downto 0);
		calcFinished : out std_logic
		
	);
end component;

signal clk : std_logic; 
signal resetn_tb : std_logic;
signal M_tb : std_logic_vector(127 downto 0);
signal e_tb : std_logic_vector(127 downto 0);
signal n_tb : std_logic_vector(127 downto 0);
signal Cout : std_logic_vector(127 downto 0);

begin

	
	-- clock generation
	CLKGEN: process is
	begin 
	   clk <= '1';
	   wait for 10 ns; 
	   clk <= '0';
	   wait for 10 ns; 
    end process; 
    
	
	--stimuli generation
	STIM: process is
	   begin
       resetn_tb <= '0';
       wait for 10 ns; 
       resetn_tb <= '1';
       wait for 10 ns;
	   M_tb <= std_logic_vector(to_unsigned(2349, M_tb'length));
	   e_tb <= std_logic_vector(to_unsigned(394, e_tb'length));
	   n_tb <= std_logic_vector(to_unsigned(678, n_tb'length));
       wait; 
   end process;

	
	
	--DUT instantiation
	dut: binary_RSA
	port map(
	clk => clk,
	resetn => resetn_tb,
	M => M_tb,
	exp => e_tb,
	n => n_tb,
	C => Cout
	);
	
end testbench;





