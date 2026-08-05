/* ============================================================
   PilotDECODER — shared site behavior
   Load at the end of <body> with a RELATIVE path:
     tool pages: <script src="../assets/site.js?v=2"></script>
   Handles: light/dark toggle, copyright year.
   v2: the old teal/blue toggle became light/dark to match the
   homepage redesign. Persists to `pd-home-theme` — the SAME key
   the homepage uses, so the preference follows the reader across
   the whole site. (The old `pd-theme` key is abandoned.)
   NOTE: each page must ALSO keep the tiny pre-paint snippet in
   <head> so the stored theme applies before first paint:
   <script>try{if(localStorage.getItem("pd-home-theme")==="dark")document.documentElement.setAttribute("data-theme","dark");}catch(e){}</script>
   ============================================================ */
"use strict";
(function () {
  /* ---- copyright year ---- */
  var yr = document.getElementById("yr");
  if (yr) yr.textContent = new Date().getFullYear();

  /* ---- light/dark toggle ---- */
  var btn = document.getElementById("theme-btn");
  function isDark() {
    return document.documentElement.getAttribute("data-theme") === "dark";
  }
  function apply(dark) {
    if (dark) document.documentElement.setAttribute("data-theme", "dark");
    else document.documentElement.removeAttribute("data-theme");
    if (btn) {
      btn.setAttribute("aria-pressed", String(dark));
      btn.setAttribute("aria-label", dark ? "Switch to light mode" : "Switch to dark mode");
    }
    /* let page scripts (canvas redraws etc.) react to theme changes */
    try { document.dispatchEvent(new CustomEvent("pd:theme", { detail: { theme: dark ? "dark" : "light" } })); } catch (e) {}
  }
  apply(isDark());
  if (btn) btn.addEventListener("click", function () {
    var dark = !isDark();
    apply(dark);
    try { localStorage.setItem("pd-home-theme", dark ? "dark" : "light"); } catch (e) {}
  });
})();
