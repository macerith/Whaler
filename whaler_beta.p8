pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
poke(0x5f5c,8) 
poke(0x5f5d,8)
w = {}
last_hit = 0
tport_t = {}
wnum_t = {1,2,3,4,5,6,7,8,9,10,
          11,12,13,14,15}
smoke_t = {023,024,025,026}
score_t = {50,50,50,50,50}
menu_state = 0
start_t = 0
s_t = {}
tcol_t = {7,8,9,10,11,12,14}
col_ctr = 0
col_t = {7,7,7,10,10,12,12,8}
p_x = 16  p_y = 64
ps_t = {}
es_t = {}
pan_state = 0
saucer_t = {}
striker_t = {}
speeder_t = {}
tank_t = {}
jet_t = {}
gunship_t = {}
blaster_t = {}
sdest_t = {}
ldest_t = {}
missile_t = {}
lasers_t = {}
score_h = 0
score_ht = 0
score_hm = 0
score_hb = 0
p_health = 5
krill_t = {}
end_t = 0
krill_ctr = 0
wave_num = 1
wave_ctr = 0
saucer_x = 110
striker_x = 110
speeder_x = 110
tank_x = 110
jet_x = 100
gs_hp = 0
gs_ctr = 0
bs_hp = 0
bs_ctr = 0

function draw_krill()
	if rnd(200) < 1 then
		add(krill_t,{130,rnd(127),0})
	end
	for i in all(krill_t) do
		if t()%0.5 == 0 then
	 	if  i[3] == 1 then
				i[3] = 0
			else
			 i[3] = 1
	 	end
	 end
	 if i[3] == 0 then
		 spr(050,i[1],i[2])
	 else
		 spr(051,i[1],i[2])
		end
		i[1] -= .5
		if i[1]<-20 then
			del(krill_t,i)
		end
 end
end

function draw_health()
	for i=1,p_health do
		spr(063,(128-i*9),1)
	end
end		
					
function draw_score()
	print("score",50,1,8)
	if score_h < 10 then
	  print(score_h,66,8,7)
	 elseif score_h < 100 then
	  print(score_h,62,8,7)
	 else
	 	print(score_h,58,8,7)
	end
	if score_ht > 0 then
	 if score_h < 10 then
	 	print(0,62,8,7)
	 	print(0,58,8,7)
	 elseif score_h < 100 then
	  print(0,58,8,7)
	 end
	 if score_ht < 10 then
	   print(score_ht,54,8,7)
	  elseif score_ht < 100 then
	   print(score_ht,50,8,7)
	  else
	 	 print(score_ht,46,8,7)
	 end
	end
	if score_hm > 0 then
	 if score_ht < 10 then
	 	print(0,46,8,7)
	 	print(0,50,8,7)
	 elseif score_ht < 100 then
	  print(0,46,8,7)
	 end
	 if score_hm < 10 then
	   print(score_hm,42,8,7)
	  elseif score_hm < 100 then
	   print(score_hm,38,8,7)
	  else
	 	 print(score_hm,34,8,7)
	 end
	end
	if score_hb > 0 then
	 if score_hm < 10 then
	 	print(0,38,8,7)
	 	print(0,34,8,7)
	 elseif score_hm < 100 then
	  print(0,34,8,7)
	 end
	 if score_hb < 10 then
	   print(score_hb,30,8,7)
	  elseif score_hb < 100 then
	   print(score_hb,26,8,7)
	  else
	 	 print(score_hb,22,8,7)
	 end
	end
end	

function add_score(x)
	score_h += x
	if score_h > 999 then
		score_ht += flr(score_h/1000)
		score_h = score_h%1000
	end
	if score_ht > 999 then
		score_hm += flr(score_ht/1000)
		score_ht = score_ht%1000
	end
	if score_hm > 999 then
		score_hb += flr(score_hm/1000)
		score_hm = score_hm%1000
	end
end

function check_hit(
x,y,xthresh,ythresh,t)
	for i in all(t) do
		if i[1] < x+xthresh and
			i[1] > x-xthresh and
			i[2] < y+ythresh and
			i[2] > y-ythresh then
			del(t,i)
			if t == missile_t then
				add(sdest_t,i)
			end
			return true
		end
	end
	return false
end

function pregen_stars()
	for i=1,128 do
		if rnd(5) < 2 then
		 add(s_t,{127,rnd(127),rnd(col_t)})
	 end
	 for i in all(s_t) do
		 i[1] -= 1
  end
 end
end
	
function starfield()
	if rnd(5) < 2 then
		add(s_t,{127,rnd(127),rnd(col_t)})
	end
	for i in all(s_t) do
		pset(i[1],i[2],i[3])
		i[1] -= 1
		if i[1]<0 then
			del(s_t,i)
		end
 end
end
	
function enemy_end_behavior(t)
	for i in all(t) do
		i[1] -= .25		
	end
end

