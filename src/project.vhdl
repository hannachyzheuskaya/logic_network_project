library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
    
entity project_reti_logiche is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        o_address : out std_logic_vector(15 downto 0);
        o_done : out std_logic;
        o_en : out std_logic;
        o_we : out std_logic;
        o_data : out std_logic_vector (7 downto 0)
    );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
component datapath is
   port (
          i_start : in std_logic;
          i_clk : in std_logic;
          i_rst : in std_logic;
          i_data : in std_logic_vector(7 downto 0);
          i_address : in std_logic_vector(15 downto 0);
          
          fsm_on: in std_logic;
          dim_load: in std_logic;
          r1_load: in std_logic;
          r1_sel: in std_logic;
          r2_load: in std_logic;
          r3_load: in std_logic;
          r3_sel: in std_logic;
          r4_load: in std_logic;
          r5_load: in std_logic;
          r6_load: in std_logic;
          r7_load: in std_logic;
          bit_load: in std_logic; 
          bit_sel: in std_logic;
          addr_sel: in std_logic_vector(1 downto 0);
          dim_is_zero : out std_logic;
          end_reading : out std_logic;
          end_byte: out std_logic;
          o_address : out std_logic_vector(15 downto 0);
          o_data : out std_logic_vector (7 downto 0)      
    );
end component;

signal fsm_on: std_logic;
signal dim_load: std_logic;
signal r1_load: std_logic;
signal r1_sel: std_logic;
signal r2_load: std_logic;
signal r3_load: std_logic;
signal r3_sel: std_logic;
signal r4_load: std_logic;
signal r5_load: std_logic;
signal r6_load: std_logic;
signal r7_load: std_logic;
signal bit_sel: std_logic;
signal bit_load: std_logic;
signal dim_is_zero: std_logic;
signal addr_sel: std_logic_vector(1 downto 0);
signal end_reading: std_logic;
signal end_byte: std_logic;
signal i_address : std_logic_vector(15 downto 0);
type S is (s0, s1, s2, s3,s4, s5, s6, s7, s8,s9, s10, s11, s12, s13, s14, s15);

signal nextState,currentState: S; 

begin    
    DATAPATH0: datapath port map(
        i_start => i_start,
        i_clk => i_clk,
        i_rst => i_rst,
        i_data => i_data,
        dim_load => dim_load,
        r1_load => r1_load,
        r1_sel => r1_sel,
        r2_load => r2_load,
        r3_load => r3_load,
        r3_sel => r3_sel,
        r4_load => r4_load,
        r5_load => r5_load,
        r6_load => r6_load,
        r7_load => r7_load,
        bit_load => bit_load,
        bit_sel => bit_sel,
        dim_is_zero => dim_is_zero,
        end_byte => end_byte,
        end_reading => end_reading,
        addr_sel => addr_sel,
        o_address => o_address,
        i_address => i_address,
        o_data => o_data, 
        fsm_on => fsm_on
 );

  process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            currentState <= s0;
        elsif i_clk'event and i_clk = '1' then
            currentState <= nextState;
        end if;
    end process;

 process(i_clk, currentState, i_start, dim_is_zero, end_byte, end_reading)
    begin
        nextState <= currentState;
        case currentState is
            when S0 =>
                if i_start = '1' then
                    nextState <= S1;
                end if;
            when S1 =>
                   nextState <= S2;
            when S2 =>
                    nextState <= S3;
            when S3 =>
                if dim_is_zero = '1' then
                    nextState <= S15;
                 else
                    nextState <= S4;
                 end if;
            when S4 =>
                nextState <= S5;
            when S5 =>
                nextState <= S6;
            when S6 =>
                nextState <= S7;
            when S7 =>
                nextState <= S8;
            when S8 =>
                nextState <= S9;
            when S9 =>
                nextState <= S10;
            when S10 =>
               if end_byte = '1' and end_reading = '1' then
                    nextState <= S15;
               elsif end_byte = '1' and end_reading = '0' then
                    nextState <= S12;
               else
                    nextState <= S11;
               end if;
            when S11 =>
                nextState <= S6;
            when S12 =>
                nextState <= S13;
            when S13 =>
                nextState <= S14;  
            when S14 =>
                nextState <= S5;        
            when S15 =>
                 if i_start = '0' then
                    nextState <= S0;
                 end if;
        end case;
    end process;

    process(currentState)
    begin
        o_done <= '0';
        o_en <= '0';
        o_we <= '0';
        i_address <= (others => '0');
        
        dim_load <= '0';
        r1_sel <= '0';
        r1_load <= '0';
        r3_sel <= '0';
        r3_load <= '0';
        addr_sel <= "00";
        r2_load <= '0';
        bit_sel <= '0';
        bit_load <= '0';
        r4_load <= '0';
        r5_load <= '0';
        r6_load <= '0';
        r7_load <= '0';
        fsm_on <= '1';
        
        case currentState is
            when S0 =>
            when S1 =>
                addr_sel <= "10";
                o_en <= '1';
                r3_sel <= '0';
                r3_load <= '1';
                r1_sel <= '0';
                r1_load <= '1';
                --bit_sel <= '0';
                --bit_load <= '1';
            when S2 =>
                dim_load <= '1';
                --r3_load <= '0';
            when S3 =>
                r1_sel <= '1';
                r1_load <= '1';
            when S4 =>
                addr_sel <= "10";
                o_en <= '1';
                --r1_load <= '0';
                --r3_load <= '0';
            when S5 =>
                r2_load <= '1';
                bit_sel <= '0';
                bit_load <= '1';
            when S6 =>
                r4_load <= '1';
                bit_sel <= '1';
                bit_load <= '1';
            when S7 =>
                bit_sel <= '1';
                bit_load <= '1';
                r5_load <= '1';
            when S8 =>
                bit_sel <= '1';
                bit_load <= '1';
                r6_load <= '1';
            when S9 =>
                r7_load <= '1';
                fsm_on <= '0';
            when S10 =>
                addr_sel <= "11";
                o_en <= '1';
                o_we <= '1';
                fsm_on <= '0';
                --bit_load <= '0';
            when S11 =>
                bit_sel <= '1';
                bit_load <= '1';
                r3_sel <= '1';
                r3_load <= '1';
                --fsm_on <= '0';
            when S12 =>
                r1_sel <= '1';
                r1_load <= '1';
                fsm_on <= '0';
            when S13 =>    
                addr_sel <= "10";
                o_en <= '1';
                fsm_on <= '0';
            when S14 =>
                r3_sel <= '1';
                r3_load <= '1';  
                fsm_on <= '0';  
            when S15 =>
                o_done <= '1';
        end case;
    end process;
