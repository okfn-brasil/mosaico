(function(){angular.module("fgvApp").filter("percentual",function(){var a;return a=function(a){var b,c;return b=Math.abs(a),c=b>100?0:b>10?1:2,a.toFixed(c).replace(".",",")},function(b){return a(b||0)+"%"}})}).call(this),function(){var a={}.hasOwnProperty;angular.module("fgvApp").directive("percentualChangeBars",["$q","openspending","routing",function(b,c,d){var e,f,g;return f=function(a){return a.reduce(function(a,b){return a[b.type]=b.id,a},{})},e=function(b){var c,d,e,f,g,h;g=100,f=0;for(h in b)a.call(b,h)&&(c=b[h],e=Math.abs(c.delta),e>f&&(f=e));d=function(a){return Math.abs(a*g/f)};for(h in b)a.call(b,h)&&(c=b[h],c.height=d(c.delta));return b},g=function(a,b){var d,g,h;return g=f(b),delete g.year,h=[b[b.length-1].type,"year"],d=void 0,c.aggregate(g,h).then(function(b){var c,f,g,h,i,j,k;for(d=function(){var a,c,d,e;for(d=b.data.drilldown,e=[],a=0,c=d.length;c>a;a++)f=d[a],e.push({label:f.year,value:f.amount});return e}(),d.sort(function(a,b){return parseInt(a.label)-parseInt(b.label)}),h=j=0,k=d.length;k>j;h=++j)c=d[h],0===h?c.delta=0:(i=d[h-1].value,g=100*c.value/i-100,c.delta=g);return a.bars=e(d)})},{restrict:"E",templateUrl:"views/partials/percentual_change_bars.html",link:function(a){var b;return c.aggregate(void 0,["year"]).then(function(b){var c,d,e,f,g;for(d={},g=b.data.drilldown,e=0,f=g.length;f>e;e++)c=g[e],d[c.year]=c.amount;return a.totals=d}),b=function(){var b;return b=d.getBreadcrumb(),b&&a.totals?g(a,b,a.totals):void 0},a.$watch(d.getBreadcrumb,b,!0),a.$watch("totals",b)}}}])}.call(this);