-->8
function draw_p()
	if game_state == 3 then
		spr(019,p_x,p_y)
		return
	end
	if check_hit(
	p_x,p_y,5,3,es_t) then
	 if t() - last_hit > .5 then
	  sfx(3)
	  p_health -= 1
	  pan_state = 2
	  last_hit = t()
	 end
	end
 if check_hit(
	p_x,p_y,4,6,missile_t) then
	 if t() - last_hit > .5 then
	  sfx(3)
	  p_health -= 1
	  pan_state = 2
	  last_hit = t()
	 end
	end
 for i in all(laser_t) do
		if i[1] < p_y+2 and
			  i[1] > p_y-7 then
		 if t() - last_hit > .5 then
	   sfx(3)
	   p_health -= 1
	   pan_state = 2
	   last_hit = t()
	  end
	 end
	end
	if check_hit(
	    p_x,p_y,5,5,krill_t) then
  add_score(150)
	 pan_state = 3
	 krill_ctr += 1
  if krill_ctr > 2 then
  	if p_health < 5 then
	 		p_health += 1
	 	end
	 	krill_ctr = 0
	 	sfx(13)
	 	add_score(350)
	 else
	 	sfx(12)
	 end
	end
	if t()%0.5 == 0 then
	 if  pan_state == 1 then
			pan_state = 0
		else
			pan_state = 1
		end
	end
	if pan_state == 0 then
		spr(001,p_x,p_y)
	elseif pan_state == 1 then
		spr(017,p_x,p_y)
	elseif pan_state == 3 then
		spr(018,p_x,p_y)		
	else
		spr(049,p_x,p_y)
	end
end

function p_input()
	if game_state == 3 then
		return
	end
	if btn(0) and p_x > 2 then
  p_x-=3 end
	if btn(1) and p_x < 31 then
 	p_x+=1 end
	if btn(2) and p_y > -3 then 
  p_y-=2 end
 if btn(3) and p_y < 119 then
  p_y+=2 end
 if game_state == 1 then
 	return end
 if btnp(4) and #ps_t < 3 then
 	sfx(0)
 	add(ps_t,{p_x+2,p_y}) end
end

function do_p_shots()
	for i in all(ps_t) do
		spr(033,i[1],i[2])
		i[1] += 3
		if i[1]>127 then
			del(ps_t,i)
		end
 end
end

function do_move(y,move_y)
	if move_y < 0 then
		if y > 1+move_y then
			return true
		else
			return false
		end
	else		
		if y < 120-move_y then
			return true
		else
			return false
		end
	end
end

-->8
function draw_sdest()
	for i in all(sdest_t) do	
		if t() < i[3]+0.1 then
			spr(015,i[1],i[2])
		elseif t() < i[3]+0.2 then
			spr(031,i[1],i[2])
		elseif t() < i[3]+0.3 then
			spr(047,i[1],i[2])
		elseif t() < i[3]+0.4 then
			spr(015,i[1],i[2])
		else
			del(sdest_t,i)
		end
	end
end	

function draw_tport()
	for i in all(tport_t) do	
		if t() < i[3]+0.1 then
			spr(083,i[1],i[2])
		elseif t() < i[3]+0.2 then
			spr(082,i[1],i[2])
		elseif t() < i[3]+0.3 then
			spr(081,i[1],i[2])
		elseif t() < i[3]+0.4 then
			spr(080,i[1],i[2])
		else
			del(tport_t,i)
		end
	end
end

function draw_ldest()
	for i in all(ldest_t) do	
		if t() < i[3]+0.1 then
			sspr(104,0,16,16,i[1],i[2])
		elseif t() < i[3]+0.2 then
			sspr(104,16,16,16,i[1],i[2])
		elseif t() < i[3]+0.3 then
			sspr(104,0,16,16,i[1],i[2])
		elseif t() < i[3]+0.4 then
			sspr(88,0,16,16,i[1],i[2])
		elseif t() < i[3]+0.5 then
			sspr(104,16,16,16,i[1],i[2])
		elseif t() < i[3]+0.6 then
			sspr(88,0,16,16,i[1],i[2])
		elseif t() < i[3]+0.7 then
			sspr(104,16,16,16,i[1],i[2])
		elseif t() < i[3]+0.8 then
			sspr(104,0,16,16,i[1],i[2])
		else
			del(ldest_t,i)
		end
	end
end	

function spawn_e_shot(x,y)
	for i in all(es_t) do
		if i[1] < x+12 and
			i[1] > x-12 and
			i[2] < y+8 and
			i[2] > y-8 then
			return
		end
 end
 add(es_t,{x-2,y})
 sfx(1)
end

function do_e_shots()
	for i in all(es_t) do
		spr(003,i[1],i[2])
		i[1] -= 3
		if i[1]<0 then
			del(es_t,i)
		end
 end
end

function spawn_saucer(y)
	add(saucer_t,{150,y,y,0})
end

function draw_saucers()
	for i in all(saucer_t) do
		spr(002,i[1],i[2])
	end
end

function saucer_ai(x)
	if game_state == 3 then
  enemy_end_behavior(saucer_t)
		return
	end
			
	for i in all(saucer_t) do
		if i[1] > x then
			i[1] -= 1
		elseif i[2] < i[3]-9 then
			i[4] = 1
			i[2] += 1
			if rnd(15) < 1 then
				spawn_e_shot(i[1],i[2])
			end	
		elseif i[2] > i[3]+9 then
			i[4] = 0
			i[2] -= 1
			if rnd(15) < 1 then
				spawn_e_shot(i[1],i[2])
			end
		elseif i[4] == 0 then
			i[2] -= 1
			if rnd(15) < 1 then
				spawn_e_shot(i[1],i[2])
			end
		else
			i[2] += 1
			if rnd(15) < 1 then
				spawn_e_shot(i[1],i[2])
			end
		end
		if check_hit(
		i[1],i[2],5,4,ps_t) then
			add(sdest_t,{i[1],i[2],t()})
			del(saucer_t,i)
			sfx(2)
			add_score(100)
		end
 end
end

function spawn_striker(y)
	add(striker_t,{150,y,y,0,0})
end

function draw_strikers()
	for i in all(striker_t) do
		if i[5] == 0 then
			spr(004,i[1],i[2])
		else
		 spr(005,i[1],i[2])
		end
	end
end

