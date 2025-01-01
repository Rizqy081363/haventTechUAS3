-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 29 Des 2024 pada 10.25
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `aksesoris_computer`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_ke_keranjang` (IN `idPengguna` INT, IN `idProduk` INT, IN `jumlah` INT)   BEGIN
    DECLARE harga DECIMAL(10, 2);
    
    -- Ambil harga produk
    SELECT harga INTO harga FROM produk WHERE id = idProduk;
    
    -- Tambahkan ke tabel detail_pesanan
    INSERT INTO detail_pesanan (id_pesanan, id_produk, jumlah, harga_satuan, is_keranjang)
    VALUES (NULL, idProduk, jumlah, harga, TRUE);
END$$

--
-- Fungsi
--
CREATE DEFINER=`root`@`localhost` FUNCTION `hitung_total_pesanan` (`idPesanan` INT) RETURNS DECIMAL(10,2)  BEGIN
    DECLARE total DECIMAL(10, 2);
    SELECT SUM(jumlah * harga_satuan) INTO total
    FROM detail_pesanan
    WHERE id_pesanan = idPesanan;
    RETURN IFNULL(total, 0);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `bayar`
--

CREATE TABLE `bayar` (
  `id_bayar` int(11) NOT NULL,
  `id_pengguna` int(11) NOT NULL,
  `total_bayar` decimal(10,2) NOT NULL,
  `id_pesanan` int(11) NOT NULL,
  `status_bayar` enum('Belum Dibayar','Sudah Dibayar','Menunggu Konfirmasi') NOT NULL,
  `tanggal_bayar` datetime DEFAULT current_timestamp(),
  `bukti_bayar` varchar(255) DEFAULT NULL,
  `metode_bayar` enum('Transfer Bank','Kartu Kredit','E-Wallet') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `bayar`
--

INSERT INTO `bayar` (`id_bayar`, `id_pengguna`, `total_bayar`, `id_pesanan`, `status_bayar`, `tanggal_bayar`, `bukti_bayar`, `metode_bayar`) VALUES
(69, 17, 550000.00, 134, 'Sudah Dibayar', '2024-12-29 08:02:47', '1735455767_0efa5e59098703ff90039bdf136e1cde.jpg', 'Transfer Bank'),
(70, 17, 450000.00, 135, 'Sudah Dibayar', '2024-12-29 08:11:54', '1735456314_ac9c4459db525b0b73f07bdbaee70f7d.jpg', 'Transfer Bank'),
(71, 17, 250000.00, 136, 'Sudah Dibayar', '2024-12-29 08:46:57', '1735458417_0efa5e59098703ff90039bdf136e1cde.jpg', 'Transfer Bank'),
(72, 17, 250000.00, 137, 'Menunggu Konfirmasi', '2024-12-29 08:50:07', '1735458607_warnaa.jpg', 'Transfer Bank');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kategori`
--