end Behavioral;

    
------------------------------------------
------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity datapath is
  port(
          i_start : in std_logic;
          i_clk : in std_logic;
          i_rst : in std_logic;
          i_data : in std_logic_vector(7 downto 0);
          i_address : in std_logic_vector(15 downto 0);
          
          fsm_on: in std_logic;
          dim_load: in std_logic;
          r1_load: in std_logic;
          r1_sel: in std_logic;
          r2_load: in std_logic;
          r3_load: in std_logic;
          r3_sel: in std_logic;
          r4_load: in std_logic;
          r5_load: in std_logic;
          r6_load: in std_logic;
          r7_load: in std_logic;
          bit_load : in std_logic;
          bit_sel : in std_logic;
          addr_sel: in std_logic_vector(1 downto 0);
          dim_is_zero : out std_logic;
          end_reading : out std_logic;
          end_byte: out std_logic;
          o_address : out std_logic_vector(15 downto 0);
          o_data : out std_logic_vector (7 downto 0)
     );
end datapath;

architecture Behavioral of datapath is
signal u: std_logic;
signal y: std_logic_vector(1 downto 0);
signal o_r1: std_logic_vector(15 downto 0);
signal o_r2: std_logic_vector(7 downto 0);
signal o_r3: std_logic_vector(15 downto 0);
signal o_r4: std_logic_vector(1 downto 0);
signal o_r5: std_logic_vector(1 downto 0);
signal o_r6: std_logic_vector(1 downto 0);
signal o_r7: std_logic_vector(1 downto 0);
signal o_bit: std_logic_vector(3 downto 0);
signal o_dim: std_logic_vector(7 downto 0);
signal mux1_r1: std_logic_vector(15 downto 0);
signal sum1: std_logic_vector(15 downto 0);
signal mux3_r3: std_logic_vector(15 downto 0);
signal sum3: std_logic_vector(15 downto 0);
signal muxb: std_logic_vector(3 downto 0);
signal sumb: std_logic_vector(3 downto 0);
signal conc1: std_logic_vector(3 downto 0);
signal conc2: std_logic_vector(5 downto 0);

type STATUS is (s0, s1, s2, s3);
signal PS, NS : STATUS;