function striker_ai(x)
	if game_state == 3 then
  enemy_end_behavior(striker_t)
		return
	end
			
	for i in all(striker_t) do
		if i[1] > x then
			i[1] -= 1
		elseif i[4] < 10 then
			i[4] += 1
			if do_move(i[2],1) then
			 i[2] += 1 end
			spawn_e_shot(i[1],i[2])
		elseif i[4] < 40 then
			i[4] += 1
		elseif i[4] < 50 then
			i[4] += 1
			if do_move(i[2],1) then
			 i[2] += 1 end
			spawn_e_shot(i[1],i[2])	
		elseif i[4] < 80 then
			i[4] += 1
		elseif i[4] < 90 then
			i[4] += 1
			if do_move(i[2],1) then
			 i[2] += 1 end
			spawn_e_shot(i[1],i[2])
		elseif i[4] < 120 then
			i[4] += 1
		elseif i[4] < 130 then
			i[4] += 1
			if do_move(i[2],1) then
			 i[2] -= 1 end
			spawn_e_shot(i[1],i[2])
		elseif i[4] < 160 then
			i[4] += 1
		elseif i[4] < 170 then
			i[4] += 1
			if do_move(i[2],-1) then
			 i[2] -= 1 end
			spawn_e_shot(i[1],i[2])	
		elseif i[4] < 200 then
			i[4] += 1
		elseif i[4] < 210 then
			i[4] += 1
			if do_move(i[2],-1) then
			 i[2] -= 1 end
			spawn_e_shot(i[1],i[2])
		elseif i[4] < 240 then
			i[4] += 1
		else
			i[4] = 0
		end
		if check_hit(
		i[1],i[2],5,4,ps_t) then
			i[5] += 1
			if i[5] == 1 then
				sfx(15)
			else
				add(sdest_t,{i[1],i[2],t()})
				del(striker_t,i)
				sfx(2)
				add_score(200)
			end
		end
 end
end

function spawn_speeder(y)
	add(speeder_t,{150,y,y,0})
end

function draw_speeders()
	for i in all(speeder_t) do
		spr(020,i[1],i[2])
	end
end

function speeder_ai(x)
	if game_state == 3 then
  enemy_end_behavior(speeder_t)
		return
	end
			
	for i in all(speeder_t) do
		if i[1] > x then
			i[1] -= 2
		elseif i[2] >= 118 then
			i[4] = 1
			i[2] -= 2
			if rnd(15) < 1 then
				spawn_e_shot(i[1],i[2])
			end
		elseif i[2] <= 2 then
			i[4] = 0
			i[2] += 2
			if rnd(15) < 1 then
				spawn_e_shot(i[1],i[2])
			end
		elseif i[2] < 118 and
									i[4] == 0 then
			i[2] += 2
			if rnd(15) < 1 then
				spawn_e_shot(i[1],i[2])
			end	
		elseif i[2] > 2 and
										i[4] == 1 then
			i[2] -= 2
			if rnd(15) < 1 then
				spawn_e_shot(i[1],i[2])
			end
		end
		if check_hit(
		i[1],i[2],5,4,ps_t) then
			add(sdest_t,{i[1],i[2],t()})
			del(speeder_t,i)
			sfx(2)
			add_score(150)
		end
 end
end

function spawn_tank(y)
	add(tank_t,{150,y,y,0,0})
end

function draw_tanks()
	for i in all(tank_t) do
		if i[5] == 0 then
			spr(036,i[1],i[2])
		elseif i[5] == 1 then
		 spr(052,i[1],i[2])
		else
			spr(021,i[1],i[2])
		end
	end
end

function tank_ai(x)
	if game_state == 3 then
  enemy_end_behavior(tank_t)
		return
	end
			
	for i in all(tank_t) do
		if check_hit(
		    i[1],i[2],5,4,ps_t) then
			i[5] += 1
			if i[5] < 3 then
				sfx(15)
			else
				add(sdest_t,{i[1],i[2],t()})
				del(tank_t,i)
				sfx(2)
				add_score(300)
			end
		end
		if i[1] > x then
			i[1] -= .5
			return
		elseif i[2] >= 119 then
			i[4] = 1
			i[2] -= .5
		elseif i[2] <= 1 then
			i[4] = 0
			i[2] += .5
		elseif i[2] < 119 and
									i[4] == 0 then
			i[2] += .5
		elseif i[2] > 1 and
									i[4] == 1 then
			i[2] -= .5
		end
		if pan_state == 1 then
			spawn_e_shot(i[1],i[2])
		end
 end
end

function spawn_jet(y)
	add(jet_t,{150,y,y,0,0})
end

function draw_jets()
	for i in all(jet_t) do
		spr(006,i[1],i[2])
	end
end

function jet_ai(x)
	if game_state == 3 then
  enemy_end_behavior(jet_t)
		return
	end
	
	for i in all(jet_t) do
		if check_hit(
						i[1],i[2],5,4,ps_t) then
			add(sdest_t,{i[1],i[2],t()})
			del(jet_t,i)
			sfx(2)
			add_score(200)
		end
 	if i[1] > x then
 		i[1] -= 3
 	elseif i[4] == 1 then
 		if (rnd({1,1,1,1,1,2}) == 1) and
 					do_move(i[2],3) then
 			i[2] += 3
 		else
 			i[4] = 0
 		end
 	elseif i[4] == 2 then
 		if rnd({1,1,1,1,1,2}) == 1 and
 					do_move(i[2],-3) then
 			i[2] -= 3
 		else
 			i[4] = 0
 		end
 	elseif i[4] == 0 then
 		if	i[5] < 15 then 
 		 i[5] += 1
 		else
 			i[4] = 3
 			i[5] = 0
 		end
 	else
 		if i[5] < 30 then
 			spawn_e_shot(i[1],i[2])
 			i[5] += 1
 		else
 			i[5] = 0
 			i[4] = rnd({1,2})
 		end
 	end
 end
