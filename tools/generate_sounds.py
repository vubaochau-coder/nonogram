"""Tổng hợp hiệu ứng âm thanh của game (không dùng mẫu âm của bên thứ ba)."""
# Chạy: python3 tools/generate_sounds.py assets/sounds  (cần numpy)
import sys, wave
import numpy as np
SR = 44100
OUT = sys.argv[1]

def t(d): return np.arange(int(SR*d))/SR
def tone(f, d, decay, harm=(1, 0.35, 0.12)):
    x = t(d); env = np.exp(-decay*x)*np.minimum(1, x*300)
    return sum(a*np.sin(2*np.pi*f*(i+1)*x) for i, a in enumerate(harm))*env
def fade_tail(x, ms=8):
    n = int(SR*ms/1000); x = x.copy(); x[-n:] *= np.linspace(1, 0, n); return x
def save(name, x, peak):
    x = fade_tail(x); x = x/max(1e-9, np.abs(x).max())*peak
    with wave.open(f'{OUT}/{name}.wav', 'wb') as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(SR)
        w.writeframes((x*32767).astype(np.int16).tobytes())

# Tô ô: "pop" ngắn, cao độ trượt xuống.
x = t(0.11); fr = np.linspace(620, 330, len(x))
save('fill', np.sin(2*np.pi*np.cumsum(fr)/SR)*np.exp(-38*x)*np.minimum(1, x*900), 0.7)

# Đánh X / xoá ô: tiếng tick khô.
x = t(0.06); rng = np.random.default_rng(1)
tick = (np.sin(2*np.pi*1800*x)*0.6 + np.convolve(rng.normal(size=len(x)), np.ones(6)/6, 'same')*0.4)*np.exp(-80*x)
save('mark', tick, 0.45)

# Xong một hàng / cột: hai nốt chuông đi lên.
a = tone(1046.5, 0.22, 16); b = tone(1568, 0.3, 12)
x = np.zeros(int(SR*0.38)); x[:len(a)] += a; o = int(SR*0.06); x[o:o+len(b)] += b
save('line', x, 0.5)

# Sóng nổi ô (~1,3 s): 10 tiếng "bụp" đi lên theo thang ngũ cung.
def bubble(f):
    x = t(0.16); f2 = f*(1+0.5*np.minimum(1, x/0.05))
    return np.sin(2*np.pi*np.cumsum(f2)/SR)*np.exp(-22*x)*np.minimum(1, x*500)
penta = [523.25, 587.33, 659.25, 783.99, 880.0, 1046.5, 1174.66, 1318.5, 1567.98, 1760.0]
x = np.zeros(int(SR*1.45))
for i, f in enumerate(penta):
    s = bubble(f); o = int(SR*(i/9)*1.0); x[o:o+len(s)] += s
save('wave', x, 0.45)

# Tranh bay (~0,9 s): tiếng gió nhẹ.
d = 0.9; x = t(d); n = np.convolve(np.random.default_rng(3).normal(size=len(x)), np.ones(40)/40, 'same')
save('whoosh', n*np.sin(np.pi*np.clip(x/d, 0, 1))**2, 0.3)

# Tranh đáp xuống: rải hợp âm Đô trưởng + lấp lánh.
x = np.zeros(int(SR*1.4))
for i, f in enumerate([523.25, 659.25, 783.99, 1046.5]):
    s = tone(f, 1.1, 3.5 if i == 3 else 6); o = int(SR*0.08*i); x[o:o+len(s)] += s*0.5
rng = np.random.default_rng(5)
for k in range(8):
    s = tone(rng.uniform(2200, 3400), 0.18, 25, (1,)); o = int(SR*(0.35+k*0.06)); x[o:o+len(s)] += s*0.12
save('fanfare', x, 0.75)
