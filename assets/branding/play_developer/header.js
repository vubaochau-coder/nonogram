// Google Play developer header, 4096x2304. Minimal CRT style matching icon C.
const { chromium } = require('playwright');
const W=4096,H=2304;
const G=["XX.......XXX",".XX.....XX..","..XX....XX..",".XX.....XX..","XX.......XXX","............","....XXXX...."];
const cell=72,gap=16;
let face=''; G.forEach((r,j)=>[...r].forEach((c,i)=>{ if(c==='X') face+=`<div class="px" style="left:${i*(cell+gap)}px;top:${j*(cell+gap)}px"></div>`; }));
const fw=G[0].length*(cell+gap)-gap, fh=G.length*(cell+gap)-gap;
// very sparse, faint binary at the far edges only
let seed=11; const rnd=()=>(seed=(seed*16807)%2147483647)/2147483647; let rain='';
for(let c=0;c<W/64;c++){ const x=c*64+32; const d=Math.abs(x-W/2)/(W/2); if(d<0.62||rnd()<0.55) continue;
  const len=3+Math.floor(rnd()*8), start=Math.floor(rnd()*36);
  for(let k=0;k<len;k++) rain+=`<span style="left:${x}px;top:${(start+k)*64}px;opacity:${(0.03+0.07*k/len).toFixed(3)}">${rnd()>.5?1:0}</span>`; }
const html=`<html><head><style>
body{margin:0;width:${W}px;height:${H}px;overflow:hidden;position:relative;font-family:'JetBrains Mono';background:radial-gradient(ellipse at 50% 50%,#06140B 0%,#020704 65%)}
.rain span{position:absolute;color:#00FF66;font-size:40px;transform:translateX(-50%)}
.wrap{position:absolute;left:50%;top:50%;transform:translate(-50%,-50%);display:flex;align-items:center;gap:200px}
.face{position:relative;width:${fw}px;height:${fh}px}
.px{position:absolute;width:${cell}px;height:${cell}px;border-radius:8px;background:#00FF66;box-shadow:0 0 36px rgba(0,255,102,.55)}
.name{color:#E6FFEE;font-size:200px;font-weight:700;letter-spacing:-4px;text-shadow:0 0 40px rgba(0,255,102,.35)}
.tag{color:#3F7A55;font-size:68px;margin-top:20px}
.scan{position:absolute;inset:0;background:repeating-linear-gradient(0deg,rgba(0,0,0,.22) 0 3px,transparent 3px 6px)}
.vig{position:absolute;inset:0;background:radial-gradient(ellipse at 50% 50%,transparent 50%,rgba(0,0,0,.7) 100%)}
</style></head><body><div class="rain">${rain}</div>
<div class="wrap"><div class="face">${face}</div><div><div class="name">chauvb.dev</div><div class="tag">// indie games &amp; apps</div></div></div>
<div class="scan"></div><div class="vig"></div></body></html>`;
(async()=>{const b=await chromium.launch();const p=await b.newPage({viewport:{width:W,height:H}});
await p.setContent(html);await p.evaluate(()=>document.fonts.ready);
await p.screenshot({path:'dev_header_4096x2304.jpg',type:'jpeg',quality:90});
await p.setViewportSize({width:1366,height:768});
await p.setContent(`<body style="margin:0"><img style="width:1366px" src="data:image/jpeg;base64,${require('fs').readFileSync('dev_header_4096x2304.jpg').toString('base64')}"></body>`);
await p.screenshot({path:process.env.PREV||'/dev/null'});await b.close();})();