end
 		
 		 
-->8
game_state = 0
--0=menu,1=start,2=playing,3=lose

function state0_run()
	if t()%5 == 0 then
		if menu_state == 0 then
			menu_state = 1
		else
			menu_state = 0
		end
	end
	if menu_state == 0 then
		local col = tcol_t[col_ctr]
		print("w h a l e r",40,50,col)
		col_ctr += 1
		if col_ctr > 7 then
	 	col_ctr = 0
		end
		if t() > start_t+1 then
			print("PRESS X TO START",30,
									70,8) end
	else
		print("placeholder",41,30,8)
	end
end

function state1_run(inp_t)
	start_game()
	draw_p()
	draw_score()
 draw_health()
 print("ready",50,54,12)
end

function state2_run()
	do_p_shots()
	do_e_shots()
	do_missiles()
	do_lasers()
	draw_sdest()
	draw_ldest()
	draw_tport()
 draw_p()
 draw_krill()
 draw_saucers()
 draw_strikers()
 draw_speeders()
 draw_tanks()
 draw_jets()
 draw_gunship()
 draw_blaster()
 draw_score()
 draw_health()
 check_wave(wave_num)
 print("wave "..wave_num,1,1,7)
end

function state3_run(inp_t)
	do_p_shots()
	do_e_shots()
	do_missiles()
	draw_sdest()
	draw_ldest()
	draw_tport()
 draw_p()
 draw_saucers()
 draw_strikers()
 draw_speeders()
 draw_tanks()
 draw_jets()
 draw_gunship()
 draw_blaster()
 draw_score()
 print("game over",45,54,8)
 if (t() > (inp_t+5)) then
 	game_state = 0
 	menu_state = 0
 	start_t = t()
 end
end
	

function start_game(t)
	p_x = 16  p_y = 64
	tport_t = {}
	ps_t = {}
	es_t = {}
	pan_state = 0
	saucer_t = {}
	striker_t = {}
	speeder_t = {}
	tank_t = {}
	jet_t = {}
	gunship_t = {}
	blaster_t = {}
	sdest_t = {}
	ldest_t = {}
	missile_t = {}
	laser_t = {}
 score_h = 0
 score_ht = 0
 score_hm = 0
 score_hb = 0
	p_health = 5
	krill_t = {}
	krill_ctr = 0
	wave_num = 1
	saucer_x = 110
	striker_x = 110
	speeder_x = 110
	tank_x = 110
	jet_x = 110
	wave_ctr = 0
	gs_hp = 0
 gs_ctr = 0
 bs_hp = 0
 bs_ctr = 0
end

function enemies_left()
	if #saucer_t > 0 or
				#striker_t > 0 or
				#speeder_t > 0 or
				#jet_t > 0 or
				#tank_t > 0 or
				#gunship_t > 0 or
				#blaster_t > 0 then
		return true
	else
		return false
	end
end

function bs_tport(x,y)
 bs_temp = rnd({-41,-37,-33,-29,
                -25,-21,-17,-13,
                13,17,21,25,29,
                33,37,41})
 while not (y+bs_temp < 112 and
         y+bs_temp > 1) do
  bs_temp = rnd({-41,-37,-33,-29,
                -25,-21,-17,-13,
                13,17,21,25,29,
                33,37,41})
 end
 if y+bs_temp < 112 and
  	 y+bs_temp > 1 then
  sfx(23)
  add(tport_t,{x+5,y,t()})
  return bs_temp
 else
  return 0
 end
end
-->8
function check_state()
	if p_health <= 0 and
				game_state != 3 then
		game_state = 3
		sfx(14)
		p_health = 5
		end_t = t()
	end
	if game_state == 0 then
		state0_run()
	elseif game_state == 1 then
		state1_run(end_t)
	elseif game_state == 2 then
	 state2_run()
	else
		state3_run(end_t)
	end
end

function _init()
	pregen_stars()
end

function _update()
	if game_state == 0 then
		if btn(5) then
		 sfx(24)
   sfx(25)
		 end_t = t() - 5
			game_state = 1 end
	else
		p_input()
		saucer_ai(saucer_x)
		striker_ai(striker_x)
		speeder_ai(speeder_x)
		jet_ai(jet_x)
		tank_ai(tank_x)
		gunship_ai()
		blaster_ai()
	end
end
 
function _draw()
	cls(0)
	starfield()
	check_state()
	if end_t == 0 then
		if game_state == 1 and
			  t() > 3 then
			game_state = 2
		end	
	else
		if game_state == 1 and
				 t() > end_t+8 then
			game_state = 2
		end
	end
end

function spawn_gunship()
	add(gunship_t,{150,48,48,0,0,0,0,0})
	gs_hp = 50
	gs_ctr = 0
end

function draw_gunship()
	for i in all(gunship_t) do
	 if i[7] == 1 and
	    i[8] < 5 then
	  sspr(56,16,16,16,i[1],i[2])
	  i[8] += 1
	 elseif i[7] == 1 and
	        i[8] >= 5 then
	  sspr(56,16,16,16,i[1],i[2])
	  i[7] = 0
	  i[8] = 0
	 else 	
		 sspr(40,16,16,16,i[1],i[2])
		end
	end
	if game_state == 3 then
		return
	end
	if #gunship_t > 0 then
		bar_per = ((77*gs_hp)/50)+26
		rectfill(25,113,104,120,7)
		if bar_per > 26 then
	 	rectfill(26,114,bar_per,119,8)
		end
	end
