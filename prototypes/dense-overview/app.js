(() => {
  const root=document.getElementById('gv-dense-overview'),app=root.querySelector('.gd-app');
  const viewport=root.querySelector('.gd-viewport'),layer=root.querySelector('.gd-cells');
  const lens=root.querySelector('.gd-lens'),slider=root.querySelector('#gd-density');
  const overview=root.querySelector('.gd-overview'),object=root.querySelector('.gd-object');
  const status=root.querySelector('.gd-status');
  const titles=['Сохранить позицию сетки при возврате','Добавить сводку репозитория','Не терять фильтр при масштабировании','Показать неполные данные проекта','Предпросмотр по удержанию','Упростить карточки Issue','Разделить статус review и CI','Сохранить источник мотивации','Проверить повторные запуски CI','Ускорить обновление счётчиков','Поддержать крупный шрифт','Обновить навигацию проекта','Уточнить причину закрытия','Добавить метрики обсуждения','Сохранить выбранный репозиторий','Показать недоступные проверки','Проверить возврат из preview','Добавить сводку дочерних Issue','Согласовать период графика','Сохранить контекст фильтра'];
  const items=Array.from({length:100},(_,i)=>{
    const type=i%5===4?'issue':'pr';
    const tone=type==='issue'||i%17===16?'grey':([0,7].includes(i%11)?'red':[1,4,8].includes(i%11)?'yellow':'green');
    return {i,type,tone,n:i+61,title:titles[i%titles.length],
      review:tone==='red'?'Запрошены изменения':tone==='yellow'?'Ожидает review':tone==='grey'?'Нет полного результата':'Одобрено',
      ci:tone==='red'?[3,4,8,15]:tone==='yellow'?[0,4,8,12]:tone==='grey'?null:[0,0,12,12],
      threads:i%7,comments:3+i%19,children:[i%3,4],
      motivation:type==='pr'?'Быстро просматривать поток изменений, сохраняя общий обзор проекта.':'Уточнить ожидаемое поведение и сохранить контекст для следующего изменения.'};
  });
  const state={cols:8,offset:0,selected:0,mode:'grid'};
  const design={showMotivation:true};
  let geom={width:0,size:0,step:0,height:0,total:0},hold=null,start=null,scrubbing=false,pinned=false;
  let pinch=null,suppressUntil=0,lastPoint=null,hovered=false;
  const icon=n=>`<i data-lucide="${n}" aria-hidden="true"></i>`;
  const esc=s=>String(s).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
  const clamp=(v,a,b)=>Math.max(a,Math.min(b,v));
  const nodes=items.map(i=>{
    const b=document.createElement('button');b.type='button';b.className='gd-cell cursor-interaction';
    b.dataset.index=i.i;b.dataset.tone=i.tone;
    b.setAttribute('aria-label',`${i.type==='pr'?'PR':'Issue'} #${i.n}: ${i.title}; ${i.type==='pr'?i.review:'открыта'}`);
    b.innerHTML=`<span class="gd-cell-icon">${icon(i.type==='pr'?'git-pull-request':'circle-dot')}</span><span class="gd-cell-number">${i.n}</span><span class="gd-cell-title">${esc(i.title)}</span><span class="gd-cell-state">${i.type==='pr'?i.review:i.comments+' комментариев'}</span>`;
    layer.append(b);return b;
  });
  function icons(){if(globalThis.lucide)globalThis.lucide.createIcons({attrs:{width:14,height:14}});}
  function save(){if(window.openai&&window.openai.setWidgetState)Promise.resolve(window.openai.setWidgetState({modelContent:{prototype:'GitView dense overview',columns:state.cols,selected:`${items[state.selected].type} #${items[state.selected].n}`,mode:state.mode},privateContent:{...state,design:{...design}}})).catch(()=>{});}
  function updateStatus(){status.textContent=state.mode==='object'?`Объект · ${items[state.selected].type==='pr'?'PR':'Issue'} #${items[state.selected].n}`:`${state.cols} колонок · ${scrubbing?'скользящий preview':'тот же набор из 100 объектов'}`;}
  function layout(){
    if(!viewport.clientWidth)return;
    const width=viewport.clientWidth,gap=state.cols>5?4:state.cols>3?6:10;
    const size=(width-gap*(state.cols-1))/state.cols;
    const base=(width-7*4)/8;
    geom={width,size,step:size+gap,height:Math.ceil(100/8)*(base+4)-4,total:Math.ceil(100/state.cols)*(size+gap)-gap};
    state.offset=clamp(state.offset,0,Math.max(0,geom.total-geom.height));
    viewport.style.height=geom.height+'px';
    app.dataset.density=state.cols>=7?'micro':state.cols>=4?'compact':'large';
    nodes.forEach((n,i)=>{
      n.style.width=size+'px';n.style.height=size+'px';
      n.style.transform=`translate(${(i%state.cols)*geom.step}px,${Math.floor(i/state.cols)*geom.step-state.offset}px)`;
      const visible=Math.floor(i/state.cols)*geom.step+size>=state.offset&&Math.floor(i/state.cols)*geom.step<=state.offset+geom.height;
      n.inert=!visible;
    });
    const first=Math.floor(state.offset/geom.step)*state.cols+1;
    const last=Math.min(100,Math.ceil((state.offset+geom.height)/geom.step)*state.cols);
    root.querySelector('.gd-visible').textContent=`${first}–${last} из 100`;
    slider.value=10-state.cols;root.querySelector('.gd-columns').textContent=state.cols+' в ряд';
    updateStatus();
  }
  function pickAt(x,y){const r=viewport.getBoundingClientRect();if(x<r.left||x>r.right||y<r.top||y>r.bottom)return null;const col=clamp(Math.floor((x-r.left)/geom.step),0,state.cols-1),row=Math.floor((y-r.top+state.offset)/geom.step);const index=row*state.cols+col;return index>=0&&index<100?index:null;}
  function colorSummary(i){return i.type==='issue'?`${i.comments} комментариев · ${i.children[0]}/${i.children[1]} дочерних закрыто`:i.ci?`<span class="gd-red">× ${i.ci[0]}</span><span class="gd-yellow">◷ ${i.ci[1]}</span><span class="gd-green">✓ ${i.ci[2]}</span><span>Всего ${i.ci[3]}</span>`:'Данные CI неполные';}
  function placeLens(x,y){
    lastPoint={x,y};const r=app.getBoundingClientRect(),w=lens.offsetWidth,h=lens.offsetHeight;
    const left=clamp(x-r.left-w*.5,12,Math.max(12,r.width-w-12));
    const above=y-r.top-h-28;
    const top=above>=12?above:Math.min(y-r.top+30,r.height-h-12);
    lens.style.left=left+'px';lens.style.top=Math.max(12,top)+'px';
  }
  function showLens(index,x,y){
    if(index===null||state.mode!=='grid')return;
    const changed=state.selected!==index||lens.hidden;
    nodes[state.selected].dataset.picked='false';state.selected=index;nodes[index].dataset.picked='true';
    if(changed){const i=items[index];lens.innerHTML=`<div class="gd-lens-id"><span>GitView · ${i.type==='pr'?'PR':'Issue'} #${i.n}</span><button type="button" data-action="close-lens" aria-label="Закрыть preview">${icon('x')}</button></div><h2>${esc(i.title)}</h2><div class="gd-lens-state gd-${i.tone}">${i.type==='pr'?i.review:'Открыта'}</div><div class="gd-lens-metrics">${colorSummary(i)}${i.type==='pr'?`<span>· ${i.threads} незакрытых тредов</span>`:''}</div>${design.showMotivation?`<p class="gd-lens-motivation">${esc(i.motivation)}</p>`:''}<button type="button" class="gd-lens-open" data-action="open">Открыть объект ${icon('arrow-up-right')}</button>`;icons();}
    lens.hidden=false;placeLens(x,y);
  }
  function closeLens(){lens.hidden=true;nodes[state.selected].dataset.picked='false';pinned=false;hovered=false;}
  function zoomTo(cols,anchor){
    cols=clamp(Math.round(cols),2,10);if(cols===state.cols)return;
    const local=anchor||{x:viewport.getBoundingClientRect().left+geom.width/2,y:viewport.getBoundingClientRect().top+geom.height/2};
    const index=pickAt(local.x,local.y)??state.selected;
    const localY=local.y-viewport.getBoundingClientRect().top;
    closeLens();state.cols=cols;layout();
    state.offset=Math.floor(index/cols)*geom.step-localY+geom.size/2;layout();
  }
  function clearHold(){if(hold)clearTimeout(hold);hold=null;}
  function beginHold(x,y){
    clearHold();start={x,y,offset:state.offset,moved:false};
    hold=setTimeout(()=>{hold=null;scrubbing=true;pinned=false;showLens(pickAt(x,y),x,y);updateStatus();},480);
  }
  function finish(){const changed=!!pinch||!!(start&&start.moved)||scrubbing;clearHold();if(scrubbing){scrubbing=false;suppressUntil=performance.now()+450;closeLens();}start=null;pinch=null;app.classList.remove('gd-dragging');updateStatus();if(changed)save();}
  viewport.addEventListener('pointermove',e=>{
    if(e.pointerType==='touch')return;
    if(scrubbing){showLens(pickAt(e.clientX,e.clientY),e.clientX,e.clientY);return;}
    if(e.buttons&&start){if(Math.hypot(e.clientX-start.x,e.clientY-start.y)>9){clearHold();start.moved=true;app.classList.add('gd-dragging');state.offset=start.offset-(e.clientY-start.y);layout();}return;}
    if(!e.buttons&&!pinned&&!lens.contains(e.target)){hovered=true;showLens(pickAt(e.clientX,e.clientY),e.clientX,e.clientY);}
  });
  viewport.addEventListener('pointerdown',e=>{if(e.pointerType!=='touch'&&e.button===0){closeLens();beginHold(e.clientX,e.clientY);viewport.setPointerCapture(e.pointerId);}});
  viewport.addEventListener('pointerup',e=>{if(e.pointerType==='touch')return;const moved=start&&start.moved;const index=pickAt(e.clientX,e.clientY);const tap=start&&!moved&&!scrubbing&&index!==null;if(moved)suppressUntil=performance.now()+300;finish();if(tap){state.selected=index;openObject();suppressUntil=performance.now()+300;}});
  viewport.addEventListener('pointercancel',finish);
  viewport.addEventListener('contextmenu',e=>{e.preventDefault();});
  viewport.addEventListener('touchstart',e=>{
    closeLens();if(e.touches.length===2){clearHold();start=null;const a=e.touches[0],b=e.touches[1];pinch={distance:Math.hypot(a.clientX-b.clientX,a.clientY-b.clientY),cols:state.cols};}
    else if(e.touches.length===1)beginHold(e.touches[0].clientX,e.touches[0].clientY);
  },{passive:true});
  viewport.addEventListener('touchmove',e=>{
    if(e.touches.length===2&&pinch){e.preventDefault();const a=e.touches[0],b=e.touches[1];const distance=Math.hypot(a.clientX-b.clientX,a.clientY-b.clientY);zoomTo(pinch.cols*pinch.distance/distance,{x:(a.clientX+b.clientX)/2,y:(a.clientY+b.clientY)/2});return;}
    if(e.touches.length!==1)return;const t=e.touches[0];
    if(scrubbing){e.preventDefault();showLens(pickAt(t.clientX,t.clientY),t.clientX,t.clientY);return;}
    if(start&&Math.hypot(t.clientX-start.x,t.clientY-start.y)>9){e.preventDefault();clearHold();start.moved=true;app.classList.add('gd-dragging');state.offset=start.offset-(t.clientY-start.y);layout();}
  },{passive:false});
  viewport.addEventListener('touchend',()=>{if(start&&start.moved)suppressUntil=performance.now()+300;finish();},{passive:true});
  viewport.addEventListener('touchcancel',finish,{passive:true});
  viewport.addEventListener('wheel',e=>{
    if(e.ctrlKey){e.preventDefault();zoomTo(state.cols+(e.deltaY>0?1:-1),{x:e.clientX,y:e.clientY});save();return;}
    const max=Math.max(0,geom.total-geom.height),next=clamp(state.offset+e.deltaY,0,max);
    if(next!==state.offset){e.preventDefault();closeLens();app.classList.add('gd-dragging');state.offset=next;layout();save();}
  },{passive:false});
  app.addEventListener('pointerleave',()=>{if(hovered&&!pinned&&!scrubbing)closeLens();});
  slider.addEventListener('input',()=>zoomTo(10-Number(slider.value)));
  slider.addEventListener('change',save);
  function openObject(){
    const i=items[state.selected];closeLens();state.mode='object';overview.hidden=true;object.hidden=false;
    object.innerHTML=`<button type="button" class="gd-object-back" data-action="back">${icon('chevron-left')}К сетке · ${state.cols} в ряд</button><p class="gd-context">GitView · ${i.type==='pr'?'PR':'Issue'} #${i.n}</p><h2>${esc(i.title)}</h2><div class="gd-lens-state gd-${i.tone}">${i.type==='pr'?i.review:'Открыта'}</div><div class="gd-lens-metrics">${colorSummary(i)}</div><section><h3>Problem</h3><p>В плотной сетке название и подробности объекта не видны целиком.</p></section><section><h3>Motivation</h3><p>${esc(i.motivation)}</p></section><section><h3>Expected outcome</h3><p>Просматривать объекты, сохраняя масштаб, область и место в сетке.</p></section><section><h3>References</h3><p>Демонстрационные данные · не считаны из GitHub</p></section>`;
    icons();updateStatus();save();object.querySelector('button').focus({preventScroll:true});
  }
  root.addEventListener('click',e=>{
    if(performance.now()<suppressUntil){e.preventDefault();return;}
    const b=e.target.closest('button');if(!b)return;
    if(b.dataset.action==='close-lens'){closeLens();return;}
    if(b.dataset.action==='open'){openObject();return;}
    if(b.dataset.action==='back'){state.mode='grid';object.hidden=true;overview.hidden=false;layout();updateStatus();save();nodes[state.selected].focus({preventScroll:true});return;}
    if(b.dataset.index!==undefined){state.selected=Number(b.dataset.index);openObject();}
  });
  layer.addEventListener('focusin',e=>{const b=e.target.closest('[data-index]');if(b){const r=b.getBoundingClientRect();showLens(Number(b.dataset.index),r.left+r.width/2,r.top+r.height/2);}});
  root.addEventListener('keydown',e=>{if(e.key==='Escape'){clearHold();scrubbing=false;closeLens();updateStatus();}});
  function restore(saved){const s=saved&&saved.privateContent;if(!s)return;if(Number.isFinite(s.cols))state.cols=clamp(Math.round(s.cols),2,10);if(Number.isFinite(s.offset))state.offset=Math.max(0,s.offset);if(Number.isInteger(s.selected))state.selected=clamp(s.selected,0,99);if(s.design&&typeof s.design.showMotivation==='boolean')design.showMotivation=s.design.showMotivation;}
  restore(window.openai&&window.openai.widgetState);layout();icons();
  new ResizeObserver(()=>{layout();if(!lens.hidden&&lastPoint)placeLens(lastPoint.x,lastPoint.y);}).observe(viewport);
  window.addEventListener('openai:set_globals',e=>{if(e.detail&&e.detail.globals&&e.detail.globals.widgetState){restore(e.detail.globals.widgetState);layout();}});
  if(globalThis.Tweak){const tweak=new Tweak({container:app,onChange:()=>{if(!lens.hidden&&lastPoint){lens.hidden=true;showLens(state.selected,lastPoint.x,lastPoint.y);}save();}});tweak.addToggle(design,'showMotivation',{label:'Мотивация в бабле'});}
})();
