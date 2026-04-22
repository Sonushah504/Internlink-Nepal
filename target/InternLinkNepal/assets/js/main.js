/* ================================================================
   InternLink Nepal — Main JavaScript
   ================================================================ */

/* ── Carousel ─────────────────────────────────────────────────── */
(function initCarousel() {
  const track = document.querySelector('.carousel-track');
  if (!track) return;

  const slides = track.querySelectorAll('.carousel-slide');
  const dots   = document.querySelectorAll('.carousel-dot');
  let   current = 0;
  let   timer;

  function goTo(idx) {
    current = (idx + slides.length) % slides.length;
    track.style.transform = `translateX(-${current * 100}%)`;
    dots.forEach((d, i) => d.classList.toggle('active', i === current));
  }

  function next() { goTo(current + 1); }
  function prev() { goTo(current - 1); }

  document.querySelector('.carousel-btn-next')?.addEventListener('click', () => { clearInterval(timer); next(); resetTimer(); });
  document.querySelector('.carousel-btn-prev')?.addEventListener('click', () => { clearInterval(timer); prev(); resetTimer(); });
  dots.forEach((d, i) => d.addEventListener('click', () => { clearInterval(timer); goTo(i); resetTimer(); }));

  function resetTimer() { timer = setInterval(next, 5000); }
  resetTimer();
})();

/* ── Navbar scroll shadow ─────────────────────────────────────── */
(function navbarScroll() {
  const nav = document.querySelector('.navbar');
  if (!nav) return;
  window.addEventListener('scroll', () => {
    nav.style.boxShadow = window.scrollY > 10 ? '0 2px 12px rgba(0,0,0,.1)' : '';
  });
})();

/* ── Alert auto-dismiss ───────────────────────────────────────── */
(function alertDismiss() {
  document.querySelectorAll('.alert[data-auto-dismiss]').forEach(el => {
    setTimeout(() => {
      el.style.opacity = '0';
      el.style.transition = 'opacity .4s';
      setTimeout(() => el.remove(), 400);
    }, 4000);
  });
})();

/* ── Filter form auto-submit ──────────────────────────────────── */
(function autoSubmitFilters() {
  document.querySelectorAll('select[data-auto-submit]').forEach(sel => {
    sel.addEventListener('change', () => sel.closest('form').submit());
  });
})();

/* ── Donut Chart (pure canvas) ───────────────────────────────── */
function drawDonut(canvasId, data) {
  const canvas = document.getElementById(canvasId);
  if (!canvas) return;
  const ctx  = canvas.getContext('2d');
  const cx   = canvas.width / 2;
  const cy   = canvas.height / 2;
  const r    = Math.min(cx, cy) - 20;
  const inner = r * 0.55;
  const total = data.reduce((s, d) => s + d.value, 0);

  if (total === 0) return;

  let startAngle = -Math.PI / 2;
  data.forEach(seg => {
    const sweep = (seg.value / total) * 2 * Math.PI;
    ctx.beginPath();
    ctx.moveTo(cx, cy);
    ctx.arc(cx, cy, r, startAngle, startAngle + sweep);
    ctx.closePath();
    ctx.fillStyle = seg.color;
    ctx.fill();
    startAngle += sweep;
  });

  // Hollow center
  ctx.beginPath();
  ctx.arc(cx, cy, inner, 0, 2 * Math.PI);
  ctx.fillStyle = '#fff';
  ctx.fill();

  // Center text
  ctx.fillStyle = '#212529';
  ctx.font = `bold ${Math.round(r * 0.28)}px Inter, sans-serif`;
  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';
  ctx.fillText(total, cx, cy - 8);
  ctx.font = `${Math.round(r * 0.16)}px Inter, sans-serif`;
  ctx.fillStyle = '#6C757D';
  ctx.fillText('total', cx, cy + 14);
}