end

function double_shot(ctr,x,y)
	if ctr%10 ==  0 then
		add(es_t,{(x-2),(y+2)})
		add(es_t,{(x-2),(y+10)})
		sfx(18)
	end
end		

function spawn_laser(y)
	add(laser_t,{y,0})
	sfx(22)
end

function spawn_missile(x,y)
	add(missile_t,{x,y,t(),p_x,p_y})
	sfx(19)
end

function do_lasers()
	for i in all(laser_t) do
		if i[2] < 30 then
			for j in all {0,8,16,24,32,40,
			              48,56,64,72,80,88,96,104}
			              do
			 spr(rnd(4)+64,j,i[1]+4)
			end
			if i[2]%4 == 0 then
				sfx(22)
			end
			i[2] += 1
		else
			del(laser_t,i)
		end
	end
end
		
function do_missiles()
	for i in all(missile_t) do
	 if i[1] < i[4]+1 then
	 	del(missile_t,i)
	 	add(sdest_t,{i[1],i[2],t()})
	 	sfx(2)
	 end
		if i[2] < i[5]-1 then
			i[2] += 1
			spr(rnd(smoke_t),(i[1]+8),(i[2]-3))
			spr(rnd(smoke_t),(i[1]+16),(i[2]-6))
			spr(rnd(smoke_t),(i[1]+24),(i[2]-9))
		elseif i[2] > i[5]+1 then
			i[2] -= 1
			spr(rnd(smoke_t),(i[1]+8),(i[2]+3))
			spr(rnd(smoke_t),(i[1]+16),(i[2]+6))
			spr(rnd(smoke_t),(i[1]+24),(i[2]+9))
		else
   spr(rnd(smoke_t),(i[1]+8),i[2])
			spr(rnd(smoke_t),(i[1]+16),i[2])
			spr(rnd(smoke_t),(i[1]+24),(i[2]))			
		end
		i[1] -= 2
		spr(022,i[1],i[2])
		spr(007,i[4],i[5])
	end
end
		
function gunship_ai()
	if game_state == 3 then
  enemy_end_behavior(gunship_t)
		return
	end
			
	for i in all(gunship_t) do
		if check_hit(
		    (i[1]+4),(i[2]+4),
		    8,8,ps_t) then
			gs_hp -= 1
			i[7] = 1
			if gs_hp <= 0 then
			 add(ldest_t,{i[1],i[2],t()})
				del(gunship_t,i)
				sfx(17)
				add_score(1500)
				return
			end
			sfx(15)
		end
		if i[1] > 100 and
		   i[6] != 2 then
			i[1] -= .5
   return
		elseif i[6] == 0 and
		       i[2] >= 112 and
		       i[5] < 150 and
		       i[4] == 0 then
			i[4] = 1
			i[2] -= 1
			i[5] += 1
			double_shot(i[5],i[1],i[2])
		elseif i[6] == 0 and
		       i[2] <= 1 and
		       i[5] < 150 and
		       i[4] == 1 then
			i[4] = 0
			i[2] += 1
			i[5] += 1
			double_shot(i[5],i[1],i[2])
		elseif i[2] < 112 and
	        i[6] == 0 and
	        i[5] < 150 and
									i[4] == 0 then
			i[2] += 1
			i[5] += 1
			double_shot(i[5],i[1],i[2])
		elseif i[2] > 1 and
		       i[6] == 0 and
		       i[5] < 150 and
									i[4] == 1 then
			i[2] -= 1
			i[5] += 1
			double_shot(i[5],i[1],i[2])
		elseif i[5] >= 150 and
									i[6] == 0then
			i[6] = 1
			i[5] = -15
			sfx(20)
		elseif i[6] == 1 and
									i[5] < 60 then
			if i[5]%30== 0 then
				spawn_missile(i[1]+3,i[2])
			end
			i[5] += 1
		elseif i[6] == 1 then
		 if gs_ctr > 1 then
			 i[6] = 2
			 i[5] = 0
			 speeder_x = 102
			 spawn_speeder(16)
			 spawn_speeder(48)
			 spawn_speeder(64)
			 spawn_speeder(96)
			 spawn_speeder(108)
			 spawn_speeder(112)
			 sfx(21)
			 gs_ctr = 0
			else
			 gs_ctr += 1
			 i[6] = 0
			 i[5] = 0
			end
		elseif i[6] == 2 then
		 if #speeder_t < 1 then
		 	i[6] = 0
		 	i[5] = 0
		 	return
		 end
		 double_shot(i[5],i[1],i[2])
		 i[5] += 1
			if i[1] < 110 then
			 i[1] += 3
			elseif i[2] >= 112 and
		    i[4] == 0 then
			 i[4] = 1
			 i[2] -= 3
		 elseif i[2] <= 1 and
		       i[4] == 1 then
			 i[4] = 0
			 i[2] += 3
		 elseif i[2] < 112 and
									 i[4] == 0 then
			 i[2] += 3
		 elseif i[2] > 1 and
									i[4] == 1 then
			 i[2] -= 3
			end
		else
		 i[6] = 0
		end
 end
end

function spawn_blaster()
	add(blaster_t,{150,48,0,0,0,0,0,0})
	bs_hp = 30
	bs_ctr = 0
end

