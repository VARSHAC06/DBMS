create database music_streaming_system;
use music_streaming_system;

create table artists (
    artist_id int primary key auto_increment,
    artist_name varchar(100),
    genre varchar(50),
    country varchar(50)
);
create table albums (
    album_id int primary key auto_increment,
    album_title varchar(100),
    release_year int,
    artist_id int,
    foreign key (artist_id) references artists(artist_id)
);
create table songs (
    song_id int primary key auto_increment,
    song_title varchar(100),
    duration decimal(5,2),  -- duration in minutes
    album_id int,
    artist_id int,
    foreign key (album_id) references albums(album_id),
    foreign key (artist_id) references artists(artist_id)
);

insert into artists (artist_name, genre, country) values
('Arijit Singh', 'Pop', 'India'),
('Taylor Swift', 'Pop', 'USA'),
('A. R. Rahman', 'Classical', 'India'),
('Ed Sheeran', 'Pop', 'UK');

insert into albums (album_title, release_year, artist_id) values
('Soulful Nights', 2022, 1),
('Midnights', 2023, 2),
('Infinite Dreams', 2021, 3),
('Divide', 2017, 4);

insert into songs (song_title, duration, album_id, artist_id) values
('Tum Hi Ho', 4.35, 1, 1),
('Raabta', 3.80, 1, 1),
('Anti-Hero', 3.20, 2, 2),
('Lavender Haze', 3.35, 2, 2),
('Kun Faya Kun', 5.50, 3, 3),
('Jai Ho', 4.40, 3, 3),
('Perfect', 4.23, 4, 4),
('Shape of You', 3.55, 4, 4);

select 
    s.song_id,
    s.song_title,
    s.duration,
    a.album_title,
    ar.artist_name,
    ar.genre,
    ar.country
from songs s
join albums a on s.album_id = a.album_id
join artists ar on s.artist_id = ar.artist_id
order by ar.artist_name, a.album_title;
/*'5', 'Kun Faya Kun', '5.50', 'Infinite Dreams', 'A. R. Rahman', 'Classical', 'India'
'6', 'Jai Ho', '4.40', 'Infinite Dreams', 'A. R. Rahman', 'Classical', 'India'
'1', 'Tum Hi Ho', '4.35', 'Soulful Nights', 'Arijit Singh', 'Pop', 'India'
'2', 'Raabta', '3.80', 'Soulful Nights', 'Arijit Singh', 'Pop', 'India'
'7', 'Perfect', '4.23', 'Divide', 'Ed Sheeran', 'Pop', 'UK'
'8', 'Shape of You', '3.55', 'Divide', 'Ed Sheeran', 'Pop', 'UK'
'3', 'Anti-Hero', '3.20', 'Midnights', 'Taylor Swift', 'Pop', 'USA'
'4', 'Lavender Haze', '3.35', 'Midnights', 'Taylor Swift', 'Pop', 'USA'*/

select 
    a.album_title,
    ar.artist_name,
    count(s.song_id) as total_songs
from songs s
join albums a on s.album_id = a.album_id
join artists ar on s.artist_id = ar.artist_id
group by a.album_title, ar.artist_name
order by total_songs desc;
/*'Soulful Nights', 'Arijit Singh', '2'
'Midnights', 'Taylor Swift', '2'
'Infinite Dreams', 'A. R. Rahman', '2'
'Divide', 'Ed Sheeran', '2'*/

delimiter $$

create procedure insert_song(
    in p_song_title varchar(100),
    in p_duration decimal(5,2),
    in p_album_id int,
    in p_artist_id int
)
begin
    declare album_exists int;
    declare artist_exists int;

    select count(*) into album_exists from albums where album_id = p_album_id;
    select count(*) into artist_exists from artists where artist_id = p_artist_id;

    if album_exists > 0 and artist_exists > 0 then
        insert into songs (song_title, duration, album_id, artist_id)
        values (p_song_title, p_duration, p_album_id, p_artist_id);
    else
        signal sqlstate '45000'
        set message_text = 'Invalid Album ID or Artist ID!';
    end if;
end $$

delimiter ;
call insert_song('Photograph', 4.12, 4, 4);


delimiter $$

create procedure update_song(
    in p_song_id int,
    in p_new_title varchar(100),
    in p_new_duration decimal(5,2)
)
begin
    update songs
    set song_title = p_new_title,
        duration = p_new_duration
    where song_id = p_song_id;
end $$

delimiter ;
call update_song(3, 'Anti-Hero (Remix)', 3.45);

