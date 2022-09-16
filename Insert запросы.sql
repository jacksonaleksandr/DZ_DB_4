-- 1. количество исполнителей в каждом жанре; --
select g.name, count(a.name)
from genre as g
left join artist_genre as gm on g.id = gm.genre_id
left join artist as a on gm.artist_id = a.id
group by g.name
order by count(a.name) DESC

-- 2. количество треков, вошедших в альбомы 2019-2020 годов; --
select t.name, a.date_of_release
from album as a
left join track as t on t.album_id = a.id
where (a.date_of_release >= '2019-01-01') and (a.date_of_release <= '2020-01-01')

-- 3. средняя продолжительность треков по каждому альбому; --
select a.name, AVG(t.length)
from album as a
left join track as t on t.album_id = a.id
group by a.name
order by AVG(t.length)

-- 4. все исполнители, которые не выпустили альбомы в 2020 году; --
select distinct m.name
from artist as m
left join artist_album as am on m.id = am.artist_id
left join album as a on a.id = am.album_id
where not a.date_of_release = '2020-01-01'
order by m.name

-- 5. названия сборников, в которых присутствует конкретный исполнитель (Скриптонит); --
select distinct c.name
from collection as c
left join collection_track as ct on c.id = ct.collection_id
left join track as t on t.id = ct.track_id
left join album as a on a.id = t.album_id
left join artist_album as am on am.album_id = a.id
left join artist as m on m.id = am.artist_id
where m.name like '%%Скриптонит%%'
order by c.name

-- 6. название альбомов, в которых присутствуют исполнители более 1 жанра; --
select a.name
from album as a
left join artist_album as am on a.id = am.album_id
left join artist as m on m.id = am.artist_id
left join artist_genre as gm on m.id = gm.artist_id
left join genre as g on g.id = gm.genre_id
group by a.name
having count(distinct g.name) > 1
order by a.name

-- 7. наименование треков, которые не входят в сборники; --
select t.name
from track as t
left join collection_track as ct on t.id = ct.track_id
where ct.track_id is null

-- 8. исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько);--
select m.name, t.length
from track as t
left join album as a on a.id = t.album_id
left join artist_album as am on am.album_id = a.id
left join artist as m on m.id = am.artist_id
group by m.name, t.length
having t.length = (select min(length) from track)
order by m.name

-- 9. название альбомов, содержащих наименьшее количество треков. --
select distinct a.name
from album as a
left join track as t on t.album_id = a.id
where t.album_id in (
    select album_id
    from track
    group by album_id
    having count(id) = (
        select count(id)
        from track
        group by album_id
        order by count
        limit 1
    )
)
order by a.name