function draw_blaster()
	for i in all(blaster_t) do
		if i[7] == 2 and
					i[8] < 30 then
			if i[8]%2 == 0 then
				sspr(32,48,16,16,i[1],i[2])
				i[8] += 1
			else
				sspr(48,48,16,16,i[1],i[2])
				i[8] += 1
			end
		elseif i[7] == 2 and
									i[8] >= 5 then
			sspr(32,48,16,16,i[1],i[2])
			i[7] = 0
			i[8] = 0
	 elseif i[7] == 1 and
	    i[8] < 5 then
	  sspr(16,48,16,16,i[1],i[2])
	  i[8] += 1
	 elseif i[7] == 1 and
	        i[8] >= 5 then
	  sspr(16,48,16,16,i[1],i[2])
	  i[7] = 0
	  i[8] = 0
	 else 	
		 sspr(0,48,16,16,i[1],i[2])
		end
	end
	if game_state == 3 then
		return
	end
	if #blaster_t > 0 then
		bar_per = ((77*bs_hp)/30)+26
		rectfill(25,113,104,120,7)
		if bar_per > 26 then
	 	rectfill(26,114,bar_per,119,8)
		end
	end
end

function blaster_ai()
	if game_state == 3 then
  enemy_end_behavior(blaster_t)
		return
	end
			
	for i in all(blaster_t) do
		if check_hit(
		    (i[1]+4),(i[2]+4),
		    8,8,ps_t) then
			bs_hp -= 1
			i[7] = 1
			if bs_hp <= 0 then
			 add(ldest_t,{i[1],i[2],t()})
				del(blaster_t,i)
				sfx(17)
				add_score(2500)
				return
			end
			sfx(15)
		end
		if i[1] > 100 then
			i[1] -= 1.5
   return
  elseif i[4] == 0 and
  							i[5] < 250 then
  	i[2] += bs_tport(i[1],i[2])
  	i[5] += 1
  	i[4] = 1
  	i[6] = 0
  elseif i[4] == 0 then
  	i[2] += bs_tport(i[1],i[2])
  	i[5] = 0
  	i[4] = 4
  elseif i[4] == 1 and
         i[6] < 13 then
   i[5] += 1
   i[6] += 1
  elseif i[4] == 1 then
   i[5] += 1
   i[6] = 0
   i[4] = 2
  elseif i[4] == 2 and
         i[6] < 30 then
   if i[6] == 0 then
   	spawn_laser(i[2])
   end
   i[7] = 2
   i[6] += 1
   i[5] += 1
  elseif i[4] == 2 and
         i[6] >= 5 then
   i[7] = 0
   i[5] += 1
   i[6] = 0
   i[4] = 3
  elseif i[4] == 3 and
  							i[6] < 13 then
  	i[5] += 1
  	i[6] += 1
  elseif i[4] == 3 then
  	i[5] += 1
  	i[6] = 0
  	i[4] = 0
  elseif i[4] == 0 and
  							i[5] >= 150 then
  	i[5] = 0
  	i[4] = 4
  	i[6] = 0
  	sfx(20)
  elseif i[4] == 4 and
         i[5] < 90 then
   if i[5]%15 == 0 then
    i[2] += bs_tport(i[1],i[2])
   	spawn_missile(i[1]+3,i[2])
   end
   i[5] += 1
  elseif i[4] == 4 then
  	i[5] = 0
  	i[3] += 1
  	i[4] = 0
  	if i[3] >= 3 then
  	 i[3] = 0
  	 i[4] = 5
  	 i[6] = 0
  	 saucer_x = 102
			 spawn_saucer(16)
			 spawn_saucer(64)
			 spawn_saucer(96)
			 spawn_saucer(112)
			 tank_x = 110
			 spawn_tank(32)
			 spawn_tank(64)
			 spawn_tank(96)
			 sfx(21)
			 sfx(23)
    add(tport_t,{i[1]+5,y,t()})
    i[1] = 300
    i[2] = -200
  	end
  elseif i[4] == 5 then
   if #saucer_t < 1 and
      #tank_t < 1 then
		 	i[4] = 0
		 	i[5] = 0
		 	sfx(23)
		 	i[1] = 150
		 	i[2] = 48
		 	return
		 end
		else
		 i[4] = 0
		end
 end
end
         
   	
  	
-->8
big_ctr = 0
wave_t_rnd = 0
function random_wave(x)
	if x == 1 then
  make_wave(25,70,89,102,76,89,115,
		2,2,2,2,1)
	elseif x == 2 then
	 make_wave(30,50,115,0,0,0,0,
		10,0,0,0,0)
	elseif x == 3 then
	 make_wave(30,50,115,0,89,102,0,
		5,0,3,3,0)
	elseif x == 4 then
	 make_wave(20,50,0,102,0,0,115,
		0,5,0,0,3)
	elseif x == 5 then
	 make_wave(30,50,0,0,115,0,0,
		0,0,7,0,0)
	elseif x == 6 then
	 make_wave(25,70,102,115,0,89,0,
		5,3,0,3,0)
	elseif x == 7 then
	 make_wave(30,70,115,0,102,0,0,
		7,0,5,0,0)
	elseif x == 8 then
	 make_wave(25,50,102,0,0,0,115,
		7,0,0,0,3)
	elseif x == 9 then
	 make_wave(25,70,89,102,76,89,115,
		4,2,1,1,2)
	elseif x == 10 then
	 make_wave(25,70,89,102,76,89,115,
		1,3,3,1,3)
	elseif x == 11 then
	 make_wave(25,70,89,102,76,89,115,
		2,3,2,1,3)
	elseif x == 12 then
	 make_wave(25,70,89,102,76,89,115,
		1,2,3,3,1)
	elseif x == 13 then
	 make_wave(25,70,89,102,76,89,115,
		1,2,1,4,1)
	elseif x == 14 then
	 make_wave(25,70,89,102,76,89,115,
		1,1,1,1,4)
	else
  make_wave(25,70,89,102,76,89,115,
		1,1,5,1,1)
	end
end

