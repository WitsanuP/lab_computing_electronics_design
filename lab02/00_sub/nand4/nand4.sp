nand4

.option post=2 *generate output waveform
.prot 
.lib  'cic018.l' tt *call library
.unprot
.global vdd gnd
*DC source
vvdd vdd 0  1.8
vgnd gnd 0  0

*   drain gate source body mos_type L 
.subckt nand a b c d out vdd gnd 
mp0 out a vdd vdd p_18 l=0.18u w=1u 
mp1 out b vdd vdd p_18 l=0.18u w=1u 
mp2 out c vdd vdd p_18 l=0.18u w=1u 
mp3 out d vdd vdd p_18 l=0.18u w=1u 

mn0 out  a   net  0 n_18 l=0.18u w=1u 
mn1 net  b   net2 0 n_18 l=0.18u w=1u 
mn2 net2 c   net3 0 n_18 l=0.18u w=1u 
mn3 net3 d   0    0 n_18 l=0.18u w=1u 
.ends
xa1 a b c d out vdd gnd nand
*cload node+ node- value
cload  out   gnd   0.02p

*V  node+ node- pulse(V1  V2 T_delay T_rise T_fall pw    period)
va a    gnd   pulse(1.8 0  0.1n   0.1n  0.1n  9.9n 20n)
vb b    0     1.8
vc c    0     1.8
vd d    0     1.8

*transient analysis:Time step is 0.1n ,stop time is 80n
.tran 0.1n 80n 
*(sweep k 0.5u 2u 0.5u)

*delay analysis val=half of vdd
.meas tran delayN1 trig v(a)   val=0.9 rise=2
+                  targ v(out) val=0.9 fall=2

*average_power analysis
.meas tran pw avg power

*power-Delay-Product(pdp) analysis
.meas tran pdp=param('pw*delayN1')

.end

