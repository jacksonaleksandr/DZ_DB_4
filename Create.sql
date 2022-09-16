CREATE TABLE artist
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(60) NOT NULL
);

CREATE TABLE genre
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE artist_genre
(
    artist_id INTEGER NOT NULL REFERENCES artist (id),
    genre_id  INTEGER NOT NULL REFERENCES genre (id),
    UNIQUE (artist_id, genre_id)
);

CREATE TABLE album
(
    id              SERIAL PRIMARY KEY,
    name            VARCHAR(60) NOT NULL,
    date_of_release DATE        NOT NULL
        CHECK (date_of_release >= '1970-01-01' and date_of_release <= CURRENT_DATE)
);

CREATE TABLE artist_album
(
    artist_id INTEGER NOT NULL REFERENCES artist (id),
    album_id  INTEGER NOT NULL REFERENCES album (id),
    UNIQUE (artist_id, album_id)
);

CREATE TABLE track
(
    id       SERIAL PRIMARY KEY,
    length   INTEGER     NOT NULL,
    name     VARCHAR(60) NOT NULL,
    album_id INTEGER     NOT NULL REFERENCES album (id)
        CHECK (length > 0)
);

CREATE TABLE collection
(
    id              SERIAL PRIMARY KEY,
    name            VARCHAR(60) NOT NULL,
    date_of_release DATE        NOT NULL,
    CHECK (date_of_release >= '1970-01-01' and date_of_release <= CURRENT_DATE)
);

CREATE TABLE collection_track
(
    collection_id INTEGER NOT NULL REFERENCES collection (id),
    track_id      INTEGER NOT NULL REFERENCES track (id),
    UNIQUE (collection_id, track_id)
);
