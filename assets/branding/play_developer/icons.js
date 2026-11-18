const { chromium } = require('playwright');
const fs = require('fs');
// pixel ">_c": ">" = squinting eye / prompt, "c" = eye / initial, "_" = mouth / cursor
const G = [
 "XX.......XXX",
 ".XX.....XX..",
 "..XX....XX..",
 ".XX.....XX..",
 "XX.......XXX",
 "............",
 "....XXXX....",
];
function grid({x0,y0,cell,gap,r,on,off,offOp,glow}) {
  let s='';
  G.forEach((row,j)=>[...row].forEach((c,i)=>{
    const x=x0+i*(cell+gap), y=y0+j*(cell+gap);
    if(c==='X') s+=`<rect x="${x}" y="${y}" width="${cell}" height="${cell}" rx="${r}" fill="${on}" ${glow?`filter="url(#glow)"`:''}/>`;
    else if(off) s+=`<rect x="${x}" y="${y}" width="${cell}" height="${cell}" rx="${r}" fill="${off}" opacity="${offOp}"/>`;
  }));
  return s;
}
const cell=21,gap=5, W=G[0].length*(cell+gap)-gap, H=G.length*(cell+gap)-gap;
const glowDef=(std)=>`<filter id="glow" x="-50%" y="-50%" width="200%" height="200%"><feGaussianBlur stdDeviation="${std}" result="b"/><feMerge><feMergeNode in="b"/><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter>`;
const dots=(y)=>['#FF5F57','#FEBC2E','#28C840'].map((c,i)=>`<circle cx="${72+i*34}" cy="${y}" r="11" fill="${c}"/>`).join('');

const variants = {
 // A: terminal window, neon green, nonogram empty cells
 A: `<rect width="512" height="512" fill="#0D1117"/>
   <rect width="512" height="96" fill="#161B22"/>${dots(48)}
   <defs>${glowDef(6)}</defs>
   ${grid({x0:(512-W)/2,y0:96+(416-H)/2,cell,gap,r:7,on:'#3DFF8A',off:'#3DFF8A',offOp:0.08,glow:true})}`,
 // B: brand gradient (same as game logo), white pixel prompt
 B: `<defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#3B5BDB"/><stop offset="1" stop-color="#6B3FD6"/></linearGradient>${glowDef(5)}</defs>
   <rect width="512" height="512" fill="url(#g)"/>
   <rect x="40" y="40" width="432" height="432" rx="40" fill="#0D1117" opacity="0.55"/>
   ${dots(84).replace(/cx="(\d+)"/g,(m,v)=>`cx="${+v+8}"`)}
   ${grid({x0:(512-W)/2,y0:122+(350-H)/2,cell,gap,r:7,on:'#FFFFFF',off:'#FFFFFF',offOp:0.10,glow:false})}`,
 // C: hacker CRT, phosphor green, binary rain, scanlines
 C: (()=>{ let rain=''; let seed=7; const rnd=()=>(seed=(seed*16807)%2147483647)/2147483647;
   for(let c=0;c<16;c++){ const len=4+Math.floor(rnd()*10), start=Math.floor(rnd()*20)-4;
     for(let k=0;k<len;k++){ const row=start+k; if(row<0||row>16) continue;
       rain+=`<text x="${c*32+16}" y="${row*32+26}" fill="#00FF66" opacity="${((0.04+0.18*k/len)*((Math.abs(c*32+16-256)<190&&Math.abs(row*32-250)<170)?0.35:1)).toFixed(2)}" font-family="JetBrains Mono" font-size="22" text-anchor="middle">${rnd()>.5?1:0}</text>`; } }
   return `<defs>${glowDef(8)}<pattern id="scan" width="4" height="4" patternUnits="userSpaceOnUse"><rect width="4" height="2" fill="#000" opacity="0.35"/></pattern>
     <radialGradient id="v" cx=".5" cy=".5" r=".7"><stop offset=".6" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".7"/></radialGradient></defs>
     <rect width="512" height="512" fill="#020A04"/>${rain}
     ${grid({x0:(512-W)/2,y0:(512-H)/2,cell,gap,r:3,on:'#00FF66',off:null,glow:true})}
     <rect width="512" height="512" fill="url(#scan)"/><rect width="512" height="512" fill="url(#v)"/>`; })(),
};
(async()=>{
  const b=await chromium.launch(); const p=await b.newPage({viewport:{width:512,height:512}});
  for(const [k,v] of Object.entries(variants)){
    await p.setContent(`<html><body style="margin:0"><svg xmlns="http://www.w3.org/2000/svg" width="512" height="512">${v}</svg></body></html>`);
    await p.screenshot({path:`icon_${k}.png`});
  }
  await b.close();
})();
