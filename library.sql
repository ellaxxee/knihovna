-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Počítač: localhost:8889
-- Vytvořeno: Ned 23. lis 2025, 18:29
-- Verze serveru: 8.0.40
-- Verze PHP: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Databáze: `library`
--

-- --------------------------------------------------------

--
-- Struktura tabulky `books`
--

CREATE TABLE `books` (
  `id` int NOT NULL,
  `title` varchar(200) NOT NULL,
  `author` varchar(100) DEFAULT NULL,
  `isbn` varchar(20) DEFAULT NULL,
  `publication_year` int DEFAULT NULL,
  `genre` varchar(50) DEFAULT NULL,
  `total_copies` int DEFAULT '0',
  `available_copies` int DEFAULT '0',
  `added_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Vypisuji data pro tabulku `books`
--

INSERT INTO `books` (`id`, `title`, `author`, `isbn`, `publication_year`, `genre`, `total_copies`, `available_copies`, `added_at`) VALUES
(1, 'Malý princ', 'Antoine de Saint-Exupéry', '9782070612758', 1943, 'Pohádka', 5, 5, '2025-10-29 14:11:04'),
(2, 'Babička', 'Božena Němcová', '9788086264130', 1855, 'Klasická literatura', 3, 3, '2025-10-29 14:11:11'),
(3, '1984', 'George Orwell', '9780451524935', 1949, 'Dystopie', 4, 4, '2025-10-29 15:09:53'),
(4, 'Harry Potter a Kámen mudrců', 'J. K. Rowling', '9788000021964', 1997, 'Fantasy', 6, 6, '2025-10-29 14:11:17'),
(5, 'Kytice', 'Karel Jaromír Erben', '9788072870392', 1853, 'Poezie', 3, 3, '2025-10-29 14:10:58'),
(6, 'Zločin a trest', 'Fjodor Michajlovič Dostojevskij', '9780140449136', 1866, 'Román', 4, 4, '2025-10-29 14:11:21'),
(7, 'Na západní frontě klid', 'Erich Maria Remarque', '9788025732342', 1929, 'Válečný román', 2, 2, '2025-10-29 14:10:53'),
(8, 'Pýcha a předsudek', 'Jane Austen', '9780141439518', 1813, 'Román', 5, 5, '2025-10-29 14:10:50'),
(9, 'Saturnin', 'Zdeněk Jirotka', '9788020429025', 1942, 'Humor', 3, 3, '2025-10-29 15:09:53'),
(10, 'Hobit aneb Cesta tam a zase zpátky', 'J. R. R. Tolkien', '9788025710500', 1937, 'Fantasy', 7, 7, '2025-10-29 14:10:44');

-- --------------------------------------------------------

--
-- Struktura tabulky `loans`
--

CREATE TABLE `loans` (
  `id` int NOT NULL,
  `reservation_id` int NOT NULL,
  `loan_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `returned` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Struktura tabulky `reservations`
--

CREATE TABLE `reservations` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `book_id` int NOT NULL,
  `reservation_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `pickup_date` date DEFAULT NULL,
  `status` enum('pending','confirmed','cancelled','picked_up','returned') DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Struktura tabulky `reviews`
--

CREATE TABLE `reviews` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `book_id` int NOT NULL,
  `rating` int DEFAULT NULL,
  `comment` text,
  `review_date` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Struktura tabulky `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','librarian','student') DEFAULT 'student',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Vypisuji data pro tabulku `users`
--

INSERT INTO `users` (`id`, `username`, `first_name`, `last_name`, `email`, `password`, `role`, `created_at`) VALUES
(2, 'josh.doe', 'josh', 'doe', 'joshdoe@gmail.com', '$2y$10$sySIFIxCuWYYBHeA5I6ATOrhkrtipPPxRvqEIeQmku9KLiwHmn1z2', 'student', '2025-10-19 20:22:25'),
(3, 'nellie.knight', 'nellie', 'knight', 'nellieknight@gmail.com', '$2y$10$KRIvZRkcuwhYcIT.F5/UquHAZZyZmcTBjgDor8.w4lXTRKpIYiP.i', 'student', '2025-10-22 18:06:09'),
(4, 'nicole.dwight', 'nicole', 'dwight', 'dwifht123@gmail.com', '$2y$10$dZkSQ0.8bIbWfoM4cbNWqeenj5l2Zd21wijau6dx5/xFSECEpiZsa', 'librarian', '2025-10-22 18:06:38'),
(5, 'mark.novak', 'mark', 'novak', 'marknovak@gmail.com', '$2y$10$RsYm9lVQ/OeToOwGWFz6augn7LyA60U99RpPrMgqgPRI8c4YN282e', 'admin', '2025-10-22 18:09:42');

--
-- Indexy pro exportované tabulky
--

--
-- Indexy pro tabulku `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pro tabulku `loans`
--
ALTER TABLE `loans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reservation_id` (`reservation_id`);

--
-- Indexy pro tabulku `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `book_id` (`book_id`);

--
-- Indexy pro tabulku `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `book_id` (`book_id`);

--
-- Indexy pro tabulku `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT pro tabulky
--

--
-- AUTO_INCREMENT pro tabulku `books`
--
ALTER TABLE `books`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pro tabulku `loans`
--
ALTER TABLE `loans`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pro tabulku `reservations`
--
ALTER TABLE `reservations`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pro tabulku `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pro tabulku `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Omezení pro exportované tabulky
--

--
-- Omezení pro tabulku `loans`
--
ALTER TABLE `loans`
  ADD CONSTRAINT `loans_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`id`) ON DELETE CASCADE;

--
-- Omezení pro tabulku `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE;

--
-- Omezení pro tabulku `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
