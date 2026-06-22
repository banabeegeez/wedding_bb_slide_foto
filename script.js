let images = [],
  index = 0,
  autoplayTimer,
  isPlaying = true;
const imgEl = document.getElementById("slide-img");

function openAlbum() {
  document.getElementById("cover").style.display = "none";
  document.getElementById("menu-view").style.display = "flex";
  document.getElementById("menu-view").style.opacity = "1";
}

async function loadThumbnails() {
  const res = await fetch("image-files.txt");
  const text = await res.text();
  const allFiles = text
    .split("\n")
    .map((n) => n.trim())
    .filter(Boolean);
  ["LAMARAN", "PEMBERKATAN", "RESEPSI"].forEach((cat) => {
    const files = allFiles.filter((n) =>
      n.toLowerCase().startsWith(cat.toLowerCase() + "/"),
    );
    if (files.length > 0)
      document.getElementById(`thumb-${cat}`).src =
        `images/${files[Math.floor(Math.random() * files.length)]}`;
  });
}
document.addEventListener("DOMContentLoaded", loadThumbnails);

async function openCategory(category) {
  const res = await fetch("image-files.txt");
  const text = await res.text();
  images = text
    .split("\n")
    .map((n) => n.trim())
    .filter(
      (n) => n && n.toLowerCase().startsWith(category.toLowerCase() + "/"),
    )
    .map((n) => `images/${n}`);
  if (images.length === 0) {
    alert("Data foto belum siap!");
    return;
  }
  document.getElementById("menu-view").style.display = "none";
  document.getElementById("album-view").style.display = "flex";
  document.getElementById("album-view").style.opacity = "1";
  showRandom();
  startAutoplay();
}

function setSlide(i) {
  index = (i + images.length) % images.length;
  imgEl.classList.remove("zoomed");
  imgEl.style.opacity = "0";
  const preload = new Image();
  preload.src = images[index];
  preload.onload = () => {
    setTimeout(() => {
      imgEl.src = preload.src;
      imgEl.style.opacity = "1";
      setTimeout(() => imgEl.classList.add("zoomed"), 50);
    }, 500);
  };
}

function backToMenu() {
  stopAutoplay();
  document.getElementById("album-view").style.display = "none";
  document.getElementById("menu-view").style.display = "flex";
  document.getElementById("menu-view").style.opacity = "1";
  document.getElementById("play-pause-icon").src = "buttons/pause_btn.png";
  isPlaying = true;
}

function downloadCurrentPhoto() {
  fetch(imgEl.src)
    .then((r) => r.blob())
    .then((b) => {
      const a = document.createElement("a");
      a.href = window.URL.createObjectURL(b);
      a.download = `Foto_Bana_Bella_${index + 1}.webp`;
      a.click();
    });
}
function showRandom() {
  setSlide(Math.floor(Math.random() * images.length));
}
function nextSlide() {
  setSlide(index + 1);
  resetAutoplay();
}
function prevSlide() {
  setSlide(index - 1);
  resetAutoplay();
}
function toggleAutoplay() {
  const icon = document.getElementById("play-pause-icon");
  isPlaying ? stopAutoplay() : startAutoplay();
  icon.src = isPlaying ? "buttons/play_btn.png" : "buttons/pause_btn.png";
  isPlaying = !isPlaying;
}
function startAutoplay() {
  autoplayTimer = setInterval(showRandom, 3000);
}
function stopAutoplay() {
  clearInterval(autoplayTimer);
}
function resetAutoplay() {
  stopAutoplay();
  if (isPlaying) startAutoplay();
}
function toggleFullscreen() {
  const elem = document.documentElement; // Membuka seluruh halaman ke mode fullscreen
  const icon = document.getElementById("fs-icon");

  if (!document.fullscreenElement) {
    if (elem.requestFullscreen) {
      elem.requestFullscreen();
    } else if (elem.webkitRequestFullscreen) {
      /* Safari */
      elem.webkitRequestFullscreen();
    }
    icon.innerText = "⛶"; // Anda bisa ganti dengan icon gambar jika mau
  } else {
    if (document.exitFullscreen) {
      document.exitFullscreen();
    } else if (document.webkitExitFullscreen) {
      /* Safari */
      document.webkitExitFullscreen();
    }
    icon.innerText = "⛶";
  }
}
