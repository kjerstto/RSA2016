library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.RSAParameters.all;

entity RSACore is
    port(
        Clk : in std_logic;
        Resetn : in std_logic;
        InitRsa : in std_logic;
        StartRsa : in std_logic;
        DataIn : in std_logic_vector (W_DATA-1 downto 0);
        DataOut : out std_logic_vector (W_DATA-1 downto 0);
        CoreFinished : out std_logic
        );
end RSACore;

architecture Behavioral of RSACore is

component binary_RSA is
    port(
        clk : in std_logic;
        resetn : in std_logic;
        M : in std_logic_vector(127 downto 0);
        exp : in std_logic_vector(127 downto 0);
        n : in std_logic_vector(127 downto 0);
        C : buffer std_logic_vector(127 downto 0);
        calcFinished : out std_logic
        );
end component;

type state_type is (idle, wait_state, read_e, read_n, read_m, RSA, RSA_out);
signal rsa_state: state_type;

signal exp : std_logic_vector(W_BLOCK-1 downto 0);
signal n : std_logic_vector(W_BLOCK-1 downto 0);
signal M : std_logic_vector(W_BLOCK-1 downto 0);
signal C : std_logic_vector(W_BLOCK-1 downto 0);
signal Cshift : std_logic_vector(W_BLOCK-1 downto 0);

signal RSA_finished : std_logic;
signal resetn_binary : std_logic;
signal count : integer;

begin
    state_machine : process(Clk, Resetn)
    
    begin
    if (Resetn = '0') then
        CoreFinished <= '1';
        exp <= (others => '0');
        n <= (others => '0');
        M <= (others => '0');
        
        rsa_state <= idle;      
        
        resetn_binary <= '0';
        count <= 0;
    elsif (Clk'event and Clk = '1') then
        CoreFinished <= '1';
        case rsa_state is
            when idle =>
                rsa_state <= wait_state;
            when wait_state =>
                if(InitRsa = '1') then
                    CoreFinished <= '0';
                    exp(W_DATA*4 - 1 downto W_DATA*3) <= DataIn; --read part 1 of e
                    count <= 1;
                    rsa_state <= read_e;
                elsif(StartRsa = '1') then
                    CoreFinished <= '0';
                    count <= 1;
                    M(W_DATA*4 - 1 downto W_DATA*3) <= DataIn; -- read part 1 of m
                    rsa_state <= read_m;
                end if;            
            when read_e =>
                CoreFinished <= '0';
                if(count < 4) then
                    exp <= DataIn & exp(W_DATA*4 - 1 downto W_DATA); --read part 2-4 of e
                    count <= count + 1;
                else
                    n(W_DATA*4 - 1 downto W_DATA*3) <= DataIn; --read part 1 of n
                    count <= 1;
                    rsa_state <= read_n;
                end if;
            when read_n =>
                if(count < 4) then
                    CoreFinished <= '0';
                    n <= DataIn & n(W_DATA*4 - 1 downto W_DATA); --read part 2-4 f n
                    count <= count + 1;                    
                else                    
                    CoreFinished <= '1';
                    count <= 0;
                    rsa_state <= wait_state;
                end if;       
            when read_m =>
                CoreFinished <= '0';
                if(count < 4) then
                    M <= DataIn & M(W_DATA*4 - 1 downto W_DATA);
                    count <= count + 1;
                else
                    count <= 0;
                    rsa_state <= RSA;
                end if;           
            when RSA =>
                CoreFinished <= '0';
                resetn_binary <= '1';
                if(RSA_finished = '1') then
                    Cshift <= C;
                    resetn_binary <= '0';
                    rsa_state <= RSA_out;
                end if;           
            when RSA_out =>
                CoreFinished <= '1';
                if(count < 4) then
                    DataOut <= Cshift(W_DATA-1 downto 0);
                    Cshift <= (others => '0');
                    Cshift(W_DATA*3 - 1 downto 0) <= Cshift(W_DATA*4 - 1 downto W_DATA);
                else
                    count <= 0;
                    rsa_state <= idle;
                end if;                    
        end case;
    end if;
end process state_machine;

    Binary1 : binary_RSA
    Port map(
        clk => Clk,
        resetn => resetn_binary,
        M => M,
        exp => exp,
        n => n,
        C => C,
        calcFinished => RSA_finished
        );        
end Behavioral;
