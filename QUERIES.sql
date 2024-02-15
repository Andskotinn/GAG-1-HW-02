-- HW2
-- Student names: Ari

-- A. 447 different members attended at least one class on January 10th. How many different members attended at least one class on January 15th?
-- Explanation: 

select count(*)
from (
	select distinct A.mid
	from class C
	join
		attends A
	on C.id = A.CID
	where
		extract(month from C.date) = 01 and extract(day from C.date) = 15
) tmp;	


-- B. 4 different class types require more than 20 light dumbbells. How many class types require more than 20 yoga mats?
-- Explanation: 

select count(*)
from (
	select distinct T.id
	from needs N
	join type T 
		on N.tid = T.id
	join equipment E 
		on N.eid = E.id
	where 
		N.eid = 0 
		and N.quantity > 20
) tmp;	


-- C. Oh no! Some member hacked the database and is still attending classes but has quit according to the database. Write a query to reveal their name!
-- Explanation: 

select distinct M.name
from member M
join attends A
	on M.id = A.mid
join class C
	on A.cid = C.id
where M.quit_date < C.date;


-- D. How many members have a personal trainer with the same first name as themselves, but have never attended a class that their personal trainer led?
-- Explanation: 

--ATH
select distinct M.name
from member M
join instructor I
	on M.iid = I.id
join attends A
	on M.id = A.mid
where substring (M.name, 0, position(' ' in M.name)) = substring (I.name, 0, position(' ' in I.name))
and I.id != M.iid
;

-- E. For every class type, return its name and whether it has an average rating higher or equal to 7, or lower than 7, in a column named "Rating" with values "Good" or "Bad", respectively.
-- Explanation: 

select T.name, case when avg(A.rating) >= 7 then 'Good' else 'Bad' end as Rating
from class C
join type T
	on C.tid = T.id
join attends A
	on A.cid = C.id
group by T.name;


-- F. Out of the members that have not quit, member with ID 6976 has been a customer for the shortest time. Out of the members that have not quit, return the ID of the member(s) that have been customer(s) for the longest time.
-- Explanation: 

select M.id
from member M
where (now() - M.start_date)
	in(
		select max(now() - M.start_date)
		from member M
		);


-- G. How many class types have at least one equipment that costs more than 100.000 and at least one other equipment that costs less than 5.000?
-- Explanation: 

select count(*)
from (
	select N.tid
	from needs N
	join equipment E
		on N.eid = E.id
	group by N.tid
	having max(E.price) > 100000 and min(E.price) < 5000
	) tmp;	


-- H. How many instructors have led a class in all gyms on the same day?
-- Explanation: 

select count(*)
from (
	select C.iid
	from class C
	group by C.iid, C.date
		having count (C.gid) = (
			select count (G.id)
			from gym G)
	) tmp;	
	
	
-- I. How many instructors have not led classes of all different class types?
-- Explanation: 

select count(*)
from (
	select I.id
	from instructor I
	where I.id not in
		(
		select C.iid
		from class C
		group by C.iid, C.date
		having count (C.gid) = 
			(
			select count (G.id)
			from gym G
			)
		)
	) tmp;	
	
	
-- J. The class type "Circuit training" has the lowest equipment cost per member, based on full capacity. Return the name of the class type that has the highest equipment cost per person, based on full capacity.
-- Explanation: 




-- K (BONUS). The hacker revealed in query C has left a message for the database engineers. This message may save the database!
-- Return the 5th letter of all members that started the gym on December 24th of any year and have at least 3 different odd numbers in their phone number, in a descending order of their IDs,
-- followed by the 8th letter of all instructors that have not led any "Trampoline Burn" classes, in an ascending order of their IDs.
-- Explanation: 