CREATE TABLE `kategori` (
  `id_kategori` int(11) NOT NULL,
  `nama_kategori` varchar(100) NOT NULL,
  `Gambar_kategori` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kategori`
--

INSERT INTO `kategori` (`id_kategori`, `nama_kategori`, `Gambar_kategori`) VALUES
(14, 'Keyboardr', 'keyboard.png'),
(15, 'Mouse Gaming', 'mouse.png'),
(16, 'Headphone', 'HeadPhone.png'),
(17, 'Gamepad', 'gameapd.png');

-- --------------------------------------------------------

--
-- Struktur dari tabel `keluhan`
--

CREATE TABLE `keluhan` (
  `id_keluhan` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `subjek` varchar(255) NOT NULL,
  `isi_keluhan` text NOT NULL,
  `status` enum('Pending','Diterima','Ditolak') DEFAULT 'Pending',
  `tanggal_kirim` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `keluhan`
--

INSERT INTO `keluhan` (`id_keluhan`, `id_user`, `subjek`, `isi_keluhan`, `status`, `tanggal_kirim`) VALUES
(1, 11, 'kualitas produk', 'rusak', 'Diterima', '2024-12-19 21:09:14'),
(2, 16, 'vdv', 'fbfbf', 'Pending', '2024-12-21 16:37:57');

-- --------------------------------------------------------

--
-- Struktur dari tabel `keranjang`
--

CREATE TABLE `keranjang` (
  `id` int(11) NOT NULL,
  `id_produk` int(11) NOT NULL,
  `id_pengguna` int(11) NOT NULL,
  `harga` decimal(10,2) NOT NULL,
  `jumlah` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `keranjang`
--

INSERT INTO `keranjang` (`id`, `id_produk`, `id_pengguna`, `harga`, `jumlah`) VALUES
(59, 15, 17, 250000.00, 1);

--
-- Trigger `keranjang`
--
DELIMITER $$
CREATE TRIGGER `produk_after_update` AFTER UPDATE ON `keranjang` FOR EACH ROW BEGIN
  IF NEW.jumlah <> OLD.jumlah THEN
    UPDATE `produk`
    SET `stok` = `stok` - (NEW.jumlah - OLD.jumlah)
    WHERE `id_produk` = NEW.id_produk;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `metode_bayar`
--

CREATE TABLE `metode_bayar` (
  `id` int(11) NOT NULL,
  `nama_metode` enum('Transfer Bank','Kartu Kredit','E-Wallet') NOT NULL,
  `nomor_rekening` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `metode_bayar`
--

INSERT INTO `metode_bayar` (`id`, `nama_metode`, `nomor_rekening`) VALUES
(1, 'Transfer Bank', '123-456-7890'),
(2, 'Kartu Kredit', '9876-5432-10'),
(3, 'E-Wallet', '87654321');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengguna`
--

CREATE TABLE `pengguna` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `key` text DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `telepon` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pengguna`
--

INSERT INTO `pengguna` (`id`, `nama`, `email`, `password`, `key`, `alamat`, `telepon`) VALUES
(3, 'zikri', 'zikri@students.amikom.ac.id', '$2y$10$OiUupuQSPOh1xBNeC/dGOOmuNuAM/RH7Sg4H9MDacJbfBmsM18YlK', NULL, NULL, NULL),
(8, 'Muhaamad Rizqy Wahyu Kurniawan', 'kurniawan@students.amikom.ac.id', '$2y$10$q9lOij4qtcs8CqJXaKXsqeOSqoYkx2rdd9nTdVOLzTkSXDNWS5khK', NULL, NULL, NULL),
(11, 'kiki', 'kiki@gmail.com', '$2y$10$hep2X7V5.yVMKcgfgf4wzONZ/qeY4.3J1B6O.Ns25DEZ2Me43s/Wm', NULL, NULL, NULL),
(16, 'Febry Vallentihanto', 'vallentihanto14@students.amikom.ac.id', '$2y$10$gA/HlMtOOnHI0OGrCvVYL.vNIcWPSenSVeMRFKL23MGSaW837XWsC', NULL, NULL, NULL),
(17, 'rizqy', 'rizqywahyu59@gmail.com', '$2y$10$ODl5dsaGHHMcypTgrvi.0e7.v7xOpf6gCxPEj1h1UmeLOHB8bvnNW', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pesanan`
--

CREATE TABLE `pesanan` (
  `id_pesanan` int(11) NOT NULL,
  `id_pengguna` int(11) NOT NULL,
  `tanggal_pesanan` datetime DEFAULT current_timestamp(),
  `total_harga` decimal(10,2) NOT NULL CHECK (`total_harga` >= 0),
  `status` enum('Pending','Diproses','Dikirim','Selesai','Dibatalkan') DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pesanan`
--

INSERT INTO `pesanan` (`id_pesanan`, `id_pengguna`, `tanggal_pesanan`, `total_harga`, `status`) VALUES
(134, 17, '2024-12-29 08:02:47', 550000.00, 'Diproses'),
(135, 17, '2024-12-29 08:11:54', 450000.00, 'Diproses'),
(136, 17, '2024-12-29 08:46:57', 250000.00, 'Pending'),
(137, 17, '2024-12-29 08:50:07', 250000.00, 'Pending');

-- --------------------------------------------------------

--
-- Struktur dari tabel `produk`
--

CREATE TABLE `produk` (
  `id_produk` int(11) NOT NULL,
  `nama_produk` varchar(200) NOT NULL,
  `harga` decimal(10,2) NOT NULL CHECK (`harga` >= 0),
  `stok` int(11) NOT NULL CHECK (`stok` >= 0),
  `id_kategori` int(11) DEFAULT NULL,
  `gambar_produk` varchar(255) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `produk`
--

INSERT INTO `produk` (`id_produk`, `nama_produk`, `harga`, `stok`, `id_kategori`, `gambar_produk`, `deskripsi`) VALUES
(9, 'Headphone Shark V2 Pro', 250000.00, 10, 16, 'Headphone1.png', 'Headphone gaming terkenal dengan kualitas suara yang jernih dan nyaman digunakan untuk sesi gaming panjang.'),
(10, 'Headphone Arctis 7+', 450000.00, 14, 16, 'Headphone2.png', 'Headphone gaming nirkabel dengan suara surround 7.1, ideal untuk pengalaman gaming yang imersif.'),
(11, 'Headphone Pro X Wireless', 350000.00, 25, 16, 'heaphone3.png', 'Headphone gaming premium dengan teknologi nirkabel LIGHTSPEED dan bantalan memory foam yang nyaman'),
(12, 'Headphone Pro V145', 500000.00, 35, 16, 'Headphone4.png', 'Headphone gaming ringan cocok untuk komunikasi gamming.'),
(13, 'Keyboard Smooth Glide V64', 450000.00, 15, 14, 'Keyboard1.png', 'Menggunakan switch seperti Cherry MX Red atau Gateron Yellow untuk pengalaman mengetik halus tanpa umpan balik taktil atau suara klik'),
(14, 'Keyboard Precision Touch V97', 550000.00, 25, 14, 'Keyboard2.png', 'Menggunakan switch seperti Cherry MX Brown atau Durock T1, yang menawarkan umpan balik taktil tanpa suara klik yang mengganggu'),
(15, 'Keyboard Click Master V8', 250000.00, 20, 14, 'Keyboard3.png', 'Dilengkapi switch seperti Cherry MX Blue atau Kailh Box White yang menghasilkan suara klik khas dan umpan balik taktil.'),
(16, 'Keyboard Hot-Swappable V43', 350000.00, 30, 14, 'Keyboard4.png', 'Keyboard yang mendukung penggantian switch tanpa solder, ideal untuk pengguna yang ingin bereksperimen dengan berbagai jenis switch.'),
(17, 'Mouse Death Adder', 350000.00, 30, 15, 'mouse1.png', 'Tipe ini terkenal dengan ergonomisnya yang nyaman dan sensor presisi tinggi, cocok untuk berbagai jenis game.'),
(18, 'Mouse Pro X Superlight', 250000.00, 10, 15, 'mouase2.png', 'Mouse gaming nirkabel dengan bobot sangat ringan dan teknologi nirkabel canggih.'),
(19, 'Mouse SteelSeries Rival 600', 450000.00, 20, 15, 'mouse3.png', 'Dilengkapi dengan sensor ganda untuk akurasi maksimal dan desain yang dapat disesuaikan.'),
(20, 'Mouse M65 RGB Elite', 550000.00, 25, 15, 'mouase4.png', 'Mouse ini memiliki desain tangguh dengan bobot yang bisa disesuaikan dan tombol sniper khusus.'),
(21, 'Gamepad Xbox Wireless', 550000.00, 25, 17, 'gamepad1.png', 'Gamepad ini kompatibel dengan PC melalui kabel USB atau Bluetooth. Desain ergonomis dan dukungan luas membuatnya menjadi pilihan populer.'),
(22, 'Gamepad Dual Sense', 250000.00, 20, 17, 'gamepad2.png', 'Dengan fitur haptic feedback dan adaptive triggers, DualSense menawarkan pengalaman bermain yang imersif dan dapat digunakan di PC melalui kabel atau Bluetooth.'),
(23, 'Gamepad F310', 450000.00, 15, 17, 'gamepad3.jpeg', 'Gamepad kabel yang ekonomis dengan desain klasik dan kompatibilitas luas. Ideal untuk gamer yang mencari opsi hemat biaya.'),
(24, 'Gamepad Wolverine V2', 350000.00, 45, 17, 'gamepad4.png', 'Gamepad premium dengan fitur-fitur seperti tombol tambahan yang dapat diprogram, pencahayaan RGB, dan desain ergonomis untuk sesi gaming panjang.');

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `view_pesanan_detail`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `view_pesanan_detail` (
`id_pesanan` int(11)
,`status_bayar` enum('Belum Dibayar','Sudah Dibayar','Menunggu Konfirmasi')
,`total_bayar` decimal(10,2)
,`tanggal_pesanan` datetime
,`status_pesanan` enum('Pending','Diproses','Dikirim','Selesai','Dibatalkan')
,`nama_pengguna` varchar(100)
,`email_pengguna` varchar(100)
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `worker`
--

CREATE TABLE `worker` (
  `id` int(11) NOT NULL,
  `KEY` varchar(255) NOT NULL,
  `ROLE` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `worker`
--

INSERT INTO `worker` (`id`, `KEY`, `ROLE`) VALUES
(1, 'ADMIN9090', 'ADMIN'),
(2, 'CS9090', 'CS');

-- --------------------------------------------------------

--
-- Struktur untuk view `view_pesanan_detail`
--
DROP TABLE IF EXISTS `view_pesanan_detail`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_pesanan_detail`  AS SELECT `p`.`id_pesanan` AS `id_pesanan`, `b`.`status_bayar` AS `status_bayar`, `b`.`total_bayar` AS `total_bayar`, `p`.`tanggal_pesanan` AS `tanggal_pesanan`, `p`.`status` AS `status_pesanan`, `u`.`nama` AS `nama_pengguna`, `u`.`email` AS `email_pengguna` FROM ((`pesanan` `p` join `bayar` `b` on(`p`.`id_pesanan` = `b`.`id_pesanan`)) join `pengguna` `u` on(`p`.`id_pengguna` = `u`.`id`)) WHERE `b`.`status_bayar` = 'Sudah Dibayar' ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `bayar`
--
ALTER TABLE `bayar`
  ADD PRIMARY KEY (`id_bayar`),
  ADD KEY `id_pesanan` (`id_pesanan`),
  ADD KEY `id_pengguna` (`id_pengguna`),
  ADD KEY `metode_bayar` (`metode_bayar`);

--
-- Indeks untuk tabel `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id_kategori`),
  ADD UNIQUE KEY `nama_kategori` (`nama_kategori`);

--
-- Indeks untuk tabel `keluhan`
--
ALTER TABLE `keluhan`
  ADD PRIMARY KEY (`id_keluhan`),
  ADD KEY `id_user` (`id_user`);

--
-- Indeks untuk tabel `keranjang`
--
ALTER TABLE `keranjang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_produk` (`id_produk`),
  ADD KEY `id_pengguna` (`id_pengguna`);

--
-- Indeks untuk tabel `metode_bayar`
--
ALTER TABLE `metode_bayar`
  ADD PRIMARY KEY (`id`,`nama_metode`);

--
-- Indeks untuk tabel `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indeks untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`id_pesanan`),
  ADD KEY `id_pengguna` (`id_pengguna`);

--
-- Indeks untuk tabel `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id_produk`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- Indeks untuk tabel `worker`
--
ALTER TABLE `worker`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `bayar`
--
ALTER TABLE `bayar`
  MODIFY `id_bayar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT untuk tabel `kategori`
--
ALTER TABLE `kategori`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT untuk tabel `keluhan`
--
ALTER TABLE `keluhan`
  MODIFY `id_keluhan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `keranjang`
--
ALTER TABLE `keranjang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT untuk tabel `metode_bayar`
--
ALTER TABLE `metode_bayar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `id_pesanan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=138;

--
-- AUTO_INCREMENT untuk tabel `produk`
--
ALTER TABLE `produk`
  MODIFY `id_produk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT untuk tabel `worker`
--
ALTER TABLE `worker`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `bayar`
--
ALTER TABLE `bayar`
  ADD CONSTRAINT `bayar_ibfk_1` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `keluhan`
--
ALTER TABLE `keluhan`
  ADD CONSTRAINT `keluhan_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `pengguna` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `keranjang`
--
ALTER TABLE `keranjang`
  ADD CONSTRAINT `keranjang_ibfk_1` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`) ON DELETE CASCADE,
  ADD CONSTRAINT `keranjang_ibfk_2` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id`);

--
-- Ketidakleluasaan untuk tabel `produk`
--
ALTER TABLE `produk`
  ADD CONSTRAINT `produk_ibfk_1` FOREIGN KEY (`id_kategori`) REFERENCES `kategori` (`id_kategori`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
