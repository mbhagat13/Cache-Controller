----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:57:33 10/16/2019 
-- Design Name: 
-- Module Name:    cache_control - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cache_control is
    Port ( addr_in : in  STD_LOGIC_VECTOR (15 downto 0);
           wr_in : in  STD_LOGIC;
           cs_in : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           data_in_cpu : in  STD_LOGIC_VECTOR (7 downto 0);
           data_in_sdram : in  STD_LOGIC_VECTOR (7 downto 0);
           addr_out : out  STD_LOGIC_VECTOR (15 downto 0);
           wr_out : out  STD_LOGIC;
           mstrb : out  STD_LOGIC;
           data_out_sdram : out  STD_LOGIC_VECTOR (7 downto 0);
			  data_out_cpu : out  STD_LOGIC_VECTOR (7 downto 0);
			  ready_out : out STD_LOGIC);
end cache_control;

architecture Behavioral of cache_control is


--ALL COMPONENT DECLARATIONS

COMPONENT bram_cache
PORT (
		clka : IN STD_LOGIC;
		wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END COMPONENT;

COMPONENT Multiplexer1to2
PORT (
		w : in  STD_LOGIC_VECTOR (7 downto 0);
		s : in  STD_LOGIC;
		f1 : out  STD_LOGIC_VECTOR (7 downto 0);
		f2 : out  STD_LOGIC_VECTOR (7 downto 0)				
);
END COMPONENT;

COMPONENT Multiplexer2to1
PORT (
		w0 : in  STD_LOGIC_VECTOR (7 downto 0);
		w1 : in  STD_LOGIC_VECTOR (7 downto 0);
		s : in  STD_LOGIC;
		f : out  STD_LOGIC_VECTOR (7 downto 0)
);
END COMPONENT;

COMPONENT str
PORT(
	clk : IN std_logic;
	enable : IN std_logic;          
	strb : OUT std_logic
);
END COMPONENT;


component icon
PORT (
		CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0)
);
end component;

component ila
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CLK : IN STD_LOGIC;
    DATA : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
    TRIG0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
);
end component;


-- END OF ALL COMPONENT DECLARATIONS

--array to store all tags: 9th bit is valid bit, 8th bit is dirty bit
type storage_cache is array (7 downto 0) of STD_LOGIC_VECTOR (9 DOWNTO 0);
signal Memory: storage_cache;


--cache controller signals breakdown the inputs
signal index :std_LOGIC_VECTOR(2 downto 0);
signal offset :std_LOGIC_VECTOR(4 downto 0);
signal tag :std_LOGIC_VECTOR(7 downto 0);

--strobing signals
signal enable_str : STD_LOGIC;
signal memstrb: STD_LOGIC;


--Cache SRAM signals needed:
signal smux1_bram :std_LOGIC;
signal smux2_bram :std_LOGIC;
signal wen_cache_bram :STD_LOGIC_VECTOR(0 DOWNTO 0);
signal addr_cache_bram :std_LOGIC_VECTOR(7 downto 0);
signal data_in_bram:std_LOGIC_VECTOR(7 downto 0);
signal data_out_bram:std_LOGIC_VECTOR(7 downto 0);


signal STATE: STD_LOGIC_VECTOR (2 downto 0);


--ila icon signals as needed
	signal control0 : std_logic_vector(35 downto 0);
	signal ila_data : std_logic_vector(255 downto 0);
	signal trig0 : std_logic_vector(7 downto 0);
	
--ila driver other signals:
	signal addr_out_sig : std_logic_vector(15 downto 0);
	signal wr_out_sig : std_LOGIC;


begin


		--ila  port maps
		
		sys_icon : icon
		port map (
			CONTROL0 => control0
		);

		sys_ila : ila
		port map (
			CONTROL => control0,
			CLK => clk,
			DATA => ila_data,
			TRIG0 => trig0
		);
		

		--Multiplexer Components

		cache_input_mux : Multiplexer2to1
		port map (
			w0 => data_in_cpu,
			w1 => data_in_sdram,
			s => smux1_bram,
			f => data_in_bram
		);
		
		cache_output_mux: Multiplexer1to2 
		PORT MAP(
		w => data_out_bram,
		s => smux2_bram,
		f1 => data_out_sdram,
		f2 => data_out_cpu
		);
		
		--BRAM Components
		
		cache_mem : bram_cache
		PORT MAP (
			clka => clk,
			wea => wen_cache_bram,
			addra => addr_cache_bram,
			dina => data_in_bram,
			douta => data_out_bram
		);
		
		--components
		 memory_strobe: str port map (
		 clk => clk,
		 enable => enable_str,
		 strb => memstrb
	);

-- Main Cache Controller Process--

