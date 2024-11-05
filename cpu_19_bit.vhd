library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
port(
	clk: in std_logic;
	rst:in std_logic;
	inst:in std_logic_vector(18 downto 0);
	res: out std_logic_vector(18 downto 0)
);

end cpu;

architecture behave of cpu is 
signal opcode:std_logic_vector(18 downto 14);
signal r1,r2,r3:std_logic_vector(3 downto 0);
signal immediate:std_logic_vector(18 downto 0);
signal pc :std_logic_vector(18 downto 0);
signal sp:std_logic_vector(18 downto 0);

type gp_arr  is array(0 to 15) of std_logic_vector(18 downto 0);
signal gp_reg:gp_arr:=(others=>(others=>'0'));

type mem_arr is array(0 to 524287) of std_logic_vector(18 downto 0);
signal mem_sig:mem_arr :=(others=>(others=>'0'));

type stack is array(0 to 15) of std_logic_vector(18 downto 0);
signal sp_sig:stack:=(others=>(others=>'0'));

begin
opcode <=inst(18 downto 14);
r1<=inst(13 downto 10);
r2<=inst(9 downto 6);
r3<=inst(5 downto 2);
immediate<= inst(18 downto 0);

process(clk,rst)
variable i: integer;

-- enc
procedure enc (test:in integer; src:in integer) is
constant key:std_logic_vector (18 downto 0):="1010101010101010101";
begin
for i in 0 to 7 loop
 mem_sig(test+i)<=mem_sig(src+i) xor key;
end loop;
end procedure;
-- dec
procedure dec(test:in integer; src:in integer) is
constant key:std_logic_vector (18 downto 0):="1010101010101010101";
begin
for i in 0 to 7 loop
 mem_sig(test+i)<=mem_sig(src+i) xor key;
end loop;
end procedure;

begin
if rst='1' then
	pc<=(others=>'0');
	sp<=(others=>'0');
	res<=(others=>'0');
	 for i in 0 to 15 loop
	 gp_reg(i)<= (others=>'0');
	 end loop;
elsif rising_edge(clk) then
	case opcode is
	--arithmetic
		when "00000" => gp_reg(to_integer(unsigned(r1)))<=std_logic_vector(unsigned(gp_reg(to_integer(unsigned(r2))))+unsigned(gp_reg(to_integer(unsigned(r3)))));
		when "00001" => gp_reg(to_integer(unsigned(r1)))<=std_logic_vector(unsigned(gp_reg(to_integer(unsigned(r2))))-unsigned(gp_reg(to_integer(unsigned(r3)))));
		when "00010" => gp_reg(to_integer(unsigned(r1)))<=std_logic_vector(unsigned(gp_reg(to_integer(unsigned(r2))))*unsigned(gp_reg(to_integer(unsigned(r3)))));
		when "00011" => if unsigned(gp_reg(to_integer(unsigned(r3))))/=0 then
								gp_reg(to_integer(unsigned(r1)))<=std_logic_vector(unsigned(gp_reg(to_integer(unsigned(r2))))/unsigned(gp_reg(to_integer(unsigned(r3)))));
								else
									gp_reg(to_integer(unsigned(r1)))<=(others=>'0');
end if;
	--logic
		when "00100" => gp_reg(to_integer(unsigned(r1)))<=(gp_reg(to_integer(unsigned(r2)))) and (gp_reg(to_integer(unsigned(r3))));
		when "00101" => gp_reg(to_integer(unsigned(r1)))<=(gp_reg(to_integer(unsigned(r2)))) or (gp_reg(to_integer(unsigned(r3))));
		when "00110" => gp_reg(to_integer(unsigned(r1)))<=(gp_reg(to_integer(unsigned(r2)))) xor (gp_reg(to_integer(unsigned(r3))));
		when "00111" => gp_reg(to_integer(unsigned(r1)))<=(gp_reg(to_integer(unsigned(r2)))) nand (gp_reg(to_integer(unsigned(r3))));
		when "01000" => gp_reg(to_integer(unsigned(r1)))<=(gp_reg(to_integer(unsigned(r2)))) nor (gp_reg(to_integer(unsigned(r3))));
		when "01001" =>gp_reg(to_integer(unsigned(r1)))<=not (gp_reg(to_integer(unsigned(r2))));
	--inc/dec
		when "01010" =>gp_reg(to_integer(unsigned(r1)))<=std_logic_vector(unsigned(gp_reg(to_integer(unsigned(r1))))+1);
		when "01011" =>gp_reg(to_integer(unsigned(r1)))<=std_logic_vector(unsigned(gp_reg(to_integer(unsigned(r1))))-1);
	-- control op
 		when "01100" =>
		 pc<= immediate;
		 when"01101"=> if gp_reg(to_integer(unsigned(r1)))= gp_reg(to_integer(unsigned(r2))) then 
		 pc<= immediate;
		 end if;
		 when "01110"=> if gp_reg(to_integer(unsigned(r1)))/= gp_reg(to_integer(unsigned(r2))) then 
		 pc<= immediate;
		 end if;
	-- call and returns
		when "01111"=> 
					sp_sig(to_integer(unsigned(sp)))<=std_logic_vector(unsigned(pc) +1);
					sp<=std_logic_vector(unsigned(sp)-1);
					pc<=immediate;
		when "10000"=>
					sp<=std_logic_vector(unsigned(sp)+1);
					pc<=sp_sig(to_integer(unsigned(sp)));
	-- Memory access
		when "10001" =>  gp_reg(to_integer(unsigned(r1)))<=mem_sig(to_integer(unsigned(immediate)));
		when "10010" =>  mem_sig(to_integer(unsigned(immediate)))<=gp_reg(to_integer(unsigned(r1)));
	-- special op
		when "10011"=>enc(to_integer(unsigned(r1)),to_integer(unsigned(r2)));
		when "10100"=>dec(to_integer(unsigned(r1)),to_integer(unsigned(r2)));
	when others=> null;
end case;
	pc<=std_logic_vector(unsigned(pc) +1);

end if;			
end process;
-- output process
process(clk,rst)
begin
 if rst='1' then
	res<=(others=>'0');
	elsif rising_edge(clk)  then
		res<=gp_reg(0);
		end if;
end process;
end behave;
