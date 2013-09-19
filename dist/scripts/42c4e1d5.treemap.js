OpenSpending="OpenSpending"in window?OpenSpending:{},function(a){OpenSpending.Treemap=function(b,c,d){var e=this,f=[OpenSpending.scriptRoot+"/widgets/treemap/js/thejit-2.min.js",OpenSpending.scriptRoot+"/widgets/treemap/css/treemap.css"];window.HTMLCanvasElement||f.push(OpenSpending.scriptRoot+"/widgets/treemap/js/excanvas.js"),e.context=a.extend({click:function(a){if(a.data.link){var b=c.embed?a.data.link+"?embed=true":a.data.link;document.location.href=b}},hasClick:function(a){return void 0!==a.data.link},createLabel:function(a,b,c){c.data.value/e.total>.03&&(b.innerHTML="<div class='desc'><div class='amount'>"+OpenSpending.Utils.formatAmountWithCommas(c.data.value,0,e.currency)+"</div><div class='lbl'>"+c.name+"</div></div>")},tooltipMessage:function(a,b){var c=100*b.data.value/a.total;return b.name+" ("+OpenSpending.Utils.formatAmountWithCommas(c,2)+"%)"},drilldown:function(a){e.drilldown(a)}},c),e.state=d,this.configure=function(a){e.$qb.empty(),new OpenSpending.Widgets.QueryBuilder(e.$qb,e.update,a,e.context,[{variable:"drilldowns",label:"Tiles:",type:"select","default":e.state.drilldowns,help:"Each selected dimension will display as an additional level of tiles for the treemap."},{variable:"year",label:"Year:",type:"slider",dimension:"time",attribute:"year","default":e.state.year,help:"Filter by year."},{variable:"cuts",label:"Filters:",type:"cuts","default":e.state.cuts,help:"Limit the set of data to display."}])},this.update=function(a){e.state=a,e.state.drilldowns=e.state.drilldowns||[e.state.drilldown],e.state.cuts=e.state.cuts||{};var b=[];for(var c in e.state.cuts)b.push(c+":"+e.state.cuts[c]);e.state.year&&b.push("time.year:"+e.state.year),"undefined"!=typeof e.context.member&&"undefined"!=typeof e.context.dimension&&b.push(e.context.dimension+":"+e.context.member),e.state.drilldowns&&(e.aggregator=new OpenSpending.Aggregator({siteUrl:e.context.siteUrl,dataset:e.context.dataset,drilldowns:e.state.drilldowns,cuts:b,rootNodeLabel:"Total",callback:function(a){e.setDataFromAggregator(this.dataset,a)}}))},this.getDownloadURL=function(){return e.aggregator.getCSVURL()},this.serialize=function(){return e.state},this.init=function(){e.$e=b,e.$e.before('<div class="treemap-qb"></div>'),e.$qb=b.prev(),e.$e.addClass("treemap-widget"),e.update(d)},this.setDataFromAggregator=function(a,b){e.currency=b.currency,e.setNode(b)},this.setNode=function(b){var c=!0;e.total=b.amount,e.data={children:a.map(b.children,function(a){return a.color&&(c=!1),{children:[],id:a.id,name:a.label||a.name,data:{node:a,value:a.amount,$area:a.amount,title:a.label||a.name,link:a.html_url,name:a.name,$color:a.color||"#333333"}}})},c&&this.autoColorize(),e.draw()},this.drilldown=function(a){a.data.node.children.length?e.setNode(a.data.node):e.context.click(a)},this.autoColorize=function(){for(var a=e.data.children.length,b=OpenSpending.Utils.getColorPalette(a),c=0;a>c;c++)e.data.children[c].data.$color=b[c]},this.draw=function(){return e.$e.empty(),e.data.children.length?(a(e.$e).show(),e.tm=new $jit.TM.Squarified({injectInto:e.$e.prop("id"),levelsToShow:1,titleHeight:0,animate:!0,transition:$jit.Trans.Expo.easeOut,offset:2,Label:{type:"HTML",size:12,family:"Tahoma, Verdana, Arial",color:"#DDE7F0"},Node:{color:"#243448",CanvasStyles:{shadowBlur:0,shadowColor:"#000"}},Events:{enable:!0,onClick:function(a){a&&e.context.drilldown(a)},onRightClick:function(){e.tm.out()},onMouseEnter:function(a){a&&(e.context.hasClick(a)||e.$e.find("#"+a.id).css("cursor","default"),a.setCanvasStyle("shadowBlur",8),a.orig_color=a.getData("color"),a.setData("color","#A3B3C7"),e.tm.fx.plotNode(a,e.tm.canvas))},onMouseLeave:function(a){a&&(a.removeData("color"),a.removeCanvasStyle("shadowBlur"),a.setData("color",a.orig_color),e.tm.plot())}},duration:1e3,Tips:{enable:!0,type:"Native",offsetX:20,offsetY:20,onShow:function(a,b){var c='<div class="tip-title">'+e.context.tooltipMessage(e,b)+'</div><div class="tip-text">';b.data,a.innerHTML=c}},request:function(a,b,c){var d=json,e=$jit.json.getSubtree(d,a);$jit.json.prune(e,1),c.onComplete(a,e)},onCreateLabel:function(a,b){e.context.createLabel(e,a,b)}}),e.tm.loadJSON(this.data),e.tm.refresh(),void 0):(a(e.$e).hide(),void 0)};var g=a.Deferred();return g.done(function(a){a.init()}),window.treemapWidgetLoaded?g.resolve(e):yepnope({load:f,complete:function(){window.treemapWidgetLoaded=!0,g.resolve(e)}}),g.promise()}}(jQuery),function(){angular.module("fgvApp").filter("slug",function(){return function(a){var b,c,d,e,f,g,h;if(!a)return"";for(e=a.trim().toLowerCase(),c="àáäâãèéëêìíïîòóöôõùúüûñç·/_,:;",f="aaaaaeeeeiiiiooooouuuunc------",d=g=0,h=c.length;h>g;d=++g)b=c[d],e=e.replace(new RegExp(b,"g"),f.charAt(d));return e=e.replace(/[^a-z0-9 -]/g,"").replace(/\s+/g,"-").replace(/-+/g,"-")}})}.call(this),function(){angular.module("fgvApp").filter("sort",function(){var a,b;return a=function(a,b){return a-b},b=function(a,b){return b-a},function(c,d){var e;if(c)return e=c.slice(),"desc"===d?e.sort(b):e.sort(a)}})}.call(this),function(){var a,b=[].indexOf||function(a){for(var b=0,c=this.length;c>b;b++)if(b in this&&this[b]===a)return b;return-1},c={}.hasOwnProperty;angular.module("fgvApp").factory("routing",["$state","$filter","$rootScope","openspending",function(d,e,f,g){var h,i,j,k,l,m,n,o,p,q,r,s,t,u;return s={year:"treemap.year","funcao.year":"treemap.year.funcao","funcao.subfuncao.year":"treemap.year.funcao.subfuncao","funcao.orgao.subfuncao.year":"treemap.year.funcao.subfuncao.orgao","funcao.orgao.subfuncao.uo.year":"treemap.year.funcao.subfuncao.orgao.uo","funcao.mod_aplic.orgao.subfuncao.uo.year":"treemap.year.funcao.subfuncao.orgao.uo.mod_aplic","elemento_despesa.funcao.mod_aplic.orgao.subfuncao.uo.year":"treemap.year.funcao.subfuncao.orgao.uo.mod_aplic.elemento_despesa"},t={year:"treemap.year",funcao:"treemap.year.funcao",subfuncao:"treemap.year.funcao.subfuncao",orgao:"treemap.year.funcao.subfuncao.orgao",uo:"treemap.year.funcao.subfuncao.orgao.uo",mod_aplic:"treemap.year.funcao.subfuncao.orgao.uo.mod_aplic",elemento_despesa:"treemap.year.funcao.subfuncao.orgao.uo.mod_aplic.elemento_despesa"},l=new a,i=function(a){return a&&b.call(l.keys,a)>=0?l.val(a):l.all()},j=function(a){var b,c,e,f,g,h;for(c=t[a.type],b={},h=i(),f=0,g=h.length;g>f;f++)e=h[f],b[e.type]=q(e);return b[a.type]=q(a),c?d.href(c,b):void 0},k=function(a){var b,c,e,f,g;null!=a&&l.push(a.type,a),c={},g=l.vals;for(f in g)b=g[f],c[b.type]=q(b);return e=r(c),null!=e?d.go(e,c):void 0},h=function(){return d.go("^")},o=function(){var a,c,e,f,g,h;for(f=d.current.name.split("."),e=d.params,g=0,h=f.length;h>g;g++)c=f[g],e[c]&&l.push(c,{type:c,id:parseInt(e[c])});return m(),b.call(l.keys,"year")<0?(a=(new Date).getFullYear(),l.push("year",{type:"year",id:a})):void 0},u=function(){var a,b,c,e,f,g,h;for(e=l.keys.slice().reverse(),c=d.params,h=[],f=0,g=e.length;g>f;f++)b=e[f],c[b]?(a=parseInt(c[b])!==parseInt(l.val(b).id),a?h.push(l.push(b,{type:b,id:parseInt(c[b])})):h.push(void 0)):h.push(l.pop());return h},r=function(a){var b;return b=Object.keys(a).sort().join("."),s[b]},m=function(){var a,b,d,e,f;d={},f=i();for(e in f)c.call(f,e)&&(b=f[e],b.label||"year"===b.type||(d[b.type]=b.id));return a=Object.keys(d),a.length?g.aggregate(d,a).then(function(a){var b,e,f,g,h;for(h in d)c.call(d,h)&&(g=d[h],b=a.data.drilldown[0][h],e=null!=l.val(h)&&parseInt(g)===parseInt(b.name),e&&(f=i(h),f.label=b.label));return k()}):void 0},q=function(a){var b;return b=a.id,a.label&&(b+="-"+p(a.label)),b},p=e("slug"),n=function(){return f.$on("$stateChangeSuccess",u),o()},n(),{href:j,updateState:k,back:h,getBreadcrumb:i}}]),a=function(){function a(){this.keys=[],this.vals={}}return a.prototype.push=function(a,b){return this.vals[a]||this.keys.push(a),this.vals[a]=b},a.prototype.peek=function(){var a;return a=this.keys[this.keys.length-1],this.vals[a]},a.prototype.pop=function(){var a,b;return a=this.keys.pop(),b=this.vals[a],delete this.vals[a],b},a.prototype.all=function(){var a,b,c,d,e;for(d=this.keys,e=[],b=0,c=d.length;c>b;b++)a=d[b],e.push(this.vals[a]);return e},a.prototype.val=function(a){return this.vals[a]},a}()}.call(this),function(){angular.module("fgvApp").directive("treemap",["openspending",function(a){var b,c,d,e,f;return c=function(a){var b,c,d;for(d=[],b=c=0;a>=0?a>c:c>a;b=a>=0?++c:--c)d.push("#1C2F67");return d},e=function(){},d=function(){return!0},f=function(a,b){var c;return c=a.context.drilldown,a.context.drilldown=function(a){return b.$apply(function(){return e(a),c(a)})}},b=function(b,c,e,g){var h,i,j;return j={drilldowns:c,cuts:e},h={dataset:a.dataset,siteUrl:a.url,embed:!0,click:function(){},hasClick:d},i=new window.OpenSpending.Treemap(b,h,j),i.done(function(a){return f(a,g)}),i},{restrict:"E",scope:{cuts:"=",click:"=",drilldown:"="},templateUrl:"views/partials/treemap.html",link:function(f,g,h){var i;return window.OpenSpending.Utils.getColorPalette=c,window.OpenSpending.scriptRoot=""+a.url+"/static/openspendingjs",window.OpenSpending.localeGroupSeparator=",",window.OpenSpending.localeDecimalSeparator=".",i=g.children("div"),null!=f.click&&(e=f.click),d=function(a){return a.data.node.taxonomy!==h.lastDrilldown},f.$watch("cuts + currentDrilldown",function(){var a,c;return a=f.cuts,c=f.drilldown,a&&c?b(i,[c],a,f):void 0},!0)}}}])}.call(this),function(){var a=[].indexOf||function(a){for(var b=0,c=this.length;c>b;b++)if(b in this&&this[b]===a)return b;return-1};angular.module("fgvApp").directive("years",["openspending",function(b){return{templateUrl:"views/partials/years.html",restrict:"E",scope:{year:"=",years:"=",cuts:"="},link:function(c){var d;return d=function(d){var e;return e=$.extend({},d),delete e.year,b.aggregate(e,["year"]).then(function(b){var d,e,f;return e=function(){var a,c,e,f;for(e=b.data.drilldown,f=[],a=0,c=e.length;c>a;a++)d=e[a],f.push(d.year);return f}(),c.years=e.sort(),c.year&&(f=c.year,a.call(c.years,f)>=0)?void 0:c.year=c.years[c.years.length-1]})},c.$watch("cuts",d,!0)}}}])}.call(this),function(){angular.module("fgvApp").directive("breadcrumb",["$state","routing",function(a,b){return{restrict:"E",templateUrl:"views/partials/breadcrumb.html",link:function(a,c){var d;return d=function(d){var e,f;for(e=0,f=d.length;f>e;e++)c=d[e],c.url=b.href(c);return a.breadcrumb=d},a.$watch(b.getBreadcrumb,d,!0)}}}])}.call(this),function(){var a={}.hasOwnProperty;angular.module("fgvApp").controller("TreemapCtrl",["$scope","routing",function(b,c){var d,e,f,g;return b.back=c.back,b.treemapOnClick=function(a){var b,d;return b={id:parseInt(a.data.name),label:a.name,type:a.data.node.taxonomy},d="elemento_despesa",b.type!==d?c.updateState(b):void 0},b.year=c.getBreadcrumb("year").id,b.$watch("year",function(a){var b;return b={id:a,type:"year"},b.id?c.updateState(b):void 0}),g=function(c){var d,e,f;e={};for(f in c)a.call(c,f)&&(d=c[f],e[d.type]=parseInt(d.id));return b.cuts=e},d=["funcao","subfuncao","orgao","uo","mod_aplic","elemento_despesa"],f=function(a){var c,e;return e=a[a.length-1].type,c=d.indexOf(e)+1,b.currentDrilldown=d[c]},e=function(a){return g(a),f(a)},b.$watch(c.getBreadcrumb,e,!0)}])}.call(this);