function make_wave(num_en,rate,
          sa_x,st_x,sp_x,j_x,t_x,
          num_sa,num_st,num_sp,
          num_j,num_t)
	saucer_x = sa_x
	striker_x = st_x
 speeder_x = sp_x
 tank_x = t_x
 jet_x = j_x
 if wave_ctr > num_en then
		if enemies_left() then
			return end
		wave_ctr = 0
		wave_num += 1
		wave_t_rnd = rnd(wnum_t)
		if wave_num % 6 == 0 then
		 boss_gen_roll = rnd({1,2})
		 if boss_gen_roll == 1 then
			 spawn_gunship()
			else
			 spawn_blaster()
			end
		end
		sfx(16)
		return end
	if #tank_t < num_t and
		  ceil(rnd(rate)) < 5 then
		spawn_tank(rnd(120))
  wave_ctr += 1	
 elseif #jet_t < num_j and
 		 ceil(rnd(rate)) < 5 then
 	spawn_jet(rnd(120))
 	wave_ctr += 1	
	elseif #striker_t < num_st and
		  ceil(rnd(rate)) < 5 then
		spawn_striker(rnd(98))
  wave_ctr += 1			
	elseif #speeder_t < num_sp and
		  ceil(rnd(rate)) < 5 then
		spawn_speeder(rnd(120))
  wave_ctr += 1
 elseif #saucer_t < num_sa and
		  ceil(rnd(rate)) < 5 then
		spawn_saucer(rnd(93) + 20)
  wave_ctr += 1
 end
end

function check_wave()
	if wave_num == 1 then
		make_wave(10,50,
												115,0,0,0,0,
												5,0,0,0,0)
 elseif wave_num == 2 then
 	make_wave(15,50,
												102,115,0,0,0,
												3,3,0,0,0)	
 elseif wave_num == 3 then
		make_wave(20,50,
												0,115,102,0,0,
												0,3,5,0,0)
	elseif wave_num == 4 then
		make_wave(20,50,
												102,0,0,89,115,
												3,0,0,2,1)
	elseif wave_num == 5 then
	 make_wave(25,70,
											 89,102,76,89,115,
											 2,2,2,2,1)
	elseif wave_num >= 6 then
	 if wave_num%6 == 0 then
	  if enemies_left() then
	 	 return
	 	else
	 	 wave_num += 1
	 	 wave_ctr = 0
	 	 wave_t_rnd = rnd(wnum_t)
	 	end
	 else
   random_wave(wave_t_rnd)
	 end
 else
 	print("end of game",50,50,8)
 	if big_ctr > 90 then
 	 p_health = 0
 	end
 	big_ctr += 1 	
	end
