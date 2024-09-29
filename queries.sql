SELECT AVG(rating) AS "Average rating" FROM reviews GROUP BY reviews.guitar_id;

--reviews and comments of a particular guitar
SELECT reviews.review, comments.comment FROM reviews JOIN comments ON reviews.id = comments.review_id WHERE reviews.guitar_id IN
(SELECT id FROM guitars WHERE name = 'American Performer Precision Bass') ORDER BY reviews.likes DESC;

--most wishlisted guitar by users
SELECT guitars.name  AS 'Most wishlisted guitars' FROM guitars JOIN wishlists ON wishlists.guitar_id = guitars.id
GROUP BY guitars.name
ORDER BY COUNT(wishlists.guitar_id)
DESC LIMIT 1;

--find all discontinued guitars
SELECT name from guitars WHERE status = 'DISCONTINUED';

--all guitars played by John Lennon
SELECT guitars.name FROM guitars JOIN guitarists ON guitarists.guitar_id = guitars.id WHERE guitarists.name = 'John Lennon';

--specs of all guitars played by John Lennon
SELECT guitars.name, features.* FROM guitars JOIN features ON guitars.id = features.guitar_id
WHERE guitars.id IN (SELECT guitar_id FROM guitarists WHERE name = 'John Lennon');

--specs of a particular guitar
SELECT guitars.name, features.* FROM features JOIN guitars ON features.guitar_id = guitars.id WHERE guitars.id = 1;

--find all colors in which a guitar is available
SELECT colors.name FROM colors JOIN guitars ON guitars.id = colors.guitar_id WHERE guitars.name = 'American Performer Precision Bass';

--all guitarsists that play Gibson Les Paul Jr.
SELECT guitarists.name FROM guitarists JOIN guitars ON guitarists.guitar_id = guitars.id WHERE guitars.name = 'Gibson Les Paul Jr.';

--top reviews
SELECT reviews.review FROM reviews JOIN guitars ON reviews.guitar_id = guitars.id WHERE name = 'American Performer Precision Bass'
GROUP BY reviews.review
ORDER BY COUNT(reviews.likes) DESC;

--find the brand name of a guitar
SELECT brands.name FROM brands JOIN guitars ON brands.id = guitars.brand_id WHERE guitars.name = 'American Performer Precision Bass';

-- all categories of guitars
SELECT * FROM categories;

INSERT INTO users(id, username, password, name, email_id, role, deleted) VALUES
(1, 'bethechance', '3fv4861%fdw@45', 'Aditi Munde', 'aditimunde2005@gmail.com', 'users', 0),
(2, 'yud6134', '7drlpe&fe4fm8f', 'Rio Gillete', 'rio.gillete1135@gmail.com', 'users', 1),
(3, 'baker_fan', '2wdwaowua5d72dgr', 'Eloise Ngyuen', 'eloisem11@gmail.com', 'users', 0),
(4, 'acrobat', '8efhyj1dfwpti6718', 'Will Wilson', 'will213@gmail.com' ,'users', 0);

INSERT INTO categories(id, name) VALUES
(1, 'Electric guitar'), (2, 'Acoustic guitar'), (3, 'Bass guitar');

INSERT INTO brands(id, name) VALUES
(1, 'Epiphone Classic'), (2, 'BC Rich'), (3, 'Gibson'), (4, 'Fender');


INSERT INTO guitars(id, name, category_id, brand_id, release_year, status) VALUES
(1, 'Gibson Les Paul Jr.', 1, 3,  1954, 'AVAILABLE' ),
(2, 'American Performer Precision Bass', 3, 4, 2018, 'AVAILABLE'),
(3, 'Epiphone Casino', 1, 1, 1961, 'DISCONTINUED');

INSERT INTO guitarists(id, guitar_id, name) VALUES
(1, 1,'Billie Joe Armstrong'),
(2, 1, 'Lislie West'),
(3, 1 , 'John Lennon'),
(4, 1, 'Johnny Thunders'),
(5, 1, 'Martin Barre'),
(6, 2, 'John Lennon');

INSERT INTO colors(guitar_id, name) VALUES
(1, 'Pelham Blue'), (1, 'TV Yellow'), (1, 'Vintage Sunburst'), (1, 'Classic White'),
(1, 'Ebony'), (1, 'Limed Oak/Limed Mahogany'),
(2, 'Arctic White'), (2, 'Sunburst'), (3, 'Satin Lake Placid Blue');
(3, 'Vintage Sunburst');

DELETE FROM colors WHERE colors.name = 'Ebony' AND colors.guitar_id = 1;

