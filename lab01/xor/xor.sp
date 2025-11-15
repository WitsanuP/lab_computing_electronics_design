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
.subckt  xor   a a_bar  b b_bar  out  vdd gnd 
mp0  net0  a      vdd   vdd  p_18  l=0.18u  w=4u
mp1  net1  a_bar  vdd   vdd  p_18  l=0.18u  w=4u
mp2  out   b      net1  vdd  p_18  l=0.18u  w=4u
mp3  out   b_bar  net0  vdd  p_18  l=0.18u  w=4u

mn0 out a     net2 0 n_18 l=0.18u w=2u 
mn1 out a_bar net3 0 n_18 l=0.18u w=2u 
mn2 net2 b     0 0 n_18 l=0.18u w=2u 
mn3 net3 b_bar 0 0 n_18 l=0.18u w=2u 
.ends
xa1 a a_bar  b b_bar  out  vdd gnd xor
*cload node+ node- value
cload  out   gnd   0.05p

*V  node+ node- pulse(V1  V2 T_delay T_rise T_fall pw    period)
va      a       gnd   pulse(1.8 0  0.1n   0.1n  0.1n  4.9n 10n)
va_bar  a_bar   gnd   pulse(0 1.8  0.1n   0.1n  0.1n  4.9n 10n)
vb      b       gnd   pulse(1.8 0  0.1n   0.1n  0.1n  9.9n 20n)
vb_bar  b_bar   gnd   pulse(0 1.8  0.1n   0.1n  0.1n  9.9n 20n)

*transient analysis:Time step is 0.1n ,stop time is 80n
.tran 0.1n 240n 
*(sweep k 0.5u 2u 0.5u)

*delay analysis val=half of vdd
.meas tran delayN1 trig v(a)   val=0.9 rise=2
+                  targ v(out) val=0.9 fall=1

*average_power analysis
.meas tran pw avg power

*power-Delay-Product(pdp) analysis
.meas tran pdp=param('pw*delayN1')



.end

