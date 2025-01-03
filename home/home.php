<?php
session_start();
require_once '../config.php';
$is_admin = isset($_SESSION['user_role']) && $_SESSION['user_role'] === 'Admin';
$query = "SELECT * FROM kategori";
$result = $conn->query($query);
?>

<!DOCTYPE html>
<html lang="id">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Home</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  <link rel="stylesheet" href="../css/home.css">
</head>

<body>
  <header>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-lg-top">
      <div class="container-fluid">
        <div class="d-flex align-items-center">
          <div class="logo me-3">
            <a href="home.php">
              <img src="../asset/logo.png" alt="logo" height="40">
            </a>
          </div>
          <a class="navbar-brand">HavenTech</a>
        </div>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
          aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
          <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            <li class="nav-item">
              <a class="nav-link" href="home.php">Home</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="about.html">Tentang Kami</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="produk.php">Produk</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="kontak.html">Kontak</a>
            </li>
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="pesananDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                Status
              </a>
              <ul class="dropdown-menu" aria-labelledby="pesananDropdown">
                <li><a class="dropdown-item" href="pesanan.php">Pesanan</a></li>
                <li><a class="dropdown-item" href="keranjang.php">Keranjang</a></li>
              </ul>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="ajukan_keluhan.php">Keluhan</a>
            </li>
          </ul>
          <div class="auth">
            <a class="btn btn-primary" href="../pengguna/logout.php">Logout</a>
          </div>
        </div>
      </div>
    </nav>
  </header>
  <main>
    <div id="carouselExampleIndicators" class="carousel slide mb-4" data-bs-ride="carousel" data-bs-interval="2000">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="0" class="active"
          aria-current="true" aria-label="Slide 1"></button>
        <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="1"
          aria-label="Slide 2"></button>
        <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="2"
          aria-label="Slide 3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active">
          <img src="../asset/pc1.jpg" class="d-block w-100" alt="sampul1">
        </div>
        <div class="carousel-item">
          <img src="../asset/pc2.jpg" class="d-block w-100" alt="sampul2">
        </div>
        <div class="carousel-item">
          <img src="../asset/pc3.jpg" class="d-block w-100" alt="sampul3">
        </div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Previous</span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Next</span>
      </button>
    </div>
    <h2 class="text-center my-5 fw-bold">Kategori Produk</h2>
    <div class="container my-5">
      <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
        <?php while ($row = $result->fetch_assoc()): ?>
          <div class="col">
            <div class="card h-100 shadow-sm border-0 text-white" style="background-color: #1f48c2;">
              <div class="overflow-hidden rounded-top">
                <img src="<?= "../asset/uploads/" . $row['Gambar_kategori']; ?>"
                  class="card-img-top img-fluid"
                  alt="<?= $row['nama_kategori']; ?>"
                  style="height: 200px; object-fit: cover;">
              </div>
              <div class="card-body text-center">
                <h5 class="card-title mb-3 fw-bold"><?= $row['nama_kategori']; ?></h5>
                <a href="produk.php?id_kategori=<?= $row['id_kategori'] ?>"
                  class="btn btn-white text-black px-3 py-1"
                  style="background-color: white; color: black; ">Lihat</a>
              </div>
            </div>
          </div>
        <?php endwhile; ?>
      </div>
    </div>
  </main>
  <footer class="footer">
    <div class="footer-kontak">
      <h3>Kontak Kami</h3>
      <p>Email: haventech@startup.ac.id</p>
      <p>Telepon: 088764349532 </p>
      <p>Alamat: Yogyakarta</p>
    </div>
    <div class="footer-kontak">
      <h3>Link</h3>
      <div class="footer-link">
        <a href="home.php">Home</a>
        <a href="about.html">Tentang Kami</a>
        <a href="produk.php">Produk</a>
        <a href="kontak.html">Kontak</a>
      </div>
    </div>
    <div class="footer-kontak">
      <h3>Ikuti Kami</h3>
      <div class="footer-icon">
        <a href="https://www.instagram.com/"><img src="../asset/icon1.png"></a>
        <a href="https://www.facebook.com/?locale=id_ID"><img src="../asset/icon2.png"></a>
        <a href="https://x.com/?lang=id"><img src="../asset/icon3.png"></a>
      </div>
    </div>
  </footer>
  <div class="footer-copyright">
    &copy;2024 Febry Vallentihanto | Diki Prasetia Dekanata | Anas Abiyyu Falah | Muhammad Rizqy Wahyu Kurniawan | Satrio Hayu Wibowo | All rights reserved
  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
    crossorigin="anonymous"></script>
</body>

</html>