end
__gfx__
00000000000000000000000000000000000060000000500000055000888008880000000000010000000100000000000000000000000000000000000000000000
000000000000000000000000000000000006580000054a00005600008000000800011000001c1000001c100000008007800a0700000000000000000000000000
0070070000000000000000000000000006656500055454000056000580000008001cc10001c7c10001c7c1000070007000000000000000000000000000000000
00077000c0000cbc0003300007a800006336580052254a00336565680000000001c77c101c7a7c1001ca7c100800800a0a708a080000000000000000007a0700
000770000cc0cccc06633660777aaa880665650005545400336565680000000001c77c101c7aa7c11c77a7100000a0000000000000000000a000000000008000
00700700c0cccecc0066660007a800000006580000054a000056000580000008001cc10001c7c11001ca7c10070000087000a070000000700070000000780a00
00000000000eee0000000000000000000000600000005000005600008000000800011000001c10000017c100000a080000800000000000087000000000000000
00000000000000000000000000000000000000000000000000055000888008880000000000010000000110000070800a800700a0000080a00870000000000000
0000000000000000000000000000000009999000222002290000000000000000000000000000000000000000a0800a077000070800000808700a000000000000
0000000000000000000000000000000094a4a9002512215200000000000000000000000000000000000000000007000000a800000000a0700800000000000000
00000000000000000000000000055500099a4a90215115190880000a000000000000000000000000000000000000008000070a00000000a00070000008007080
0002200000000cbc000ee0000055d550000334a9021ee120856565650006700000070600000670000007060007000a077000000000000000a000000000700700
20222282000ccccce0eeeece05500d55000334a9021ee120856565650070050000007000000705000000570000080000a08008000000000000000000080080a0
02255522c0ceeecc0eebbbee55000d56099a4a90215115190880000a000060000005000000007000000600000a00070000000000000000000000000000700700
200005220ce00000e0000bee05000d5594a4a90025122152000000000000000000000000000000000000000000000008700a000000000000000000000800a080
00000000c00000000000000000000000099990002220022900000000000000000000000000000000000000000000a00000000000000000000000000000000000
000000000000000000000000000000005550055800000000055555500000000002222220000000000000000000000000000000000000000000000000a0700008
0000000000000000000000000000000057655675000000055d6d6d650000000228989892000000000000000000000000000000000000000000000000000a0700
00000000000000000000000000000000567667680000005d6d6d6d50000000289898982000000000000000000000000000000000000000000000000008000000
00000000000070000000000000000000056336500856565d6d6d55000e898928989822000000000000000000000000000000000000000a8000a00000a0800a07
0000000000cbeb0000000000000000000563365000000055555500000000002222220000000000000555555000000000022222200008000070000a00070080a0
000000000000b000000000000000000056766768005555d1d15000000022228484200000005555555ff555a800222222299222a8000070788070000080000000
0000000000000000000000000000000057655675051d1d1d15a000000248484842a0000005aa54444455558a02ee28888822228a000a00000000a0000800a000
0000000000000000000000000000000055500558513331d1d580000024eee484828000005aaa5ffff55555a82eee2999922222a800a080a7a708000070070a0a
000000000000000000000e000e00000e4440044a5d333d1d15a0000028eee84842a000005aaa5444555544502eee2888222288200000800770000a000cc00cc0
0000000000000000090b000000000b004654456405d1d1d1d5800000028484848280000055555ff5555ff5a822222992222992a8000700a808080000ce8cc8ec
0000000000000000e0000090b09000004565565a0055551d1d5000000022224848200000005444555544458a002888222288828a00a0070000000000ce8bb8ec
0000000000088000000000000000009004522540000000555555000000000022222200008565f5555ffff5a8e8989222299992a80000800780a00000ce8bb8ec
00000000808888580b0e0000e00b0000045225400856565d6d6d55000e8989289898220000005555555555500000222222222220000000a00000a0000ce88ec0
000000000882228800000090000000b04565565a0000005d6d6d6d50000000289898982000000000000000000000000000000000000000000700000000ceec00
000000008000028809000e000b000e0046544564000000055d6d6d650000000228989892000000000000000000000000000000000000000000000000000cc000
0000000000000000000b0000009000004440044a0000000005555550000000000222222000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8a9a88988a89889a89a99888a9a9898a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8a89a8a9898aa988a88a8a9a898a8a88000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000700000000000000000000c070000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000070000000000000000000010700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00011000000000000c0070c00c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
701cc100007107000070070010c00c07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001cc1070000c0000c00c0100700c010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00011000007c010000700700c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000070000000000c0010c00c001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00007000000000000000000070070c0c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000055a000000000000022a000000000000066a000000000000077a0000000000000000000000000000000000000000000000000000000000000000
000000000000567800000000000028980000000000006ea80000000000007ae80000000000000000000000000000000000000000000000000000000000000000
000555550005765a000222220002982a000666660006ae6a000777770007ea7a0000000000000000000000000000000000000000000000000000000000000000
00567676500575000028989820029200006eaeae6006a600007aeaea7007e7000000000000000000000000000000000000000000000000000000000000000000
0576555675567500029822289228920006ae666ea66ea60007ea777ae77ae7000000000000000000000000000000000000000000000000000000000000000000
0575000576767500029200029898920006a60006aeaea60007e70007eaeae7000000000000000000000000000000000000000000000000000000000000000000
00500000567ccc5000200000289eee20006000006eaccc60007000007aeccc700000000000000000000000000000000000000000000000000000000000000000
0000000056cccc750000000028eeee92000000006ecccca6000000007acccca70000000000000000000000000000000000000000000000000000000000000000
0000000056cccc750000000028eeee92000000006ecccca6000000007acccca70000000000000000000000000000000000000000000000000000000000000000
00500000567ccc5000200000289eee20006000006eaccc60007000007aeccc700000000000000000000000000000000000000000000000000000000000000000
0575000576767500029200029898920006a60006aeaea60007e70007eaeae7000000000000000000000000000000000000000000000000000000000000000000
0576555675567500029822289228920006ae666ea66ea60007ea777ae77ae7000000000000000000000000000000000000000000000000000000000000000000
00567676500575000028989820029200006eaeae6006a600007aeaea7007e7000000000000000000000000000000000000000000000000000000000000000000
00055555000576580002222200029828000666660006ae68000777770007ea780000000000000000000000000000000000000000000000000000000000000000
000000000000567a000000000000289a0000000000006eaa0000000000007aea0000000000000000000000000000000000000000000000000000000000000000
00000000000005580000000000000228000000000000066800000000000007780000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000020150102502115017250221501a25023150171501e150131501d1500c1501b15013150191500a050161500c0501515005050121500805010150040500e150070500b1500915009150041500000000000
0001000035130062302c1300523023130042302313004230071300323007130042300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200003e6500d05033650060502a6500d05026650060501f6500d050060501c6500d050196500605016650040501564003040136400104010640000300c6300b63009620076200562003620016100061000600
00030000000000a0700a1701207009070111700817010070061700e07005570045700156002560075400254000530005300000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500001d1501d1502415024150300502d050300502d050300500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300001d1501d150211502115024150241502715027150290502d0502905030050290502d050290503505035050290502905035050350503500035000290002900035000350001d00000000000000000000000
3807000000000090700d070115701407010570140700f570140700e570140700f0700d5700e0700c5700d0600b5600c0600a5600b060095600a05008550090500754006740055400574004530037300253000000
000300000d170121701a2702117009170000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0009000021550265502d5500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00040000166500324020650032402a6500324035650032403f650022400124036650022402b6500124021650002301564000230136400023010640002200c6300022009620002100562003620016100061000600
000100002c150052502315005250191500325019150022501515003050141500205012050010500f050000500c050010500b05000050080500005006050000500405000050020500005000050000000000000000
000200002a6302b6302d6302f630316303363035630366303763036630336302c63025630206301b63019630166301463011630106300e6300d6300c6300b6300a63009630076300663005630046300363002630
000700002b32035320353202b32035320353200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000303502a350303502a350303002a300303002a300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000202500865002150081503a350202500865002150081503a3503a3501f2500865002150081501e25008650021503a3503a350081501c25008650021503a3501b250086501b25008650021500815019250
000200002a2503f6502a6502115028650282501715028650272500d15025650232500615021650021501d2501b650021501725015650021500b25007650021500115002150011500015000000000000000000000
000b00001c1501c1501c1501c15021150211502115021150231502315023150231502315023150211501f150211502115026150261502615026150231502315023150231502a1502a1502a1502a1502615026150
002c00000c2500c250092500925006250062500225002250281500425000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