PROCESS(clk,wr_in,addr_in,cs_in)
	
		variable hit: STD_ULOGIC := '0';
		variable i_value: integer := 0;
		variable counter : integer := 0;
		variable offset_needed : integer := 0;
	
	BEGIN

		index <= addr_in (7 downto 5);
		offset <= addr_in (4 downto 0);
		tag <= addr_in (15 downto 8);

	
		if rising_edge(clk) then
			STATE <= "001";
			
			if STATE = "001" then -- init state
				hit:='0';
				ready_out <= '0';
					for i in 0 to 7 loop --scan controller mem sig for existing tags
						if(Memory(i)(9) = '1') and (Memory(i)(7 downto 0) = tag) then
							hit := '1';
							i_value := i;
						end if;
					end loop;
					
					if hit = '1' and wr_in = '1' then --hit write state
						STATE <= "010";
					elsif hit = '1' and wr_in = '0' then --hit read state
						STATE <= "011";
					elsif hit = '0' and Memory(i_value)(8) = '0' then --miss dirty bit 0 state
						STATE <= "101";
					elsif hit = '0' and Memory(i_value)(8) = '1' then --miss dirty bit 1 state
						STATE <= "100";
					end if;		

			--hit write
			elsif STATE = "010" then 
				addr_cache_bram <= index & offset;
				Memory(i_value) <= Memory(i_value) or "1100000000"; --set valid and dirty bit
				smux1_bram <= '0';
				wen_cache_bram(0) <= '1';
				STATE <= "110";
				
			--hit read
			elsif STATE = "011" then 
				addr_cache_bram <= index & offset;
				smux2_bram <= '1';
				wen_cache_bram(0) <= '0';
				STATE <= "110";	
			
			--miss case
			--dirty bit = 0
			elsif STATE = "101" then 
				enable_str <= '1';
				counter := counter + 1;
				if counter = 64 and wr_in = '1' then
					enable_str <= '0';--stop the strobing
					counter := 0;--reset
					Memory(i_value)(7 downto 0) <= tag;-- replace the corresponding tag
					Memory(i_value)(9) <= '1';-- set valid bit
					offset_needed := 0;--reset
					STATE <= "010"; --next state is write hit stage
				elsif counter = 64 and wr_in = '0' then
					enable_str <= '0'; --stop the strobing
					counter := 0; --reset
					Memory(i_value)(7 downto 0) <= tag; -- replace the corresponding tag
					Memory(i_value)(9) <= '1';-- set valid bit
					offset_needed := 0;--reset
					STATE <= "011"; -- next stage is read hit stage
				else--Read whole block from main mem & write it in local cache
					addr_out_sig <= tag & index & STD_LOGIC_VECTOR(to_unsigned(offset_needed, offset'length)); --change addr to increment by 1
					addr_cache_bram <= index & STD_LOGIC_VECTOR(to_unsigned(offset_needed, offset'length)); --change addr to increment by 1
					wr_out_sig <= '0'; --set sdram to read mode
					wen_cache_bram(0) <= '1'; --set cache to write mode 
					smux1_bram <= '1'; -- change input to read from sdram
					offset_needed := offset_needed+1; --increment offset ass needed 
				end if;
				
			--miss case
			--dirty bit is 1
			elsif STATE = "100" then
				counter := counter + 1;
				enable_str <= '1';
				if counter = 64 then --once counter increments to the required strobes, then proceed to reading from main mem state
					Memory(i_value)(8) <= '0';  --dirty bit is now 0
					enable_str <= '0'; -- stop memstrobe
					counter := 0; --reset
					offset_needed := 0; --reset
					STATE <= "101"; -- next stage is miss with dirty bit =0
				else --Write everything to main memory while the counter is incrementing
					addr_out_sig <= tag & index & STD_LOGIC_VECTOR(to_unsigned(offset_needed, offset'length)); -- change addr increment by 1
					addr_cache_bram <= index & STD_LOGIC_VECTOR(to_unsigned(offset_needed, offset'length)); --change addr increment by 1
					wr_out_sig <= '1'; --enable writing to sdram
					wen_cache_bram(0) <= '0'; --enable reading from cache
					smux2_bram <= '0'; --send data to sdram rather than cpu
					offset_needed := offset_needed+1; --increment the offset
				end if;

			elsif STATE = "110" then --wait state for cs strobe
				ready_out <= '1';
				if rising_edge(cs_in) then
					STATE <= "001";
				end if;
			end if;
		end if;	
END PROCESS;
	
	
--signal for ila to view waveforms 	
addr_out<=addr_out_sig;	
wr_out<=wr_out_sig;

--ILA outputs
ila_data(15 downto 0) <= addr_in;
ila_data(23 downto 16) <= data_in_cpu;
ila_data(24) <= cs_in;
ila_data(25) <= wr_in;
ila_data(41 downto 26) <= addr_out_sig;
ila_data(49 downto 42) <= addr_cache_bram;
ila_data(50) <= memstrb;
ila_data(58 downto 51) <= data_out_bram;
ila_data(59) <= smux2_bram;
ila_data(62 downto 60) <= STATE;
ila_data(63) <= smux1_bram;
ila_data(71 downto 64) <= data_in_sdram;
ila_data(72) <= wr_out_sig;
ila_data(255 downto 73) <= (others => '0');


end Behavioral;

