const { chromium } = require('playwright');
const W=4096,H=2304;
let seed=42; const rnd=()=>(seed=(seed*16807)%2147483647)/2147483647;
// matrix rain of nonogram clue digits
let rain=''; const cw=64;
for(let c=0;c<W/cw;c++){
  const x=c*cw+cw/2; const centerDim = Math.abs(x-W/2)<1250 ? 0.35 : 1;
  for(let s=0;s<2;s++){
    const len=6+Math.floor(rnd()*22), start=Math.floor(rnd()*44)-10;
    for(let k=0;k<len;k++){ const row=start+k; if(row<0||row>36) continue;
      const head=k===len-1; const op=head?0.9:(0.05+0.35*k/len);
      const ch = rnd()<0.18 ? '■' : String(1+Math.floor(rnd()*9));
      rain+=`<span style="left:${x}px;top:${row*64}px;opacity:${(op*centerDim).toFixed(2)};color:${head?'#C8FFD9':'#00FF66'};${head?'text-shadow:0 0 18px #00FF66':''}">${ch}</span>`;
    }
  }
}
const heart=[".X.X.","XXXXX","XXXXX",".XXX.","..X.."], rc=["1 1","5","5","3","1"], cc=["2","4","4","4","2"];
const cell=58,gap=10;
let hz=`<div class="hz"><div></div>${cc.map(c=>`<div class="cc">${c}</div>`).join('')}`;
heart.forEach((r,j)=>{ hz+=`<div class="rc">${rc[j]}</div>`+[...r].map(c=>`<div class="cell ${c==='X'?'on':''}"></div>`).join(''); });
hz+='</div>';
const html=`<html><head><style>
body{margin:0;width:${W}px;height:${H}px;background:radial-gradient(ellipse at 50% 50%,#0A1A10 0%,#030806 70%);overflow:hidden;font-family:'JetBrains Mono';position:relative}
.rain span{position:absolute;font-size:48px;font-weight:700;transform:translateX(-50%)}
.scan{position:absolute;inset:0;background:repeating-linear-gradient(0deg,rgba(0,0,0,.28) 0 3px,transparent 3px 6px)}
.vig{position:absolute;inset:0;background:radial-gradient(ellipse at 50% 50%,transparent 55%,rgba(0,0,0,.75) 100%)}
.term{position:absolute;left:50%;top:50%;width:2300px;transform:translate(-50%,-50%);background:rgba(8,14,11,.94);border:3px solid #1F4D2E;border-radius:36px;box-shadow:0 0 120px rgba(0,255,102,.18),0 40px 120px rgba(0,0,0,.6);overflow:hidden}
.bar{height:110px;background:#0F1C15;display:flex;align-items:center;padding:0 48px;gap:26px;border-bottom:3px solid #1F4D2E}
.dot{width:36px;height:36px;border-radius:50%}
.title{flex:1;text-align:center;color:#5E8F6E;font-size:40px;margin-right:160px}
.body{padding:70px 90px 80px;color:#00FF66;font-size:64px;line-height:1.5;text-shadow:0 0 14px rgba(0,255,102,.55)}
.p{color:#7DFFB0}.d{color:#4E8A62;text-shadow:none}.w{color:#E8FFF0;font-weight:800;font-size:120px;letter-spacing:-2px;line-height:1.25;text-shadow:0 0 30px rgba(0,255,102,.7)}
.row{display:flex;gap:110px;align-items:center;margin:26px 0 20px}
.hz{display:grid;grid-template-columns:150px repeat(5,${cell}px);gap:${gap}px;align-items:center}
.cc{text-align:center;font-size:44px;color:#4E8A62;text-shadow:none}.rc{text-align:right;padding-right:24px;font-size:44px;color:#4E8A62;text-shadow:none}
.cell{width:${cell}px;height:${cell}px;border-radius:10px;background:rgba(0,255,102,.08)}.cell.on{background:#00FF66;box-shadow:0 0 22px rgba(0,255,102,.8)}
.cur{display:inline-block;width:38px;height:72px;background:#00FF66;vertical-align:-12px;box-shadow:0 0 20px #00FF66}
</style></head><body>
<div class="rain">${rain}</div>
<div class="term"><div class="bar"><div class="dot" style="background:#FF5F57"></div><div class="dot" style="background:#FEBC2E"></div><div class="dot" style="background:#28C840"></div><div class="title">chauvb.dev — ~/games — zsh</div></div>
<div class="body">
<div><span class="p">~ $</span> whoami</div>
<div class="w">chauvb.dev</div>
<div class="d"># indie games · built pixel by pixel</div>
<div style="height:30px"></div>
<div><span class="p">~ $</span> ./pixel-nonogram --solve heart</div>
<div class="row">${hz}<div><div>[██████████] 100%</div><div>✔ solved <span class="d">in 00:42</span></div></div></div>
<div><span class="p">~ $</span> <span class="cur"></span></div>
</div></div>
<div class="scan"></div><div class="vig"></div>
</body></html>`;
(async()=>{const b=await chromium.launch();const p=await b.newPage({viewport:{width:W,height:H}});
await p.setContent(html);await p.evaluate(()=>document.fonts.ready);
await p.screenshot({path:'header.jpg',type:'jpeg',quality:88});
await p.setViewportSize({width:W,height:H});await p.screenshot({path:'header.png'});
await b.close();})();
