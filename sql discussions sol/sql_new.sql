/*
select submission_date, h.hacker_id, name, 
            count(submission_id)over(partition by submission_date order by h.hacker_id)
from Hackers h inner join Submissions s
on h.hacker_id=s.hacker_id;
*/
select a.sd, b.ch, a.hid, a.n
from
    (select s.submission_date sd, s.hacker_id hid,h.name n, s.csid,
     rank()over(partition by s.submission_date order by s.csid desc, s.hacker_id            asc)cs_
     from 
        (select submission_date, hacker_id, count(submission_id)csid
        from Submissions
        group by submission_date, hacker_id)s 
    inner join hackers h
    on s.hacker_id=h.hacker_id)a
-- order by submission_date, hacker_id, c desc;
inner join
    (select submission_date sd, count(hacker_id)ch
    from Submissions s
    group by submission_date)b
on a.sd=b.sd
where a.cs_=1
order by a.sd;
/*
select s.submission_date, s.hacker_id hid,h.name n, s.csid,
     rank()over(partition by s.submission_date order by s.csid desc, s.hacker_id asc)cs_
from 
    (select submission_date, hacker_id, count(submission_id)csid
    from Submissions
    group by submission_date, hacker_id)s 
inner join hackers h
on s.hacker_id=h.hacker_id

--group by submission_date, s.hacker_id, h.name;

*/

-- latest

select a.sd, b.ch, a.hid, a.n
from
    (select s.submission_date sd, s.hacker_id hid,h.name n, s.csid,
     rank()over(partition by s.submission_date order by s.csid desc, s.hacker_id            asc)cs_
     from 
        (select submission_date, hacker_id, count(submission_id)csid
        from Submissions
        group by submission_date, hacker_id)s 
    inner join hackers h
    on s.hacker_id=h.hacker_id)a
-- order by submission_date, hacker_id, c desc;
inner join
    (select submission_date sd, count(hacker_id)ch
    from Submissions s
    group by submission_date)b
on a.sd=b.sd
where a.cs_=1
order by a.sd;