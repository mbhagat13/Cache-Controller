
-- VHDL Instantiation Created from source file cache_control.vhd -- 09:07:49 10/29/2019
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT cache_control
	PORT(
		addr_in : IN std_logic_vector(15 downto 0);
		wr_in : IN std_logic;
		cs_in : IN std_logic;
		clk : IN std_logic;
		data_in_cpu : IN std_logic_vector(7 downto 0);
		data_in_sdram : IN std_logic_vector(7 downto 0);          
		addr_out : OUT std_logic_vector(15 downto 0);
		wr_out : OUT std_logic;
		mstrb : OUT std_logic;
		data_out_sdram : OUT std_logic_vector(7 downto 0);
		data_out_cpu : OUT std_logic_vector(7 downto 0);
		ready_out : OUT std_logic
		);
	END COMPONENT;

	Inst_cache_control: cache_control PORT MAP(
		addr_in => ,
		wr_in => ,
		cs_in => ,
		clk => ,
		data_in_cpu => ,
		data_in_sdram => ,
		addr_out => ,
		wr_out => ,
		mstrb => ,
		data_out_sdram => ,
		data_out_cpu => ,
		ready_out => 
	);