/* ── Bar Chart (pure canvas) ─────────────────────────────────── */
function drawBar(canvasId, labels, values, color) {
  const canvas = document.getElementById(canvasId);
  if (!canvas) return;
  const ctx    = canvas.getContext('2d');
  const W = canvas.width;
  const H = canvas.height;
  const padL = 40, padB = 30, padT = 16, padR = 16;
  const chartW = W - padL - padR;
  const chartH = H - padT - padB;
  const max = Math.max(...values, 1);
  const barW = (chartW / values.length) * 0.6;
  const gap  = (chartW / values.length) * 0.4;

  ctx.clearRect(0, 0, W, H);

  // Grid lines
  ctx.strokeStyle = '#E9ECEF';
  ctx.lineWidth = 1;
  for (let i = 0; i <= 4; i++) {
    const y = padT + chartH - (chartH * i / 4);
    ctx.beginPath(); ctx.moveTo(padL, y); ctx.lineTo(W - padR, y); ctx.stroke();
    ctx.fillStyle = '#ADB5BD';
    ctx.font = '11px Inter, sans-serif';
    ctx.textAlign = 'right';
    ctx.fillText(Math.round(max * i / 4), padL - 6, y + 4);
  }

  // Bars
  values.forEach((v, i) => {
    const x = padL + i * (barW + gap) + gap / 2;
    const barH = (v / max) * chartH;
    const y = padT + chartH - barH;
    ctx.fillStyle = color || '#185FA5';
    ctx.beginPath();
    ctx.roundRect(x, y, barW, barH, [4, 4, 0, 0]);
    ctx.fill();

    // Value label
    ctx.fillStyle = '#343A40';
    ctx.font = 'bold 12px Inter, sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText(v, x + barW / 2, y - 6);

    // X label
    ctx.fillStyle = '#6C757D';
    ctx.font = '11px Inter, sans-serif';
    ctx.fillText(labels[i], x + barW / 2, H - 8);
  });
}

/* ── Modal helpers ───────────────────────────────────────────── */
function openModal(id) {
  const m = document.getElementById(id);
  if (m) { m.style.display = 'flex'; document.body.style.overflow = 'hidden'; }
}
function closeModal(id) {
  const m = document.getElementById(id);
  if (m) { m.style.display = 'none'; document.body.style.overflow = ''; }
}
document.addEventListener('keydown', e => {
  if (e.key === 'Escape') document.querySelectorAll('.modal').forEach(m => { m.style.display = 'none'; });
});
document.querySelectorAll('.modal').forEach(m => {
  m.addEventListener('click', e => { if (e.target === m) closeModal(m.id); });
});

/* ── Google Maps integration helpers ────────────────────────── */
function initCompanyMap(lat, lng, companyName) {
  if (!window.google || !lat || !lng) return;
  const pos = { lat: parseFloat(lat), lng: parseFloat(lng) };
  const map = new google.maps.Map(document.getElementById('map'), {
    center: pos,
    zoom: 14,
    mapTypeControl: false,
    streetViewControl: false,
    styles: [
      { featureType: 'poi', elementType: 'labels', stylers: [{ visibility: 'off' }] }
    ]
  });
  new google.maps.Marker({
    position: pos,
    map,
    title: companyName,
    icon: {
      path: google.maps.SymbolPath.CIRCLE,
      scale: 12,
      fillColor: '#185FA5',
      fillOpacity: 1,
      strokeColor: '#fff',
      strokeWeight: 2
    }
  });
}

/* ── Geocode address to lat/lng (uses Nominatim free API) ───── */
async function geocodeAddress(address) {
  const url = `https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(address)}&format=json&limit=1`;
  try {
    const resp = await fetch(url, { headers: { 'Accept-Language': 'en' } });
    const data = await resp.json();
    if (data.length > 0) {
      return { lat: parseFloat(data[0].lat), lng: parseFloat(data[0].lon) };
    }
  } catch (e) { console.error('Geocoding error:', e); }
  return null;
}

/* ── Auto-geocode on company register form ───────────────────── */
(function setupGeocodeBtn() {
  const btn = document.getElementById('geocodeBtn');
  if (!btn) return;
  btn.addEventListener('click', async () => {
    const address = document.getElementById('address').value + ', Nepal';
    btn.textContent = 'Locating…';
    btn.disabled = true;
    const result = await geocodeAddress(address);
    if (result) {
      document.getElementById('latitude').value  = result.lat.toFixed(6);
      document.getElementById('longitude').value = result.lng.toFixed(6);
      btn.textContent = '✓ Location found';
    } else {
      btn.textContent = 'Not found – enter manually';
    }
    btn.disabled = false;
  });
})();

/* ── Profile completeness meter ──────────────────────────────── */
(function profileMeter() {
  const bar = document.querySelector('.profile-completeness-bar');
  if (!bar) return;
  const score = parseInt(bar.dataset.score || '0');
  bar.querySelector('.progress-bar').style.width = score + '%';
})();
