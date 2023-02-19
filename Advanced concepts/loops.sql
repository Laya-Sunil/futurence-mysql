-- Active: 1670401223911@@127.0.0.1@3307

--
DELIMITER #


loop_label: LOOP -- marks begining
    if x>5 then leave loop_label; -- leave works like break
    end if;
    set x = x+1;
    if(x mod 2 = 0) then iterate loop_label; -- iterate works like continue
    else
        set str = concat(str, x,', ');
    end if;
end loop;
select str;