begin
   r1: process(i_clk, i_rst)
    begin
        if i_rst='1' then
          o_r1 <= (others => '0');
        elsif rising_edge(i_clk) then
            if(r1_load='1') then
                o_r1 <= mux1_r1;
            end if;
        end if;
    end process;

   r2: process(i_clk, i_rst)
    begin
        if i_rst='1' then
          o_r2 <= (others => '0');
        elsif rising_edge(i_clk) then
            if(r2_load='1') then
                o_r2 <= i_data;
            end if;
        end if;
    end process;
    
    r3: process(i_clk, i_rst)
    begin
        if i_rst='1' then
          o_r3 <= (others => '0');
        elsif rising_edge(i_clk) then
            if(r3_load='1') then
                o_r3 <= mux3_r3;
            end if;
        end if;
    end process;
    
    b: process(i_clk, i_rst)
    begin
        if i_rst='1' then
          o_bit <= (others => '0');
        elsif rising_edge(i_clk) then
            if(bit_load='1') then
                o_bit <= muxb;
            end if;
        end if;
    end process;
    
    
    dim: process(i_clk, i_rst)
    begin
        if i_rst='1' then
          o_dim <= (others => '0');
        elsif rising_edge(i_clk) then
            if(dim_load='1') then
                o_dim <= i_data;
            end if;
        end if;
    end process;

   r4: process(i_clk, i_rst)
    begin
        if i_rst='1' then
          o_r4 <= (others => '0');
        elsif rising_edge(i_clk) then
            if(r4_load='1') then
                o_r4 <= y;
            end if;
        end if;
    end process;

   r5: process(i_clk, i_rst)
    begin
        if i_rst='1' then
          o_r5 <= (others => '0');
        elsif rising_edge(i_clk) then
            if(r5_load='1') then
                o_r5 <= y;
            end if;
        end if;
    end process;

   r6: process(i_clk, i_rst)
    begin
        if i_rst='1' then
          o_r6 <= (others => '0');
        elsif rising_edge(i_clk) then
            if(r6_load='1') then
                o_r6 <= y;
            end if;
        end if;
    end process;

   r7: process(i_clk, i_rst)
    begin
        if i_rst='1' then
          o_r7 <= (others => '0');
        elsif rising_edge(i_clk) then
            if(r7_load='1') then
                o_r7 <= y;
            end if;
        end if;
    end process;
       
    sumb <= o_bit + "0001";
    
    sum1 <= o_r1 + "0000000000000001";
    
    sum3 <= o_r3 + "0000000000000001";
    
    conc1 <= o_r4&o_r5;
    
    conc2 <= conc1&o_r6;
    
    o_data <= conc2&o_r7;
    
    with bit_sel select muxb <= 
        "0000" when '0',
        sumb when '1',
        "XXXX" when others;
        
    with r1_sel select mux1_r1 <= 
       "0000000000000000" when '0',
       sum1 when '1',
       "XXXXXXXXXXXXXXXX" when others;
       
    with r3_sel select mux3_r3 <= 
       "0000001111101000" when '0',
       sum3 when '1',
       "XXXXXXXXXXXXXXXX" when others;
       
    with o_bit select u <= 
       o_r2(7) when "0000",
       o_r2(6) when "0001",
       o_r2(5) when "0010",
       o_r2(4) when "0011",
       o_r2(3) when "0100",
       o_r2(2) when "0101",
       o_r2(1) when "0110",
       o_r2(0) when "0111",
       'X' when others;
       
   with addr_sel select o_address <= 
       o_r1 when "10",
       o_r3 when "11",
       "XXXXXXXXXXXXXXXX" when others;
       
     end_reading <= '1' when ("00000000"&o_dim = o_r1) else '0';
     end_byte <= '1' when (sumb = "1000") else '0';
     dim_is_zero <= '1' when (o_dim ="00000000") else '0';

 delta_lambda : process(PS, u)
     begin
            if PS = s0 then
                  if(u='0') then
                      NS <= s0;
                      y <= "00";
                  else
                      NS <= s2;
                      y <= "11";
                  end if;
              elsif PS = s1 then
                   if(u='0') then
                      NS <= s0;
                      y <= "11";
                   else
                      NS <= s2;
                      y <= "00";
                   end if;
               elsif PS = s2 then
                    if(u='0') then
                       NS <= s1;
                       y <= "01";
                    else
                       NS <= s3;
                       y <= "10";
                    end if;
               elsif PS = s3 then
                    if(u='0') then
                       NS <= s1;
                       y <= "10";
                     else
                       NS <= s3;
                       y <= "01";
                    end if;  
               else
                      NS <= s0;
                      y <= "00";    
               end if;                  
     end process;

 state: process(i_clk)
      begin
         if rising_edge(i_clk) then
           if rising_edge(i_rst) or rising_edge(i_start) then
              PS <= S0;
           else
              if fsm_on = '1' then
                 PS <= NS;
              end if;
         end if;
        end if;
      end process;

end Behavioral;