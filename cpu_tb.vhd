library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_tb is
end cpu_tb;

architecture tb of cpu_tb is
    signal clk     : std_logic := '0';
    signal rst     : std_logic := '1';
    signal inst    : std_logic_vector(18 downto 0) := (others => '0');
    signal res     : std_logic_vector(18 downto 0);
component cpu
port(
      clk  : in std_logic;
      rst  : in std_logic;
      inst : in std_logic_vector(18 downto 0);
      res  : out std_logic_vector(18 downto 0)
        );
end component;
begin
uut: cpu
port map (
     clk  => clk,
     rst  => rst,
     inst => inst,
     res  => res);
clk_process: process
begin    
	clk <= '0';
	wait for 10 ns;
	clk <= '1';	
	wait for 10 ns;
 end process;
testing: process
    begin
        -- Reset the CPU
    rst <= '1';
    wait for 20 ns;
    rst <= '0';
    --r1 = r2 + r3
    inst <= "0000000001000100001";
    wait for 20 ns;
    --r1 = r2 - r3
    inst <= "0000100001000100001"; 
    wait for 20 ns;
    --r1 = r2 AND r3
    inst <= "0010000001000100001";
    wait for 20 ns;
    --r1 = r2 OR r3
    inst <= "0010100001000100001"; 
    wait for 20 ns;
    --encryption instruction
    inst <= "1000100001000100001";
    wait for 20 ns;
    --decryption instruction
    inst <= "1001000001000100001";
    wait for 20 ns;
    --unconditional jump
    inst <= "0101000000000000001";
    wait for 20 ns;
 wait;
end process;

end tb;
