-- Таблица "Статусы городов".
CREATE TABLE IF NOT EXISTS CityStatuses
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

-- Таблица "Статусы походов".
CREATE TABLE IF NOT EXISTS HikeStatuses
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

-- Таблица "Города викингов".
CREATE TABLE IF NOT EXISTS Cities
(
    id          BIGSERIAL PRIMARY KEY,
    cityName    VARCHAR(30) NOT NULL,
    status      INT REFERENCES CityStatuses (id) DEFAULT 1,
    description TEXT,
    imageURL    VARCHAR(500) DEFAULT 'https://w.forfun.com/fetch/7b/7b30cdee828356e2e9a5a161f4fa75a5.jpeg'
);

-- Таблица "Викинги".
CREATE TABLE IF NOT EXISTS Vikings
(
    id            BIGSERIAL PRIMARY KEY,
    vikingName    VARCHAR(60)  NOT NULL,
    post          VARCHAR(100) NOT NULL,
    birthday      DATE,
    dayOfDeath    DATE,
    cityOfBirthID INT REFERENCES Cities (id),
    imageURL      VARCHAR(500) DEFAULT 'https://novye-multiki.ru/wp-content/uploads/2019/01/kak-priruchit-drakona-3-oboi8.jpg'
);

-- Таблица "Походы викингов".
CREATE TABLE IF NOT EXISTS Hikes
(
    id          BIGSERIAL PRIMARY KEY,
    hikeName    VARCHAR(50)                      NOT NULL,
    dateStart   DATE                             NOT NULL DEFAULT CURRENT_DATE,
    dateEnd     DATE,
    authorID    INT REFERENCES Author (id)       NOT NULL,
    status      INT REFERENCES HikeStatuses (id) NOT NULL,
    description TEXT
);

-- Таблица "Участники похода"
CREATE TABLE IF NOT EXISTS ExpeditionParticipants
(
    id       BIGSERIAL PRIMARY KEY,
    vikingID INT REFERENCES Vikings (id) NOT NULL,
    hikeID   INT REFERENCES Hikes (id)   NOT NULL
);

-- Таблица "Города похода".
CREATE TABLE IF NOT EXISTS DestinationHikes
(
    id     BIGSERIAL PRIMARY KEY,
    cityID INT REFERENCES Cities (id) NOT NULL,
    hikeID INT REFERENCES Hikes (id)  NOT NULL
);

-- Таблица "Авторы статей про походы викингов"
CREATE TABLE IF NOT EXISTS Author
(
    id         BIGSERIAL PRIMARY KEY,
    authorName VARCHAR(50),
    profession VARCHAR(255),
    birthday   DATE,
    imageURL   VARCHAR(500) DEFAULT 'http://localhost:7070/static/img/mock-photo.png'
)
