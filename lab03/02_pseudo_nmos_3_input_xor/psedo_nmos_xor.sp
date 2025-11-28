xor
.option post=2 *generate output waveform
.prot 
.lib  'cic018.l' tt *call library
.unprot
.global vdd gnd
*DC source
vvdd vdd 0 1.8
vgnd gnd 0  0

*   drain gate source body mos_type L 

.subckt inv a out vdd vss
mp0 out a vdd vdd p_18 l=0.18u w=2u
mn0 out a vss vss n_18 l=0.18u w=1u
.ends 

.subckt xor a a_bar b b_bar c c_bar out vdd vss
mp0     out   vss   vdd  vdd  p_18  l=0.18u  w=0.5u


mn0      out   a_bar   net02  vss  n_18  l=0.18u  w=3u
mn1      net02 b       net03  vss  n_18  l=0.18u  w=3u
mn2      net03 c       vss    vss  n_18  l=0.18u  w=3u

mn3      out   a       net12  vss  n_18  l=0.18u  w=3u
mn4      net12 b_bar   net13  vss  n_18  l=0.18u  w=3u
mn5      net13 c       vss    vss  n_18  l=0.18u  w=3u

mn6      out   a       net22  vss  n_18  l=0.18u  w=3u
mn7      net22 b       net23  vss  n_18  l=0.18u  w=3u
mn8      net23 c_bar   vss    vss  n_18  l=0.18u  w=3u

mn9      out   a_bar   net32  vss  n_18  l=0.18u  w=3u
mn10     net32 b_bar   net33  vss  n_18  l=0.18u  w=3u
mn11     net33 c_bar   vss    vss  n_18  l=0.18u  w=3u
.ends

xinv0 a_input a_bar_input vdd gnd inv 
xinv1 b_input b_bar_input vdd gnd inv
xinv2 c_input c_bar_input vdd gnd inv


xxor a_input a_bar_input b_input b_bar_input c_input c_bar_input out1 vdd gnd xor
*cload node+ node- value
cload  out1   gnd   0.05p

*V  node+ node- pulse(V1  V2 T_delay T_rise T_fall pw    period)
va a_input 0 pulse(1.8 0  0.1n   0.1n  0.1n  39.9n  80n)
vb b_input 0 pulse(1.8 0  0.1n   0.1n  0.1n  79.9n  160n)
vc c_input 0 pulse(1.8 0  0.1n   0.1n  0.1n  159.9n 320n)

*transient analysis:Time step is 0.1n ,stop time is 80n
.tran 0.1n 640n 
*(sweep k 0.5u 2u 0.5u)

*delay analysis val=half of vdd
.meas tran delayN1 trig v(a_input)  val=0.9 rise=2
+                  targ v(out1) val=0.9 fall=2

*average_power analysis
.meas tran pw avg power

*power-Delay-Product(pdp) analysis
.meas tran pdp=param('pw*delayN1')



.end

