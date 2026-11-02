(() => {
  const root = document.getElementById('gv-peek-pop');
  const app = root.querySelector('.gv-app');
  const grid = root.querySelector('.gv-grid');
  const base = root.querySelector('.gv-base');
  const overlay = root.querySelector('.gv-overlay');
  const preview = root.querySelector('.gv-preview-card');
  const detail = root.querySelector('.gv-detail');
  const label = root.querySelector('.gv-state-label');
  const items = [
    {id:'pr61',type:'pr',n:61,title:'Сохранить позицию сетки при возврате',state:'Открыт',review:'Запрошены изменения',tone:'red',ci:[3,4,8,15],threads:[5,8],lines:[214,35],files:6,commits:4,time:'8 мин',problem:'После просмотра PR сетка возвращается в начало.',motivation:'Быстро просматривать поток работы, сохраняя место и выбранный фильтр.',outcome:'Возврат открывает ту же карточку на прежнем месте.',changes:'Сохранены выбранный объект, фильтр и положение сетки.',validation:'Проверены переход, возврат и обновление состояния PR.'},
    {id:'pr62',type:'pr',n:62,title:'Добавить сводку репозитория',state:'Открыт',review:'Одобрено',tone:'green',ci:[0,0,12,12],threads:[0,3],lines:[423,81],files:9,commits:3,time:'24 мин',problem:'Обзор репозитория требует открытия множества объектов.',motivation:'Видеть основные сигналы работы одним взглядом.',outcome:'Сводка показывает PR, Issue и полноту данных.',changes:'Добавлены счётчики открытой работы и сигналов внимания.',validation:'Проверены счётчики на вымышленных наборах объектов.'},
    {id:'issue24',type:'issue',n:24,title:'Не терять фильтр при смене масштаба',state:'Открыта',tone:'blue',comments:7,people:3,children:[2,4],blockers:1,time:'36 мин',problem:'При приближении сетки сбрасывается фильтр красного CI.',motivation:'Просматривать проблемные PR без повторной настройки выборки.',outcome:'Плотность меняется, а область и фильтр сохраняются.'},
    {id:'pr63',type:'pr',n:63,title:'Показать неполные данные проекта',state:'Открыт',review:'Ожидает review',tone:'yellow',ci:[0,3,6,9],threads:[2,5],lines:[142,19],files:4,commits:2,time:'52 мин',problem:'Недоступный репозиторий выглядит как отсутствие работы.',motivation:'Отличать известный ноль от неполной сводки.',outcome:'Охват данных виден на карточке Project.',changes:'Добавлен признак полноты и время наблюдения.',validation:'Проверен сценарий недоступного источника.'},
    {id:'issue25',type:'issue',n:25,title:'Предпросмотр по long press',state:'Открыта',tone:'blue',comments:4,people:2,children:[1,3],blockers:0,time:'1 ч',problem:'Для краткого знакомства с объектом приходится переходить внутрь.',motivation:'Сохранять обзор сетки во время просмотра подробностей.',outcome:'Long press показывает preview; открытие ведёт в тот же объект.'},
    {id:'pr64',type:'pr',n:64,title:'Упростить карточки Issue',state:'Draft',review:'Ещё без review',tone:'secondary',ci:[0,1,4,5],threads:[0,0],lines:[87,62],files:3,commits:2,time:'2 ч',problem:'Небольшая карточка перегружена второстепенными сведениями.',motivation:'Ускорить чтение плотной сетки.',outcome:'Основные признаки читаются без приближения.',changes:'Перестроена иерархия заголовка и метрик.',validation:'Требуется проверка с крупным системным шрифтом.'}
  ];
  let state = {mode:'grid',selected:'pr61',filter:'all'};
  const design = {gridDetails:true,previewMotivation:true};
  let timer = null, origin = null, suppressUntil = 0, previousFocus = null;
  const esc = s => String(s).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
  const icon = name => `<i data-lucide="${name}" aria-hidden="true"></i>`;
  const selected = () => items.find(i=>i.id===state.selected) || items[0];
  function icons() { if (globalThis.lucide) globalThis.lucide.createIcons({attrs:{width:17,height:17}}); }
  function save() {
    if (window.openai && window.openai.setWidgetState) {
      Promise.resolve(window.openai.setWidgetState({modelContent:{prototype:'GitView Peek and Pop',scene:state.mode,object:state.selected},privateContent:{...state,design:{...design}}})).catch(()=>{});
    }
  }
  function checks(i) {
    const names=['Ошибки','Ожидание или выполнение','Успех'];
    return `<span class="gv-checks">${['red','yellow','green'].map((c,k)=>`<span class="gv-${c}" aria-label="${names[k]}: ${i.ci[k]}">${icon(['circle-x','clock','circle-check'][k])}${i.ci[k]}</span>`).join('')}<span class="gv-secondary">/ ${i.ci[3]}</span></span>`;
  }
  function facts(i) {
    if(i.type==='pr') return `<div class="gv-fact"><span>Review</span><span class="gv-${i.tone}">${i.review}</span></div><div class="gv-fact"><span>Проверки</span>${checks(i)}</div><div class="gv-fact"><span>Треды</span><span>${i.threads[0]} незакрытых / ${i.threads[1]}</span></div><div class="gv-fact"><span>Изменения</span><span><span class="gv-green">+${i.lines[0]}</span> <span class="gv-red">−${i.lines[1]}</span> · ${i.files} файлов</span></div>`;
    return `<div class="gv-fact"><span>Обсуждение</span><span>${i.comments} комментариев · ${i.people} участника</span></div><div class="gv-fact"><span>Дочерние Issue</span><span>${i.children[0]} закрыто / ${i.children[1]}</span></div><div class="gv-fact"><span>Блокировки</span><span>${i.blockers ? '1 открытый blocker' : 'Нет открытых blockers'}</span></div>`;
  }
  function heading(i) {return `<div class="gv-object-id">${icon(i.type==='pr'?'git-pull-request':'circle-dot')}demo / GitView · ${i.type==='pr'?'PR':'Issue'} #${i.n}</div><span class="gv-object-title">${esc(i.title)}</span><span class="gv-state">${i.state}</span>`;}
  function renderGrid() {
    grid.innerHTML = items.filter(i=>state.filter==='all'||i.type===state.filter).map(i=>`<article class="gv-tile"><button type="button" class="gv-tile-main" data-open="${i.id}" aria-label="Открыть ${i.type==='pr'?'PR':'Issue'} #${i.n}: ${esc(i.title)}"><span class="gv-tile-top">${icon(i.type==='pr'?'git-pull-request':'circle-dot')}${i.type==='pr'?'PR':'Issue'} #${i.n}</span><span class="gv-tile-title">${esc(i.title)}</span><span class="gv-tile-status gv-${i.tone}">${i.type==='pr'?i.review:'Открыта'}</span><span class="gv-tile-metric">${icon(i.type==='pr'?'messages-square':'message-circle')}${i.type==='pr'?i.threads[0]+' незакрытых':i.comments+' комментариев'}</span></button><span class="gv-tile-time">${i.time}</span><button type="button" class="gv-preview-trigger" data-peek="${i.id}" aria-label="Предпросмотр ${i.type==='pr'?'PR':'Issue'} #${i.n}">${icon('eye')}</button></article>`).join('');
    root.querySelectorAll('[data-filter]').forEach(b=>b.setAttribute('aria-pressed',String(b.dataset.filter===state.filter)));
    icons();
  }
  function render() {
    const i = selected();
    app.dataset.mode = state.mode;
    app.classList.toggle('gv-less-details',!design.gridDetails);
    base.hidden = state.mode==='detail';
    base.inert = state.mode==='peek';
    overlay.hidden = state.mode!=='peek';
    detail.hidden = state.mode!=='detail';
    root.querySelectorAll('[data-scene]').forEach(b=>b.setAttribute('aria-pressed',String(b.dataset.scene===state.mode)));
    if(state.mode==='peek') {
      preview.innerHTML=heading(i)+`<div class="gv-facts">${facts(i)}</div>`+(design.previewMotivation?`<div class="gv-preview-text"><span class="gv-section-label">Motivation</span><p>${esc(i.motivation)}</p></div>`:'');
    }
    if(state.mode==='detail') {
      const sections=[['Problem',i.problem],['Motivation',i.motivation],['Expected outcome',i.outcome]];
      if(i.type==='pr') sections.push(['Changes',i.changes],['Validation',i.validation]);
      detail.innerHTML=`<nav class="gv-detail-nav"><button type="button" data-action="back">${icon('chevron-left')}GitView</button><span>${i.type==='pr'?'PR':'Issue'} #${i.n}</span><button type="button" data-action="peek-detail" aria-label="Предпросмотр текущего объекта">${icon('eye')}</button></nav><div class="gv-detail-heading">${heading(i)}</div><div class="gv-detail-group">${facts(i)}${i.type==='pr'?`<div class="gv-fact"><span>Коммиты</span><span>${i.commits}</span></div>`:''}<div class="gv-fact"><span>Наблюдение</span><span>Сейчас · демо</span></div></div><div class="gv-description">${sections.map(([title,text])=>`<section><h2>${title}</h2><p>${esc(text)}</p></section>`).join('')}<section><h2>References</h2><p class="gv-secondary">${i.type==='pr'?'Issue #24 · сохранение контекста':'Project Apple Apps · обзор работы'}</p></section></div>`;
    }
    label.textContent=state.mode==='grid'?'Сетка':`${state.mode==='peek'?'Предпросмотр':'Объект'} · ${i.type==='pr'?'PR':'Issue'} #${i.n}`;
    icons();
  }
  function go(mode,id,focus=true) {
    if(mode==='peek') previousFocus=document.activeElement;
    if(id) state.selected=id;
    state.mode=mode;render();save();
    if(focus) {
      if(mode==='peek') overlay.querySelector('[data-action="pop"]').focus({preventScroll:true});
      else if(mode==='detail') detail.querySelector('[data-action="back"]').focus({preventScroll:true});
      else if(previousFocus && previousFocus.isConnected) previousFocus.focus({preventScroll:true});
    }
  }
  root.addEventListener('click',e=>{
    if(performance.now()<suppressUntil){e.preventDefault();e.stopPropagation();return;}
    const b=e.target.closest('button');if(!b)return;
    if(b.dataset.scene){go(b.dataset.scene);return;}
    if(b.dataset.filter){state.filter=b.dataset.filter;renderGrid();save();return;}
    if(b.dataset.peek){go('peek',b.dataset.peek);return;}
    if(b.dataset.open){go('detail',b.dataset.open);return;}
    if(b.dataset.action==='pop')go('detail');
    if(b.dataset.action==='back'||b.dataset.action==='dismiss'||b.classList.contains('gv-backdrop'))go('grid');
    if(b.dataset.action==='peek-detail')go('peek');
  });
  function clearHold(){if(timer)clearTimeout(timer);timer=null;origin=null;}
  grid.addEventListener('pointerdown',e=>{
    const b=e.target.closest('[data-open]');if(!b||e.button!==0)return;
    clearHold();origin={x:e.clientX,y:e.clientY};
    timer=setTimeout(()=>{timer=null;suppressUntil=performance.now()+450;go('peek',b.dataset.open);},500);
  });
  grid.addEventListener('pointermove',e=>{if(origin&&Math.hypot(e.clientX-origin.x,e.clientY-origin.y)>10)clearHold();});
  root.addEventListener('pointerup',clearHold);
  root.addEventListener('pointercancel',clearHold);
  grid.addEventListener('contextmenu',e=>{const b=e.target.closest('[data-open]');if(b){e.preventDefault();clearHold();if(state.mode!=='peek')go('peek',b.dataset.open);}});
  root.addEventListener('keydown',e=>{
    if(e.key==='Escape'&&state.mode!=='grid'){e.preventDefault();go('grid');}
    if(e.key==='Tab'&&state.mode==='peek'){
      const buttons=[...overlay.querySelectorAll('button')].filter(b=>!b.disabled);
      const first=buttons[0],last=buttons[buttons.length-1];
      if(e.shiftKey&&document.activeElement===first){e.preventDefault();last.focus();}
      else if(!e.shiftKey&&document.activeElement===last){e.preventDefault();first.focus();}
    }
  });
  function restore(saved){
    const s=saved&&saved.privateContent;
    if(!s)return;
    if(['grid','peek','detail'].includes(s.mode))state.mode=s.mode;
    if(items.some(i=>i.id===s.selected))state.selected=s.selected;
    if(['all','pr','issue'].includes(s.filter))state.filter=s.filter;
    if(s.design){if(typeof s.design.gridDetails==='boolean')design.gridDetails=s.design.gridDetails;if(typeof s.design.previewMotivation==='boolean')design.previewMotivation=s.design.previewMotivation;}
  }
  restore(window.openai && window.openai.widgetState);
  renderGrid();render();
  window.addEventListener('openai:set_globals',e=>{if(e.detail&&e.detail.globals&&e.detail.globals.widgetState){restore(e.detail.globals.widgetState);renderGrid();render();}});
  if(globalThis.Tweak){
    const tweak=new Tweak({container:app,onChange:()=>{render();save();}});
    tweak.addToggle(design,'gridDetails',{label:'Детали в сетке'});
    tweak.addToggle(design,'previewMotivation',{label:'Мотивация в preview'});
  }
})();