INSERT INTO features
(guitar_id, body_type, body_material, profile, fret_type, frets,  neck_material, fingerboard_material, neck_pickup, bridge_pickup, controls, configuration) VALUES
(1, 'Les Paul', 'Mahogany', '50s Vintage', 'Medium Jumbo', 22, 'Mahogany', 'Rosewood', 'P-90 Dog Ear', NULL, '1 Volume, 1 Tone', 'HHS'),
(2, NULL, 'Alder', 'C neck profile', 'Medium Jumbo', 20,  'Maple', 'Rosewood', 'Yosemite® Split Single-Coil Precision Bass®', 'Yosemite® Single-Coil Jazz Bass®', NULL, 'SS'),
(3, 'Hollow', 'Maple', 'C neck profile', 'Medium Jumbo', 22, 'Mahogany', 'Indian Laurel', 'Epiphone Pro P-90 Single-coil', 'Epiphone Pro P-90 Single-coil', '2 x volume, 2 x tone', 'HHS');


INSERT INTO reviews (id, guitar_id, user_id, review, rating, likes, dislikes)
VALUES
(1, 1, 1, 'Juniors sound killer (listen to any early mountain, Leslies tones is out of this world).\nThe wrap tail is a bit of a pain sometimes.\nThe 50s LPJ have those crazy slanted bridges which made intonation a bit of a pain.\nThe ones built these days do not have as steep of an angle.', 4.8, 8, 2),
(2, 2, 3, 'I had a couple of Mexican Fenders that I sold off years ago, then I exclusively played my Rickenbacker until I bought this one.\n Cannot keep my hands off it for five minutes. \n The sound and build leaves absolutely nothing to be desired. \nIt is pure joy.', 4.9, 40, 6),
(3, 2, 1, 'Fender designs, redesigns, reintroductions, etc. Simply put, the American Performer Precision really impressed. Granted, the bass is not a true P, but the tonal options would make it appeal to just about anyone. If I had to choose one thing that made this bass special, it would be the neck, because it was such a true joy to play. A close second would be the aforementioned tonal variations that are suitable for a lot of different music. This bass was built for everything under the sun, and for a U.S.-crafted instrument with this attention to detail and playability, you would be hard-pressed to spend the same money elsewhere and get the same results.', 4.7, 48, 3),
(4, 3, 4, 'I have a Casino and I love it. If you are worried about Epiphone being the poor mans Gibson, well they are, but that does not mean that they produce poor instruments. I pick it up far more often than my Gibson Les Paul. One reason is that being a hollow body I can practice without having to plug it in to my amp. It is a joy to play, it is light, it has a tone which has the beautiful airy quality of a hollow body but with the P90s it can sound really fat. I do not have problems with feedback, but then I only play at home, so it is not like I am gigging it in front of a Marshall stack. People who do experience feedback when gigging them stuff rags in the f holes. There are no quality issues with mine, it is a beautiful and well-made instrument.', 4.1, 5, 1);

UPDATE reviews SET likes = likes + 1 WHERE reviews.id = 1;

INSERT INTO comments (id, review_id, user_id, comment, likes, dislikes)
VALUES
(1, 1, 2, 'I like the music city replacement bridge for 50s juniors and specials. Big improvement in intonation and height setup.', 2, 1),
(2, 1, 3, 'I have two original 50s Juniors and a 61 SG Junior. I love wrap bridges. I think they sound great. I mean, I also like mono records, so factor that in.', 2, 1),
(3, 2, 1, 'Inb4 the budget players start trashing Fender and insisting you should have gotten a P-bass clone import from some other brand. You made a solid choice. If I ever got another P-bass, the Performer is probably where I would start shopping around.', 18, 2),
(4, 3, 2, 'I have never tried the rags or foam trick, so I do not know how much it affects tone, but it is a common trick. If you are that worried about hollow body feedback, then maybe think about a semi-hollow Epi like a Wildcat with P90s or the Dot, 339, or Sheraton with humbuckers.', 1, 1);

UPDATE comments SET dislikes = dislikes + 1 WHERE comments.id = 2;

INSERT INTO price_comparison (guitar_id, old_price, current_price, current_price_added_at) VALUES
(1, 500, 600, '2024-09-28'),
(2, 700, 900, '2025-09-26'),
(3, 710, 840, '2024-10-17');

INSERT INTO wishlists (id, guitar_id, user_id, date) VALUES
(1, 1, 3, '2022-05-16'),
(2, 2, 2, '2023-09-14'),
(3, 2, 4, '2020-03-05');

ALTER TABLE reviews
ADD CONSTRAINT unique_user_guitar_review UNIQUE(user_id, guitar_id);
