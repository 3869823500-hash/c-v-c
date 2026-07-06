<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>罗伯特斯</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;user-select:none}
body{background:#0d1117;min-height:100vh;display:flex;align-items:center;justify-content:center;font-family:'Microsoft YaHei',sans-serif}

.win{
  position:absolute;
  width:360px;
  background:rgba(22,27,38,0.95);
  border-radius:10px;
  border:1px solid rgba(255,255,255,0.06);
  box-shadow:0 20px 60px rgba(0,0,0,0.8);
  transition:all 0.3s;
  overflow:hidden;
}

.titlebar{
  display:flex;
  align-items:center;
  justify-content:space-between;
  padding:10px 14px;
  cursor:grab;
  border-bottom:1px solid rgba(255,255,255,0.04);
}
.titlebar:active{cursor:grabbing}
.titlebar .name{color:rgba(255,255,255,0.8);font-size:14px;font-weight:500}
.titlebar .btns{display:flex;gap:5px}
.titlebar .btns button{
  width:26px;height:26px;
  border:none;border-radius:4px;
  background:rgba(255,255,255,0.04);
  color:rgba(255,255,255,0.5);
  font-size:14px;
  cursor:pointer;
  transition:0.15s;
}
.titlebar .btns button:hover{background:rgba(255,255,255,0.1);color:#fff}
.btn-min{color:#f5cd6b}
.btn-min:hover{background:rgba(255,215,0,0.15)!important}
.btn-close{color:#ff6b6b}
.btn-close:hover{background:rgba(255,70,70,0.2)!important}

.content{padding:16px}

.func{
  display:flex;
  align-items:center;
  justify-content:space-between;
  padding:8px 10px;
  border-radius:6px;
  margin-bottom:4px;
  border:1px solid rgba(255,255,255,0.03);
}
.func:hover{background:rgba(255,255,255,0.03)}
.func .label{color:rgba(255,255,255,0.8);font-size:13px}

.toggle{
  width:36px;height:20px;
  background:rgba(255,255,255,0.08);
  border-radius:10px;
  cursor:pointer;
  transition:0.3s;
  position:relative;
  flex-shrink:0;
}
.toggle.on{background:rgba(74,222,128,0.3)}
.toggle .knob{
  position:absolute;
  top:1px;left:1px;
  width:16px;height:16px;
  background:#fff;
  border-radius:50%;
  transition:0.3s;
}
.toggle.on .knob{left:17px;background:#4ade80}

.status{
  margin-top:10px;
  padding:6px 10px;
  border-radius:6px;
  background:rgba(255,255,255,0.02);
  color:rgba(255,255,255,0.3);
  font-size:12px;
  text-align:center;
}

/* 球体 */
.ball{
  width:60px!important;
  height:60px!important;
  min-height:60px!important;
  border-radius:50%;
  display:flex!important;
  align-items:center;
  justify-content:center;
  cursor:grab;
}
.ball .titlebar,.ball .content{display:none}
.ball::after{
  content:"⚡";
  font-size:22px;
  animation:pulse 1.5s infinite alternate;
}
@keyframes pulse{
  0%{opacity:0.5;transform:scale(0.9)}
  100%{opacity:1;transform:scale(1.1)}
}
</style>
</head>
<body>

<div id="win" class="win" style="left:60px;top:60px">
  <div class="titlebar" id="drag">
    <span class="name">⚡ 罗伯特斯</span>
    <div class="btns">
      <button class="btn-min" id="minBtn">−</button>
      <button class="btn-close" id="closeBtn">✕</button>
    </div>
  </div>
  <div class="content">
    <div class="func"><span class="label">🎯 自瞄</span><div class="toggle" data-fn="aim"><span class="knob"></span></div></div>
    <div class="func"><span class="label">👁 透视</span><div class="toggle" data-fn="esp"><span class="knob"></span></div></div>
    <div class="func"><span class="label">✈️ 飞行</span><div class="toggle" data-fn="fly"><span class="knob"></span></div></div>
    <div class="func"><span class="label">🧱 穿墙</span><div class="toggle" data-fn="clip"><span class="knob"></span></div></div>
    <div class="status" id="status">● 就绪</div>
  </div>
</div>

<script>
(function(){
const win=document.getElementById('win')
const drag=document.getElementById('drag')
const minBtn=document.getElementById('minBtn')
const closeBtn=document.getElementById('closeBtn')
const status=document.getElementById('status')

// ===== 功能状态 =====
const state={aim:false,esp:false,fly:false,clip:false}

// ===== 更新UI =====
function update(){
  document.querySelectorAll('.toggle').forEach(el=>{
    const key=el.dataset.fn
    el.classList.toggle('on',state[key])
  })
  const n=Object.values(state).filter(v=>v).length
  status.textContent=n>0?`● ${n}个功能已开启`:'● 就绪'
  status.style.color=n>0?'rgba(74,222,128,0.6)':'rgba(255,255,255,0.3)'
}

// ===== 切换功能 =====
document.querySelectorAll('.toggle').forEach(el=>{
  el.addEventListener('click',()=>{
    const key=el.dataset.fn
    state[key]=!state[key]
    update()
    console.log(`[罗伯特斯] ${key} ${state[key]?'开启':'关闭'}`)
  })
})

// ===== 键盘快捷键 =====
document.addEventListener('keydown',e=>{
  if(e.key==='F1'){state.esp=!state.esp;update();console.log(`[透视] ${state.esp?'开':'关'}`);e.preventDefault()}
  if(e.key==='F2'){state.clip=!state.clip;update();console.log(`[穿墙] ${state.clip?'开':'关'}`);e.preventDefault()}
  if(e.key===' ' && state.fly){e.preventDefault();console.log('[飞行] 空格触发')}
})

// ===== 鼠标右键自瞄 =====
document.addEventListener('contextmenu',e=>{
  if(state.aim){e.preventDefault();console.log('[自瞄] 右键触发')}
})

// ===== 拖动 =====
let dragging=false,ox=0,oy=0
drag.addEventListener('mousedown',e=>{
  if(!drag.contains(e.target))return
  const r=win.getBoundingClientRect()
  ox=e.clientX-r.left; oy=e.clientY-r.top
  dragging=true; win.classList.add('dragging')
})
document.addEventListener('mousemove',e=>{
  if(!dragging)return
  let x=e.clientX-ox, y=e.clientY-oy
  const w=window.innerWidth,h=window.innerHeight
  const ew=win.offsetWidth||360, eh=win.offsetHeight||300
  x=Math.max(-ew+20,Math.min(w-20,x))
  y=Math.max(-eh+20,Math.min(h-20,y))
  win.style.left=x+'px'; win.style.top=y+'px'
})
document.addEventListener('mouseup',()=>{dragging=false;win.classList.remove('dragging')})

// ===== 缩成球 =====
let ball=false
minBtn.addEventListener('click',()=>{
  ball=!ball
  win.classList.toggle('ball',ball)
})

// ===== 关闭 =====
closeBtn.addEventListener('click',()=>{
  if(confirm('关闭？')) win.style.display='none'
})

update()
console.log('[罗伯特斯] 已启动 | F1透视 F2穿墙 空格飞行 右键自瞄')
})()
</script>
</body>
</html>
