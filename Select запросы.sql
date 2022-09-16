-- 1. количество исполнителей в каждом жанре; --
SELECT g.name, count(a.name)
FROM genre AS g
LEFT JOIN artist_genre AS gm ON g.id = gm.genre_id
LEFT JOIN artist AS a ON gm.artist_id = a.id
GROUP BY g.name
ORDER BY count(a.name) DESC

-- 2. количество треков, вошедших в альбомы 2019-2020 годов; --
SELECT t.name, a.date_of_release
FROM album AS a
LEFT JOIN track AS t ON t.album_id = a.id
WHERE (a.date_of_release >= '2019-01-01') AND (a.date_of_release <= '2020-01-01')

-- 3. средняя продолжительность треков по каждому альбому; --
SELECT a.name, AVG(t.length)
FROM album AS a
LEFT JOIN track AS t ON t.album_id = a.id
GROUP BY a.name
ORDER BY AVG(t.length)

-- 4. все исполнители, которые не выпустили альбомы в 2020 году; --
SELECT DISTINCT m.name
FROM artist AS m
LEFT JOIN artist_album AS am ON m.id = am.artist_id
LEFT JOIN album AS a ON a.id = am.album_id
WHERE NOT a.date_of_release = '2020-01-01'
ORDER BY m.name

-- 5. названия сборников, в которых присутствует конкретный исполнитель (Скриптонит); --
SELECT DISTINCT c.name
FROM collection AS c
LEFT JOIN collection_track AS ct ON c.id = ct.collection_id
LEFT JOIN track AS t ON t.id = ct.track_id
LEFT JOIN album AS a ON a.id = t.album_id
LEFT JOIN artist_album AS am ON am.album_id = a.id
LEFT JOIN artist AS m ON m.id = am.artist_id
WHERE m.name LIKE '%%Скриптонит%%'
ORDER BY c.name

-- 6. название альбомов, в которых присутствуют исполнители более 1 жанра; --
SELECT a.name
FROM album AS a
LEFT JOIN artist_album AS am ON a.id = am.album_id
LEFT JOIN artist AS m ON m.id = am.artist_id
LEFT JOIN artist_genre AS gm ON m.id = gm.artist_id
LEFT JOIN genre AS g ON g.id = gm.genre_id
GROUP BY a.name
HAVING count(DISTINCT g.name) > 1
ORDER BY a.name

-- 7. наименование треков, которые не входят в сборники; --
SELECT t.name
FROM track AS t
LEFT JOIN collection_track AS ct ON t.id = ct.track_id
WHERE ct.track_id IS NULL

-- 8. исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько);--
SELECT m.name, t.length
FROM track AS t
LEFT JOIN album AS a ON a.id = t.album_id
LEFT JOIN artist_album AS am ON am.album_id = a.id
LEFT JOIN artist AS m ON m.id = am.artist_id
GROUP BY m.name, t.length
HAVING t.length = (SELECT min(length) FROM track)
ORDER BY m.name

-- 9. название альбомов, содержащих наименьшее количество треков. --
SELECT DISTINCT a.name
FROM album AS a
LEFT JOIN track AS t ON t.album_id = a.id
WHERE t.album_id in (
    SELECT album_id
    FROM track
    GROUP BY album_id
    HAVING count(id) = (
        SELECT count(id)
        FROM track
        GROUP BY album_id
        ORDER BY count
        LIMIT 1
    )
)
ORDER BY a.name

