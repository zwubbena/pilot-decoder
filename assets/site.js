/* ============================================================
   PilotDECODER — shared site behavior
   Load at the end of <body> with a RELATIVE path:
     homepage:   <script src="assets/site.js?v=1"></script>
     tool pages: <script src="../assets/site.js?v=1"></script>
   Handles: theme toggle (+ favicon recolor), copyright year.
   NOTE: each page must ALSO keep the tiny pre-paint theme snippet
   in <head> so the stored theme applies before first paint:
   <script>try{var t=localStorage.getItem("pd-theme");if(t==="blue")document.documentElement.setAttribute("data-theme","blue");}catch(e){}</script>
   ============================================================ */
"use strict";
(function () {
  /* ---- copyright year ---- */
  var yr = document.getElementById("yr");
  if (yr) yr.textContent = new Date().getFullYear();

  /* ---- theme toggle ---- */
  var FAV = { green: "%2314555e", blue: "%230d6eac" };
  var ORDER = ["green", "blue"];
  var btn = document.getElementById("theme-btn");
  function stored() {
    try {
      var s = localStorage.getItem("pd-theme");
      if (s === "green" || s === "blue") return s;
    } catch (e) {}
    return null;
  }
  var cur = stored() || "green";
  function apply(t) {
    cur = t;
    if (t === "green") { document.documentElement.removeAttribute("data-theme"); }
    else { document.documentElement.setAttribute("data-theme", t); }
    if (btn) btn.setAttribute("aria-label", "Switch color theme (current: " + (t === "green" ? "teal" : t) + ")");
    var fav = document.querySelector('link[rel="icon"]');
    if (fav) { for (var k in FAV) { fav.href = fav.href.replace(FAV[k], FAV[t]); } }
    /* let page scripts (canvas redraws etc.) react to theme changes */
    try { document.dispatchEvent(new CustomEvent("pd:theme", { detail: { theme: t } })); } catch (e) {}
  }
  apply(cur);
  if (btn) btn.addEventListener("click", function () {
    var next = ORDER[(ORDER.indexOf(cur) + 1) % ORDER.length];
    apply(next);
    try { localStorage.setItem("pd-theme", next); } catch (e) {}
  });
})();
