note
	description: "STABLE MARRIAGES application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			--Run application.
		require
			nothing: True
		local
			m_availability, w_availability: ARRAY[INTEGER]
			m_preferences, w_preferences, original_m_pref, original_w_pref: ARRAY2[INTEGER]
			n,self_id,pref_id: INTEGER
			m,w,m1,i,j,iter_1,p,flag: INTEGER
			r_temp:REAL


		do
			--taking input n
			io.read_integer
			n:=io.last_integer
			--initializing all men and women to free and their preference lists to empty
			create m_availability.make_filled (0, 1, n)
			create w_availability.make_filled (0, 1, n)
			create m_preferences.make_filled (0, n, n)
			create w_preferences.make_filled (0, n, n)

			--m_availability[i] = 0, if  man i is free, and m_availability[i] = j, if man i is engaged to woman j

			--taking input preferences
			from i:=1 until i>n	loop
				io.read_real
				r_temp:=io.last_real
				self_id:=r_temp.ceiling
				from j:=1 until j>n loop
					io.read_real
					r_temp:=io.last_real
					pref_id:=r_temp.ceiling
					w_preferences.put (pref_id, self_id, j)
					j:=j+1
				end
				i:=i+1
			end
			from i:=1 until i>n	loop
				io.read_real
				r_temp:=io.last_real
				self_id:=r_temp.ceiling
				from j:=1 until j>n loop
					io.read_real
					r_temp:=io.last_real
					pref_id:=r_temp.ceiling
					m_preferences.put (pref_id, self_id, j)
					j:=j+1
				end
				i:=i+1
			end

			--checking input valid or not
			flag:=1
			from i:=1 until i>n	loop
				from j:=1 until j>n loop
					iter_1:=0
					from p:=1 until p>n loop
						if m_preferences.item (i, p)=j then
							iter_1:=1
						end
						p:=p+1
					end
					if iter_1/=1 then
						flag:=0
					end
					j:=j+1
				end
				i:=i+1
			end
			from i:=1 until i>n	loop
				from j:=1 until j>n loop
					iter_1:=0
					from p:=1 until p>n loop
						if w_preferences.item (i, p)=j then
							iter_1:=1
						end
						p:=p+1
					end
					if iter_1/=1 then
						flag:=0
					end
					j:=j+1
				end
				i:=i+1
			end
			if flag=0 then
				print("INVALID%N")
			else

				original_m_pref:=m_preferences
				original_w_pref:=w_preferences

				--while there exists free man who still has a woman to propose to
				from iter_1:=1 until iter_1>1 loop
					m:=get_free_man(m_availability)
					if (m/=0) then
						w:=first_preference(m,m_preferences)
						if (w/=0) then
							--print("Got man "+m.out+" Got Woman "+w.out+"%N")
							if (w_availability.item (w)=0) then
								m_availability.put (w, m)
								w_availability.put (m, w)
							elseif (w_availability.item (w)>0) then
								m1 := w_availability.item (w)
								--print("Got m1 "+m1.out+"%N")
								if (prefers_more(w,m,m1,original_w_pref)=1) then
									--print("Woman "+w.out+"prefers "+m.out+" over "+m1.out+"%N")
									m_availability.put (0, m1)	--m1 becomes free
									m_availability.put (w, m)	--m and w become engaged
									w_availability.put (m, w)
								else
									--assure that m1 and w remain engaged
									m_availability.put (w, m1)	--m and w become engaged
									w_availability.put (m1, w)
								end
							end
						end

						--m can no longer propose woman w after this iteration
						from p:=1 until p>n	loop
							if m_preferences.item (m, p)=w then
								m_preferences.item (m, p):=0
							end
							p:=p+1
						end

						--if no more free men with proposals left, loop will terminate
						if ((get_free_man(m_availability)=0)) then
							iter_1:=2
						end
					end
				end

				--see final results
				from i:=1 until i>n loop
					print(m_availability.item (i).out+"%N")
					i:=i+1
				end
			end
			ensure
				nothing: True
			rescue
			print("INVALID%N")
		end

	first_preference(id: INTEGER; preference_list: ARRAY2[INTEGER]): INTEGER
		require
			valid_id_and_preference_list: id>0 and preference_list.height>0 and preference_list.height*preference_list.height=preference_list.capacity and id<=preference_list.height
		local
			res,i,n: INTEGER
		do

			n:=preference_list.height
			res:=0
			from i:=1 until i>n	loop
				if preference_list.item (id,i)/=0 then
					res:=preference_list.item (id,i)
					i:=n+1
				end
				i:=i+1
			end
			Result:= res
			ensure
				valid_id: Result>=0
			rescue
				print("INVALID%N")
		end

	get_free_man(m_avail: ARRAY[INTEGER]) : INTEGER
		require
			vaild_m_avail: m_avail.capacity>0
		local
			i,res: INTEGER
		do
			res:=0
			from i:=1 until i>m_avail.capacity loop
				if (m_avail.item (i) =0)then
					res:=i
					i:=m_avail.capacity+1
				end
				i:=i+1
			end
			Result:=res
			ensure
				no_man_found_or_free_man_found: Result=0 or m_avail.item (Result)=0
			rescue
				print("INVALID%N")
		end

	prefers_more(id: INTEGER; pref_1:INTEGER; pref_2: INTEGER; preferences: ARRAY2[INTEGER]) : INTEGER
		require
			valid_id_and_preferences: id>0 and pref_1>0 and pref_2>0 and preferences.height>0 and preferences.height*preferences.height=preferences.capacity and id<=preferences.height
		local
			i,n,fp: INTEGER
		do
			--print("Got m as " + pref_1.out +" Got m1 as " + pref_2.out+ "%N")
			fp:=0
			n:=preferences.height
			from i:=1 until i>n	loop
				if preferences.item(id,i)=pref_1 then
					fp:=pref_1
					i:=n+1
					--print("Set pref as first %N")
				elseif preferences.item(id,i)=pref_2 then
					fp:=pref_2
					--print("Set pref as second %N")
					i:=n+1
				end
				i:=i+1
			end
			if (fp=pref_1) then
				Result:=1
			else
				Result:=2
			end
			ensure
			either_preference_is_being_returned: Result=1 or Result=2
			rescue
				print("INVALID%N")
		end
end


