
  var xcd=0;
   function asignarPuntos(linea)
   {
        var end=linea._end.shape;
        var start=linea._start.shape;

        linea._opt.vertices[0]=fd(xcd,(start.attrs.y+(start.attrs.height/2)));
        linea._opt.vertices[1]=fd(xcd,(end.attrs.y+(end.attrs.height/2)));
        linea.update();
        xcd+=8;
   }
   function crunch2(linea)
   {

		var end=linea._end.shape;
        var start=linea._start.shape;
        var inc=(start.attrs.height/10);
        linea._opt.vertices[0]=fd((end.attrs.x+(end.attrs.width/2)),(start.attrs.y+(inc*8)));
		
        linea.drawCrunch(["connection","startCap","endCap","handleStart","handleEnd","label"],start.attrs.x,(start.attrs.y+(inc*8)),2);

   }
   function crunch(linea)
   {
        var end=linea._end.shape;
        var start=linea._start.shape;
		linea._opt.vertices=new Array();
		linea._opt.vertices[0]=fd((start.attrs.x+(start.attrs.width/2)),(end.attrs.y+(end.attrs.height/2)));//fd((start.X+(start.W/2)),(end.Y+(end.H/2)));
		linea.update();
	}
var codProceso='';
var contmenos=0;
var personalSelect='';
var enRegistro=false;
var codLote='';
var codProcesoActual='';
var codSubProcesoActual='';
var contador=0;
var procesoActual=null;
function verificarInterupcion(linea)
  {

  }
function cambiarValor1()
{
            document.getElementById('conforme').checked=true;
            document.getElementById('noconforme').checked=false;
}
function cambiarValor2()
{
            document.getElementById('conforme').checked=false;
            document.getElementById('noconforme').checked=true;
}
function nuevoAjax()
            {	var xmlhttp=false;
                try {
                    xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                } catch (e) {
                    try {
                        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (E) {
                        xmlhttp = false;
                    }
                }
                if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                    xmlhttp = new XMLHttpRequest();
                }

                return xmlhttp;
            }
function ocultarSeguimiento()
{
    document.getElementById('divDetalle').style.visibility='hidden';
    document.getElementById('modalTamizado').style.visibility='hidden';
	enRegistro=false;
}
function transformDate(fecha)
{
    var fechaTexto=fecha.getFullYear()+"/";
    fechaTexto+=(fecha.getMonth()>=9?"":"0")+(fecha.getMonth()+1)+"/";
    fechaTexto+=(fecha.getDate()>9?"":"0")+fecha.getDate()+" ";
    fechaTexto+=(fecha.getHours()>9?"":"0")+fecha.getHours()+":";
    fechaTexto+=(fecha.getMinutes()>9?"":"0")+fecha.getMinutes();
    return fechaTexto;
}

function validarFechaRegistro(input){
    input.style.backgroundColor='#ffffff';
    var registrar = true;
    if (input.value == ""){
        alert("Formato de Fecha Incorrecto");
        input.style.backgroundColor='#F08080';
        input.focus();
        return false;
    }
    if (input.value != ""){
    registrar = registrar && (valAno(input));
    registrar = registrar && (valMes(input));
    registrar = registrar && (valDia(input));
    registrar = registrar && (valSep(input));
    if (!registrar){
        alert("Formato de Fecha Incorrecto");
        input.style.backgroundColor='#F08080';
        input.focus();
        return false;
    }
  }
  return true;
}
function validarHoraRegistro(input)
    {
        var areglo=input.value.split(":");
        input.style.backgroundColor='#ffffff'
        if(areglo.length!=2)
        {
            alert('Formato de hora incorrecto');
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }
        if(isNaN(areglo[0][1])||isNaN(areglo[0][0])||isNaN(areglo[1][0])||isNaN(areglo[1][1])||(areglo[0].length!=2)||(areglo[1].length!=2))
        {
            alert('Hora no permitida');
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }
        if((parseInt(areglo[0])<0)||(parseInt(areglo[0])>23))
        {
            alert('El rango de horas permitido es de 0 a 23');
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }
        if((parseInt(areglo[1])<0)||(parseInt(areglo[1])>59))
        {
            alert('El rango de minutos permitido es de 0 a 59');
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }

        return true;

    }
function validarRegistrosHorasNoNegativas1(inputHoraInicio,inputHoraFinal)
{

    var horaIni=parseInt(inputHoraInicio.value.split(":")[0]);
    var horaFin=parseInt(inputHoraFinal.value.split(":")[0]);
    if(horaFin>horaIni)
    {
        inputHoraInicio.style.backgroundColor='#ffffff';
        inputHoraFinal.style.backgroundColor='#ffffff';
        return true;
    }
    if(horaFin<horaIni)
    {
        inputHoraInicio.style.backgroundColor='#F08080';
        inputHoraFinal.style.backgroundColor='#F08080';
        inputHoraInicio.focus();
        alert('La hora final debe ser mayor a la hora inicial');
        return false;
    }
    else
    {
        if(parseInt(inputHoraFinal.value.split(":")[1])>parseInt(inputHoraInicio.value.split(":")[1]))
        {
            inputHoraInicio.style.backgroundColor='#ffffff';
            inputHoraFinal.style.backgroundColor='#ffffff';
            return true;
        }
        else
        {
            inputHoraInicio.style.backgroundColor='#F08080';
            inputHoraFinal.style.backgroundColor='#F08080';
            inputHoraInicio.focus();
            alert('La hora final debe ser mayor a la hora inicial');
            return false;
        }
    }
    return false
}

function guardarSeguimientoProgramaProduccionComprimidos(adminHoja,codPersonalHoja)
{
    document.getElementById('divImagen').style.visibility='visible';
    document.getElementById('formProgreso').style.visibility='visible';
    var tablaSeguimiento=document.getElementById("registroTiempo");
    var dataSeguimiento=new Array();
    var cont=0;
    var fechaInicioActividad=null;
    var fechaFinalActividad=null;
    var horasHombreActividad=0;
    for(var i=1;i<tablaSeguimiento.rows.length;i++)
    {
                dataSeguimiento[dataSeguimiento.length]=tablaSeguimiento.rows[i].cells[0].getElementsByTagName("select")[0].value;
                dataSeguimiento[dataSeguimiento.length]=tablaSeguimiento.rows[i].cells[1].getElementsByTagName("span")[0].innerHTML;
                dataSeguimiento[dataSeguimiento.length]=tablaSeguimiento.rows[i].cells[2].getElementsByTagName("span")[0].innerHTML;
                dataSeguimiento[dataSeguimiento.length]=tablaSeguimiento.rows[i].cells[3].getElementsByTagName("span")[0].innerHTML;
                dataSeguimiento[dataSeguimiento.length]=parseFloat(tablaSeguimiento.rows[i].cells[4].getElementsByTagName("span")[0].innerHTML);
                dataSeguimiento[dataSeguimiento.length]=(tablaSeguimiento.rows[i].cells[3].getElementsByTagName("button")[0].className='buttonFinishActive'?1:0)
             
    }
    ajax=nuevoAjax();

    var peticion="ajaxGuardarSeguimientoProgramaProduccion.jsp?&noCache="+ Math.random()+
                "&dataSeguimientoPersonal="+dataSeguimiento+
                "&codFormula="+document.getElementById("codFormula").value+
                "&codProgramaProd="+document.getElementById("codProgramaProd").value+
                "&codTipoProduccion="+document.getElementById("codTipoProduccion").value+
                "&codActividadPrograma="+document.getElementById("codActividadPrograma").value+
                "&codCompProd="+document.getElementById("codCompProd").value+
                "&horasMaquina="+document.getElementById("horasMaquinaActividad").value+
                "&admin="+(adminHoja?"1":"0")+
                "&codPersonalRegistro="+codPersonalHoja+
                (adminHoja?"&observacionLote="+encodeURIComponent(document.getElementById("observacion").value):"")+
                "&codLote="+codLote;
    ajax.open("GET",peticion,true);
    ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {

                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert((adminHoja?'Se cerro la hoja':'Se registraron los tiempos del personal'));
                            ocultarSeguimiento();
							document.getElementById('formProgreso').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            if(adminHoja)window.close();
                        }
                        else
                        {
                            alert("&"+ajax.responseText.split("\n").join("")+"&");
                            document.getElementById('formProgreso').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                        }
                    }
                }

                ajax.send(null);
        return true;
}

function guardarSeguimientoProgramaProduccion(adminHoja,codPersonalHoja)
{
    document.getElementById('divImagen').style.visibility='visible';
    document.getElementById('formProgreso').style.visibility='visible';
    var tablaSeguimiento=document.getElementById("registroTiempo");
    var dataSeguimiento=new Array();
    var cont=0;
    var fechaInicioActividad=null;
    var fechaFinalActividad=null;
    var horasHombreActividad=0;
    for(var i=1;i<tablaSeguimiento.rows.length;i++)
    {
            if(validarFechaRegistro(tablaSeguimiento.rows[i].cells[1].getElementsByTagName("input")[0])&&
                validarHoraRegistro(tablaSeguimiento.rows[i].cells[2].getElementsByTagName("input")[0])&&
                validarHoraRegistro(tablaSeguimiento.rows[i].cells[3].getElementsByTagName("input")[0])
            &&validarRegistrosHorasNoNegativas1(tablaSeguimiento.rows[i].cells[2].getElementsByTagName("input")[0],tablaSeguimiento.rows[i].cells[3].getElementsByTagName("input")[0]))
            {
                dataSeguimiento[cont]=tablaSeguimiento.rows[i].cells[0].getElementsByTagName("select")[0].value;
                cont++;
                dataSeguimiento[cont]=tablaSeguimiento.rows[i].cells[1].getElementsByTagName("input")[0].value;
                cont++;
                dataSeguimiento[cont]=tablaSeguimiento.rows[i].cells[2].getElementsByTagName("input")[0].value;
                cont++;
                dataSeguimiento[cont]=tablaSeguimiento.rows[i].cells[3].getElementsByTagName("input")[0].value;
                cont++;
                dataSeguimiento[cont]=parseFloat(tablaSeguimiento.rows[i].cells[4].getElementsByTagName("span")[0].innerHTML);
                horasHombreActividad+=parseFloat(dataSeguimiento[cont]);
                cont++;
                var aux=dataSeguimiento[cont-4].split("/");
                var auxini=dataSeguimiento[cont-3].split(":");
                var auxend=dataSeguimiento[cont-2].split(":");
                var currentDateIni=new Date(parseInt(aux[2]),(parseInt(aux[1])-1), parseInt(aux[0]),parseInt(auxini[0]),parseInt(auxini[1]), 0, 0);
                var currentDateFin=new Date(parseInt(aux[2]),(parseInt(aux[1])-1), parseInt(aux[0]),parseInt(auxend[0]),parseInt(auxend[1]), 0, 0);
                if(fechaInicioActividad==null||currentDateIni<fechaInicioActividad)
                {
                    fechaInicioActividad=currentDateIni;
                }
                if(fechaFinalActividad==null||currentDateFin>fechaFinalActividad)
                {
                    fechaFinalActividad=currentDateFin;
                }
            }
            else
            {
                document.getElementById('divImagen').style.visibility='hidden';
                document.getElementById('formProgreso').style.visibility='hidden';
                return false;
            }
    }
    ajax=nuevoAjax();
    
    var peticion="ajaxGuardarSeguimientoProgramaProduccion.jsp?&noCache="+ Math.random()+
                "&dataSeguimientoPersonal="+dataSeguimiento+
                "&codFormula="+document.getElementById("codFormula").value+
                "&codProgramaProd="+document.getElementById("codProgramaProd").value+
                "&codTipoProduccion="+document.getElementById("codTipoProduccion").value+
                "&codActividadPrograma="+document.getElementById("codActividadPrograma").value+
                "&codCompProd="+document.getElementById("codCompProd").value+
                "&fechaInicioActividad="+transformDate(fechaInicioActividad)+
                "&fechaFinalActividad="+transformDate(fechaFinalActividad)+
                "&horasHombreActivad="+horasHombreActividad+"&codMaquina="+document.getElementById("codMaquinaActividad").value+
                "&horasMaquina="+document.getElementById("horasMaquinaActividad").value+
                "&admin="+(adminHoja?"1":"0")+
                "&codPersonalRegistro="+codPersonalHoja+
                (adminHoja?"&observacionLote="+encodeURIComponent(document.getElementById("observacion").value):"")+
                "&codLote="+codLote;
    ajax.open("GET",peticion,true);
    ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {

                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert((adminHoja?'Se cerro la hoja':'Se registraron los tiempos del personal'));
                            ocultarSeguimiento();
							document.getElementById('formProgreso').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            if(adminHoja)window.close();
                        }
                        else
                        {
                            alert("&"+ajax.responseText.split("\n").join("")+"&");
                            document.getElementById('formProgreso').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                        }
                    }
                }

                ajax.send(null);
        return true;
}
function guardarSeguimiento()
{
    
    document.getElementById('imagenDetalle1').style.visibility='visible';
    document.getElementById('modalTamizado').style.visibility='visible';
    if(document.getElementById('conforme').checked==document.getElementById('noconforme').checked)
        {alert('No puede registrar conforme y no conforme con el mismo valor');}
    ajax=nuevoAjax();
	var resultado='';
    ajax.open("GET","ajaxGuardarSeguimientoLote.jsp?&noCache="+ Math.random()+
                          "&codProceso="+procesoActual.properties.codProcesos+
                          "&codSubProceso="+procesoActual.properties.codSubProceso+
                          "&codLote="+codLote+
                          "&conforme="+(document.getElementById('conforme').checked?"1":"0")+
                          "&personal="+document.getElementById('codResponsable').value+
                          "&observaciones="+document.getElementById('observaciones').value+
                          "&personal2="+document.getElementById('codResponsable2').value
                          
                      ,true);
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            ocultarSeguimiento();
							procesoActual.updatePersonal(procesoActual,document.getElementById('codResponsable').value,
							(document.getElementById('codResponsable').options[document.getElementById('codResponsable').selectedIndex].innerHTML),(document.getElementById('conforme').checked?"1":"0"),
                            document.getElementById('codResponsable2').value,(document.getElementById('codResponsable2').options[document.getElementById('codResponsable2').selectedIndex].innerHTML),
                            document.getElementById("observaciones").value);
                            procesoActual=null;
                            document.getElementById('modalTamizado').style.visibility='hidden';
                            document.getElementById('imagenDetalle1').style.visibility='hidden';
                        }
                        else
                        {
                            alert("&"+ajax.responseText.split("\n").join("")+"&");
                            document.getElementById('formProgreso').style.visibility='hidden';
                            document.getElementById('imagenDetalle1').style.visibility='hidden';
                        }
                    }
                }

                ajax.send(null);

}
function mostrarSeguimiento()
            {

                //alert(codProceso);
                //ajax=nuevoAjax();
				var a=document.getElementById("modalTamizado");
				var b=document.getElementById("diagrama");
                a.style.visibility='visible';
                enRegistro=true;
				document.getElementById('divDetalle').style.visibility='visible';
                document.getElementById('observaciones').value=procesoActual.properties.observaciones;
                document.getElementById('conforme').checked=(procesoActual.properties.conforme=='1'||procesoActual.properties.conforme=='2');
				document.getElementById('noconforme').checked=(procesoActual.properties.conforme!='1'&&procesoActual.properties.conforme!='2');
				var c=document.getElementById('codResponsable');
                var d=document.getElementById('codResponsable2');
                c.innerHTML=personalSelect;
                d.innerHTML=personalSelect;
                d.value=procesoActual.properties.codPersonal2;
                c.value=procesoActual.properties.codPersonal;
                var div_mostrar_seguimiento=document.getElementById("panelSeguimiento");
				div_mostrar_seguimiento.focus();
            }

function  sizeText(cabecera,style)
            {

                var span = document.createElement("span");
                span.innerHTML=cabecera;
                span.className=style;
                document.body.appendChild(span);
                var cantidad=span.offsetWidth;
                document.body.removeChild(span);
                return cantidad;
            }

/**
 * Joint 0.4 - JavaScript diagramming library.
 * Copyright (c) David Durman 2009 - 2011
 * Licensed under the MIT license: (http://www.opensource.org/licenses/mit-license.php)
 */Raphael=function(){
    function D(a,b,d){
        function f(){
            var h=Array[C].slice.call(arguments,0),e=h[Y]("\u25ba"),o=f.cache=f.cache||{},m=f.count=f.count||[];if(o[M](e))return d?d(o[e]):o[e];m[y]>=1E3&&delete o[m.shift()];m[aa](e);o[e]=a[L](b,h);return d?d(o[e]):o[e]
            }return f
        }function t(){
        return this.x+R+this.y
        }function F(a){
        return function(b,d,f,h){
            var e={
                back:a
            };v.is(f,"function")?h=f:e.rot=f;b&&b.constructor==K&&(b=b.attrs.path);b&&(e.along=b);return this.animate(e,d,h)
            }
        }var g=/[, ]+/,i=/^(circle|rect|path|ellipse|text|image)$/, k=document,s=window,x={
        was:"Raphael"in s,
        is:s.Raphael
        },v=function(){
        if(v.is(arguments[0],"array")){
            for(var a=arguments[0],b=Ca[L](v,a.splice(0,3+v.is(a[0],da))),d=b.set(),f=0,h=a[y];f<h;f++){
                var e=a[f]||{};i.test(e.type)&&d[aa](b[e.type]().attr(e))
                }return d
            }return Ca[L](v,arguments)
        },J=function(){},L="apply",R=" ",Z="click dblclick mousedown mousemove mouseout mouseover mouseup".split(R),M="hasOwnProperty",Y="join",y="length",C="prototype",T=String[C].toLowerCase,N=Math,fa=N.max,la=N.min,da="number", ta=Object[C].toString,V=N.pow,aa="push",qa=/^(?=[\da-f]$)/,xa=/^url\(['"]?([^\)]+)['"]?\)$/i,ua=/^\s*((#[a-f\d]{6})|(#[a-f\d]{3})|rgb\(\s*([\d\.]+\s*,\s*[\d\.]+\s*,\s*[\d\.]+)\s*\)|rgb\(\s*([\d\.]+%\s*,\s*[\d\.]+%\s*,\s*[\d\.]+%)\s*\)|hs[bl]\(\s*([\d\.]+\s*,\s*[\d\.]+\s*,\s*[\d\.]+)\s*\)|hs[bl]\(\s*([\d\.]+%\s*,\s*[\d\.]+%\s*,\s*[\d\.]+%)\s*\))\s*$/i,$=N.round,c=parseFloat,j=parseInt,p=String[C].toUpperCase,u={
        "clip-rect":"0 0 1e9 1e9",
        cursor:"default",
        cx:0,
        cy:0,
        fill:"#fff",
        "fill-opacity":1,
        font:'12px "Arial"',
        "font-family":'"Arial"',
        "font-size":"12",
        "font-style":"normal",
        "font-weight":400,
        gradient:0,
        height:0,
        href:"http://raphaeljs.com/",
        opacity:1,
        path:"M0,0",
        r:0,
        rotation:0,
        rx:0,
        ry:0,
        scale:"1 1",
        src:"",
        stroke:"#000",
        "stroke-dasharray":"",
        "stroke-linecap":"butt",
        "stroke-linejoin":"butt",
        "stroke-miterlimit":0,
        "stroke-opacity":1,
        "stroke-width":1,
        target:"_blank",
        "text-anchor":"middle",
        title:"Raphael",
        translation:"0 0",
        width:0,
        x:0,
        y:0
    },w={
        along:"along",
        "clip-rect":"csv",
        cx:da,
        cy:da,
        fill:"colour",
        "fill-opacity":da,
        "font-size":da,
        height:da,
        opacity:da,
        path:"path",
        r:da,
        rotation:"csv",
        rx:da,
        ry:da,
        scale:"csv",
        stroke:"colour",
        "stroke-opacity":da,
        "stroke-width":da,
        translation:"csv",
        width:da,
        x:da,
        y:da
    };v.version="1.3.1";v.type=s.SVGAngle||k.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure","1.1")?"SVG":"VML";if(v.type=="VML"){
        var z=document.createElement("div");z.innerHTML="<\!--[if vml]><br><br><![endif]--\>";if(z.childNodes[y]!=2)return null
            }v.svg=!(v.vml=v.type=="VML");J[C]=v[C];v._id= 0;v._oid=0;v.fn={};v.is=function(a,b){
        b=T.call(b);return(b=="object"||b=="undefined")&&typeof a==b||a==null&&b=="null"||T.call(ta.call(a).slice(8,-1))==b
        };v.setWindow=function(a){
        s=a;k=s.document
        };var P=function(a){
        if(v.vml){
            var b=/^\s+|\s+$/g;P=D(function(f){
                var h;f=(f+"").replace(b,"");try{
                    var e=new ActiveXObject("htmlfile");e.write("<body>");e.close();h=e.body
                    }catch(o){
                    h=createPopup().document.body
                    }e=h.createTextRange();try{
                    h.style.color=f;var m=e.queryCommandValue("ForeColor");return"#"+("000000"+ ((m&255)<<16|m&65280|(m&16711680)>>>16).toString(16)).slice(-6)
                    }catch(n){
                    return"none"
                    }
                })
            }else{
            var d=k.createElement("i");d.title="Rapha\u00ebl Colour Picker";d.style.display="none";k.body.appendChild(d);P=D(function(f){
                d.style.color=f;return k.defaultView.getComputedStyle(d,"").getPropertyValue("color")
                })
            }return P(a)
        };v.hsb2rgb=D(function(a,b,d){
        if(v.is(a,"object")&&"h"in a&&"s"in a&&"b"in a){
            d=a.b;b=a.s;a=a.h
            }var f;if(d==0)return{
            r:0,
            g:0,
            b:0,
            hex:"#000"
        };if(a>1||b>1||d>1){
            a/=255;b/=255;d/=255
            }f=~~(a* 6);a=a*6-f;var h=d*(1-b),e=d*(1-b*a),o=d*(1-b*(1-a));a=[d,e,h,h,o,d,d][f];b=[o,d,d,e,h,h,o][f];f=[h,h,o,d,d,e,h][f];a*=255;b*=255;f*=255;d={
            r:a,
            g:b,
            b:f
        };a=(~~a).toString(16);b=(~~b).toString(16);f=(~~f).toString(16);a=a.replace(qa,"0");b=b.replace(qa,"0");f=f.replace(qa,"0");d.hex="#"+a+b+f;return d
        },v);v.rgb2hsb=D(function(a,b,d){
        if(v.is(a,"object")&&"r"in a&&"g"in a&&"b"in a){
            d=a.b;b=a.g;a=a.r
            }if(v.is(a,"string")){
            var f=v.getRGB(a);a=f.r;b=f.g;d=f.b
            }if(a>1||b>1||d>1){
            a/=255;b/=255;d/=255
            }f=fa(a, b,d);var h=la(a,b,d);if(h==f)return{
            h:0,
            s:0,
            b:f
        };else{
            h=f-h;a=a==f?(b-d)/h:b==f?2+(d-a)/h:4+(a-b)/h;a/=6;a<0&&a++;a>1&&a--
        }return{
            h:a,
            s:h/f,
            b:f
        }
        },v);var ba=/,?([achlmqrstvxz]),?/gi;v._path2string=function(){
        return this.join(",").replace(ba,"$1")
        };v.getRGB=D(function(a){
        if(!a||(a+="").indexOf("-")+1)return{
            r:-1,
            g:-1,
            b:-1,
            hex:"none",
            error:1
        };if(a=="none")return{
            r:-1,
            g:-1,
            b:-1,
            hex:"none"
        };!({
            hs:1,
            rg:1
        }[M](a.substring(0,2))||a.charAt()=="#")&&(a=P(a));var b,d,f,h;if(a=a.match(ua)){
            if(a[2]){
                f=j(a[2].substring(5), 16);d=j(a[2].substring(3,5),16);b=j(a[2].substring(1,3),16)
                }if(a[3]){
                f=j((h=a[3].charAt(3))+h,16);d=j((h=a[3].charAt(2))+h,16);b=j((h=a[3].charAt(1))+h,16)
                }if(a[4]){
                a=a[4].split(/\s*,\s*/);b=c(a[0]);d=c(a[1]);f=c(a[2])
                }if(a[5]){
                a=a[5].split(/\s*,\s*/);b=c(a[0])*2.55;d=c(a[1])*2.55;f=c(a[2])*2.55
                }if(a[6]){
                a=a[6].split(/\s*,\s*/);b=c(a[0]);d=c(a[1]);f=c(a[2]);return v.hsb2rgb(b,d,f)
                }if(a[7]){
                a=a[7].split(/\s*,\s*/);b=c(a[0])*2.55;d=c(a[1])*2.55;f=c(a[2])*2.55;return v.hsb2rgb(b,d,f)
                }a={
                r:b,
                g:d,
                b:f
            }; b=(~~b).toString(16);d=(~~d).toString(16);f=(~~f).toString(16);b=b.replace(qa,"0");d=d.replace(qa,"0");f=f.replace(qa,"0");a.hex="#"+b+d+f;return a
            }return{
            r:-1,
            g:-1,
            b:-1,
            hex:"none",
            error:1
        }
        },v);v.getColor=function(a){
        a=this.getColor.start=this.getColor.start||{
            h:0,
            s:1,
            b:a||0.75
            };var b=this.hsb2rgb(a.h,a.s,a.b);a.h+=0.075;if(a.h>1){
            a.h=0;a.s-=0.2;a.s<=0&&(this.getColor.start={
                h:0,
                s:1,
                b:a.b
                })
            }return b.hex
        };v.getColor.reset=function(){
        delete this.start
        };v.parsePathString=D(function(a){
        if(!a)return null; var b={
            a:7,
            c:6,
            h:1,
            l:2,
            m:2,
            q:4,
            s:4,
            t:2,
            v:1,
            z:0
        },d=[];if(v.is(a,"array")&&v.is(a[0],"array"))d=ea(a);d[y]||(a+"").replace(/([achlmqstvz])[\s,]*((-?\d*\.?\d*(?:e[-+]?\d+)?\s*,?\s*)+)/ig,function(f,h,e){
            var o=[];f=T.call(h);for(e.replace(/(-?\d*\.?\d*(?:e[-+]?\d+)?)\s*,?\s*/ig,function(m,n){
                n&&o[aa](+n)
                });o[y]>=b[f];){
                d[aa]([h].concat(o.splice(0,b[f])));if(!b[f])break
            }
            });d.toString=v._path2string;return d
        });v.findDotsAtSegment=function(a,b,d,f,h,e,o,m,n){
        var q=1-n,A=V(q,3)*a+V(q,2)*3*n*d+q*3*n*n*h+V(n, 3)*o;q=V(q,3)*b+V(q,2)*3*n*f+q*3*n*n*e+V(n,3)*m;var B=a+2*n*(d-a)+n*n*(h-2*d+a),I=b+2*n*(f-b)+n*n*(e-2*f+b),S=d+2*n*(h-d)+n*n*(o-2*h+d),G=f+2*n*(e-f)+n*n*(m-2*e+f);a=(1-n)*a+n*d;b=(1-n)*b+n*f;h=(1-n)*h+n*o;e=(1-n)*e+n*m;m=90-N.atan((B-S)/(I-G))*180/N.PI;(B>S||I<G)&&(m+=180);return{
            x:A,
            y:q,
            m:{
                x:B,
                y:I
            },
            n:{
                x:S,
                y:G
            },
            start:{
                x:a,
                y:b
            },
            end:{
                x:h,
                y:e
            },
            alpha:m
        }
        };var W=D(function(a){
        if(!a)return{
            x:0,
            y:0,
            width:0,
            height:0
        };a=ka(a);for(var b=0,d=0,f=[],h=[],e,o=0,m=a[y];o<m;o++){
            e=a[o];if(e[0]=="M"){
                b=e[1];d=e[2]; f[aa](b);h[aa](d)
                }else{
                b=oa(b,d,e[1],e[2],e[3],e[4],e[5],e[6]);f=f.concat(b.min.x,b.max.x);h=h.concat(b.min.y,b.max.y);b=e[5];d=e[6]
                }
            }a=la[L](0,f);e=la[L](0,h);return{
            x:a,
            y:e,
            width:fa[L](0,f)-a,
            height:fa[L](0,h)-e
            }
        }),ea=function(a){
        var b=[];if(!v.is(a,"array")||!v.is(a&&a[0],"array"))a=v.parsePathString(a);for(var d=0,f=a[y];d<f;d++){
            b[d]=[];for(var h=0,e=a[d][y];h<e;h++)b[d][h]=a[d][h]
                }b.toString=v._path2string;return b
        },ra=D(function(a){
        if(!v.is(a,"array")||!v.is(a&&a[0],"array"))a=v.parsePathString(a); var b=[],d=0,f=0,h=0,e=0,o=0;if(a[0][0]=="M"){
            d=a[0][1];f=a[0][2];h=d;e=f;o++;b[aa](["M",d,f])
            }for(var m=a[y];o<m;o++){
            var n=b[o]=[],q=a[o];if(q[0]!=T.call(q[0])){
                n[0]=T.call(q[0]);switch(n[0]){
                    case "a":n[1]=q[1];n[2]=q[2];n[3]=q[3];n[4]=q[4];n[5]=q[5];n[6]=+(q[6]-d).toFixed(3);n[7]=+(q[7]-f).toFixed(3);break;case "v":n[1]=+(q[1]-f).toFixed(3);break;case "m":h=q[1];e=q[2];default:for(var A=1,B=q[y];A<B;A++)n[A]=+(q[A]-(A%2?d:f)).toFixed(3)
                        }
                }else{
                b[o]=[];if(q[0]=="m"){
                    h=q[1]+d;e=q[2]+f
                    }n=0;for(A=q[y];n< A;n++)b[o][n]=q[n]
                    }q=b[o][y];switch(b[o][0]){
                case "z":d=h;f=e;break;case "h":d+=+b[o][q-1];break;case "v":f+=+b[o][q-1];break;default:d+=+b[o][q-2];f+=+b[o][q-1]
                    }
            }b.toString=v._path2string;return b
        },0,ea),ca=D(function(a){
        if(!v.is(a,"array")||!v.is(a&&a[0],"array"))a=v.parsePathString(a);var b=[],d=0,f=0,h=0,e=0,o=0;if(a[0][0]=="M"){
            d=+a[0][1];f=+a[0][2];h=d;e=f;o++;b[0]=["M",d,f]
            }for(var m=a[y];o<m;o++){
            var n=b[o]=[],q=a[o];if(q[0]!=p.call(q[0])){
                n[0]=p.call(q[0]);switch(n[0]){
                    case "A":n[1]=q[1]; n[2]=q[2];n[3]=q[3];n[4]=q[4];n[5]=q[5];n[6]=+(q[6]+d);n[7]=+(q[7]+f);break;case "V":n[1]=+q[1]+f;break;case "H":n[1]=+q[1]+d;break;case "M":h=+q[1]+d;e=+q[2]+f;default:for(var A=1,B=q[y];A<B;A++)n[A]=+q[A]+(A%2?d:f)
                        }
                }else{
                A=0;for(B=q[y];A<B;A++)b[o][A]=q[A]
                    }switch(n[0]){
                case "Z":d=h;f=e;break;case "H":d=n[1];break;case "V":f=n[1];break;default:d=b[o][b[o][y]-2];f=b[o][b[o][y]-1]
                    }
            }b.toString=v._path2string;return b
        },null,ea),ia=function(a,b,d,f,h,e){
        var o=1/3,m=2/3;return[o*a+m*d,o*b+m*f,o*h+m*d, o*e+m*f,h,e]
        },ha=function(a,b,d,f,h,e,o,m,n,q){
        var A=N.PI,B=A*120/180,I=A/180*(+h||0),S=[],G,E=D(function(X,Ia,za){
            var Za=X*N.cos(za)-Ia*N.sin(za);X=X*N.sin(za)+Ia*N.cos(za);return{
                x:Za,
                y:X
            }
            });if(q){
            O=q[0];G=q[1];e=q[2];U=q[3]
            }else{
            G=E(a,b,-I);a=G.x;b=G.y;G=E(m,n,-I);m=G.x;n=G.y;N.cos(A/180*h);N.sin(A/180*h);G=(a-m)/2;O=(b-n)/2;d=fa(d,N.abs(G));f=fa(f,N.abs(O));U=G*G/(d*d)+O*O/(f*f);if(U>1){
                d*=N.sqrt(U);f*=N.sqrt(U)
                }U=d*d;var H=f*f;U=(e==o?-1:1)*N.sqrt(N.abs((U*H-U*O*O-H*G*G)/(U*O*O+H*G*G)));e=U* d*O/f+(a+m)/2;var U=U*-f*G/d+(b+n)/2,O=N.asin(((b-U)/f).toFixed(7));G=N.asin(((n-U)/f).toFixed(7));O=a<e?A-O:O;G=m<e?A-G:G;O<0&&(O=A*2+O);G<0&&(G=A*2+G);if(o&&O>G)O-=A*2;if(!o&&G>O)G-=A*2
                }if(N.abs(G-O)>B){
            S=G;A=m;H=n;G=O+B*(o&&G>O?1:-1);m=e+d*N.cos(G);n=U+f*N.sin(G);S=ha(m,n,d,f,h,0,o,A,H,[G,S,e,U])
            }e=G-O;h=N.cos(O);B=N.sin(O);o=N.cos(G);A=N.sin(G);G=N.tan(e/4);d=4/3*d*G;G*=4/3*f;f=[a,b];a=[a+d*B,b-G*h];b=[m+d*A,n-G*o];m=[m,n];a[0]=2*f[0]-a[0];a[1]=2*f[1]-a[1];if(q)return[a,b,m].concat(S);else{
            S= [a,b,m].concat(S)[Y]().split(",");q=[];m=0;for(n=S[y];m<n;m++)q[m]=m%2?E(S[m-1],S[m],I).y:E(S[m],S[m+1],I).x;return q
            }
        },ma=function(a,b,d,f,h,e,o,m,n){
        var q=1-n;return{
            x:V(q,3)*a+V(q,2)*3*n*d+q*3*n*n*h+V(n,3)*o,
            y:V(q,3)*b+V(q,2)*3*n*f+q*3*n*n*e+V(n,3)*m
            }
        },oa=D(function(a,b,d,f,h,e,o,m){
        var n=h-2*d+a-(o-2*h+d),q=2*(d-a)-2*(h-d),A=a-d,B=(-q+N.sqrt(q*q-4*n*A))/2/n;n=(-q-N.sqrt(q*q-4*n*A))/2/n;var I=[b,m],S=[a,o];N.abs(B)>1E12&&(B=0.5);N.abs(n)>1E12&&(n=0.5);if(B>0&&B<1){
            B=ma(a,b,d,f,h,e,o,m,B);S[aa](B.x); I[aa](B.y)
            }if(n>0&&n<1){
            B=ma(a,b,d,f,h,e,o,m,n);S[aa](B.x);I[aa](B.y)
            }n=e-2*f+b-(m-2*e+f);q=2*(f-b)-2*(e-f);A=b-f;B=(-q+N.sqrt(q*q-4*n*A))/2/n;n=(-q-N.sqrt(q*q-4*n*A))/2/n;N.abs(B)>1E12&&(B=0.5);N.abs(n)>1E12&&(n=0.5);if(B>0&&B<1){
            B=ma(a,b,d,f,h,e,o,m,B);S[aa](B.x);I[aa](B.y)
            }if(n>0&&n<1){
            B=ma(a,b,d,f,h,e,o,m,n);S[aa](B.x);I[aa](B.y)
            }return{
            min:{
                x:la[L](0,S),
                y:la[L](0,I)
                },
            max:{
                x:fa[L](0,S),
                y:fa[L](0,I)
                }
            }
        }),ka=D(function(a,b){
        var d=ca(a),f=b&&ca(b),h={
            x:0,
            y:0,
            bx:0,
            by:0,
            X:0,
            Y:0,
            qx:null,
            qy:null
        },e={
            x:0,
            y:0,
            bx:0,
            by:0,
            X:0,
            Y:0,
            qx:null,
            qy:null
        },o=function(E,H){
            var U,O;if(!E)return["C",H.x,H.y,H.x,H.y,H.x,H.y];!(E[0]in{
                T:1,
                Q:1
            })&&(H.qx=H.qy=null);switch(E[0]){
                case "M":H.X=E[1];H.Y=E[2];break;case "A":E=["C"].concat(ha[L](0,[H.x,H.y].concat(E.slice(1))));break;case "S":U=H.x+(H.x-(H.bx||H.x));O=H.y+(H.y-(H.by||H.y));E=["C",U,O].concat(E.slice(1));break;case "T":H.qx=H.x+(H.x-(H.qx||H.x));H.qy=H.y+(H.y-(H.qy||H.y));E=["C"].concat(ia(H.x,H.y,H.qx,H.qy,E[1],E[2]));break;case "Q":H.qx=E[1];H.qy=E[2];E=["C"].concat(ia(H.x, H.y,E[1],E[2],E[3],E[4]));break;case "L":E=["C"].concat([H.x,H.y,E[1],E[2],E[1],E[2]]);break;case "H":E=["C"].concat([H.x,H.y,E[1],H.y,E[1],H.y]);break;case "V":E=["C"].concat([H.x,H.y,H.x,E[1],H.x,E[1]]);break;case "Z":E=["C"].concat([H.x,H.y,H.X,H.Y,H.X,H.Y])
                    }return E
            },m=function(E,H){
            if(E[H][y]>7){
                E[H].shift();for(var U=E[H];U[y];)E.splice(H++,0,["C"].concat(U.splice(0,6)));E.splice(H,1);A=fa(d[y],f&&f[y]||0)
                }
            },n=function(E,H,U,O,X){
            if(E&&H&&E[X][0]=="M"&&H[X][0]!="M"){
                H.splice(X,0,["M",O.x,O.y]); U.bx=0;U.by=0;U.x=E[X][1];U.y=E[X][2];A=fa(d[y],f&&f[y]||0)
                }
            },q=0,A=fa(d[y],f&&f[y]||0);for(;q<A;q++){
            d[q]=o(d[q],h);m(d,q);f&&(f[q]=o(f[q],e));f&&m(f,q);n(d,f,h,e,q);n(f,d,e,h,q);var B=d[q],I=f&&f[q],S=B[y],G=f&&I[y];h.x=B[S-2];h.y=B[S-1];h.bx=c(B[S-4])||h.x;h.by=c(B[S-3])||h.y;e.bx=f&&(c(I[G-4])||e.x);e.by=f&&(c(I[G-3])||e.y);e.x=f&&I[G-2];e.y=f&&I[G-1]
            }return f?[d,f]:d
        },null,ea),va=D(function(a){
        for(var b=[],d=0,f=a[y];d<f;d++){
            var h={},e=a[d].match(/^([^:]*):?([\d\.]*)/);h.color=v.getRGB(e[1]); if(h.color.error)return null;h.color=h.color.hex;e[2]&&(h.offset=e[2]+"%");b[aa](h)
            }d=1;for(f=b[y]-1;d<f;d++)if(!b[d].offset){
            a=c(b[d-1].offset||0);e=0;for(h=d+1;h<f;h++)if(b[h].offset){
                e=b[h].offset;break
            }if(!e){
                e=100;h=f
                }e=c(e);for(e=(e-a)/(h-d+1);d<h;d++){
                a+=e;b[d].offset=a+"%"
                }
            }return b
        }),sa=function(){
        var a;if(v.is(arguments[0],"string")||v.is(arguments[0],"object")){
            a=v.is(arguments[0],"string")?k.getElementById(arguments[0]):arguments[0];if(a.tagName)return arguments[1]==null?{
                container:a,
                width:a.style.pixelWidth||a.offsetWidth,
                height:a.style.pixelHeight||a.offsetHeight
                }:{
                container:a,
                width:arguments[1],
                height:arguments[2]
                }
            }else if(v.is(arguments[0],da)&&arguments[y]>3)return{
            container:1,
            x:arguments[0],
            y:arguments[1],
            width:arguments[2],
            height:arguments[3]
            }
        },Da=function(a,b){
        var d=this,f;for(f in b)if(b[M](f)&&!(f in a))switch(typeof b[f]){
            case "function":(function(h){
                a[f]=a===d?h:function(){
                    return h[L](d,arguments)
                    }
                })(b[f]);break;case "object":a[f]=a[f]||{};Da.call(this,a[f],b[f]); break;default:a[f]=b[f]
                }
        },wa=function(a,b){
        a==b.top&&(b.top=a.prev);a==b.bottom&&(b.bottom=a.next);a.next&&(a.next.prev=a.prev);a.prev&&(a.prev.next=a.next)
        },Ja=function(a,b){
        if(b.top!==a){
            wa(a,b);a.next=null;a.prev=b.top;b.top.next=a;b.top=a
            }
        },Ka=function(a,b){
        if(b.bottom!==a){
            wa(a,b);a.next=b.bottom;a.prev=null;b.bottom.prev=a;b.bottom=a
            }
        },La=function(a,b,d){
        wa(a,d);b==d.top&&(d.top=a);b.next&&(b.next.prev=a);a.next=b.next;a.prev=b;b.next=a
        },Ma=function(a,b,d){
        wa(a,d);b==d.bottom&&(d.bottom=a); b.prev&&(b.prev.next=a);a.prev=b.prev;b.prev=a;a.next=b
        },Na=function(a){
        return function(){
            throw Error("Rapha\u00ebl: you are calling to method \u201c"+a+"\u201d of removed object");
        }
        },Oa=/^r(?:\(([^,]+?)\s*,\s*([^\)]+?)\))?/;if(v.svg){
        J[C].svgns="http://www.w3.org/2000/svg";J[C].xlink="http://www.w3.org/1999/xlink";$=function(a){
            return+a+(~~a===a)*0.5
            };var $a=function(a){
            for(var b=0,d=a[y];b<d;b++)if(T.call(a[b][0])!="a")for(var f=1,h=a[b][y];f<h;f++)a[b][f]=$(a[b][f]);else{
                a[b][6]=$(a[b][6]);a[b][7]= $(a[b][7])
                }return a
            },Q=function(a,b){
            if(b)for(var d in b)b[M](d)&&a.setAttribute(d,b[d]);else return k.createElementNS(J[C].svgns,a)
                };v.toString=function(){
            return"Your browser supports SVG.\nYou are running Rapha\u00ebl "+this.version
            };var Pa=function(a,b){
            var d=Q("path");b.canvas&&b.canvas.appendChild(d);d=new K(d,b);d.type="path";na(d,{
                fill:"none",
                stroke:"#000",
                path:a
            });return d
            },ya=function(a,b,d){
            var f="linear",h=0.5,e=0.5,o=a.style;b=(b+"").replace(Oa,function(A,B,I){
                f="radial";if(B&&I){
                    h=c(B); e=c(I);A=(e>0.5)*2-1;V(h-0.5,2)+V(e-0.5,2)>0.25&&(e=N.sqrt(0.25-V(h-0.5,2))*A+0.5)&&e!=0.5&&(e=e.toFixed(5)-1.0E-5*A)
                    }return""
                });b=b.split(/\s*\-\s*/);if(f=="linear"){
                var m=b.shift();m=-c(m);if(isNaN(m))return null;var n=[0,0,N.cos(m*N.PI/180),N.sin(m*N.PI/180)];m=1/(fa(N.abs(n[2]),N.abs(n[3]))||1);n[2]*=m;n[3]*=m;if(n[2]<0){
                    n[0]=-n[2];n[2]=0
                    }if(n[3]<0){
                    n[1]=-n[3];n[3]=0
                    }
                }b=va(b);if(!b)return null;m=Q(f+"Gradient");m.id="r"+(v._id++).toString(36);Q(m,f=="radial"?{
                fx:h,
                fy:e
            }:{
                x1:n[0],
                y1:n[1],
                x2:n[2],
                y2:n[3]
                });d.defs.appendChild(m);d=0;for(n=b[y];d<n;d++){
                var q=Q("stop");Q(q,{
                    offset:b[d].offset?b[d].offset:!d?"0%":"100%",
                    "stop-color":b[d].color||"#fff"
                    });m.appendChild(q)
                }Q(a,{
                fill:"url(#"+m.id+")",
                opacity:1,
                "fill-opacity":1
            });o.fill="";o.opacity=1;return o.fillOpacity=1
            },Ea=function(a){
            var b=a.getBBox();Q(a.pattern,{
                patternTransform:v.format("translate({0},{1})",b.x,b.y)
                })
            },na=function(a,b){
            var d={
                "":[0],
                none:[0],
                "-":[3,1],
                ".":[1,1],
                "-.":[3,1,1,1],
                "-..":[3,1,1,1,1,1],
                ". ":[1,3],
                "- ":[4,3],
                "--":[8, 3],
                "- .":[4,3,1,3],
                "--.":[8,3,1,3],
                "--..":[8,3,1,3,1,3]
                },f=a.node,h=a.attrs,e=a.rotate(),o=function(G,E){
                if(E=d[T.call(E)]){
                    for(var H=G.attrs["stroke-width"]||"1",U={
                        round:H,
                        square:H,
                        butt:0
                    }[G.attrs["stroke-linecap"]||b["stroke-linecap"]]||0,O=[],X=E[y];X--;)O[X]=E[X]*H+(X%2?1:-1)*U;Q(f,{
                        "stroke-dasharray":O[Y](",")
                        })
                    }
                };b[M]("rotation")&&(e=b.rotation);var m=(e+"").split(g);if(m.length-1){
                m[1]=+m[1];m[2]=+m[2]
                }else m=null;c(e)&&a.rotate(0,true);for(var n in b)if(b[M](n))if(u[M](n)){
                var q=b[n];h[n]= q;switch(n){
                    case "rotation":a.rotate(q,true);break;case "href":case "title":case "target":var A=f.parentNode;if(T.call(A.tagName)!="a"){
                        var B=Q("a");A.insertBefore(B,f);B.appendChild(f);A=B
                        }A.setAttributeNS(a.paper.xlink,n,q);break;case "cursor":f.style.cursor=q;break;case "clip-rect":A=(q+"").split(g);if(A[y]==4){
                        a.clip&&a.clip.parentNode.parentNode.removeChild(a.clip.parentNode);var I=Q("clipPath");B=Q("rect");I.id="r"+(v._id++).toString(36);Q(B,{
                            x:A[0],
                            y:A[1],
                            width:A[2],
                            height:A[3]
                            });I.appendChild(B); a.paper.defs.appendChild(I);Q(f,{
                            "clip-path":"url(#"+I.id+")"
                            });a.clip=B
                        }if(!q){
                        (q=k.getElementById(f.getAttribute("clip-path").replace(/(^url\(#|\)$)/g,"")))&&q.parentNode.removeChild(q);Q(f,{
                            "clip-path":""
                        });delete a.clip
                        }break;case "path":if(q&&a.type=="path"){
                        h.path=$a(ca(q));Q(f,{
                            d:h.path
                            })
                        }break;case "width":f.setAttribute(n,q);if(h.fx){
                        n="x";q=h.x
                        }else break;case "x":if(h.fx)q=-h.x-(h.width||0);case "rx":if(n=="rx"&&a.type=="rect")break;case "cx":m&&(n=="x"||n=="cx")&&(m[1]+=q-h[n]);f.setAttribute(n, $(q));a.pattern&&Ea(a);break;case "height":f.setAttribute(n,q);if(h.fy){
                        n="y";q=h.y
                        }else break;case "y":if(h.fy)q=-h.y-(h.height||0);case "ry":if(n=="ry"&&a.type=="rect")break;case "cy":m&&(n=="y"||n=="cy")&&(m[2]+=q-h[n]);f.setAttribute(n,$(q));a.pattern&&Ea(a);break;case "r":a.type=="rect"?Q(f,{
                        rx:q,
                        ry:q
                    }):f.setAttribute(n,q);break;case "src":a.type=="image"&&f.setAttributeNS(a.paper.xlink,"href",q);break;case "stroke-width":f.style.strokeWidth=q;f.setAttribute(n,q);h["stroke-dasharray"]&&o(a,h["stroke-dasharray"]); break;case "stroke-dasharray":o(a,q);break;case "translation":q=(q+"").split(g);q[0]=+q[0]||0;q[1]=+q[1]||0;if(m){
                        m[1]+=q[0];m[2]+=q[1]
                        }Aa.call(a,q[0],q[1]);break;case "scale":q=(q+"").split(g);a.scale(+q[0]||1,+q[1]||+q[0]||1,+q[2]||null,+q[3]||null);break;case "fill":if(A=(q+"").match(xa)){
                        I=Q("pattern");var S=Q("image");I.id="r"+(v._id++).toString(36);Q(I,{
                            x:0,
                            y:0,
                            patternUnits:"userSpaceOnUse",
                            height:1,
                            width:1
                        });Q(S,{
                            x:0,
                            y:0
                        });S.setAttributeNS(a.paper.xlink,"href",A[1]);I.appendChild(S);q=k.createElement("img"); q.style.cssText="position:absolute;left:-9999em;top-9999em";q.onload=function(){
                            Q(I,{
                                width:this.offsetWidth,
                                height:this.offsetHeight
                                });Q(S,{
                                width:this.offsetWidth,
                                height:this.offsetHeight
                                });k.body.removeChild(this);a.paper.safari()
                            };k.body.appendChild(q);q.src=A[1];a.paper.defs.appendChild(I);f.style.fill="url(#"+I.id+")";Q(f,{
                            fill:"url(#"+I.id+")"
                            });a.pattern=I;a.pattern&&Ea(a);break
                    }if(v.getRGB(q).error){
                        if(({
                            circle:1,
                            ellipse:1
                        }[M](a.type)||(q+"").charAt()!="r")&&ya(f,q,a.paper)){
                            h.gradient=q;h.fill= "none";break
                        }
                        }else{
                        delete b.gradient;delete h.gradient;!v.is(h.opacity,"undefined")&&v.is(b.opacity,"undefined")&&Q(f,{
                            opacity:h.opacity
                            });!v.is(h["fill-opacity"],"undefined")&&v.is(b["fill-opacity"],"undefined")&&Q(f,{
                            "fill-opacity":h["fill-opacity"]
                            })
                        }case "stroke":f.setAttribute(n,v.getRGB(q).hex);break;case "gradient":(({
                        circle:1,
                        ellipse:1
                    })[M](a.type)||(q+"").charAt()!="r")&&ya(f,q,a.paper);break;case "opacity":case "fill-opacity":if(h.gradient){
                        if(A=k.getElementById(f.getAttribute("fill").replace(/^url\(#|\)$/g, ""))){
                            A=A.getElementsByTagName("stop");A[A[y]-1].setAttribute("stop-opacity",q)
                            }break
                    }default:n=="font-size"&&(q=j(q,10)+"px");A=n.replace(/(\-.)/g,function(G){
                        return p.call(G.substring(1))
                        });f.style[A]=q;f.setAttribute(n,q)
                        }
                }ab(a,b);if(m)a.rotate(m.join(R));else c(e)&&a.rotate(e,true)
                },ab=function(a,b){
            if(!(a.type!="text"||!(b[M]("text")||b[M]("font")||b[M]("font-size")||b[M]("x")||b[M]("y")))){
                var d=a.attrs,f=a.node,h=f.firstChild?j(k.defaultView.getComputedStyle(f.firstChild,"").getPropertyValue("font-size"), 10):10;if(b[M]("text")){
                    for(d.text=b.text;f.firstChild;)f.removeChild(f.firstChild);for(var e=(b.text+"").split("\n"),o=0,m=e[y];o<m;o++)if(e[o]){
                        var n=Q("tspan");o&&Q(n,{
                            dy:h*1.2,
                            x:d.x
                            });n.appendChild(k.createTextNode(e[o]));f.appendChild(n)
                        }
                    }else{
                    e=f.getElementsByTagName("tspan");o=0;for(m=e[y];o<m;o++)o&&Q(e[o],{
                        dy:h*1.2,
                        x:d.x
                        })
                    }Q(f,{
                    y:d.y
                    });h=a.getBBox();(h=d.y-(h.y+h.height/2))&&isFinite(h)&&Q(f,{
                    y:d.y+h
                    })
                }
            },K=function(a,b){
            this[0]=a;this.id=v._oid++;this.node=a;a.raphael=this;this.paper=b;this.attrs= this.attrs||{};this.transformations=[];this._={
                tx:0,
                ty:0,
                rt:{
                    deg:0,
                    cx:0,
                    cy:0
                },
                sx:1,
                sy:1
            };!b.bottom&&(b.bottom=this);(this.prev=b.top)&&(b.top.next=this);b.top=this;this.next=null
            };K[C].rotate=function(a,b,d){
            if(this.removed)return this;if(a==null){
                if(this._.rt.cx)return[this._.rt.deg,this._.rt.cx,this._.rt.cy][Y](R);return this._.rt.deg
                }var f=this.getBBox();a=(a+"").split(g);if(a[y]-1){
                b=c(a[1]);d=c(a[2])
                }a=c(a[0]);if(b!=null)this._.rt.deg=a;else this._.rt.deg+=a;d==null&&(b=null);this._.rt.cx=b; this._.rt.cy=d;b=b==null?f.x+f.width/2:b;d=d==null?f.y+f.height/2:d;if(this._.rt.deg){
                this.transformations[0]=v.format("rotate({0} {1} {2})",this._.rt.deg,b,d);this.clip&&Q(this.clip,{
                    transform:v.format("rotate({0} {1} {2})",-this._.rt.deg,b,d)
                    })
                }else{
                this.transformations[0]="";this.clip&&Q(this.clip,{
                    transform:""
                })
                }Q(this.node,{
                transform:this.transformations[Y](R)
                });return this
            };K[C].hide=function(){
            !this.removed&&(this.node.style.display="none");return this
            };K[C].show=function(){
            !this.removed&& (this.node.style.display="");return this
            };K[C].remove=function(){
            if(!this.removed){
                wa(this,this.paper);this.node.parentNode.removeChild(this.node);for(var a in this)delete this[a];this.removed=true
                }
            };K[C].getBBox=function(){
            if(this.removed)return this;if(this.type=="path")return W(this.attrs.path);if(this.node.style.display=="none"){
                this.show();var a=true
                }var b={};try{
                b=this.node.getBBox()
                }catch(d){}finally{
                b=b||{}
                }if(this.type=="text"){
                b={
                    x:b.x,
                    y:Infinity,
                    width:0,
                    height:0
                };for(var f=0,h=this.node.getNumberOfChars();f< h;f++){
                    var e=this.node.getExtentOfChar(f);e.y<b.y&&(b.y=e.y);e.y+e.height-b.y>b.height&&(b.height=e.y+e.height-b.y);e.x+e.width-b.x>b.width&&(b.width=e.x+e.width-b.x)
                    }
                }a&&this.hide();return b
            };K[C].attr=function(){
            if(this.removed)return this;if(arguments[y]==0){
                var a={},b;for(b in this.attrs)if(this.attrs[M](b))a[b]=this.attrs[b];this._.rt.deg&&(a.rotation=this.rotate());(this._.sx!=1||this._.sy!=1)&&(a.scale=this.scale());a.gradient&&a.fill=="none"&&(a.fill=a.gradient)&&delete a.gradient;return a
                }if(arguments[y]== 1&&v.is(arguments[0],"string")){
                if(arguments[0]=="translation")return Aa.call(this);if(arguments[0]=="rotation")return this.rotate();if(arguments[0]=="scale")return this.scale();if(arguments[0]=="fill"&&this.attrs.fill=="none"&&this.attrs.gradient)return this.attrs.gradient;return this.attrs[arguments[0]]
                }if(arguments[y]==1&&v.is(arguments[0],"array")){
                b={};for(a in arguments[0])if(arguments[0][M](a))b[arguments[0][a]]=this.attrs[arguments[0][a]];return b
                }if(arguments[y]==2){
                b={};b[arguments[0]]= arguments[1];na(this,b)
                }else arguments[y]==1&&v.is(arguments[0],"object")&&na(this,arguments[0]);return this
            };K[C].toFront=function(){
            if(this.removed)return this;this.node.parentNode.appendChild(this.node);var a=this.paper;a.top!=this&&Ja(this,a);return this
            };K[C].toBack=function(){
            if(this.removed)return this;if(this.node.parentNode.firstChild!=this.node){
                this.node.parentNode.insertBefore(this.node,this.node.parentNode.firstChild);Ka(this,this.paper)
                }return this
            };K[C].insertAfter=function(a){
            if(this.removed)return this; var b=a.node;b.nextSibling?b.parentNode.insertBefore(this.node,b.nextSibling):b.parentNode.appendChild(this.node);La(this,a,this.paper);return this
            };K[C].insertBefore=function(a){
            if(this.removed)return this;var b=a.node;b.parentNode.insertBefore(this.node,b);Ma(this,a,this.paper);return this
            };var Qa=function(a,b,d,f){
            b=$(b);d=$(d);var h=Q("circle");a.canvas&&a.canvas.appendChild(h);a=new K(h,a);a.attrs={
                cx:b,
                cy:d,
                r:f,
                fill:"none",
                stroke:"#000"
            };a.type="circle";Q(h,a.attrs);return a
            },Ra=function(a, b,d,f,h,e){
            b=$(b);d=$(d);var o=Q("rect");a.canvas&&a.canvas.appendChild(o);a=new K(o,a);a.attrs={
                x:b,
                y:d,
                width:f,
                height:h,
                r:e||0,
                rx:e||0,
                ry:e||0,
                fill:"none",
                stroke:"#000"
            };a.type="rect";Q(o,a.attrs);return a
            },Sa=function(a,b,d,f,h){
            b=$(b);d=$(d);var e=Q("ellipse");a.canvas&&a.canvas.appendChild(e);a=new K(e,a);a.attrs={
                cx:b,
                cy:d,
                rx:f,
                ry:h,
                fill:"none",
                stroke:"#000"
            };a.type="ellipse";Q(e,a.attrs);return a
            },Ta=function(a,b,d,f,h,e){
            var o=Q("image");Q(o,{
                x:d,
                y:f,
                width:h,
                height:e,
                preserveAspectRatio:"none"
            }); o.setAttributeNS(a.xlink,"href",b);a.canvas&&a.canvas.appendChild(o);a=new K(o,a);a.attrs={
                x:d,
                y:f,
                width:h,
                height:e,
                src:b
            };a.type="image";return a
            },Ua=function(a,b,d,f){
            var h=Q("text");Q(h,{
                x:b,
                y:d,
                "text-anchor":"middle"
            });a.canvas&&a.canvas.appendChild(h);a=new K(h,a);a.attrs={
                x:b,
                y:d,
                "text-anchor":"middle",
                text:f,
                font:u.font,
                stroke:"none",
                fill:"#000"
            };a.type="text";na(a,a.attrs);return a
            },Va=function(a,b){
            this.width=a||this.width;this.height=b||this.height;this.canvas.setAttribute("width",this.width); this.canvas.setAttribute("height",this.height);return this
            },Ca=function(){
            var a=sa[L](null,arguments),b=a&&a.container,d=a.x,f=a.y,h=a.width;a=a.height;if(!b)throw Error("SVG container not found.");var e=Q("svg");h=h||512;a=a||342;Q(e,{
                xmlns:"http://www.w3.org/2000/svg",
                version:1.1,
                width:h,
                height:a
            });if(b==1){
                e.style.cssText="position:absolute;left:"+d+"px;top:"+f+"px";k.body.appendChild(e)
                }else b.firstChild?b.insertBefore(e,b.firstChild):b.appendChild(e);b=new J;b.width=h;b.height=a;b.canvas=e;Da.call(b, b,v.fn);b.clear();return b
            };J[C].clear=function(){
            for(var a=this.canvas;a.firstChild;)a.removeChild(a.firstChild);this.bottom=this.top=null;(this.desc=Q("desc")).appendChild(k.createTextNode("Created with Rapha\u00ebl"));a.appendChild(this.desc);a.appendChild(this.defs=Q("defs"))
            };J[C].remove=function(){
            this.canvas.parentNode&&this.canvas.parentNode.removeChild(this.canvas);for(var a in this)this[a]=Na(a)
                }
        }if(v.vml){
        var bb=function(a){
            var b=/[ahqstv]/ig,d=ca;(a+"").match(b)&&(d=ka);b=/[clmz]/g;if(d== ca&&!(a+"").match(b)){
                var f={
                    M:"m",
                    L:"l",
                    C:"c",
                    Z:"x",
                    m:"t",
                    l:"r",
                    c:"v",
                    z:"x"
                },h=/-?[^,\s-]+/g;return a=(a+"").replace(/([clmz]),?([^clmz]*)/gi,function(A,B,I){
                    var S=[];I.replace(h,function(G){
                        S[aa]($(G))
                        });return f[B]+S
                    })
                }b=d(a);a=[];for(var e,o=0,m=b[y];o<m;o++){
                d=b[o];e=T.call(b[o][0]);e=="z"&&(e="x");for(var n=1,q=d[y];n<q;n++)e+=$(d[n])+(n!=q-1?",":"");a[aa](e)
                }return a[Y](R)
            };v.toString=function(){
            return"Your browser doesn\u2019t support SVG. Falling down to VML.\nYou are running Rapha\u00ebl "+ this.version
            };Pa=function(a,b){
            var d=ga("group");d.style.cssText="position:absolute;left:0;top:0;width:"+b.width+"px;height:"+b.height+"px";d.coordsize=b.coordsize;d.coordorigin=b.coordorigin;var f=ga("shape"),h=f.style;h.width=b.width+"px";h.height=b.height+"px";f.coordsize=this.coordsize;f.coordorigin=this.coordorigin;d.appendChild(f);f=new K(f,d,b);f.isAbsolute=true;f.type="path";f.path=[];f.Path="";a&&na(f,{
                fill:"none",
                stroke:"#000",
                path:a
            });b.canvas.appendChild(d);return f
            };na=function(a,b){
            a.attrs= a.attrs||{};var d=a.node,f=a.attrs,h=d.style,e;for(e in b)if(b[M](e))f[e]=b[e];b.href&&(d.href=b.href);b.title&&(d.title=b.title);b.target&&(d.target=b.target);b.cursor&&(h.cursor=b.cursor);if(b.path&&a.type=="path"){
                f.path=b.path;d.path=bb(f.path)
                }b.rotation!=null&&a.rotate(b.rotation,true);if(b.translation){
                e=(b.translation+"").split(g);Aa.call(a,e[0],e[1]);if(a._.rt.cx!=null){
                    a._.rt.cx+=+e[0];a._.rt.cy+=+e[1];a.setBox(a.attrs,e[0],e[1])
                    }
                }if(b.scale){
                e=(b.scale+"").split(g);a.scale(+e[0]||1,+e[1]|| +e[0]||1,+e[2]||null,+e[3]||null)
                }if("clip-rect"in b){
                e=(b["clip-rect"]+"").split(g);if(e[y]==4){
                    e[2]=+e[2]+ +e[0];e[3]=+e[3]+ +e[1];var o=d.clipRect||k.createElement("div"),m=o.style,n=d.parentNode;m.clip=v.format("rect({1}px {2}px {3}px {0}px)",e);if(!d.clipRect){
                        m.position="absolute";m.top=0;m.left=0;m.width=a.paper.width+"px";m.height=a.paper.height+"px";n.parentNode.insertBefore(o,n);o.appendChild(n);d.clipRect=o
                        }
                    }if(!b["clip-rect"])d.clipRect&&(d.clipRect.style.clip="")
                    }if(a.type=="image"&& b.src)d.src=b.src;if(a.type=="image"&&b.opacity){
                d.filterOpacity=" progid:DXImageTransform.Microsoft.Alpha(opacity="+b.opacity*100+")";h.filter=(d.filterMatrix||"")+(d.filterOpacity||"")
                }b.font&&(h.font=b.font);b["font-family"]&&(h.fontFamily='"'+b["font-family"].split(",")[0].replace(/^['"]+|['"]+$/g,"")+'"');b["font-size"]&&(h.fontSize=b["font-size"]);b["font-weight"]&&(h.fontWeight=b["font-weight"]);b["font-style"]&&(h.fontStyle=b["font-style"]);if(b.opacity!=null||b["stroke-width"]!=null||b.fill!= null||b.stroke!=null||b["stroke-width"]!=null||b["stroke-opacity"]!=null||b["fill-opacity"]!=null||b["stroke-dasharray"]!=null||b["stroke-miterlimit"]!=null||b["stroke-linejoin"]!=null||b["stroke-linecap"]!=null){
                d=a.shape||d;e=d.getElementsByTagName("fill")&&d.getElementsByTagName("fill")[0];o=false;!e&&(o=e=ga("fill"));if("fill-opacity"in b||"opacity"in b){
                    h=((+f["fill-opacity"]+1||2)-1)*((+f.opacity+1||2)-1);h<0&&(h=0);h>1&&(h=1);e.opacity=h
                    }b.fill&&(e.on=true);if(e.on==null||b.fill=="none")e.on= false;if(e.on&&b.fill)if(h=b.fill.match(xa)){
                    e.src=h[1];e.type="tile"
                    }else{
                    e.color=v.getRGB(b.fill).hex;e.src="";e.type="solid";if(v.getRGB(b.fill).error&&(a.type in{
                        circle:1,
                        ellipse:1
                    }||(b.fill+"").charAt()!="r")&&ya(a,b.fill)){
                        f.fill="none";f.gradient=b.fill
                        }
                    }o&&d.appendChild(e);e=d.getElementsByTagName("stroke")&&d.getElementsByTagName("stroke")[0];o=false;!e&&(o=e=ga("stroke"));if(b.stroke&&b.stroke!="none"||b["stroke-width"]||b["stroke-opacity"]!=null||b["stroke-dasharray"]||b["stroke-miterlimit"]|| b["stroke-linejoin"]||b["stroke-linecap"])e.on=true;(b.stroke=="none"||e.on==null||b.stroke==0||b["stroke-width"]==0)&&(e.on=false);e.on&&b.stroke&&(e.color=v.getRGB(b.stroke).hex);h=((+f["stroke-opacity"]+1||2)-1)*((+f.opacity+1||2)-1);m=(c(b["stroke-width"])||1)*0.75;h<0&&(h=0);h>1&&(h=1);b["stroke-width"]==null&&(m=f["stroke-width"]);b["stroke-width"]&&(e.weight=m);m&&m<1&&(h*=m)&&(e.weight=1);e.opacity=h;b["stroke-linejoin"]&&(e.joinstyle=b["stroke-linejoin"]||"miter");e.miterlimit=b["stroke-miterlimit"]|| 8;b["stroke-linecap"]&&(e.endcap=b["stroke-linecap"]=="butt"?"flat":b["stroke-linecap"]=="square"?"square":"round");if(b["stroke-dasharray"]){
                    h={
                        "-":"shortdash",
                        ".":"shortdot",
                        "-.":"shortdashdot",
                        "-..":"shortdashdotdot",
                        ". ":"dot",
                        "- ":"dash",
                        "--":"longdash",
                        "- .":"dashdot",
                        "--.":"longdashdot",
                        "--..":"longdashdotdot"
                    };e.dashstyle=h[M](b["stroke-dasharray"])?h[b["stroke-dasharray"]]:""
                    }o&&d.appendChild(e)
                }if(a.type=="text"){
                h=a.paper.span.style;f.font&&(h.font=f.font);f["font-family"]&&(h.fontFamily= f["font-family"]);f["font-size"]&&(h.fontSize=f["font-size"]);f["font-weight"]&&(h.fontWeight=f["font-weight"]);f["font-style"]&&(h.fontStyle=f["font-style"]);a.node.string&&(a.paper.span.innerHTML=(a.node.string+"").replace(/</g,"&#60;").replace(/&/g,"&#38;").replace(/\n/g,"<br>"));a.W=f.w=a.paper.span.offsetWidth;a.H=f.h=a.paper.span.offsetHeight;a.X=f.x;a.Y=f.y+$(a.H/2);switch(f["text-anchor"]){
                    case "start":a.node.style["v-text-align"]="left";a.bbx=$(a.W/2);break;case "end":a.node.style["v-text-align"]= "right";a.bbx=-$(a.W/2);break;default:a.node.style["v-text-align"]="center"
                        }
                }
            };ya=function(a,b){
            a.attrs=a.attrs||{};var d=a.node.getElementsByTagName("fill"),f="linear",h=".5 .5";a.attrs.gradient=b;b=(b+"").replace(Oa,function(A,B,I){
                f="radial";if(B&&I){
                    B=c(B);I=c(I);V(B-0.5,2)+V(I-0.5,2)>0.25&&(I=N.sqrt(0.25-V(B-0.5,2))*((I>0.5)*2-1)+0.5);h=B+R+I
                    }return""
                });b=b.split(/\s*\-\s*/);if(f=="linear"){
                var e=b.shift();e=-c(e);if(isNaN(e))return null
                    }var o=va(b);if(!o)return null;a=a.shape||a.node;d=d[0]|| ga("fill");if(o[y]){
                d.on=true;d.method="none";d.type=f=="radial"?"gradientradial":"gradient";d.color=o[0].color;d.color2=o[o[y]-1].color;for(var m=[],n=0,q=o[y];n<q;n++)o[n].offset&&m[aa](o[n].offset+R+o[n].color);d.colors&&(d.colors.value=m[y]?m[Y](","):"0% "+d.color);if(f=="radial"){
                    d.focus="100%";d.focussize=h;d.focusposition=h
                    }else d.angle=(270-e)%360
                    }return 1
            };K=function(a,b,d){
            this[0]=a;this.id=v._oid++;this.node=a;a.raphael=this;this.Y=this.X=0;this.attrs={};this.Group=b;this.paper=d;this._= {
                tx:0,
                ty:0,
                rt:{
                    deg:0
                },
                sx:1,
                sy:1
            };!d.bottom&&(d.bottom=this);(this.prev=d.top)&&(d.top.next=this);d.top=this;this.next=null
            };K[C].rotate=function(a,b,d){
            if(this.removed)return this;if(a==null){
                if(this._.rt.cx)return[this._.rt.deg,this._.rt.cx,this._.rt.cy][Y](R);return this._.rt.deg
                }a=(a+"").split(g);if(a[y]-1){
                b=c(a[1]);d=c(a[2])
                }a=c(a[0]);if(b!=null)this._.rt.deg=a;else this._.rt.deg+=a;d==null&&(b=null);this._.rt.cx=b;this._.rt.cy=d;this.setBox(this.attrs,b,d);this.Group.style.rotation=this._.rt.deg; return this
            };K[C].setBox=function(a,b,d){
            if(this.removed)return this;var f=this.Group.style,h=this.shape&&this.shape.style||this.node.style;a=a||{};for(var e in a)if(a[M](e))this.attrs[e]=a[e];b=b||this._.rt.cx;d=d||this._.rt.cy;var o=this.attrs,m,n,q;switch(this.type){
                case "circle":e=o.cx-o.r;m=o.cy-o.r;n=q=o.r*2;break;case "ellipse":e=o.cx-o.rx;m=o.cy-o.ry;n=o.rx*2;q=o.ry*2;break;case "rect":case "image":e=+o.x;m=+o.y;n=o.width||0;q=o.height||0;break;case "text":this.textpath.v=["m",$(o.x),", ", $(o.y-2),"l",$(o.x)+1,", ",$(o.y-2)][Y]("");e=o.x-$(this.W/2);m=o.y-this.H/2;n=this.W;q=this.H;break;case "path":if(this.attrs.path){
                    q=W(this.attrs.path);e=q.x;m=q.y;n=q.width;q=q.height
                    }else{
                    m=e=0;n=this.paper.width;q=this.paper.height
                    }break;default:m=e=0;n=this.paper.width;q=this.paper.height
                    }b=(b==null?e+n/2:b)-this.paper.width/2;d=(d==null?m+q/2:d)-this.paper.height/2;if(this.type=="path"||this.type=="text"){
                f.left!=b+"px"&&(f.left=b+"px");f.top!=d+"px"&&(f.top=d+"px");this.X=this.type=="text"? e:-b;this.Y=this.type=="text"?m:-d;this.W=n;this.H=q;h.left!=-b+"px"&&(h.left=-b+"px");h.top!=-d+"px"&&(h.top=-d+"px")
                }else{
                f.left!=b+"px"&&(f.left=b+"px");f.top!=d+"px"&&(f.top=d+"px");this.X=e;this.Y=m;this.W=n;this.H=q;f.width!=this.paper.width+"px"&&(f.width=this.paper.width+"px");f.height!=this.paper.height+"px"&&(f.height=this.paper.height+"px");h.left!=e-b+"px"&&(h.left=e-b+"px");h.top!=m-d+"px"&&(h.top=m-d+"px");h.width!=n+"px"&&(h.width=n+"px");h.height!=q+"px"&&(h.height=q+"px");a=(+a.r|| 0)/la(n,q);if(this.type=="rect"&&this.arcsize.toFixed(4)!=a.toFixed(4)&&(a||this.arcsize)){
                    f=ga("roundrect");h={};e=0;d=this.events&&this.events[y];f.arcsize=a;f.raphael=this;this.Group.appendChild(f);this.Group.removeChild(this.node);this[0]=this.node=f;this.arcsize=a;for(e in o)h[e]=o[e];delete h.scale;this.attr(h);if(this.events)for(;e<d;e++)this.events[e].unbind=Wa(this.node,this.events[e].name,this.events[e].f,this)
                        }
                }
            };K[C].hide=function(){
            !this.removed&&(this.Group.style.display="none");return this
            }; K[C].show=function(){
            !this.removed&&(this.Group.style.display="block");return this
            };K[C].getBBox=function(){
            if(this.removed)return this;if(this.type=="path")return W(this.attrs.path);return{
                x:this.X+(this.bbx||0),
                y:this.Y,
                width:this.W,
                height:this.H
                }
            };K[C].remove=function(){
            if(!this.removed){
                wa(this,this.paper);this.node.parentNode.removeChild(this.node);this.Group.parentNode.removeChild(this.Group);this.shape&&this.shape.parentNode.removeChild(this.shape);for(var a in this)delete this[a];this.removed= true
                }
            };K[C].attr=function(){
            if(this.removed)return this;if(arguments[y]==0){
                var a={},b;for(b in this.attrs)if(this.attrs[M](b))a[b]=this.attrs[b];this._.rt.deg&&(a.rotation=this.rotate());(this._.sx!=1||this._.sy!=1)&&(a.scale=this.scale());a.gradient&&a.fill=="none"&&(a.fill=a.gradient)&&delete a.gradient;return a
                }if(arguments[y]==1&&v.is(arguments[0],"string")){
                if(arguments[0]=="translation")return Aa.call(this);if(arguments[0]=="rotation")return this.rotate();if(arguments[0]=="scale")return this.scale(); if(arguments[0]=="fill"&&this.attrs.fill=="none"&&this.attrs.gradient)return this.attrs.gradient;return this.attrs[arguments[0]]
                }if(this.attrs&&arguments[y]==1&&v.is(arguments[0],"array")){
                a={};b=0;for(var d=arguments[0][y];b<d;b++)a[arguments[0][b]]=this.attrs[arguments[0][b]];return a
                }if(arguments[y]==2){
                a={};a[arguments[0]]=arguments[1]
                }arguments[y]==1&&v.is(arguments[0],"object")&&(a=arguments[0]);if(a){
                if(a.text&&this.type=="text")this.node.string=a.text;na(this,a);if(a.gradient&&({
                    circle:1,
                    ellipse:1
                }[M](this.type)||(a.gradient+"").charAt()!="r"))ya(this,a.gradient);(this.type!="path"||this._.rt.deg)&&this.setBox(this.attrs)
                }return this
            };K[C].toFront=function(){
            !this.removed&&this.Group.parentNode.appendChild(this.Group);this.paper.top!=this&&Ja(this,this.paper);return this
            };K[C].toBack=function(){
            if(this.removed)return this;if(this.Group.parentNode.firstChild!=this.Group){
                this.Group.parentNode.insertBefore(this.Group,this.Group.parentNode.firstChild);Ka(this,this.paper)
                }return this
            }; K[C].insertAfter=function(a){
            if(this.removed)return this;a.Group.nextSibling?a.Group.parentNode.insertBefore(this.Group,a.Group.nextSibling):a.Group.parentNode.appendChild(this.Group);La(this,a,this.paper);return this
            };K[C].insertBefore=function(a){
            if(this.removed)return this;a.Group.parentNode.insertBefore(this.Group,a.Group);Ma(this,a,this.paper);return this
            };Qa=function(a,b,d,f){
            var h=ga("group"),e=ga("oval");h.style.cssText="position:absolute;left:0;top:0;width:"+a.width+"px;height:"+a.height+ "px";h.coordsize=a.coordsize;h.coordorigin=a.coordorigin;h.appendChild(e);e=new K(e,h,a);e.type="circle";na(e,{
                stroke:"#000",
                fill:"none"
            });e.attrs.cx=b;e.attrs.cy=d;e.attrs.r=f;e.setBox({
                x:b-f,
                y:d-f,
                width:f*2,
                height:f*2
                });a.canvas.appendChild(h);return e
            };Ra=function(a,b,d,f,h,e){
            var o=ga("group"),m=ga("roundrect"),n=(+e||0)/la(f,h);o.style.cssText="position:absolute;left:0;top:0;width:"+a.width+"px;height:"+a.height+"px";o.coordsize=a.coordsize;o.coordorigin=a.coordorigin;o.appendChild(m);m.arcsize= n;m=new K(m,o,a);m.type="rect";na(m,{
                stroke:"#000"
            });m.arcsize=n;m.setBox({
                x:b,
                y:d,
                width:f,
                height:h,
                r:e
            });a.canvas.appendChild(o);return m
            };Sa=function(a,b,d,f,h){
            var e=ga("group"),o=ga("oval");e.style.cssText="position:absolute;left:0;top:0;width:"+a.width+"px;height:"+a.height+"px";e.coordsize=a.coordsize;e.coordorigin=a.coordorigin;e.appendChild(o);o=new K(o,e,a);o.type="ellipse";na(o,{
                stroke:"#000"
            });o.attrs.cx=b;o.attrs.cy=d;o.attrs.rx=f;o.attrs.ry=h;o.setBox({
                x:b-f,
                y:d-h,
                width:f*2,
                height:h* 2
                });a.canvas.appendChild(e);return o
            };Ta=function(a,b,d,f,h,e){
            var o=ga("group"),m=ga("image");o.style.cssText="position:absolute;left:0;top:0;width:"+a.width+"px;height:"+a.height+"px";o.coordsize=a.coordsize;o.coordorigin=a.coordorigin;m.src=b;o.appendChild(m);m=new K(m,o,a);m.type="image";m.attrs.src=b;m.attrs.x=d;m.attrs.y=f;m.attrs.w=h;m.attrs.h=e;m.setBox({
                x:d,
                y:f,
                width:h,
                height:e
            });a.canvas.appendChild(o);return m
            };Ua=function(a,b,d,f){
            var h=ga("group"),e=ga("shape"),o=e.style,m=ga("path"), n=ga("textpath");h.style.cssText="position:absolute;left:0;top:0;width:"+a.width+"px;height:"+a.height+"px";h.coordsize=a.coordsize;h.coordorigin=a.coordorigin;m.v=v.format("m{0},{1}l{2},{1}",$(b),$(d),$(b)+1);m.textpathok=true;o.width=a.width;o.height=a.height;n.string=f+"";n.on=true;e.appendChild(n);e.appendChild(m);h.appendChild(e);o=new K(n,h,a);o.shape=e;o.textpath=m;o.type="text";o.attrs.text=f;o.attrs.x=b;o.attrs.y=d;o.attrs.w=1;o.attrs.h=1;na(o,{
                font:u.font,
                stroke:"none",
                fill:"#000"
            });o.setBox(); a.canvas.appendChild(h);return o
            };Va=function(a,b){
            var d=this.canvas.style;a==+a&&(a+="px");b==+b&&(b+="px");d.width=a;d.height=b;d.clip="rect(0 "+a+" "+b+" 0)";return this
            };var ga;k.createStyleSheet().addRule(".rvml","behavior:url(#default#VML)");try{
            !k.namespaces.rvml&&k.namespaces.add("rvml","urn:schemas-microsoft-com:vml");ga=function(a){
                return k.createElement("<rvml:"+a+' class="rvml">')
                }
            }catch(db){
            ga=function(a){
                return k.createElement("<"+a+' xmlns="urn:schemas-microsoft.com:vml" class="rvml">')
                }
            }Ca= function(){
            var a=sa[L](null,arguments),b=a.container,d=a.height,f=a.width,h=a.x;a=a.y;if(!b)throw Error("VML container not found.");var e=new J,o=e.canvas=k.createElement("div"),m=o.style;f=f||512;d=d||342;f==+f&&(f+="px");d==+d&&(d+="px");e.width=1E3;e.height=1E3;e.coordsize="1000 1000";e.coordorigin="0 0";e.span=k.createElement("span");e.span.style.cssText="position:absolute;left:-9999em;top:-9999em;padding:0;margin:0;line-height:1;display:inline;";o.appendChild(e.span);m.cssText=v.format("width:{0};height:{1};position:absolute;clip:rect(0 {0} {1} 0);overflow:hidden", f,d);if(b==1){
                k.body.appendChild(o);m.left=h+"px";m.top=a+"px"
                }else{
                b.style.width=f;b.style.height=d;b.firstChild?b.insertBefore(o,b.firstChild):b.appendChild(o)
                }Da.call(e,e,v.fn);return e
            };J[C].clear=function(){
            this.canvas.innerHTML="";this.span=k.createElement("span");this.span.style.cssText="position:absolute;left:-9999em;top:-9999em;padding:0;margin:0;line-height:1;display:inline;";this.canvas.appendChild(this.span);this.bottom=this.top=null
            };J[C].remove=function(){
            this.canvas.parentNode.removeChild(this.canvas); for(var a in this)this[a]=Na(a)
                }
        }J[C].safari=/^Apple|^Google/.test(navigator.vendor)&&!(navigator.userAgent.indexOf("Version/4.0")+1)?function(){
        var a=this.rect(-99,-99,this.width+99,this.height+99);setTimeout(function(){
            a.remove()
            })
        }:function(){};var Wa=function(){
        if(k.addEventListener)return function(a,b,d,f){
            var h=function(e){
                return d.call(f,e)
                };a.addEventListener(b,h,false);return function(){
                a.removeEventListener(b,h,false);return true
                }
            };else if(k.attachEvent)return function(a,b,d,f){
            var h=function(e){
                return d.call(f, e||s.event)
                };a.attachEvent("on"+b,h);return function(){
                a.detachEvent("on"+b,h);return true
                }
            }
        }();for(z=Z[y];z--;)(function(a){
        K[C][a]=function(b){
            if(v.is(b,"function")){
                this.events=this.events||[];this.events.push({
                    name:a,
                    f:b,
                    unbind:Wa(this.shape||this.node,a,b,this)
                    })
                }return this
            };K[C]["un"+a]=function(b){
            for(var d=this.events,f=d[y];f--;)if(d[f].name==a&&d[f].f==b){
                d[f].unbind();d.splice(f,1);!d.length&&delete this.events;break
            }return this
            }
        })(Z[z]);K[C].hover=function(a,b){
        return this.mouseover(a).mouseout(b)
        }; K[C].unhover=function(a,b){
        return this.unmouseover(a).unmouseout(b)
        };J[C].circle=function(a,b,d){
        return Qa(this,a||0,b||0,d||0)
        };J[C].rect=function(a,b,d,f,h){
        return Ra(this,a||0,b||0,d||0,f||0,h||0)
        };J[C].ellipse=function(a,b,d,f){
        return Sa(this,a||0,b||0,d||0,f||0)
        };J[C].path=function(a){
        a&&!v.is(a,"string")&&!v.is(a[0],"array")&&(a+="");return Pa(v.format[L](v,arguments),this)
        };J[C].image=function(a,b,d,f,h){
        return Ta(this,a||"about:blank",b||0,d||0,f||0,h||0)
        };J[C].text=function(a,b,d){
        return Ua(this, a||0,b||0,d||"")
        };J[C].set=function(a){
        arguments[y]>1&&(a=Array[C].splice.call(arguments,0,arguments[y]));return new pa(a)
        };J[C].setSize=Va;J[C].top=J[C].bottom=null;J[C].raphael=v;K[C].scale=function(a,b,d,f){
        if(a==null&&b==null)return{
            x:this._.sx,
            y:this._.sy,
            toString:t
        };b=b||a;!+b&&(b=a);var h,e,o=this.attrs;if(a!=0){
            var m=this.getBBox(),n=m.x+m.width/2,q=m.y+m.height/2;h=a/this._.sx;e=b/this._.sy;d=+d||d==0?d:n;f=+f||f==0?f:q;m=~~(a/N.abs(a));var A=~~(b/N.abs(b)),B=this.node.style,I=d+(n-d)*h; q=f+(q-f)*e;switch(this.type){
                case "rect":case "image":var S=o.width*m*h,G=o.height*A*e;this.attr({
                    height:G,
                    r:o.r*la(m*h,A*e),
                    width:S,
                    x:I-S/2,
                    y:q-G/2
                    });break;case "circle":case "ellipse":this.attr({
                    rx:o.rx*m*h,
                    ry:o.ry*A*e,
                    r:o.r*la(m*h,A*e),
                    cx:I,
                    cy:q
                });break;case "path":n=ra(o.path);for(var E=true,H=0,U=n[y];H<U;H++){
                    var O=n[H],X;X=p.call(O[0]);if(!(X=="M"&&E)){
                        E=false;if(X=="A"){
                            O[n[H][y]-2]*=h;O[n[H][y]-1]*=e;O[1]*=m*h;O[2]*=A*e;O[5]=+(m+A?!!+O[5]:!+O[5])
                            }else if(X=="H"){
                            X=1;for(jj=O[y];X<jj;X++)O[X]*= h
                                }else if(X=="V"){
                            X=1;for(jj=O[y];X<jj;X++)O[X]*=e
                                }else{
                            X=1;for(jj=O[y];X<jj;X++)O[X]*=X%2?h:e
                                }
                        }
                    }e=W(n);h=I-e.x-e.width/2;e=q-e.y-e.height/2;n[0][1]+=h;n[0][2]+=e;this.attr({
                    path:n
                })
                }if(this.type in{
                text:1,
                image:1
            }&&(m!=1||A!=1))if(this.transformations){
                this.transformations[2]="scale(".concat(m,",",A,")");this.node.setAttribute("transform",this.transformations[Y](R));h=m==-1?-o.x-(S||0):o.x;e=A==-1?-o.y-(G||0):o.y;this.attr({
                    x:h,
                    y:e
                });o.fx=m-1;o.fy=A-1
                }else{
                this.node.filterMatrix=" progid:DXImageTransform.Microsoft.Matrix(M11=".concat(m, ", M12=0, M21=0, M22=",A,", Dx=0, Dy=0, sizingmethod='auto expand', filtertype='bilinear')");B.filter=(this.node.filterMatrix||"")+(this.node.filterOpacity||"")
                }else if(this.transformations){
                this.transformations[2]="";this.node.setAttribute("transform",this.transformations[Y](R));o.fx=0;o.fy=0
                }else{
                this.node.filterMatrix="";B.filter=(this.node.filterMatrix||"")+(this.node.filterOpacity||"")
                }o.scale=[a,b,d,f][Y](R);this._.sx=a;this._.sy=b
            }return this
        };K[C].clone=function(){
        var a=this.attr();delete a.scale; delete a.translation;return this.paper[this.type]().attr(a)
        };Z=function(a,b){
        return function(d,f,h){
            d=ka(d);for(var e,o,m,n,q="",A={},B=0,I=0,S=d.length;I<S;I++){
                m=d[I];if(m[0]=="M"){
                    e=+m[1];o=+m[2]
                    }else{
                    n=cb(e,o,m[1],m[2],m[3],m[4],m[5],m[6]);if(B+n>f){
                        if(b&&!A.start){
                            e=v.findDotsAtSegment(e,o,m[1],m[2],m[3],m[4],m[5],m[6],(f-B)/n);q+=["C",e.start.x,e.start.y,e.m.x,e.m.y,e.x,e.y];if(h)return q;A.start=q;q=["M",e.x,e.y+"C",e.n.x,e.n.y,e.end.x,e.end.y,m[5],m[6]][Y]();B+=n;e=+m[5];o=+m[6];continue
                        }if(!a&& !b){
                            e=v.findDotsAtSegment(e,o,m[1],m[2],m[3],m[4],m[5],m[6],(f-B)/n);return{
                                x:e.x,
                                y:e.y,
                                alpha:e.alpha
                                }
                            }
                        }B+=n;e=+m[5];o=+m[6]
                    }q+=m
                }A.end=q;e=a?B:b?A:v.findDotsAtSegment(e,o,m[1],m[2],m[3],m[4],m[5],m[6],1);e.alpha&&(e={
                x:e.x,
                y:e.y,
                alpha:e.alpha
                });return e
            }
        };var cb=D(function(a,b,d,f,h,e,o,m){
        for(var n={
            x:0,
            y:0
        },q=0,A=0;A<1.01;A+=0.01){
            var B=ma(a,b,d,f,h,e,o,m,A);A&&(q+=N.sqrt(V(n.x-B.x,2)+V(n.y-B.y,2)));n=B
            }return q
        }),Xa=Z(1),Ba=Z(),Fa=Z(0,1);K[C].getTotalLength=function(){
        if(this.type=="path")return Xa(this.attrs.path)
            }; K[C].getPointAtLength=function(a){
        if(this.type=="path")return Ba(this.attrs.path,a)
            };K[C].getSubpath=function(a,b){
        if(this.type=="path"){
            if(N.abs(this.getTotalLength()-b)<1.0E-6)return Fa(this.attrs.path,a).end;var d=Fa(this.attrs.path,b,1);return a?Fa(d,a).end:d
            }
        };v.easing_formulas={
        linear:function(a){
            return a
            },
        "<":function(a){
            return V(a,3)
            },
        ">":function(a){
            return V(a-1,3)+1
            },
        "<>":function(a){
            a*=2;if(a<1)return V(a,3)/2;a-=2;return(V(a,3)+2)/2
            },
        backIn:function(a){
            return a*a*(2.70158*a-1.70158)
            },
        backOut:function(a){
            a-=1;return a*a*(2.70158*a+1.70158)+1
            },
        elastic:function(a){
            if(a==0||a==1)return a;return V(2,-10*a)*N.sin((a-0.075)*2*N.PI/0.3)+1
            },
        bounce:function(a){
            if(a<1/2.75)a*=7.5625*a;else if(a<2/2.75){
                a-=1.5/2.75;a=7.5625*a*a+0.75
                }else if(a<2.5/2.75){
                a-=2.25/2.75;a=7.5625*a*a+0.9375
                }else{
                a-=2.625/2.75;a=7.5625*a*a+0.984375
                }return a
            }
        };var ja={
        length:0
    },Ya=function(){
        var a=+new Date,b;for(b in ja)if(b!="length"&&ja[M](b)){
            var d=ja[b];if(d.stop){
                delete ja[b];ja[y]--
            }else{
                var f=a-d.start,h= d.ms,e=d.easing,o=d.from,m=d.diff,n=d.to,q=d.t,A=d.prev||0,B=d.el,I=d.callback,S={},G;if(f<h){
                    I=v.easing_formulas[e]?v.easing_formulas[e](f/h):f/h;for(var E in o)if(o[M](E)){
                        switch(w[E]){
                            case "along":G=I*h*m[E];n.back&&(G=n.len-G);e=Ba(n[E],G);B.translate(m.sx-m.x||0,m.sy-m.y||0);m.x=e.x;m.y=e.y;B.translate(e.x-m.sx,e.y-m.sy);n.rot&&B.rotate(m.r+e.alpha,e.x,e.y);break;case "number":G=+o[E]+I*h*m[E];break;case "colour":G="rgb("+[Ga($(o[E].r+I*h*m[E].r)),Ga($(o[E].g+I*h*m[E].g)),Ga($(o[E].b+I*h*m[E].b))][Y](",")+ ")";break;case "path":G=[];e=0;for(var H=o[E][y];e<H;e++){
                                G[e]=[o[E][e][0]];for(var U=1,O=o[E][e][y];U<O;U++)G[e][U]=+o[E][e][U]+I*h*m[E][e][U];G[e]=G[e][Y](R)
                                }G=G[Y](R);break;case "csv":switch(E){
                                case "translation":G=m[E][0]*(f-A);e=m[E][1]*(f-A);q.x+=G;q.y+=e;G=G+R+e;break;case "rotation":G=+o[E][0]+I*h*m[E][0];o[E][1]&&(G+=","+o[E][1]+","+o[E][2]);break;case "scale":G=[+o[E][0]+I*h*m[E][0],+o[E][1]+I*h*m[E][1],2 in n[E]?n[E][2]:"",3 in n[E]?n[E][3]:""][Y](R);break;case "clip-rect":G=[];for(e=4;e--;)G[e]= +o[E][e]+I*h*m[E][e]
                                    }
                            }S[E]=G
                        }B.attr(S);B._run&&B._run.call(B)
                    }else{
                    if(n.along){
                        e=Ba(n.along,n.len*!n.back);B.translate(m.sx-(m.x||0)+e.x-m.sx,m.sy-(m.y||0)+e.y-m.sy);n.rot&&B.rotate(m.r+e.alpha,e.x,e.y)
                        }(q.x||q.y)&&B.translate(-q.x,-q.y);n.scale&&(n.scale+="");B.attr(n);delete ja[b];ja[y]--;B.in_animation=null;v.is(I,"function")&&I.call(B)
                    }d.prev=f
                }
            }v.svg&&B&&B.paper.safari();ja[y]&&setTimeout(Ya)
        },Ga=function(a){
        return a>255?255:a<0?0:a
        },Aa=function(a,b){
        if(a==null)return{
            x:this._.tx,
            y:this._.ty,
            toString:t
        };this._.tx+=+a;this._.ty+=+b;switch(this.type){
            case "circle":case "ellipse":this.attr({
                cx:+a+this.attrs.cx,
                cy:+b+this.attrs.cy
                });break;case "rect":case "image":case "text":this.attr({
                x:+a+this.attrs.x,
                y:+b+this.attrs.y
                });break;case "path":var d=ra(this.attrs.path);d[0][1]+=+a;d[0][2]+=+b;this.attr({
                path:d
            })
            }return this
        };K[C].animateWith=function(a,b,d,f,h){
        ja[a.id]&&(b.start=ja[a.id].start);return this.animate(b,d,f,h)
        };K[C].animateAlong=F();K[C].animateAlongBack=F(1);K[C].onAnimation= function(a){
        this._run=a||0;return this
        };K[C].animate=function(a,b,d,f){
        if(v.is(d,"function")||!d)f=d||null;var h={},e={},o={},m;for(m in a)if(a[M](m))if(w[M](m)){
            h[m]=this.attr(m);h[m]==null&&(h[m]=u[m]);e[m]=a[m];switch(w[m]){
                case "along":var n=Xa(a[m]),q=Ba(a[m],n*!!a.back),A=this.getBBox();o[m]=n/b;o.tx=A.x;o.ty=A.y;o.sx=q.x;o.sy=q.y;e.rot=a.rot;e.back=a.back;e.len=n;a.rot&&(o.r=c(this.rotate())||0);break;case "number":o[m]=(e[m]-h[m])/b;break;case "colour":h[m]=v.getRGB(h[m]);n=v.getRGB(e[m]); o[m]={
                    r:(n.r-h[m].r)/b,
                    g:(n.g-h[m].g)/b,
                    b:(n.b-h[m].b)/b
                    };break;case "path":n=ka(h[m],e[m]);h[m]=n[0];q=n[1];o[m]=[];n=0;for(A=h[m][y];n<A;n++){
                    o[m][n]=[0];for(var B=1,I=h[m][n][y];B<I;B++)o[m][n][B]=(q[n][B]-h[m][n][B])/b
                        }break;case "csv":q=(a[m]+"").split(g);n=(h[m]+"").split(g);switch(m){
                    case "translation":h[m]=[0,0];o[m]=[q[0]/b,q[1]/b];break;case "rotation":h[m]=n[1]==q[1]&&n[2]==q[2]?n:[0,q[1],q[2]];o[m]=[(q[0]-h[m][0])/b,0,0];break;case "scale":a[m]=q;h[m]=(h[m]+"").split(g);o[m]=[(q[0]-h[m][0])/ b,(q[1]-h[m][1])/b,0,0];break;case "clip-rect":h[m]=(h[m]+"").split(g);o[m]=[];for(n=4;n--;)o[m][n]=(q[n]-h[m][n])/b
                        }e[m]=q
                }
            }this.stop();this.in_animation=1;ja[this.id]={
            start:a.start||+new Date,
            ms:b,
            easing:d,
            from:h,
            diff:o,
            to:e,
            el:this,
            callback:f,
            t:{
                x:0,
                y:0
            }
            };++ja[y]==1&&Ya();return this
        };K[C].stop=function(){
        ja[this.id]&&ja[y]--;delete ja[this.id];return this
        };K[C].translate=function(a,b){
        return this.attr({
            translation:a+" "+b
            })
        };K[C].toString=function(){
        return"Rapha\u00ebl\u2019s object"
        };v.ae=ja; var pa=function(a){
        this.items=[];this[y]=0;if(a)for(var b=0,d=a[y];b<d;b++)if(a[b]&&(a[b].constructor==K||a[b].constructor==pa)){
            this[this.items[y]]=this.items[this.items[y]]=a[b];this[y]++
        }
        };pa[C][aa]=function(){
        for(var a,b,d=0,f=arguments[y];d<f;d++)if((a=arguments[d])&&(a.constructor==K||a.constructor==pa)){
            b=this.items[y];this[b]=this.items[b]=a;this[y]++
        }return this
        };pa[C].pop=function(){
        delete this[this[y]--];return this.items.pop()
        };for(var Ha in K[C])if(K[C][M](Ha))pa[C][Ha]=function(a){
        return function(){
            for(var b= 0,d=this.items[y];b<d;b++)this.items[b][a][L](this.items[b],arguments);return this
            }
        }(Ha);pa[C].attr=function(a){
        if(a&&v.is(a,"array")&&v.is(a[0],"object"))for(var b=0,d=a[y];b<d;b++)this.items[b].attr(a[b]);else{
            b=0;for(d=this.items[y];b<d;b++)this.items[b].attr[L](this.items[b],arguments)
                }return this
        };pa[C].animate=function(a,b,d,f){
        (v.is(d,"function")||!d)&&(f=d||null);var h=this.items[y],e=h,o=this,m;f&&(m=function(){
            !--h&&f.call(o)
            });for(this.items[--e].animate(a,b,d||m,m);e--;)this.items[e].animateWith(this.items[h- 1],a,b,d||m,m);return this
        };pa[C].insertAfter=function(a){
        for(var b=this.items[y];b--;)this.items[b].insertAfter(a);return this
        };pa[C].getBBox=function(){
        for(var a=[],b=[],d=[],f=[],h=this.items[y];h--;){
            var e=this.items[h].getBBox();a[aa](e.x);b[aa](e.y);d[aa](e.x+e.width);f[aa](e.y+e.height)
            }a=la[L](0,a);b=la[L](0,b);return{
            x:a,
            y:b,
            width:fa[L](0,d)-a,
            height:fa[L](0,f)-b
            }
        };v.registerFont=function(a){
        if(!a.face)return a;this.fonts=this.fonts||{};var b={
            w:a.w,
            face:{},
            glyphs:{}
        },d=a.face["font-family"], f;for(f in a.face)if(a.face[M](f))b.face[f]=a.face[f];if(this.fonts[d])this.fonts[d][aa](b);else this.fonts[d]=[b];if(!a.svg){
            b.face["units-per-em"]=j(a.face["units-per-em"],10);for(var h in a.glyphs)if(a.glyphs[M](h)){
                d=a.glyphs[h];b.glyphs[h]={
                    w:d.w,
                    k:{},
                    d:d.d&&"M"+d.d.replace(/[mlcxtrv]/g,function(o){
                        return{
                            l:"L",
                            c:"C",
                            x:"z",
                            t:"m",
                            r:"l",
                            v:"c"
                        }[o]||"M"
                        })+"z"
                    };if(d.k)for(var e in d.k)if(d[M](e))b.glyphs[h].k[e]=d.k[e]
                    }
            }return a
        };J[C].getFont=function(a,b,d,f){
        f=f||"normal";d=d||"normal";b=+b||{
            normal:400,
            bold:700,
            lighter:300,
            bolder:800
        }[b]||400;var h=v.fonts[a];if(!h){
            a=RegExp("(^|\\s)"+a.replace(/[^\w\d\s+!~.:_-]/g,"")+"(\\s|$)","i");for(var e in v.fonts)if(v.fonts[M](e))if(a.test(e)){
                h=v.fonts[e];break
            }
            }var o;if(h){
            e=0;for(a=h[y];e<a;e++){
                o=h[e];if(o.face["font-weight"]==b&&(o.face["font-style"]==d||!o.face["font-style"])&&o.face["font-stretch"]==f)break
            }
            }return o
        };J[C].print=function(a,b,d,f,h,e){
        e=e||"middle";var o=this.set();d=(d+"").split("");var m=0;v.is(f,"string")&&(f=this.getFont(f));if(f){
            h= (h||16)/f.face["units-per-em"];var n=f.face.bbox.split(g),q=+n[0];e=+n[1]+(e=="baseline"?n[3]-n[1]+ +f.face.descent:(n[3]-n[1])/2);n=0;for(var A=d[y];n<A;n++){
                var B=n&&f.glyphs[d[n-1]]||{},I=f.glyphs[d[n]];m+=n?(B.w||f.w)+(B.k&&B.k[d[n]]||0):0;I&&I.d&&o[aa](this.path(I.d).attr({
                    fill:"#000",
                    stroke:"none",
                    translation:[m,0]
                    }))
                }o.scale(h,h,q,e).translate(a-q,b-e)
            }return o
        };v.format=function(a){
        var b=v.is(arguments[1],"array")?[0].concat(arguments[1]):arguments,d=/\{(\d+)\}/g;a&&v.is(a,"string")&&b[y]- 1&&(a=a.replace(d,function(f,h){
            return b[++h]==null?"":b[h]
            }));return a||""
        };v.ninja=function(){
        var a;if(x.was)Raphael=x.is;else delete Raphael;return Raphael
        };v.el=K[C];return v
    }();if(!this.JSON)this.JSON={}; (function(){
    function D(J){
        return J<10?"0"+J:J
        }function t(J){
        i.lastIndex=0;return i.test(J)?'"'+J.replace(i,function(L){
            var R=x[L];return typeof R==="string"?R:"\\u"+("0000"+L.charCodeAt(0).toString(16)).slice(-4)
            })+'"':'"'+J+'"'
        }function F(J,L){
        var R,Z,M,Y,y=k,C,T=L[J];if(T&&typeof T==="object"&&typeof T.toJSON==="function")T=T.toJSON(J);if(typeof v==="function")T=v.call(L,J,T);switch(typeof T){
            case "string":return t(T);case "number":return isFinite(T)?String(T):"null";case "boolean":case "null":return String(T); case "object":if(!T)return"null";k+=s;C=[];if(Object.prototype.toString.apply(T)==="[object Array]"){
                Y=T.length;for(R=0;R<Y;R+=1)C[R]=F(R,T)||"null";M=C.length===0?"[]":k?"[\n"+k+C.join(",\n"+k)+"\n"+y+"]":"["+C.join(",")+"]";k=y;return M
                }if(v&&typeof v==="object"){
                Y=v.length;for(R=0;R<Y;R+=1){
                    Z=v[R];if(typeof Z==="string")if(M=F(Z,T))C.push(t(Z)+(k?": ":":")+M)
                        }
                }else for(Z in T)if(Object.hasOwnProperty.call(T,Z))if(M=F(Z,T))C.push(t(Z)+(k?": ":":")+M);M=C.length===0?"{}":k?"{\n"+k+C.join(",\n"+k)+ "\n"+y+"}":"{"+C.join(",")+"}";k=y;return M
                }
        }if(typeof Date.prototype.toJSON!=="function"){
        Date.prototype.toJSON=function(){
            return isFinite(this.valueOf())?this.getUTCFullYear()+"-"+D(this.getUTCMonth()+1)+"-"+D(this.getUTCDate())+"T"+D(this.getUTCHours())+":"+D(this.getUTCMinutes())+":"+D(this.getUTCSeconds())+"Z":null
            };String.prototype.toJSON=Number.prototype.toJSON=Boolean.prototype.toJSON=function(){
            return this.valueOf()
            }
        }var g=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g, i=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,k,s,x={
        "\u0008":"\\b",
        "\t":"\\t",
        "\n":"\\n",
        "\u000c":"\\f",
        "\r":"\\r",
        '"':'\\"',
        "\\":"\\\\"
    },v;if(typeof JSON.stringify!=="function")JSON.stringify=function(J,L,R){
        var Z;s=k="";if(typeof R==="number")for(Z=0;Z<R;Z+=1)s+=" ";else if(typeof R==="string")s=R;if((v=L)&&typeof L!=="function"&&(typeof L!=="object"||typeof L.length!=="number"))throw Error("JSON.stringify");return F("", {
            "":J
        })
        };if(typeof JSON.parse!=="function")JSON.parse=function(J,L){
        function R(M,Y){
            var y,C,T=M[Y];if(T&&typeof T==="object")for(y in T)if(Object.hasOwnProperty.call(T,y)){
                C=R(T,y);if(C!==undefined)T[y]=C;else delete T[y]
            }return L.call(M,Y,T)
            }var Z;J=String(J);g.lastIndex=0;if(g.test(J))J=J.replace(g,function(M){
            return"\\u"+("0000"+M.charCodeAt(0).toString(16)).slice(-4)
            });if(/^[\],:{}\s]*$/.test(J.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,"@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, "]").replace(/(?:^|:|,)(?:\s*\[)+/g,""))){
            Z=eval("("+J+")");return typeof L==="function"?R({
                "":Z
            },""):Z
            }throw new SyntaxError("JSON.parse");
    }
    })();(function(D){
    function t(c,j,p){
        if(!(this instanceof t))return new t(c,j,p);this.paper=t.paper();this._registeredObjects=[];this._conVerticesCurrentIndex=0;this._nearbyVertexSqrDist=500;this.dom={};this._start={
            shape:null,
            dummy:false
        };this._end={
            shape:null,
            dummy:false
        };this._opt={
            vertices:[],
            attrs:{
                stroke:"#000",
                "fill-opacity":0,
                "stroke-width":1,
                "stroke-dasharray":"-",
                "stroke-linecap":"round",
                "stroke-linejoin":"round",
                "stroke-miterlimit":1,
                "stroke-opacity":1
            },
            cursor:"move",
            beSmooth:false,
            interactive:true,
            label:undefined,
            labelAttrsDefault:{
                position:0.5,
                offset:0,
                "font-size":12,
                fill:"#000"
            },
            labelAttrs:[],
            labelBoxAttrsDefault:{
                stroke:"white",
                fill:"white"
            },
            labelBoxAttrs:[],
            bboxCorrection:{
                start:{
                    type:null,
                    x:0,
                    y:0,
                    width:0,
                    height:0
                },
                end:{
                    type:null,
                    x:0,
                    y:0,
                    width:0,
                    height:0
                }
                },
            dummy:{
                start:{
                    radius:1,
                    attrs:{
                        opacity:0,
                        fill:"red"
                    }
                    },
                end:{
                    radius:1,
                    attrs:{
                        opacity:0,
                        fill:"yellow"
                    }
                    }
                },
            handle:{
                timeout:2E3,
                start:{
                    enabled:false,
                    radius:4,
                    attrs:{
                        opacity:1,
                        fill:"red",
                        stroke:"black"
                    }
                    },
                end:{
                    enabled:false,
                    radius:4,
                    attrs:{
                        opacity:1,
                        fill:"red",
                        stroke:"black"
                    }
                    }
                }
            };this._opt.arrow={
            start:t.getArrow("none",2,this._opt.attrs),
            end:t.getArrow("basic",5)
            };p&&this.processOptions(p);ua.init(this.paper,this._opt,this._start,this._end);p=this._start;var u=this._end;if(c.x&&c.y)ua.dummy(p,c,this._opt.dummy.start);else p.shape=c.yourself();if(j.x&&j.y)ua.dummy(u,j,this._opt.dummy.end);else u.shape=j.yourself();this.addJoint(p.shape);this.addJoint(u.shape);this.update()
        }function F(c,j){
        var p;if(j===undefined){
            p=c.split(c.indexOf("@")===-1? " ":"@");this.x=parseInt(p[0],10);this.y=parseInt(p[1],10)
            }else{
            this.x=c;this.y=j
            }
        }function g(c,j){
        return new F(c,j)
        }function i(c,j){
        this.start=c;this.end=j
        }function k(c,j){
        return new i(c,j)
        }function s(c){
        this.x=c.x;this.y=c.y;this.width=c.width;this.height=c.height
        }function x(c,j,p,u){
        if(typeof c.width==="undefined")return new s({
            x:c,
            y:j,
            width:p,
            height:u
        });return new s(c)
        }function v(c,j,p){
        this.x=c.x;this.y=c.y;this.a=j;this.b=p
        }function J(c,j,p){
        return new v(c,j,p)
        }function L(c,j,p,u){
        this.p0=c; this.p1=j;this.p2=p;this.p3=u
        }function R(c,j,p,u){
        return new L(c,j,p,u)
        }function Z(){}var M=D.Math,Y=M.cos,y=M.sin,C=M.sqrt,T=M.min,N=M.max,fa=M.atan2,la=M.acos,da=M.PI,ta=Array.isArray||function(c){
        return Object.prototype.toString.call(c)==="[object Array]"
        };if(!D.console)D.console={
        log:function(){},
        warn:function(){},
        error:function(){},
        debug:function(){}
        };if(!Array.indexOf)Array.prototype.indexOf=function(c,j){
        for(var p=j||0,u=this.length;p<u;p++)if(this[p]==c)return p;return-1
        };var V=function(){
        for(var c= arguments[0],j=1,p=arguments.length;j<p;j++){
            var u=arguments[j],w;for(w in u)if(u.hasOwnProperty(w)){
                var z=u[w];if(z!==c[w]){
                    if(typeof z=="function"&&typeof c[w]=="function"&&!z.base)z.base=c[w];c[w]=z
                    }
                }
            }return c
        },aa=function(){
        for(var c=arguments[0],j=1,p=arguments.length;j<p;j++){
            var u=arguments[j],w;for(w in u){
                var z=u[w];if(z!==c[w]){
                    if(typeof z=="function"&&typeof c[w]=="function"&&!c[w].base)c[w].base=z;if(!c.hasOwnProperty(w)&&u.hasOwnProperty(w))c[w]=z
                        }
                }
            }return c
        },qa=function(){
        for(var c= arguments[0],j=1,p=arguments.length;j<p;j++){
            var u=arguments[j],w;for(w in u){
                var z=u[w];if(z!==c[w]){
                    if(Object.prototype.toString.call(z)==="[object Object]")qa(c[w]||(c[w]={}),z);if(typeof z=="function"&&typeof c[w]=="function"&&!c[w].base)c[w].base=z;c[w]=z
                    }
                }
            }return c
        },xa=function(){
        for(var c=arguments[0],j=1,p=arguments.length;j<p;j++){
            var u=arguments[j],w;for(w in u){
                var z=u[w];if(z!==c[w]){
                    if(Object.prototype.toString.call(z)==="[object Object]")xa(c[w]||(c[w]={}),z);if(typeof z=="function"&& typeof c[w]=="function"&&!c[w].base)c[w].base=z;if(!c.hasOwnProperty(w)&&u.hasOwnProperty(w))c[w]=z
                        }
                }
            }return c
        };D.Joint=t;t.euid=1;t.generateEuid=function(){
        if(this._euid===undefined)this._euid=t.euid++;return this._euid
        };t.prototype={
        _dx:undefined,
        _dy:undefined,
        IDLE:0,
        STARTCAPDRAGGING:1,
        ENDCAPDRAGGING:2,
        CONNECTIONWIRING:3,
        state:0,
        _callbacks:{
            justConnected:function(){},
            disconnected:function(){},
            justBroken:function(){},
            wiring:function(){},
            objectMoving:function(){}
            },
        euid:function(){
            return t.generateEuid.call(this)
            },
        connection:function(){
            return this.dom.connection[0]
            },
        endObject:function(){
            return this._end.shape
            },
        startObject:function(){
            return this._start.shape
            },
        endCap:function(){
            return this.dom.endCap
            },
        endCapConnected:function(){
            return!this._end.dummy
            },
        startCap:function(){
            return this.dom.startCap
            },
        startCapConnected:function(){
            return!this._start.dummy
            },
        isStartDummy:function(){
            return this._start.dummy
            },
        isEndDummy:function(){
            return this._end.dummy
            },
        replaceDummy:function(c,j){
            c.shape.remove();c.dummy=false;c.shape= j
            },
        callback:function(c,j,p){
            this._callbacks[c].apply(j,p);return this
            },
        objectContainingPoint:function(c){
            for(var j=this._registeredObjects,p=j?j.length:0,u;p--;){
                u=j[p].yourself();if(x(u.getBBox()).containsPoint(c))return u
                    }return null
            },
        freeJoint:function(c){
            c=c.yourself().joints();var j=c.indexOf(this);c.splice(j,1);return this
            },
        addJoint:function(c){
            c=c.joints();c.indexOf(this)===-1&&c.push(this)
            },
        capMouseDown:function(c,j){
            t.currentJoint=this;this._dx=c.clientX;this._dy=c.clientY;if(j===this.dom.startCap){
                this.disconnect("start"); this.state=this.STARTCAPDRAGGING
                }else if(j===this.dom.endCap){
                this.disconnect("end");this.state=this.ENDCAPDRAGGING
                }
            },
        connectionMouseDown:function(c){
            t.currentJoint=this;c=t.getMousePosition(c,this.paper.canvas);for(var j=0,p=this._opt.vertices.length;j<p;j++)if(k(this._opt.vertices[j],c).squaredLength()<this._nearbyVertexSqrDist){
                this._conVerticesCurrentIndex=j;this.state=this.CONNECTIONWIRING;return
            }p=x(this.startObject().getBBox()).center();j=x(this.endObject().getBBox()).center();p=k(p,c).squaredLength(); j=k(j,c).squaredLength();if(p<j){
                this._conVerticesCurrentIndex=0;this._opt.vertices.unshift(c)
                }else this._conVerticesCurrentIndex=this._opt.vertices.push(c)-1;this.state=this.CONNECTIONWIRING;this.callback("justBroken",this,[c])
            },
        capDragging:function(c){
            if(this.state===this.STARTCAPDRAGGING)this.startObject().translate(c.clientX-this._dx,c.clientY-this._dy);else if(this.state===this.ENDCAPDRAGGING)this.endObject().translate(c.clientX-this._dx,c.clientY-this._dy);else return;this._dx=c.clientX;this._dy= c.clientY;this.update()
            },
        capEndDragging:function(){
            var c,j=this.state===this.STARTCAPDRAGGING,p=this.state===this.ENDCAPDRAGGING,u=j?"start":"end";if(j)c=this.startObject().getBBox();else if(p)c=this.endObject().getBBox();if(c=this.objectContainingPoint(g(c.x,c.y))){
                this.callback("justConnected",c,[u]);this.replaceDummy(this["_"+u],c);this.addJoint(c)
                }this.update()
            },
        connectionWiring:function(c){
            c=t.getMousePosition(c,this.paper.canvas);this._opt.vertices[this._conVerticesCurrentIndex]=c;this.update(); this.callback("wiring",this,[c])
            },
        update:function(){

            this.redraw().listenAll();

            },
        redraw:function(){
            this.clean(["connection","startCap","endCap","handleStart","handleEnd","label"]);this.draw(["connection","startCap","endCap","handleStart","handleEnd","label"]);return this
            },
        listenAll:function(){
            if(!this._opt.interactive)return this;var c=this;this.dom.startCap.mousedown(function(p){
                t.fixEvent(p);c.capMouseDown(p,c.dom.startCap);p.stopPropagation();p.preventDefault()
                });this.dom.endCap.mousedown(function(p){
                t.fixEvent(p); c.capMouseDown(p,c.dom.endCap);p.stopPropagation();p.preventDefault()
                });var j;for(j=this.dom.connection.length;j--;)this.dom.connection[j].mousedown(function(p){
                t.fixEvent(p);c.connectionMouseDown(p);p.stopPropagation();p.preventDefault()
                });this._opt.handle.start.enabled&&this.dom.handleStart.mousedown(function(p){
                t.fixEvent(p);c.capMouseDown(p,c.dom.startCap);p.stopPropagation();p.preventDefault()
                });this._opt.handle.end.enabled&&this.dom.handleEnd.mousedown(function(p){
                t.fixEvent(p);c.capMouseDown(p, c.dom.endCap);p.stopPropagation();p.preventDefault()
                });if(this._opt.handle.timeout!==Infinity)for(j=this.dom.connection.length;j--;)this.dom.connection[j].mouseover(function(p){
                t.fixEvent(p);c.showHandle();setTimeout(function(){
                    c.hideHandle()
                    },c._opt.handle.timeout);p.stopPropagation();p.preventDefault()
                });return this
            },
        boundPoint:function(c,j,p,u){
            if(j==="circle"||j==="ellipse")return J(c.center(),c.width/2,c.height/2).intersectionWithLineFromCenterToPoint(u);else if(j==="rect"&&c.width==c.height&& p!=0){
                j=c.width;j=Math.sqrt(j*j+j*j);c=c.center().offset(-j/2,-j/2);c=x(c.x,c.y,j,j)
                }return c.boundPoint(u)||c.center()
            },
        jointLocation:function(c,j,p){
            var u=p.length,w;w=p.length?p[0]:undefined;var z=p.length?p[u-1]:undefined,P,ba,W;p=this.boundPoint(c.bbox,c.type,c.rotation,w||j.bbox.center());w=c.bbox.center().theta(w||j.bbox.center());u=g(p.x+2*c.shift.dx*Y(w.radians),p.y+-2*c.shift.dy*y(w.radians));P=g(p.x+c.shift.dx*Y(w.radians),p.y-c.shift.dy*y(w.radians));ba=360-w.degrees+180;W=this.boundPoint(j.bbox, j.type,j.rotation,z||c.bbox.center());w=(z||c.bbox.center()).theta(j.bbox.center());c=g(W.x+-2*j.shift.dx*Y(w.radians),W.y+2*j.shift.dy*y(w.radians));j=g(W.x-j.shift.dx*Y(w.radians),W.y+j.shift.dy*y(w.radians));return{
                start:{
                    bound:p,
                    connection:u,
                    translate:P,
                    rotate:ba
                },
                end:{
                    bound:W,
                    connection:c,
                    translate:j,
                    rotate:360-w.degrees
                    }
                }
            },
            connectionPathCommandsCrunch:function(c,j,p,u,posx,posy,typeCrunch){
		if(typeCrunch==1)
		{
				j.x=posx;
				j.y=posy;
		}
		else
		{
				c.x=posx;
				c.y=posy;
		}
        if(u)return Z.curveThroughPoints([c].concat(p,[j]));c=["M",c.x,c.y];u=0;
		for(var w=p.length;u<w;u++)c.push("L",p[u].x,p[u].y);c.push("L", j.x,j.y);return c
        },
        connectionPathCommands:function(c,j,p,u){
            if(u)return Z.curveThroughPoints([c].concat(p,[j]));c=["M",c.x,c.y];u=0;for(var w=p.length;u<w;u++)c.push("L",p[u].x,p[u].y);c.push("L", j.x,j.y);return c
            },
        labelLocation:function(c){
            c=this.paper.path(c.join(" "));for(var j=c.getTotalLength(),p=[],u=this._opt.labelAttrs,w=u.length,z=0,P;z<w;z++){
                P=u[z].position;P=P>j?j:P;P=P<0?j+P:P;P=P>1?P:j*P;p.push(c.getPointAtLength(P))
                }c.remove();return p
            },
        draw:function(c){
            var j=this.jointLocation({
                bbox:x(this.startObject().getBBox()).moveAndExpand(this._opt.bboxCorrection.start),
                type:this.startObject().type,
                rotation:this.startObject().attrs.rotation,
                shift:this._opt.arrow.start
                },{
                bbox:x(this.endObject().getBBox()).moveAndExpand(this._opt.bboxCorrection.end),
                type:this.endObject().type,
                rotation:this.endObject().attrs.rotation,
                shift:this._opt.arrow.end
                },this._opt.vertices),p=this.connectionPathCommands(j.start.connection,j.end.connection,this._opt.vertices,this._opt.beSmooth),u=this.labelLocation(p);j=ua.init(this.paper,this._opt,this._start,this._end,j,p,u);p=c.length;for(var w=0;w<p;w++){
                u=c[w];this.dom[u]=j[u]()
                }
            },
            drawCrunch:function(c,posx,posy,typeCruch){
			this.clean(["connection","startCap","endCap","handleStart","handleEnd","label"]);
            var j=this.jointLocation({
                bbox:x(this.startObject().getBBox()).moveAndExpand(this._opt.bboxCorrection.start),
                type:this.startObject().type,
                rotation:this.startObject().attrs.rotation,
                shift:this._opt.arrow.start
                },{
                bbox:x(this.endObject().getBBox()).moveAndExpand(this._opt.bboxCorrection.end),
                type:this.endObject().type,
                rotation:this.endObject().attrs.rotation,
                shift:this._opt.arrow.end
                },this._opt.vertices),
				//j.end.connection.x=posx,j.end.connection.y=posy,

				p=this.connectionPathCommandsCrunch(j.start.connection,j.end.connection,this._opt.vertices,this._opt.beSmooth,posx,posy,typeCruch),
				u=this.labelLocation(p);

				j=ua.init(this.paper,this._opt,this._start,this._end,j,p,u);

				p=c.length;
				for(var w=0;w<p;w++){
                u=c[w];
				if(u=='endCapCrunchs')
				{
				this.dom[u]=j[u](posx-5,posy);
				}
				else
				this.dom[u]=j[u]()
                }
            },
        clean:function(c){
            for(var j,p,u=c.length;u--;){
                p=c[u];if(j=this.dom[p]){
                    if(j.node){
                        j.remove();this.dom[p]=null
                        }else for(var w in j)j.hasOwnProperty(w)&& j[w].remove();this.dom[p]=null
                    }
                }
            },
        processOptions:function(c){
            for(var j=this._opt,p=["interactive","cursor","beSmooth"],u=p.length;u--;)if(c[p[u]]!==undefined)j[p[u]]=c[p[u]];j.subConnectionAttrs=c.subConnectionAttrs||undefined;V(j.attrs,c.attrs);V(j.bboxCorrection.start,c.bboxCorrection&&c.bboxCorrection.start);V(j.bboxCorrection.end,c.bboxCorrection&&c.bboxCorrection.end);c.vertices&&this._setVertices(c.vertices);if(c.label){
                j.label=ta(c.label)?c.label:[c.label];if(!ta(c.labelAttrs))c.labelAttrs= [c.labelAttrs];for(u=0;u<j.label.length;u++)aa(c.labelAttrs[u]||(c.labelAttrs[u]={}),j.labelAttrsDefault);j.labelAttrs=c.labelAttrs;p=undefined;if(!ta(c.labelBoxAttrs)){
                    if(typeof c.labelBoxAttrs==="object")p=c.labelBoxAttrs;c.labelBoxAttrs=[c.labelBoxAttrs]
                    }for(u=0;u<j.label.length;u++){
                    if(p)c.labelBoxAttrs[u]=p;aa(c.labelBoxAttrs[u]||(c.labelBoxAttrs[u]={}),this._opt.labelBoxAttrsDefault)
                    }j.labelBoxAttrs=c.labelBoxAttrs
                }u=c.startArrow;p=c.endArrow;if(u&&u.type)j.arrow.start=t.getArrow(u.type,u.size, u.attrs);if(p&&p.type)j.arrow.end=t.getArrow(p.type,p.size,p.attrs);if(c.arrow){
                j.arrow.start=c.arrow.start||j.arrow.start;j.arrow.end=c.arrow.end||j.arrow.end
                }if(c.dummy&&c.dummy.start){
                if(c.dummy.start.radius)j.dummy.start.radius=c.dummy.start.radius;V(j.dummy.start.attrs,c.dummy.start.attrs)
                }if(c.dummy&&c.dummy.end){
                if(c.dummy.end.radius)j.dummy.end.radius=c.dummy.end.radius;V(j.dummy.end.attrs,c.dummy.end.attrs)
                }if(c.handle){
                if(c.handle.timeout)j.handle.timeout=c.handle.timeout;if(c.handle.start){
                    if(c.handle.start.enabled)j.handle.start.enabled= c.handle.start.enabled;if(c.handle.start.radius)j.handle.start.radius=c.handle.start.radius;V(j.handle.start.attrs,c.handle.start.attrs)
                    }if(c.handle.end){
                    if(c.handle.end.enabled)j.handle.end.enabled=c.handle.end.enabled;if(c.handle.end.radius)j.handle.end.radius=c.handle.end.radius;V(j.handle.end.attrs,c.handle.end.attrs)
                    }
                }
            },
        disconnect:function(c){
            var j,p=c==="start"?"Start":c==="end"?"End":"Both";if(c==="both"||c===undefined){
                this.freeJoint(this.startObject()).freeJoint(this.endObject());if(!this.isStartDummy()){
                    j= this.startObject();this.draw(["dummyStart"]);this.callback("disconnected",j,[c])
                    }if(!this.isEndDummy()){
                    j=this.endObject();this.draw(["dummyEnd"]);this.callback("disconnected",j,[c])
                    }
                }else if(!this["is"+p+"Dummy"]()){
                j=this[c+"Object"]();this.startObject()!==this.endObject()&&this.freeJoint(j);this.draw(["dummy"+p]);this.callback("disconnected",j,[c])
                }return this
            },
        register:function(c,j){
            j||(j="both");for(var p=c.constructor==Array?c:[c],u=0,w=p.length;u<w;u++){
                p[u].yourself()._capToStick=j;this._registeredObjects.push(p[u])
                }return this
            },
        registerForever:function(c){
            if(Object.prototype.toString.call(c)!=="[object Array]")c=Array.prototype.slice.call(arguments);this._registeredObjects=c;return this
            },
        unregister:function(c,j){
            j=j||"both";for(var p=-1,u=0,w=this._registeredObjects.length;u<w;u++){
                var z=this._registeredObjects[u].yourself()._capToStick||"both";if(this._registeredObjects[u]===c&&z===j){
                    p=u;break
                }
                }p!==-1&&this._registeredObjects.splice(p,1);return this
            },
        registeredObjects:function(){
            return this._registeredObjects
            },
        setVertices:function(c){
            this._setVertices(c); this.update();return this
            },
        _setVertices:function(c){
            for(var j=this._opt.vertices=[],p,u=0,w=c.length;u<w;u++){
                p=c[u].y===undefined?g(c[u]):g(c[u].x,c[u].y);j.push(p)
                }return this
            },
        getVertices:function(){
            return this._opt.vertices
            },
        toggleSmoothing:function(){
            this._opt.beSmooth=!this._opt.beSmooth;this.update();return this
            },
        isSmooth:function(){
            return this._opt.beSmooth
            },
        label:function(c){
            this._opt.label=ta(c)?c:[c];for(var j=0;j<c.length;j++){
                this._opt.labelAttrs[j]=this._opt.labelAttrsDefault;this._opt.labelBoxAttrs[j]= this._opt.labelBoxAttrsDefault
                }this.update();return this
            },
        registerCallback:function(c,j){
            this._callbacks[c]=j;return this
            },
        straighten:function(){
            this._opt.vertices=[];this.update();return this
            },
        toggleHandle:function(c){
            var j=this._opt.handle;if(c)j[c].enabled=!j[c].enabled;else{
                j.start.enabled=!j.start.enabled;j.end.enabled=!j.end.enabled
                }this.update();return this
            },
        showHandle:function(c){
            var j=this._opt.handle;if(c)j[c].enabled=true;else{
                j.start.enabled=true;j.end.enabled=true
                }this.update();return this
            },
        hideHandle:function(c){
            var j=this._opt.handle;if(c)j[c].enabled=false;else{
                j.start.enabled=false;j.end.enabled=false
                }this.update();return this
            },
        setBBoxCorrection:function(c,j){
            if(j)this._opt.bboxCorrection[j]=c;else this._opt.bboxCorrection.start=this._opt.bboxCorrection.end=c;this.update();return this
            },
        highlight:function(c){
            this.connection().attr("stroke",c||"red");return this
            },
        unhighlight:function(){
            this.connection().attr("stroke",this._opt.attrs.stroke||"#000");return this
            }
        };t.currentJoint=null; t.paper=function(){
        var c=arguments[0];if(c===undefined)return this._paper;this._paperArguments=arguments;if(!(c instanceof D.Raphael))return this._paper=D.Raphael.apply(D,arguments);return this._paper=c
        };t.resetPaper=function(){
        if(this._paper){
            var c=this._paper.canvas;c.parentNode.removeChild(c);t.paper.apply(t,this._paperArguments)
            }
        };t.getArrow=function(c,j,p){
        j||(j=2);c=t.arrows[c](j);if(!c.attrs)c.attrs={};if(p)for(var u in p)c.attrs[u]=p[u];return c
        };t.arrows={
        none:function(c){
            c||(c=2);return{
                path:["M", c.toString(),"0","L",(-c).toString(),"0"],
                dx:c,
                dy:c,
                attrs:{
                    opacity:0
                }
                }
            },
        basic:function(c){
            c||(c=5);return{
                path:["M",c.toString(),"0","L",(-c).toString(),(-c).toString(),"L",(-c).toString(),c.toString(),"z"],
                dx:c,
                dy:c,
                attrs:{
                    stroke:"black",
                    fill:"black"
                }
                }
            }
        };t.findPos=function(c){
        var j=g(0,0);if(c.offsetParent)for(;c;){
            j.offset(c.offsetLeft,c.offsetTop);c=c.offsetParent
            }else j.offset(c.parentNode.offsetLeft,c.parentNode.offsetTop);return j
        };t.getMousePosition=function(c,j){
        var p;if(c.pageX||c.pageY)p= g(c.pageX,c.pageY);else{
            p=document.documentElement;var u=document.body;p=g(c.clientX+(p.scrollLeft||u.scrollLeft)-p.clientLeft,c.clientY+(p.scrollTop||u.scrollTop)-p.clientTop)
            }u=t.findPos(j);return g(p.x-u.x,p.y-u.y)
        };t.mouseMove=function(c){
        if(t.currentJoint!==null){
            var j=t.currentJoint;if(j.state===j.STARTCAPDRAGGING||j.state===j.ENDCAPDRAGGING)j.capDragging(c);else j.state===j.CONNECTIONWIRING&&j.connectionWiring(c)
                }
        };t.mouseUp=function(){
        if(t.currentJoint!==null){
            var c=t.currentJoint;if(c.state=== c.STARTCAPDRAGGING||c.state===c.ENDCAPDRAGGING)c.capEndDragging()
                }t.currentJoint=null
        };t.fixEvent=function(c){
        c.preventDefault=t.fixEvent.preventDefault;c.stopPropagation=t.fixEvent.stopPropagation;return c
        };t.fixEvent.preventDefault=function(){
        this.returnValue=false
        };t.fixEvent.stopPropagation=function(){
        this.cancelBubble=true
        };t.handleEvent=function(c){
        var j=true;c=c||t.fixEvent(((D.ownerDocument||D.document||D).parentWindow||D).event);var p=this.events[c.type],u;for(u in p){
            this.$$handleEvent= p[u];if(this.$$handleEvent(c)===false)j=false
                }return j
        };t.addEvent=function(c,j,p){
        if(c.addEventListener)c.addEventListener(j,p,false);else{
            if(!p.$$guid)p.$$guid=t.addEvent.guid++;if(!c.events)c.events={};var u=c.events[j];if(!u){
                u=c.events[j]={};if(c["on"+j])u[0]=c["on"+j]
                    }u[p.$$guid]=p;c["on"+j]=t.handleEvent
            }
        };t.addEvent.guid=1;t.removeEvent=function(c,j,p){
        if(c.removeEventListener)c.removeEventListener(j,p,false);else c.events&&c.events[j]&&delete c.events[j][p.$$guid]
    };t.addEvent(document,"mousemove", t.mouseMove);t.addEvent(document,"mouseup",t.mouseUp);var ua={
        init:function(c,j,p,u,w,z,P){
            this.paper=c;this.opt=j;this.start=p;this.end=u;this.jointLocation=w;this.connectionPathCommands=z;this.labelLocation=P;return this
            },
        dummy:function(c,j,p){
            c.dummy=true;c.shape=this.paper.circle(j.x,j.y,p.radius).attr(p.attrs);c.shape.show();return c.shape
            },
        dummyStart:function(){
            return this.dummy(this.start,this.jointLocation.start.bound,this.opt.dummy.start)
            },
        dummyEnd:function(){
            return this.dummy(this.end,this.jointLocation.end.bound, this.opt.dummy.end)
            },
        handleStart:function(){
            var c=this.opt.handle.start;if(c.enabled){
                var j=this.jointLocation.start.bound;return this.paper.circle(j.x,j.y,c.radius).attr(c.attrs)
                }
            },
        handleEnd:function(){
            var c=this.opt.handle.end;if(c.enabled){
                var j=this.jointLocation.end.bound;return this.paper.circle(j.x,j.y,c.radius).attr(c.attrs)
                }
            },
        connection:function(){
            var c=this.opt,j=[],p=this.paper.path(this.connectionPathCommands.join(" ")).attr(c.attrs);if(c.subConnectionAttrs)for(var u=0,w=c.subConnectionAttrs.length, z=p.getTotalLength();u<w;u++){
                var P=c.subConnectionAttrs[u],ba=P.from||2,W=P.to||1;ba=ba>z?z:ba;ba=ba<0?z+ba:ba;ba=ba>1?ba:z*ba;W=W>z?z:W;W=W<0?z+W:W;W=W>1?W:z*W;P=this.paper.path(p.getSubpath(ba,W)).attr(P);P.node.style.cursor=c.cursor;j.push(P)
                }p.node.style.cursor=c.cursor;p.show();return[p].concat(j)
            },
        label:function(){
            if(this.opt.label!==undefined){
                for(var c=ta(this.opt.label)?this.opt.label:[this.opt.label],j=this.opt.labelAttrs,p=c.length,u=0,w=[];u<p;u++){
                    var z=this.labelLocation[u];z=this.paper.text(z.x, z.y+(j[u].offset||0),c[u]).attr(j[u]);var P=z.getBBox(),ba=j[u].padding||0;P=this.paper.rect(P.x-ba,P.y-ba+(j[u].offset||0),P.width+2*ba,P.height+2*ba).attr(this.opt.labelBoxAttrs[u]);z.insertAfter(P);w.push(z,P)
                    }return w
                }
            },
        startCap:function(){
            var c=this.opt.arrow.start;c=this.paper.path(c.path.join(" ")).attr(c.attrs);c.translate(this.jointLocation.start.translate.x,this.jointLocation.start.translate.y);c.rotate(this.jointLocation.start.rotate);c.show();return c
            },
        endCap:function(){
            var c=this.opt.arrow.end; c=this.paper.path(c.path.join(" ")).attr(c.attrs);c.translate(this.jointLocation.end.translate.x,this.jointLocation.end.translate.y);c.rotate(this.jointLocation.end.rotate);c.show();return c
            }
        };F.prototype={
        constructor:F,
        _isPoint:true,
        toString:function(){
            return this.x+"@"+this.y
            },
        deepCopy:function(){
            return g(this.x,this.y)
            },
        adhereToRect:function(c){
            if(c.containsPoint(this))return this;this.x=T(N(this.x,c.x),c.x+c.width);this.y=T(N(this.y,c.y),c.y+c.height);return this
            },
        theta:function(c){
            c=fa(-(c.y- this.y),c.x-this.x);if(c<0)c=2*da+c;return{
                degrees:180*c/da,
                radians:c
            }
            },
        distance:function(c){
            return k(this,c).length()
            },
        offset:function(c,j){
            this.x+=c;this.y+=j;return this
            },
        normalize:function(c){
            c/=C(this.x*this.x+this.y*this.y);this.x*=c;this.y*=c;return this
            }
        };F.fromPolar=function(c,j){
        return g(c*Y(j),c*y(j))
        };i.prototype={
        constructor:i,
        toString:function(){
            return"start: "+this.start.toString()+" end:"+this.end.toString()
            },
        length:function(){
            return C(this.squaredLength())
            },
        squaredLength:function(){
            var c= this.start.x,j=this.start.y,p=this.end.y;return(c-=this.end.x)*c+(j-=p)*j
            },
        midpoint:function(){
            return g((this.start.x+this.end.x)/2,(this.start.y+this.end.y)/2)
            },
        intersection:function(c){
            var j=g(this.end.x-this.start.x,this.end.y-this.start.y),p=g(c.end.x-c.start.x,c.end.y-c.start.y),u=j.x*p.y-j.y*p.x;c=g(c.start.x-this.start.x,c.start.y-this.start.y);p=c.x*p.y-c.y*p.x;c=c.x*j.y-c.y*j.x;if(u===0||p*u<0||c*u<0)return null;if(u>0){
                if(p>u||c>u)return null
                    }else if(p<u||c<u)return null;return g(this.start.x+ p*j.x/u,this.start.y+p*j.y/u)
            }
        };s.prototype={
        constructor:s,
        toString:function(){
            return"origin: "+this.origin().toString()+" corner: "+this.corner().toString()
            },
        origin:function(){
            return g(this.x,this.y)
            },
        corner:function(){
            return g(this.x+this.width,this.y+this.height)
            },
        topRight:function(){
            return g(this.x+this.width,this.y)
            },
        bottomLeft:function(){
            return g(this.x,this.y+this.height)
            },
        center:function(){
            return g(this.x+this.width/2,this.y+this.height/2)
            },
        intersect:function(c){
            var j=this.origin(),p=this.corner(), u=c.origin();c=c.corner();if(c.x<=j.x)return false;if(c.y<=j.y)return false;if(u.x>=p.x)return false;if(u.y>=p.y)return false;return true
            },
        sideNearestToPoint:function(c){
            var j=this.x+this.width-c.x,p=c.y-this.y,u=this.y+this.height-c.y;c=c.x-this.x;var w="left";if(j<c){
                c=j;w="right"
                }if(p<c){
                c=p;w="top"
                }if(u<c)w="bottom";return w
            },
        containsPoint:function(c){
            if(c.x>this.x&&c.x<this.x+this.width&&c.y>this.y&&c.y<this.y+this.height)return true;return false
            },
        pointNearestToPoint:function(c){
            if(this.containsPoint(c))switch(this.sideNearestToPoint(c)){
                case "right":return g(this.x+ this.width,c.y);case "left":return g(this.x,c.y);case "bottom":return g(c.x,this.y+this.height);case "top":return g(c.x,this.y)
                    }else return c.adhereToRect(this)
                },
        boundPoint:function(c){
            var j=g(this.x+this.width/2,this.y+this.height/2),p=[k(this.origin(),this.topRight()),k(this.topRight(),this.corner()),k(this.corner(),this.bottomLeft()),k(this.bottomLeft(),this.origin())];c=k(j,c);for(j=p.length-1;j>=0;--j){
                var u=p[j].intersection(c);if(u!==null)return u
                    }
            },
        moveAndExpand:function(c){
            this.x+=c.x;this.y+= c.y;this.width+=c.width;this.height+=c.height;return this
            }
        };v.prototype={
        constructor:v,
        bbox:function(){
            return x({
                x:this.x-this.a,
                y:this.y-this.b,
                width:2*this.a,
                height:2*this.b
                })
            },
        intersectionWithLineFromCenterToPoint:function(c){
            var j=c.x-this.x,p=c.y-this.y;if(j===0)return this.bbox().pointNearestToPoint(c);c=p/j;p=C(1/(1/(this.a*this.a)+c*c/(this.b*this.b)));if(j<0)p=-p;return g(this.x+p,this.y+c*p)
            }
        };L.prototype={
        constructor:L,
        getPoint:function(c){
            var j=1-c,p=j*j,u=p*j,w=c*c,z=w*c;return g(u*this.p0.x+ 3*p*c*this.p1.x+3*j*w*this.p2.x+z*this.p3.x,u*this.p0.y+3*p*c*this.p1.y+3*j*w*this.p2.y+z*this.p3.y)
            }
        };Z.curveThroughPoints=function(c,j,p){
        if(typeof j==="undefined")j=0.5;if(typeof p==="undefined")p=0.75;var u=[];if(c.length<2)throw Error("Points array must have minimum of two points.");for(var w=[c[0]],z=1,P=c.length;z<P;z++)if(c[z].x!=c[z-1].x||c[z].y!=c[z-1].y)w.push(c[z]);if(j<=0)j=0.5;else if(j>1)j=1;if(p<0)p=0;else if(p>1)p=1;if(w.length>2){
            var ba=1;c=w.length-1;if(w[0].x==w[c].x&&w[0].y== w[c].y){
                ba=0;c=w.length
                }P=[];for(z=ba;z<c;z++){
                var W=z-1<0?w[w.length-2]:w[z-1],ea=w[z],ra=z+1==w.length?w[1]:w[z+1],ca=W.distance(ea);if(ca<0.0010)ca=0.0010;var ia=ea.distance(ra);if(ia<0.0010)ia=0.0010;var ha=W.distance(ra);if(ha<0.0010)ha=0.0010;ha=(ia*ia+ca*ca-ha*ha)/(2*ia*ca);if(ha<-1)ha=-1;else if(ha>1)ha=1;ha=la(ha);var ma=g(W.x-ea.x,W.y-ea.y),oa=g(ea.x,ea.y),ka=g(ra.x-ea.x,ra.y-ea.y);if(ca>ia)ma.normalize(ia);else ia>ca&&ka.normalize(ca);ma.offset(ea.x,ea.y);ka.offset(ea.x,ea.y);W=oa.x-ma.x; ma=oa.y-ma.y;var va=oa.x-ka.x;oa=oa.y-ka.y;ka=W+va;var sa=ma+oa;if(ka===0&&sa===0){
                    ka=-va;sa=oa
                    }if(ma===0&&oa===0){
                    ka=0;sa=1
                    }else if(W===0&&va===0){
                    ka=1;sa=0
                    }W=fa(sa,ka);ca=T(ca,ia)*j;ca*=1-p+p*(ha/da);ha=W+da/2;ia=F.fromPolar(ca,ha);ca=F.fromPolar(ca,ha+da);ca.offset(ea.x,ea.y);ia.offset(ea.x,ea.y);P[z]=ia.distance(ra)>ca.distance(ra)?[ia,ca]:[ca,ia]
                }u.push("M",w[0].x,w[0].y);ba==1&&u.push("S",P[1][0].x,P[1][0].y,w[1].x,w[1].y);for(z=ba;z<c-1;z++){
                j=false;if(z>0&&fa(w[z].y-w[z-1].y,w[z].x-w[z-1].x)== fa(w[z+1].y-w[z].y,w[z+1].x-w[z].x)||z<w.length-2&&fa(w[z+2].y-w[z+1].y,w[z+2].x-w[z+1].x)==fa(w[z+1].y-w[z].y,w[z+1].x-w[z].x))j=true;if(j)u.push("L",w[z+1].x,w[z+1].y);else{
                    j=R(w[z],P[z][1],P[z+1][0],w[z+1]);for(p=0.01;p<1.01;p+=0.01){
                        ba=j.getPoint(p);u.push("L",ba.x,ba.y)
                        }
                    }
                }c==w.length-1&&u.push("S",P[z][1].x,P[z][1].y,w[z+1].x,w[z+1].y)
            }else if(w.length==2){
            u.push("M",w[0].x,w[0].y);u.push("L",w[1].x,w[1].y)
            }return u
        };t.Point=F;t.point=g;t.Rect=s;t.rect=x;t.Line=i;t.line=k;t.Ellipse=v;t.ellipse= J;t.BezierSegment=L;t.bezierSegment=R;t.Bezier=Z;t.Mixin=V;t.Supplement=aa;t.DeepMixin=qa;t.DeepSupplement=xa;var $=D.Raphael.el.attr;D.Raphael.el.attr=function(){
        if(arguments.length==1&&(typeof arguments[0]==="string"||typeof arguments[0]==="array")||typeof this.joints==="undefined")return $.apply(this,arguments);var c={},j;for(j in this.attrs)c[j]=this.attrs[j];$.apply(this,arguments);var p=this.attrs;j=false;if(c.x!=p.x||c.y!=p.y||c.cx!=p.cx||c.cy!=p.cy||c.path!=p.path||c.r!=p.r)j=true;for(c=this.joints().length- 1;c>=0;--c){
            p=this.joints()[c];if(j){
                p.update();p.callback("objectMoving",p,[this])
                }
            }return this
        };D.Raphael.el.joint=function(c,j){
        t.paper(this.paper);return new t(this,c,j)
        };D.Raphael.el.euid=function(){
        return t.generateEuid.call(this)
        };D.Raphael.el.yourself=function(){
        return this
        };D.Raphael.el.joints=function(){
        return this._joints||(this._joints=[])
        };D.Raphael.fn.euid=function(){
        return t.generateEuid.call(this)
        }
    })(this);(function(D){
    var t=D.Joint,F=t.point,g=t.rect,i=t.dia={

        _currentDrag:false,
        _currentZoom:false,
        _registeredObjects:{},
        _registeredJoints:{},
        Joint:function(){
            var k=t.apply(null,arguments);this.registerJoint(k);return k
            },
        registeredElements:function(){
            return this._registeredObjects[t.paper().euid()]||(this._registeredObjects[t.paper().euid()]=[])
            },
        registeredJoints:function(){
            return this._registeredJoints[t.paper().euid()]||(this._registeredJoints[t.paper().euid()]=[])
            },
        register:function(k){
            (this._registeredObjects[t.paper().euid()]|| (this._registeredObjects[t.paper().euid()]=[])).push(k)
            },
        unregister:function(k){
            for(var s=this._registeredObjects[t.paper().euid()]||(this._registeredObjects[t.paper().euid()]=[]),x=s.length;x--;)s[x]===k&&s.splice(x,1)
                },
        registerJoint:function(k){
            (this._registeredJoints[t.paper().euid()]||(this._registeredJoints[t.paper().euid()]=[])).push(k)
            },
        unregisterJoint:function(k){
            for(var s=this._registeredJoints[t.paper().euid()]||(this._registeredJoints[t.paper().euid()]=[]),x=s.length;x--;)s[x]===k&&s.splice(x, 1)
                }
        };D=i.Element=function(){};D.create=function(k){
        var s=new this(k);s.init&&s.init(k);s.defaults(s.properties);s.paper.safari();return s
        };D.extend=function(k){
        var s=k.constructor=function(v){
            this.construct(v)
            };s.base=this;var x=s.prototype=new this;t.Mixin(x,k);t.Supplement(s,this);return s
        };D.prototype={
        parentElement:null,
        toolbox:null,
        _isElement:true,
        lastScaleX:1,
        lastScaleY:1,
        dx:undefined,
        dy:undefined,
        origBBox:undefined,
        construct:function(k){
            this.properties={
                dx:0,
                dy:0,
                rot:0,
                sx:1,
                sy:1,
                module:this.module,
                object:this.object,
                parent:k.parent
                };this.shadow=this.wrapper=null;this.shadowAttrs={
                stroke:"none",
                fill:"#999",
                translation:"7,7",
                opacity:0.5
            };this.inner=[];this.ghostAttrs={
                opacity:0.5,
                "stroke-dasharray":"-",
                stroke:"black"
            };this._opt={
                draggable:true,
                ghosting:false,
                toolbox:false
            };this.paper=t.paper();i.register(this)
            },
        defaults:function(k){
            if(k.shadow){
                t.Mixin(this.shadowAttrs,k.shadow);this.createShadow()
                }
            },
        euid:function(){
            return t.generateEuid.call(this)
            },
        joints:function(){
            return this.wrapper.joints()
            },
        yourself:function(){
            return this.wrapper
            },
        updateJoints:function(){
            var k=this.wrapper.joints();if(k)for(var s=0,x=k.length;s<x;s++)k[s].update()
                },
        toggleGhosting:function(){
            this._opt.ghosting=!this._opt.ghosting;return this
            },
        createGhost:function(){
            this.ghost=this.cloneWrapper(this.ghostAttrs)
            },
        createShadow:function(){
            this.shadowAttrs.rotation=this.wrapper.attrs.rotation;this.shadow=this.cloneWrapper(this.shadowAttrs);this.shadow.toBack()
            },
        cloneWrapper:function(k){
            var s=this.wrapper.attrs,x=this.wrapper.paper, v;switch(this.wrapper.type){
                case "rect":v=x.rect(s.x,s.y,s.width,s.height,s.r);break;case "circle":v=x.circle(s.cx,s.cy,s.r);break;case "ellipse":v=x.ellipse(s.cx,s.cy,s.rx,s.ry)
                    }v.attr(k);return v
            },
        objPos:function(k){
            switch(this[k].type){
                case "rect":return F(this[k].attr("x"),this[k].attr("y"));case "circle":case "ellipse":return F(this[k].attr("cx"),this[k].attr("cy"))
                    }
            },
        wrapperPos:function(){
            return this.objPos("wrapper")
            },
        ghostPos:function(){
            return this.objPos("ghost")
            },
        toFront:function(){
            this.shadow&& this.shadow.toFront();this.wrapper&&this.wrapper.toFront();for(var k=0,s=this.inner.length;k<s;k++)this.inner[k].toFront();return this
            },
        toBack:function(){
            for(var k=this.inner.length-1;k>=0;--k)this.inner[k].toBack();this.wrapper&&this.wrapper.toBack();this.shadow&&this.shadow.toBack();return this
            },
        dragger:function(k){
            if(this.wholeShape._opt.draggable){
                i._currentDrag=this.wholeShape;if(i._currentDrag._opt.ghosting){
                    i._currentDrag.createGhost();i._currentDrag.ghost.toFront()
                    }else i._currentDrag.toFront(); i._currentDrag.removeToolbox();i._currentDrag.translate(1,1);i._currentDrag.dx=k.clientX;i._currentDrag.dy=k.clientY;k.preventDefault&&k.preventDefault()
                }
            },
        zoomer:function(k){
            i._currentZoom=this;i._currentZoom.toFront();i._currentZoom.removeToolbox();var s=g(i._currentZoom.origBBox);i._currentZoom.dx=k.clientX;i._currentZoom.dy=k.clientY;i._currentZoom.dWidth=s.width*i._currentZoom.lastScaleX;i._currentZoom.dHeight=s.height*i._currentZoom.lastScaleY;k.preventDefault&&k.preventDefault()
            },


        setWrapper:function(k){
            this.wrapper=k;this.wrapper.wholeShape=this;this.type=this.wrapper.type;this.origBBox=this.wrapper.getBBox();if(this._opt&&this._opt.draggable){
                this.wrapper.mousedown(this.dragger);this.wrapper.node.style.cursor="move"
                }if(!this.wrapper.joints){
                this.wrapper._joints= [];this.wrapper.joints=function(){
                    return this._joints
                    }
                }this.addToolbox();return this
            },
        addInner:function(k){
            this.inner.push(k);k.wholeShape=this;k.parentElement=this;if(k._isElement)k.properties.parent=this.euid();if(!k._isElement&&this._opt&&this._opt.draggable){
                k.mousedown(this.dragger);k.node.style.cursor="move"
                }k.toFront();return this
            },
        delInner:function(k){
            for(var s=0,x=this.inner.length;s<x;s++)if(this.inner[s]==k)break;if(s<x){
                this.inner.splice(s,1);k.parentElement=null;if(k._isElement)k.properties.parent= undefined
                    }return this
            },
        addToolbox:function(){
            if(!this._opt.toolbox)return this;var k=this,s=this.wrapper.getBBox(),x=s.x-10;s=s.y-22;this.toolbox=[];this.toolbox.push(this.paper.rect(x,s,33,22,5).attr({
                fill:"white"
            }));this.toolbox.push(this.paper.image("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAsAAAALCAYAAACprHcmAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAE5SURBVHjaYvz//z8DsQAggFhARGRkpBETE1M/kGkOxIz//v078+HDh4odO3acBPJ//4eaCBBADCA6Kirq4JlzJ978/vPrNwifOHX4fUhIyFmgvDQQs4HUgDBAALFAbTDX1zNiZmFmBfONDM14WFlZdYFMCSD+AsS/QOIAAcQEVcyIw5m8IJNhHIAAAisGufHMuZNfgE74A8Knzx7/LiLO91tfXx9kOgsjEIDUAQQQ2FqQZ3q7Jk6AWs2gqCbOkZDn8l9AiLuNi4vrxfHjx7cC1X8HCCCwYqiv/aBu5NXQ0FD9+/dfr4uf/te7N1/Mu337ttmbN2/uAwQQzIO/gfg11DNsN4BA/LD4n8f33swF8v8DFQoAaS6AAGLEFilQN3JCbQLhH0B8HyCAGHHFIFQDB1QTSNEXgAADAEQ2gYZ9CcycAAAAAElFTkSuQmCC", x,s,11,11));this.toolbox[this.toolbox.length-1].toFront();t.addEvent(this.toolbox[this.toolbox.length-1].node,"mousedown",function(v){
                i.Element.prototype.zoomer.apply(k,[v])
                });this.toolbox.push(this.paper.image("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAsAAAALCAYAAACprHcmAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAEJSURBVHjaYvj//z8DFGOAnz9/rjl27Jg0AwMDExAzAAQQI0ghFPz/8usZjM3ACJTnYBEC0iyfmZmZZYBCXwECiAkm+evXL4bff34w/P33C4z//PvB8O33awYmJiZeoDQ/ELMBBBALSKGJiQkPOzs7AxsbC8OaTXMZWFhZoEb8g5nFDsTMAAHEBFIIZLwCuo/hy5dvDCF+yQx/fv+BuAvhRDAACCCQM0AO5YRJfv78lSE+Ko/h79+/DP8RJoMBQACheHDv4wYGdOAs28DAyMioCmS+AAggJgYSAEAAoZiMUxHUZIAAYkES4AJSQjD3o4HvQPwXIIDgJgMVM4PCEhREWBT/BUUFQIABAMuFbgea+o0EAAAAAElFTkSuQmCC", x+22,s,11,11));this.toolbox[this.toolbox.length-1].toFront();this.toolbox[this.toolbox.length-1].node.onclick=function(){
                k.embed()
                };this.toolbox.push(this.paper.image("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAsAAAALCAYAAACprHcmAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAEJSURBVHjaYvj//z8DFGOAnz9/rjl27Jg0AwMDExAzAAQQI0ghFPz/8usZjM3ACJTnYBEC0iyfmZmZZYBCXwECiIkBCfz99wuO//z7wfDt92sGJiYmXqAUPxCzAQQQi4mJyX0gQwFZExcXJ8OaTXMYODmZYULsQMwMEEAgk9WB+D0jIyNElJ2NYdXG2QzsHOwMSE4EA4AAYjpz5swvIC3By8sLVrh2yzygiRwQTzD8Q1EMEEBwD/779+//7gcNDCysKN5gcJZtYADaqgpkvgAIILgM0CMYCtEBQAChBB1ORVCTAQKIBUmAC0gJATEnFvXfQSELEEBwk4GKQeHEBgoiLIr/AvEvgAADAH4mYO9cg5S2AAAAAElFTkSuQmCC", x+11,s,11,11));this.toolbox[this.toolbox.length-1].toFront();this.toolbox[this.toolbox.length-1].node.onclick=function(){
                k.unembed()
                };this.toolbox.push(this.paper.path("M24.778,21.419 19.276,15.917 24.777,10.415 21.949,7.585 16.447,13.087 10.945,7.585 8.117,10.415 13.618,15.917 8.116,21.419 10.946,24.248 16.447,18.746 21.948,24.248").attr({
                fill:"#000",
                stroke:"none"
            }).translate(x,s).scale(0.5));this.toolbox[this.toolbox.length-1].toFront();this.toolbox[this.toolbox.length-1].node.onclick=function(){
                k.remove()
                }; this.toolbox.push(this.paper.image("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAsAAAALCAYAAACprHcmAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAEjSURBVHjaYvz//z8DsQAggJjwSaanpwsBMReMDxBATAQMO/zv379eRkZGdiBmAgggJiymqaWlpS0GSrIAFZ4A0h5AYR4gZgEIICaoAg6ggolACea/f/9aAulAoDD3169fNwPZ0kA2B0gxQADBTBYECuYCaa7bt2/vACkEYs4zZ84cA9KsQAwKBUaAAGIBqfzz5w8jExPTRiCTXUFBwQ9IfwP5x8TExAJI/4IpBgggsOJ58+Y9B1JRQMwGdOdjoFP2ghRwcnL6A4P2KUghiA8QQGDFQIH/QGf8BDJ/L1myZC8fHx/IeiZmZmbr379/H4ApBgggFlgoANX/A1L/gJoYP336BHIG47Nnz1zu3r0LUvgD5FqAAGLEF4Og0EHy4G+AAAMAho1gqqugDLgAAAAASUVORK5CYII=", x,s+11,11,11));this.toolbox[this.toolbox.length-1].toFront();this.toolbox[this.toolbox.length-1].node.onmousedown=function(){
                i._currentDrag=k.clone()[0];console.log(i._currentDrag[0])
                };return this
            },
        removeToolbox:function(){
            if(this.toolbox)for(var k=this.toolbox.length-1;k>=0;--k)this.toolbox[k].remove();this.toolbox=null;return this
            },
        toggleToolbox:function(){
            this._opt.toolbox=!this._opt.toolbox;this._opt.toolbox?this.addToolbox():this.removeToolbox();return this
            },
        translateToolbox:function(k,s){
            if(this.toolbox)for(var x= this.toolbox.length-1;x>=0;--x)this.toolbox[x].translate(k,s)
                },
        disconnect:function(){
            for(var k=this.joints(),s=k.length,x;s--;){
                x=k[s];if(x.endObject().wholeShape===this){
                    x.freeJoint(x.endObject());x.draw(["dummyEnd"]);x.update()
                    }if(x.startObject().wholeShape===this){
                    x.freeJoint(x.startObject());x.draw(["dummyStart"]);x.update()
                    }
                }
            },
        unregisterFromJoints:function(){
            for(var k=this.joints(),s=k.length;s--;)k[s].unregister(this);return this
            },
        remove:function(){
            var k=this.inner,s=k.length;this.unregisterFromJoints(); this.disconnect();this.removeToolbox();for(this.unembed();s--;)k[s].remove();this.wrapper.remove();i.unregister(this);this.removed=true;return null
            },
        liquidate:function(){
            for(var k=this.joints(),s=k.length,x,v=this.inner;s--;){
                x=k[s];x.freeJoint(x.startObject());x.freeJoint(x.endObject());x.clean(["connection","startCap","endCap","handleStart","handleEnd","label"]);i.unregisterJoint(x);x.unregister(this)
                }this.removeToolbox();this.unembed();for(s=v.length;s--;)v[s].liquidate?v[s].liquidate():v[s].remove(); this.wrapper.remove();i.unregister(this);this.removed=true;return null
            },
        draggable:function(k){
            this._opt.draggable=k;this.wrapper.node.style.cursor=k?"move":null;for(var s=this.inner.length;s--;)this.inner[s].node.style.cursor=k?"move":null;return this
            },
        highlight:function(){
            this.wrapper.attr("stroke","red");return this
            },
        unhighlight:function(){
            this.wrapper.attr("stroke",this.properties.attrs.stroke||"#000");return this
            },
        embed:function(){
            for(var k=i._registeredObjects[this.paper.euid()],s=g(this.wrapper.getBBox()), x=null,v=0,J=k.length;v<J;v++){
                var L=k[v];if(g(L.getBBox()).containsPoint(s.origin()))x=L;if(L==this.parentElement){
                    L.delInner(this);if(x)break
                }
                }x&&x.addInner(this);return this
            },
        unembed:function(){
            if(this.parentElement){
                this.parentElement.delInner(this);this.parentElement=null;this.properties.parent=undefined
                }return this
            },
        scale:function(k,s){
            this.properties.sx=k;this.properties.sy=s;this.shadow&&this.shadow.scale.apply(this.shadow,arguments);this.wrapper.scale.apply(this.wrapper,arguments);this.zoom.apply(this, arguments);for(var x=0,v=this.inner.length;x<v;x++){
                var J=this.inner[x];J._isElement&&J.scale.apply(J,arguments)
                }if(!this._doNotRedrawToolbox){
                this.removeToolbox();this.addTooflbox()
                }
            },
        zoom:function(){},
        getBBox:function(){
            return this.wrapper.getBBox()
            },
        joint:function(k,s){
            var x=this.wrapper.joint.apply(this.wrapper,[k._isElement?k.wrapper:k,s]);t.dia.registerJoint(x);return x
            },
        attr:function(){
            return Raphael.el.attr.apply(this.wrapper,arguments)
            },
	    translate:function(k){
			/*var n=this.properties;
            console.log(n.dx);*/
            },
		mostrar:function()
		{
            procesoActual=this;
			mostrarSeguimiento();
		}
        };D.mouseUp=function(){
		//translate(k);

		if((!enRegistro)&&i._currentDrag){
			i._currentDrag.mostrar();
		}
        i._currentDrag=false;

        /*if(i._currentDrag&&i._currentDrag._opt.ghosting){
            var k=i._currentDrag.ghostPos(),s=i._currentDrag.wrapperPos();i._currentDrag.translate(k.x-s.x,k.y-s.y);i._currentDrag.ghost.remove();i._currentDrag.updateJoints()
            }if(i._currentDrag){
            i._currentDrag.addToolbox(); i._currentDrag.toFront();i._currentDrag.translate(1,1)
            }if(i._currentZoom){
            i._currentZoom.removeToolbox();i._currentZoom.addToolbox();i._currentZoom.toFront()
            }i._currentDrag=false;i._currentZoom=false*/
        };
        //t.addEvent(document,"mousemove",D.mouseMove);
        t.addEvent(document,"mouseup",D.mouseUp)
        /*t.addEvent(document,"dblclick",D.dblClick)*/
    })(this);(function(D){
    var t=D.Joint;D=t.dia.Element;var F=t.point,g=t.dia.uml={};t.arrows.aggregation=function(){
        return{
            path:["M","7","0","L","0","5","L","-7","0","L","0","-5","z"],
            dx:9,
            dy:9,
            attrs:{
                stroke:"black",
                "stroke-width":2,
                fill:"black"
            }
            }
        };g.aggregationArrow={
        endArrow:{
            type:"aggregation"
        },
        startArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"none"
        }
        };g.dependencyArrow={
        endArrow:{
            type:"basic",
            size:5
        },
        startArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"none"
        }
        };g.generalizationArrow={
        endArrow:{
            type:"basic",
            size:10,
            attrs:{
                fill:"white"
            }
            },
        startArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"none"
        }
        };g.arrow={
        startArrow:{
            type:"none"
        },
        endArrow:{
            type:"basic",
            size:5
        },
        attrs:{
            "stroke-dasharray":"none"
        }
        };g.State=D.extend({
        object:"State",
        module:"uml",
        init:function(i){
            i=t.DeepSupplement(this.properties,i,{
                radius:15,
                attrs:{
                    fill:"white",
                    "stroke-width":1
                },
                label:"",
                labelAttrs:{
                    "font-weight":"bold"
                },
				textBold:{
                    "font-weight":"bold",
					"text-anchor":"start"
                },
				textNormal:{
                      
					"text-anchor":"start"
                },
                textOperario:{
                    "fill":"00-#fff-#FFF",
					"text-anchor":"start"
                },
                separador:"SI",
                materiales:[],

                labelOffsetX:5,
                labelOffsetY:2,
                labelHeight:14,
                swimlaneOffsetY:18,
                datosMaq:[],
                actions:{
                    actividad:null,
                    Maquinaria:null,
                    inner:[]
                },
                actionsOffsetX:5,
                actionsOffsetY:5,
				coorYText:0,
                descripcion:'',
				attrsDescripcion:{
                    fill:"80-#fff-#fff:1-#FFB6C1",
                    "stroke-width":0
                },
                detailsOffsetY:0,
                codProcesos:'',
                codSubProceso:'',
                operario:'No Registrado',
                operario2:'No Registrado',
				codPersonal:'0',
                codPersonal2:'0',
                observaciones:'',
                conforme:'0',
                cooryOPerario:'0'

            });
            this.calcular(i);
            this.setWrapper(this.paper.rect(i.rect.x,i.rect.y, i.rect.width,i.rect.height,i.radius).attr(i.attrs));
            this.addInner(this.getLabelElement());
            if(i.separador=="SI"){
                this.addInner(this.getSwimlaneElement());
            }

            if(i.materiales.length>0){
			this.getMateriales(this);
			}
            if(i.datosMaq.length>0)this.getMaquinas(this);
			if(i.descripcion!='')this.getDescripcion(this);
			this.getPersonal(this);
			},
        calcular:function(v){

			if(parseInt(v.codSubProceso)>0)
			{
				codProceso=v.codProcesos;
				contmenos++;
				v.rect.y+=contador*60;

			}
			else
			{
				v.rect.y+=(contador-(parseInt(v.codProcesos)==parseInt(codProceso)?contmenos:0))*60;
				contmenos=0;
				codProceso='';
			}

            v.rect.width+=8,
            v.labelHeight=v.detailsOffsetY*16,
			//v.rect.height+=60;
            cont=3,
            v.rect.height+=v.labelOffsetY+60,
            v.rect.x-=(v.rect.width/2)
            contador++;
        },
        getDescripcion:function(g)
        {
			var n=this.properties;

			//g.addInner(g.paper.rect(s.x+n.actionsOffsetX,s.y+n.labelOffsetY+n.labelHeight+n.actionsOffsetY+n.coorYText,400,18*6,n.radius).attr(n.attrsDescripcion));

            var i=this.properties;
            s=this.wrapper.getBBox();i=this.paper.text(s.x+i.actionsOffsetX+6,s.y+i.labelOffsetY+i.labelHeight+i.actionsOffsetY+n.coorYText,'Descripcion:');
                k=i.getBBox();i.attr(n.textBold);i.translate(0,k.height/2);
				n.coorYText+=k.height;
				g.addInner(i);
            i=this.properties;
			s=this.wrapper.getBBox();
			var descripcion=n.descripcion.split(' ');
			var texto="";
			var textoaux="";
			for(var i=0;i<descripcion.length;i++)
			{
				if((sizeText(textoaux,'normal')+sizeText(descripcion[i],'normal'))<400)
				{
					textoaux+=' '+descripcion[i];
				//	console.log(textoaux);
				}
				else{
				texto+=textoaux;
				textoaux='\n'+descripcion[i];
				}
			}
			texto+=textoaux;
			//console.log(descripcion.length);
			i=this.paper.text(s.x+n.actionsOffsetX+5,s.y+n.labelOffsetY+n.labelHeight+n.actionsOffsetY+n.coorYText,/*n.descripcion.split('-').join('\n')*/texto);
			k=i.getBBox();i.attr(n.textNormal);i.translate(0,k.height/2);
			n.coorYText+=k.height;
			g.addInner(i);


        },
        getLabelElement:function(){
            var i=this.properties,
            k=this.wrapper.getBBox();
            if(i.separador!='SI')
                {
                    i.labelAttrs={ "font-weight":400};
                }

            s=this.paper.text(k.x,k.y,i.label.split('-').join('\n')).attr(i.labelAttrs||{});
            x=s.getBBox();s.translate(k.x-x.x+i.labelOffsetX,k.y-x.y+i.labelOffsetY);
            return s
            },
        getSwimlaneElement:function(){
            k=this.properties;
            var i=this.wrapper.getBBox();
            return this.paper.path(["M",i.x,i.y+k.labelOffsetY+k.labelHeight,"L",i.x+i.width,i.y+k.labelOffsetY+k.labelHeight].join(" "))
            },
		getMaquinas:function(g){
			var n=g.properties;
            var i=g.properties;

			s=this.wrapper.getBBox();
            var caja=this.paper.text(s.x+i.actionsOffsetX,s.y+i.labelOffsetY+i.labelHeight+i.actionsOffsetY+n.coorYText,'MAQUINARIAS:');
                k=caja.getBBox();caja.attr(n.textBold);caja.translate(0,k.height/2);i.coorYText+=k.height;g.addInner(caja);

             for(var ap=0;ap<n.datosMaq.length;ap++)
            {
                k='-'+n.datosMaq[ap][0];
				s=this.wrapper.getBBox();i=this.paper.text(s.x+n.actionsOffsetX,s.y+n.labelOffsetY+n.labelHeight+n.actionsOffsetY+n.coorYText,k);
                k=i.getBBox();i.attr(n.textBold);i.translate(0,k.height/2);
				n.coorYText+=k.height;
				g.addInner(i);
				k='';
                for(var ap1=0;ap1<n.datosMaq[ap][1].length;ap1+=2)
                    {
                        st='   '+n.datosMaq[ap][1][ap1]+": "+n.datosMaq[ap][1][ap1+1]+'\n';

						if(st.length+k.length>200)
						{
							//console.log(st+k);
							s=this.wrapper.getBBox();i=this.paper.text(s.x+n.actionsOffsetX,s.y+n.labelOffsetY+n.labelHeight+n.actionsOffsetY+n.coorYText,k);
							k=i.getBBox();i.attr(n.textNormal);i.translate(0,k.height/2);
							n.coorYText+=k.height;
							g.addInner(i);
							k=st;
						}
						else
						{
							k+=st;
						}
                    }
				if(k!='')
				{
					s=this.wrapper.getBBox();i=this.paper.text(s.x+n.actionsOffsetX,s.y+n.labelOffsetY+n.labelHeight+n.actionsOffsetY+n.coorYText,k);
					k=i.getBBox();i.attr(n.textNormal);i.translate(0,k.height/2);
					n.coorYText+=k.height;
					g.addInner(i);
				}
            }

         },
        getMateriales:function(g){
			var n=this.properties;
            var i=this.properties;
				s=this.wrapper.getBBox();i=this.paper.text(s.x+i.actionsOffsetX,s.y+i.labelOffsetY+i.labelHeight+i.actionsOffsetY,'MATERIALES:\n');
                k=i.getBBox();i.attr(n.textBold);i.translate(0,k.height/2);
				n.coorYText+=k.height;
				g.addInner(i);
			i=this.properties;
			var k='';
            for(var m=i.materiales.length,y=0;y<m;y+=2)
                k+='-'+i.materiales[y]+": "+i.materiales[y+1]+"\n";
                k=k.replace(/^\s\s*/,"").replace(/\s\s*$/,"");
                s=this.wrapper.getBBox();i=this.paper.text(s.x+i.actionsOffsetX,s.y+i.labelOffsetY+i.labelHeight+i.actionsOffsetY+n.coorYText,k);
                k=i.getBBox();i.attr(n.textNormal);i.translate(0,k.height/2);
				n.coorYText+=k.height;
				g.addInner(i);
        },
        getPersonal:function(g){
			var n=this.properties;
            var i=this.properties;

			s=this.wrapper.getBBox();i=this.paper.text(s.x+i.actionsOffsetX,s.y+i.labelOffsetY+i.labelHeight+i.actionsOffsetY+n.coorYText,'OPERARIO:');
            k=i.getBBox();i.attr(n.textBold);i.translate(0,k.height/2);
			n.coorYText+=k.height;
			g.addInner(i);
            i=this.properties;
            i.cooryOPerario=s.y+i.labelOffsetY+i.labelHeight+i.actionsOffsetY+n.coorYText;
            h=this.paper.text(s.x+i.actionsOffsetX,s.y+i.labelOffsetY+i.labelHeight+i.actionsOffsetY+n.coorYText,"-"+i.operario+"\n-"+i.operario2);
			s=this.wrapper.getBBox();
            k=h.getBBox();h.attr(n.textNormal);h.translate(0,k.height/2);
			n.coorYText+=k.height;
			g.addInner(h);
			i=this.properties;
			s=this.wrapper.getBBox();i=this.paper.text(s.x+i.actionsOffsetX,s.y+i.labelOffsetY+i.labelHeight+i.actionsOffsetY+n.coorYText,'CONFORME:'+(i.conforme=='1'?'SI':(i.conforme=='0'?'NO':'')));
            k=i.getBBox();i.attr(n.textBold);i.translate(0,k.height/2);
			n.coorYText+=k.height;
			g.addInner(i);
            i=this.properties;
			s=this.wrapper.getBBox();i=this.paper.text(s.x+i.actionsOffsetX,s.y+i.labelOffsetY+i.labelHeight+i.actionsOffsetY+n.coorYText,'OBSERVACIONES');
            k=i.getBBox();i.attr(n.textBold);i.translate(0,k.height/2);
			n.coorYText+=k.height;
			g.addInner(i);
            i=this.properties;
            
			s=this.wrapper.getBBox();i=this.paper.text(s.x+i.actionsOffsetX,s.y+i.labelOffsetY+i.labelHeight+i.actionsOffsetY+n.coorYText,i.observaciones);
            k=i.getBBox();i.attr(n.textNormal);i.translate(0,k.height/2);
			n.coorYText+=k.height;
			g.addInner(i);
        },
		updatePersonal:function(g,codigoPersonal,nombrePersonal,estadoConforme,codigoPersonal2,nombrePersonal2,observacion){

            g.inner[g.inner.length-1].hide();
            g.inner[g.inner.length-2].hide();
            g.inner[g.inner.length-3].hide();
            g.inner[g.inner.length-4].hide();
            var n=this.properties;
            n.operario2=nombrePersonal2;
            n.operario=nombrePersonal;
            n.codPersonal=codigoPersonal;
            n.codPersonal2=codigoPersonal2;
            n.observaciones=observacion;
            n.conforme=estadoConforme;
			var i=this.properties;
            var hed=0;
			s=this.wrapper.getBBox();i=this.paper.text(s.x+i.actionsOffsetX,i.cooryOPerario,'-'+i.operario.trim()+"\n-"+i.operario2.trim());
            k=i.getBBox();i.attr(n.textNormal);i.translate(0,k.height/2);
			g.addInner(i);
			i=this.properties;
            hed=k.height;
			s=this.wrapper.getBBox();i=this.paper.text(s.x+i.actionsOffsetX,i.cooryOPerario+hed,'CONFORME:'+(i.conforme=='1'?'SI':(i.conforme=='0'?'NO':'')));
            k=i.getBBox();i.attr(n.textBold);i.translate(0,k.height/2);
			g.addInner(i);
            hed+=k.height;
             i=this.properties;
			s=this.wrapper.getBBox();i=this.paper.text(s.x+i.actionsOffsetX,i.cooryOPerario+hed,'OBSERVACIONES');
            k=i.getBBox();i.attr(n.textBold);i.translate(0,k.height/2);
			n.coorYText+=k.height;
			g.addInner(i);
            hed+=k.height;
            i=this.properties;
            s=this.wrapper.getBBox();i=this.paper.text(s.x+i.actionsOffsetX,i.cooryOPerario+hed,i.observaciones);
            k=i.getBBox();i.attr(n.textNormal);i.translate(0,k.height/2);
			n.coorYText+=k.height;
			g.addInner(i);
        },
        asignarOperario:function(arrayCods)
        {

            var n=this.properties;

            for(var i=0;i<arrayCods.length;i+=5)
            {
                if(arrayCods[i]==n.codProcesos && arrayCods[i+1]==n.codSubProceso)
                    {

                        this.updatePersonal(this,arrayCods[i+2],arrayCods[i+3],arrayCods[i+4]);
                        return true;

                    }
            }
            return false;
        }
        ,
        zoom:function(){
            this.wrapper.attr("r",this.properties.radius);this.shadow&&this.shadow.attr("r",this.properties.radius);this.inner[0].remove();this.inner[1].remove();this.inner[2].remove();this.inner[0]=this.getLabelElement();this.inner[1]=this.getSwimlaneElement();this.inner[2]=this.getActionsElement()
            }
        });g.StartState=D.extend({
        object:"StartState",
        module:"uml",
        init:function(i){
            i=t.DeepSupplement(this.properties,i,{
                position:F(0, 0),
                radius:10,
                attrs:{
                    fill:"black"
                }
                });this.setWrapper(this.paper.circle(i.position.x,i.position.y,i.radius).attr(i.attrs))
            }
        });g.EndState=D.extend({
        object:"EndState",
        module:"uml",
        init:function(i){
            i=t.DeepSupplement(this.properties,i,{
                position:F(0,0),
                radius:10,
                innerRadius:i.radius&&i.radius/2||5,
                attrs:{
                    fill:"white"
                },
                innerAttrs:{
                    fill:"black"
                }
                });this.setWrapper(this.paper.circle(i.position.x,i.position.y,i.radius).attr(i.attrs));this.addInner(this.paper.circle(i.position.x,i.position.y,i.innerRadius).attr(i.innerAttrs))
            },
        zoom:function(){
            this.inner[0].scale.apply(this.inner[0],arguments)
            }
        });g.Class=D.extend({
        object:"Class",
        module:"uml",
        init:function(i){
            i=t.DeepSupplement(this.properties,i,{
                attrs:{
                    fill:"white"
                },
                label:"",
                labelOffsetX:20,
                labelOffsetY:5,
                swimlane1OffsetY:18,
                swimlane2OffsetY:18,
                attributes:[],
                attributesOffsetX:5,
                attributesOffsetY:5,
                methods:[],
                methodsOffsetX:5,
                methodsOffsetY:5
            });this.setWrapper(this.paper.rect(i.rect.x,i.rect.y,i.rect.width,i.rect.height).attr(i.attrs));this.addInner(this.getLabelElement()); this.addInner(this.getSwimlane1Element());this.addInner(this.getAttributesElement());this.addInner(this.getSwimlane2Element());this.addInner(this.getMethodsElement())
            },
        getLabelElement:function(){
            var i=this.properties,k=this.wrapper.getBBox(),s=this.paper.text(k.x,k.y,i.label).attr(i.labelAttrs||{}),x=s.getBBox();s.translate(k.x-x.x+i.labelOffsetX,k.y-x.y+i.labelOffsetY);return s
            },
        getSwimlane1Element:function(){
            var i=this.wrapper.getBBox(),k=this.properties;return this.paper.path(["M",i.x,i.y+k.labelOffsetY+ k.swimlane1OffsetY,"L",i.x+i.width,i.y+k.labelOffsetY+k.swimlane1OffsetY].join(" "))
            },
        getSwimlane2Element:function(){
            var i=this.properties,k=this.wrapper.getBBox(),s=this.inner[2].getBBox();return this.paper.path(["M",k.x,k.y+i.labelOffsetY+i.swimlane1OffsetY+s.height+i.swimlane2OffsetY,"L",k.x+k.width,k.y+i.labelOffsetY+i.swimlane1OffsetY+s.height+i.swimlane2OffsetY].join(" "))
            },
        getAttributesElement:function(){
            for(var i=" ",k=this.properties,s=0,x=k.attributes.length;s<x;s++)i+=k.attributes[s]+"\n"; i=i.replace(/^\s\s*/,"").replace(/\s\s*$/,"");s=this.wrapper.getBBox();i=this.paper.text(s.x+k.attributesOffsetX,s.y+k.labelOffsetY+k.swimlane1OffsetY+k.attributesOffsetY,i);k=i.getBBox();i.attr("text-anchor","start");i.translate(0,k.height/2);return i
            },
        getMethodsElement:function(){
            for(var i=" ",k=this.properties,s=0,x=k.methods.length;s<x;s++)i+=k.methods[s]+"\n";i=i.replace(/^\s\s*/,"").replace(/\s\s*$/,"");s=this.wrapper.getBBox();x=this.inner[2].getBBox();i=this.paper.text(s.x+k.methodsOffsetX, s.y+k.labelOffsetY+k.swimlane1OffsetY+k.attributesOffsetY+x.height+k.swimlane2OffsetY+k.methodsOffsetY,i);k=i.getBBox();i.attr("text-anchor","start");i.translate(0,k.height/2);return i
            },
        zoom:function(){
            this.inner[0].remove();this.inner[1].remove();this.inner[2].remove();this.inner[3].remove();this.inner[4].remove();this.inner[0]=this.getLabelElement();this.inner[1]=this.getSwimlane1Element();this.inner[2]=this.getAttributesElement();this.inner[3]=this.getSwimlane2Element();this.inner[4]=this.getMethodsElement()
            }
        })
    })(this);(function(D){
    var t=D.Joint;D=t.dia.Element;var F=t.point,g=t.dia.fsa={};g.arrow={
        startArrow:{
            type:"none"
        },
        endArrow:{
            type:"basic",
            size:5
        },
        attrs:{
            "stroke-dasharray":"none"
        }
        };g.State=D.extend({
        object:"State",
        module:"fsa",
        init:function(i){
            i=t.DeepSupplement(this.properties,i,{
                position:F(0,0),
                radius:30,
                label:"State",
                labelOffsetX:15,
                labelOffsetY:23,
                attrs:{
                    fill:"white"
                }
                });this.setWrapper(this.paper.circle(i.position.x,i.position.y,i.radius).attr(i.attrs));this.addInner(this.getLabelElement())
            },
        getLabelElement:function(){
            var i= this.properties,k=this.wrapper.getBBox(),s=this.paper.text(k.x,k.y,i.label),x=s.getBBox();s.translate(k.x-x.x+i.labelOffsetX,k.y-x.y+i.labelOffsetY);return s
            }
        });g.StartState=D.extend({
        object:"StartState",
        module:"fsa",
        init:function(i){
            i=t.DeepSupplement(this.properties,i,{
                position:F(0,0),
                radius:10,
                attrs:{
                    fill:"black"
                }
                });this.setWrapper(this.paper.circle(i.position.x,i.position.y,i.radius).attr(i.attrs))
            }
        });g.EndState=D.extend({
        object:"EndState",
        module:"fsa",
        init:function(i){
            i=t.DeepSupplement(this.properties, i,{
                position:F(0,0),
                radius:10,
                innerRadius:i.radius&&i.radius/2||5,
                attrs:{
                    fill:"white"
                },
                innerAttrs:{
                    fill:"black"
                }
                });this.setWrapper(this.paper.circle(i.position.x,i.position.y,i.radius).attr(i.attrs));this.addInner(this.paper.circle(i.position.x,i.position.y,i.innerRadius).attr(i.innerAttrs))
            },
        zoom:function(){
            this.inner[0].scale.apply(this.inner[0],arguments)
            }
        })
    })(this);(function(D){
    var t=D.Joint;D=t.dia.Element;var F=t.dia.pn={};F.arrow={
        startArrow:{
            type:"none"
        },
        endArrow:{
            type:"basic",
            size:5
        },
        attrs:{
            "stroke-dasharray":"none"
        }
        };F.Place=D.extend({
        object:"Place",
        module:"pn",
        init:function(g){
            g=t.DeepSupplement(this.properties,g,{
                radius:20,
                tokenRadius:3,
                tokens:0,
                attrs:{
                    fill:"white"
                },
                tokenAttrs:{
                    fill:"black"
                }
                });var i=this.paper;this.setWrapper(i.circle(g.position.x,g.position.y,g.radius).attr(g.attrs));switch(g.tokens){
                case 0:break;case 1:this.addInner(i.circle(g.position.x, g.position.y,g.tokenRadius).attr(g.tokenAttrs));break;case 2:this.addInner(i.circle(g.position.x-g.tokenRadius*2,g.position.y,g.tokenRadius).attr(g.tokenAttrs));this.addInner(i.circle(g.position.x+g.tokenRadius*2,g.position.y,g.tokenRadius).attr(g.tokenAttrs));break;case 3:this.addInner(i.circle(g.position.x-g.tokenRadius*2-2,g.position.y,g.tokenRadius).attr(g.tokenAttrs));this.addInner(i.circle(g.position.x+g.tokenRadius*2+2,g.position.y,g.tokenRadius).attr(g.tokenAttrs));this.addInner(i.circle(g.position.x, g.position.y,g.tokenRadius).attr(g.tokenAttrs));break;default:this.addInner(i.text(g.position.x,g.position.y,g.tokens.toString()))
                    }if(g.label){
                this.addInner(i.text(g.position.x,g.position.y-g.radius,g.label));this.inner[this.inner.length-1].translate(0,-this.inner[this.inner.length-1].getBBox().height)
                }
            },
        zoom:function(){
            for(var g=0,i=this.inner.length;g<i;g++)this.inner[g].scale.apply(this.inner[g],arguments);if(this.label){
                this.inner[this.inner.length-1].remove();g=this.wrapper.getBBox();this.inner[this.inner.length- 1]=this.paper.text(g.x,g.y,this.properties.label);this.inner[this.inner.length-1].translate(0,-this.inner[this.inner.length-1].getBBox().height)
                }
            }
        });F.Event=D.extend({
        object:"Event",
        module:"pn",
        init:function(g){
            g=t.DeepSupplement(this.properties,g,{
                attrs:{
                    fill:"black",
                    stroke:"black"
                }
                });var i=this.paper;this.setWrapper(i.rect(g.rect.x,g.rect.y,g.rect.width,g.rect.height).attr(g.attrs));if(g.label){
                this.addInner(i.text(g.rect.x,g.rect.y,g.label));this.inner[0].translate(0,-this.inner[0].getBBox().height)
                }
            },
        zoom:function(){
            if(this.properties.label){
                this.inner[0].remove();var g=this.wrapper.getBBox();this.inner[0]=this.paper.text(g.x,g.y,this.properties.label);this.inner[0].translate(0,-this.inner[0].getBBox().height)
                }
            }
        })
    })(this);(function(D){
    var t=D.Joint;D=t.dia.Element;var F=t.dia.devs={};F.arrow={
        endArrow:{
            type:"none"
        },
        startArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"none"
        }
        };F.Model=D.extend({
        object:"Model",
        module:"devs",
        init:function(g){
            g=t.DeepSupplement(this.properties,g,{
                labelOffsetX:20,
                labelOffsetY:5,
                portsOffsetX:5,
                portsOffsetY:20,
                iPortRadius:5,
                oPortRadius:5,
                iPortAttrs:{
                    fill:"green",
                    stroke:"black"
                },
                oPortAttrs:{
                    fill:"red",
                    stroke:"black"
                },
                iPortLabelOffsetX:-10,
                iPortLabelOffsetY:-10,
                oPortLabelOffsetX:10,
                oPortLabelOffsetY:-10,
                iPorts:[],
                oPorts:[]
            });var i;this.setWrapper(this.paper.rect(g.rect.x,g.rect.y,g.rect.width,g.rect.height).attr(g.attrs));this.addInner(this.getLabelElement());i=0;for(l=g.iPorts.length;i<l;i++)this.addInner(this.getPortElement("i",i+1,g.iPorts[i]));i=0;for(l=g.oPorts.length;i<l;i++)this.addInner(this.getPortElement("o",i+1,g.oPorts[i]));g.iPorts=g.oPorts=g.portsOffsetX=g.portsOffsetY=g.iPortRadius=g.oPortRadius=g.iPortAttrs=g.oPortAttrs=g.iPortLabelOffsetX=g.iPortLabelOffsetY=g.oPortLabelOffsetX= g.oPortLabelOffsetY=undefined
            },
        getLabelElement:function(){
            var g=this.properties,i=this.wrapper.getBBox(),k=this.paper.text(i.x,i.y,g.label).attr(g.labelAttrs||{}),s=k.getBBox();k.translate(i.x-s.x+g.labelOffsetX,i.y-s.y+g.labelOffsetY);return k
            },
        getPortElement:function(g,i,k){
            var s=this.wrapper.getBBox(),x=this.properties;return F.Port.create({
                label:k,
                type:g,
                position:{
                    x:s.x+(g==="o"?s.width:0),
                    y:s.y+x.portsOffsetY*i
                    },
                radius:x[g+"PortRadius"],
                attrs:x[g+"PortAttrs"],
                offsetX:x[g+"PortLabelOffsetX"],
                offsetY:x[g+"PortLabelOffsetY"]
                })
            },
        port:function(g,i){
            for(var k,s=0,x=this.inner.length;s<x;s++){
                k=this.inner[s];if(k.properties&&i==k.properties.label&&g==k.properties.type)return k
                    }
            },
        joint:function(g,i,k,s){
            if(i.port)return this.port("o",g).joint(i.port("i",k),s)
                },
        zoom:function(){}
        });F.Port=D.extend({
        object:"Port",
        module:"devs",
        init:function(g){
            g=t.DeepSupplement(this.properties,g,{
                label:"",
                offsetX:0,
                offsetY:0,
                type:"i"
            });this.setWrapper(this.paper.circle(g.position.x,g.position.y,g.radius).attr(g.attrs)); this.addInner(this.getLabelElement())
            },
        getLabelElement:function(){
            var g=this.wrapper.getBBox(),i=this.properties,k=this.paper.text(g.x,g.y,i.label),s=k.getBBox();k.translate(g.x-s.x+i.offsetX,g.y-s.y+i.offsetY);return k
            },
        zoom:function(){}
        })
    })(this);(function(D){
    var t=D.Joint;D=t.dia.Element;var F=t.dia.cdm={};t.arrows.crowfoot=function(g){
        g=g||2;return{
            path:["M",(4*g).toString(),4*g.toString(),"L",(-4*g).toString(),"0","L",(4*g).toString(),"0","M",(-4*g).toString(),"0","L",(4*g).toString(),(-g*4).toString()],
            dx:4*g,
            dy:4*g,
            attrs:{
                stroke:"#800040",
                fill:"none",
                "stroke-width":1
            }
            }
        };t.arrows.crowfootdashed=function(g){
        g=g||2;return{
            path:["M",(4*g).toString(),4*g.toString(),"L",(-4*g).toString(),"0","L",(g/4).toString(),"0","M",(2*g).toString(),"0", "L",(4*g).toString(),"0","M",(-4*g).toString(),"0","L",(4*g).toString(),(-g*4).toString()],
            dx:4*g,
            dy:4*g,
            attrs:{
                stroke:"#800040",
                fill:"white",
                "stroke-width":1
            }
            }
        };F.oneToMany={
        endArrow:{
            type:"crowfoot"
        },
        startArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"none",
            stroke:"#800040"
        }
        };F.manyToOne={
        startArrow:{
            type:"crowfoot"
        },
        endArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"none",
            stroke:"#800040"
        }
        };F.manyToMany={
        startArrow:{
            type:"crowfoot"
        },
        endArrow:{
            type:"crowfoot"
        },
        attrs:{
            "stroke-dasharray":"none",
            stroke:"#800040"
        }
        }; F.plain={
        startArrow:{
            type:"none"
        },
        endArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"none",
            stroke:"#800040"
        }
        };F.arrow={
        startArrow:{
            type:"none"
        },
        endArrow:{
            type:"basic",
            size:5,
            attrs:{
                fill:"#800040",
                stroke:"#800040"
            }
            },
        attrs:{
            "stroke-dasharray":"none",
            stroke:"#800040"
        }
        };F.oneToManyDashes={
        endArrow:{
            type:"crowfootdashed"
        },
        startArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"--",
            stroke:"#800040"
        }
        };F.manyToOneDashes={
        startArrow:{
            type:"crowfootdashed"
        },
        endArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"--",
            stroke:"#800040"
        }
        };F.manyToManyDashes={
        startArrow:{
            type:"crowfoot"
        },
        endArrow:{
            type:"crowfoot"
        },
        attrs:{
            "stroke-dasharray":"-- ",
            stroke:"#800040"
        }
        };F.exampleArrow={
        startArrow:{
            type:"crowfoot"
        },
        endArrow:{
            type:"crowfootdashed"
        },
        attrs:{
            "stroke-dasharray":"--",
            stroke:"#800040"
        },
        subConnectionAttrs:[{
            from:1.1,
            to:0.5,
            "stroke-dasharray":"none",
            stroke:"#800040"
        }],
        label:["many","many"],
        labelAttrs:[{
            position:20,
            offset:-10
        },{
            position:-20,
            offset:-10
        }]
        };F.dashes={
        startArrow:{
            type:"none"
        },
        endArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"--",
            stroke:"#800040"
        }
        };F.Entity=D.extend({
        object:"Entity",
        module:"cdm",
        init:function(g){
            g=t.DeepSupplement(this.properties,g,{
                radius:10,
                attrs:{
                    fill:"white"
                },
                label:"",
                labelOffsetX:20,
                labelOffsetY:5,
                actions:{
                    actividad:null,
                    Maquinaria:null,
                    inner:[]
                },
                attributesOffsetX:5,
                attributesOffsetY:5
            });this.setWrapper(this.paper.rect(g.rect.x,g.rect.y,g.rect.width,g.rect.height,g.radius).attr(g.attrs));this.addInner(this.getLabelElement());this.addInner(this.getAttributesElement())
            },
        getLabelElement:function(){
            var g=this.properties, i=this.wrapper.getBBox(),k=this.paper.text(i.x,i.y,g.label).attr(g.labelAttrs||{}),s=k.getBBox();k.translate(i.x-s.x+g.labelOffsetX,i.y-s.y+g.labelOffsetY);return k
            },
        getAttributesElement:function(){
            var g=this.properties,i=g.actions.actividad?"actividad/ "+g.actions.actividad+"\n":"";i+=g.actions.Maquinaria?"Maquinaria/ "+g.actions.Maquinaria+"\n":"";for(var k=g.actions.inner.length,s=0;s<k;s+=2)i+=g.actions.inner[s]+"/ "+g.actions.inner[s+1]+"\n";i=i.replace(/^\s\s*/,"").replace(/\s\s*$/,"");k=this.wrapper.getBBox();g=this.paper.text(k.x+ g.attributesOffsetX,k.y+g.labelOffsetY+g.attributesOffsetY,i);i=g.getBBox();g.attr("text-anchor","start");g.translate(0,i.height/2);return g
            },
        zoom:function(){
            this.wrapper.attr("r",this.properties.radius);this.shadow&&this.shadow.attr("r",this.properties.radius);this.inner[0].remove();this.inner[1].remove();this.inner[0]=this.getLabelElement();this.inner[1]=this.getAttributesElement()
            }
        })
    })(this);(function(D){
    var t=D.Joint;D=t.dia.Element;var F=t.dia.erd={};F.arrow={
        startArrow:{
            type:"none"
        },
        endArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"none"
        }
        };F.toMany={
        startArrow:{
            type:"none"
        },
        endArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"none"
        },
        label:"n",
        labelAttrs:{
            position:-10,
            offset:-10
        }
        };F.manyTo={
        startArrow:{
            type:"none"
        },
        endArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"none"
        },
        label:"n",
        labelAttrs:{
            position:10,
            offset:-10
        }
        };F.toOne={
        startArrow:{
            type:"none"
        },
        endArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"none"
        },
        label:"1",
        labelAttrs:{
            position:-10,
            offset:-10
        }
        };F.oneTo={
        startArrow:{
            type:"none"
        },
        endArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"none"
        },
        label:"1",
        labelAttrs:{
            position:10,
            offset:-10
        }
        };F.oneToMany={
        startArrow:{
            type:"none"
        },
        endArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"none"
        },
        label:["1","n"],
        labelAttrs:[{
            position:10,
            offset:-10
        },{
            position:-10,
            offset:-10
        }]
        };F.manyToOne={
        startArrow:{
            type:"none"
        },
        endArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"none"
        },
        label:["n","1"],
        labelAttrs:[{
            position:10,
            offset:-10
        }, {
            position:-10,
            offset:-10
        }]
        };F.Entity=D.extend({
        object:"Entity",
        module:"erd",
        init:function(g){
            g=t.DeepSupplement(this.properties,g,{
                attrs:{
                    fill:"lightgreen",
                    stroke:"#008e09",
                    "stroke-width":2
                },
                label:"",
                labelAttrs:{
                    "font-weight":"bold"
                },
                shadow:true,
                weak:false,
                padding:5
            });this.setWrapper(this.paper.rect(g.rect.x,g.rect.y,g.rect.width,g.rect.height).attr(g.attrs));g.weak&&this.addInner(this.paper.rect(g.rect.x+g.padding,g.rect.y+g.padding,g.rect.width-2*g.padding,g.rect.height-2*g.padding).attr(g.attrs)); this.addInner(this.getLabelElement())
            },
        getLabelElement:function(){
            var g=this.properties,i=this.wrapper.getBBox(),k=this.paper.text(i.x+i.width/2,i.y+i.height/2,g.label).attr(g.labelAttrs||{}),s=k.getBBox();k.translate(i.x-s.x+g.labelOffsetX,i.y-s.y+g.labelOffsetY);return k
            }
        });F.Relationship=D.extend({
        object:"Relationship",
        module:"erd",
        init:function(g){
            g=t.DeepSupplement(this.properties,g,{
                attrs:{
                    rotation:45,
                    fill:"lightblue",
                    stroke:"#000d5b",
                    "stroke-width":2
                },
                label:"",
                labelAttrs:{
                    "font-weight":"bold"
                }
                }); this.setWrapper(this.paper.rect(g.rect.x,g.rect.y,g.rect.width,g.rect.height).attr(g.attrs));this.addInner(this.getLabelElement())
            },
        getLabelElement:function(){
            var g=this.properties,i=this.wrapper.getBBox(),k=this.paper.text(i.x+i.width/2,i.y+i.height/2,g.label).attr(g.labelAttrs||{}),s=k.getBBox();k.translate(i.x-s.x+g.labelOffsetX,i.y-s.y+g.labelOffsetY);return k
            }
        });F.Attribute=D.extend({
        object:"Attribute",
        module:"erd",
        init:function(g){
            g=t.DeepSupplement(this.properties,g,{
                attrs:{
                    fill:"red",
                    opacity:g.primaryKey? 0.8:0.5,
                    stroke:"#5b0001",
                    "stroke-width":2,
                    "stroke-dasharray":g.derived?".":"none"
                    },
                label:"",
                labelAttrs:{
                    "font-weight":"bold"
                },
                multivalued:false,
                derived:false,
                padding:5
            });this.setWrapper(this.paper.ellipse(g.ellipse.x,g.ellipse.y,g.ellipse.rx,g.ellipse.ry).attr(g.attrs));g.multivalued&&this.addInner(this.paper.ellipse(g.ellipse.x,g.ellipse.y,g.ellipse.rx-g.padding,g.ellipse.ry-g.padding).attr(g.attrs));this.addInner(this.getLabelElement())
            },
        getLabelElement:function(){
            var g=this.properties,i=this.wrapper.getBBox(), k=this.paper.text(i.x+i.width/2,i.y+i.height/2,g.label).attr(g.labelAttrs||{}),s=k.getBBox();k.translate(i.x-s.x+g.labelOffsetX,i.y-s.y+g.labelOffsetY);return k
            }
        })
    })(this);(function(D){
    var t=D.Joint;D=t.dia.Element;var F=t.dia.org={};F.arrow={
        startArrow:{
            type:"none"
        },
        endArrow:{
            type:"none"
        },
        attrs:{
            "stroke-dasharray":"none",
            "stroke-width":2,
            stroke:"gray"
        }
        };F.Member=D.extend({
        object:"Member",
        module:"org",
        init:function(g){
            g=t.DeepSupplement(this.properties,g,{
                attrs:{
                    fill:"lightgreen",
                    stroke:"#008e09",
                    "stroke-width":2
                },
                name:"",
                position:"",
                nameAttrs:{
                    "font-weight":"bold"
                },
                positionAttrs:{},
                swimlaneAttrs:{
                    "stroke-width":1,
                    stroke:"black"
                },
                labelOffsetY:10,
                radius:10,
                shadow:true,
                avatar:"",
                padding:5
            });this.setWrapper(this.paper.rect(g.rect.x,g.rect.y,g.rect.width,g.rect.height,g.radius).attr(g.attrs));if(g.avatar){
                this.addInner(this.paper.image(g.avatar,g.rect.x+g.padding,g.rect.y+g.padding,g.rect.height-2*g.padding,g.rect.height-2*g.padding));g.labelOffsetX=g.rect.height
                }if(g.position){
                g=this.getPositionElement();this.addInner(g[0]);this.addInner(g[1])
                }this.addInner(this.getNameElement())
            },
        getPositionElement:function(){
            var g=this.properties,i=this.wrapper.getBBox(),k=this.paper.text(i.x+ i.width/2,i.y+i.height/2,g.position).attr(g.positionAttrs||{}),s=k.getBBox();k.translate(i.x-s.x+g.labelOffsetX,i.y-s.y+s.height);s=k.getBBox();g=this.paper.path(["M",s.x,s.y+s.height+g.padding,"L",s.x+s.width,s.y+s.height+g.padding].join(" "));return[k,g]
            },
        getNameElement:function(){
            var g=this.properties,i=this.wrapper.getBBox(),k=this.paper.text(i.x+i.width/2,i.y+i.height/2,g.name).attr(g.nameAttrs||{}),s=k.getBBox();k.translate(i.x-s.x+g.labelOffsetX,i.y-s.y+s.height*2+g.labelOffsetY);return k
            }
        })
    })(this);(function(D){
    D=D.Joint.arrows;D.hand=function(t){
        t=t?1+0.1*t:1;return{
            path:["M","-15.681352","-5.1927657","C","-15.208304","-5.2925912","-14.311293","-5.5561164","-13.687993","-5.7783788","C","-13.06469","-6.0006406","-12.343434","-6.2537623","-12.085196","-6.3408738","C","-10.972026","-6.7163768","-7.6682017","-8.1305627","-5.9385615","-8.9719142","C","-4.9071402","-9.4736293","-3.9010109","-9.8815423","-3.7027167","-9.8783923","C","-3.5044204","-9.8752373","-2.6780248","-9.5023173","-1.8662751", "-9.0496708","C","-0.49317056","-8.2840047","-0.31169266","-8.2208528","0.73932854","-8.142924","L","1.8690327","-8.0591623","L","2.039166","-7.4474021","C","2.1327395","-7.1109323","2.1514594","-6.8205328","2.0807586","-6.8020721","C","2.010064","-6.783614","1.3825264","-6.7940997","0.68622374","-6.8253794","C","-0.66190616","-6.8859445","-1.1814444","-6.8071497","-1.0407498","-6.5634547","C","-0.99301966","-6.4807831","-0.58251196","-6.4431792","-0.12850911","-6.4798929","C","1.2241412","-6.5892761", "4.7877672","-6.1187783","8.420785","-5.3511477","C","14.547755","-4.056566","16.233479","-2.9820024","15.666933","-0.73209438","C","15.450654","0.12678873","14.920327","0.61899573","14.057658","0.76150753","C","13.507869","0.85232533","12.818867","0.71394493","9.8149232","-0.090643373","C","7.4172698","-0.73284018","6.1067424","-1.0191399","5.8609814","-0.95442248","C","5.6587992","-0.90118658","4.8309652","-0.89582008","4.0213424","-0.94250688","C","3.0856752","-0.99645868","2.5291546","-0.95219288", "2.4940055","-0.82101488","C","2.4635907","-0.70750508","2.4568664","-0.61069078","2.4790596","-0.60585818","C","2.5012534","-0.60103228","2.9422761","-0.59725718","3.4591019","-0.59747878","C","3.9759261","-0.59770008","4.4500472","-0.58505968","4.512693","-0.56939128","C","4.7453841","-0.51117988","4.6195024","0.92436343","4.318067","1.650062","C","3.8772746","2.7112738","2.9836566","3.9064107","2.2797382","4.3761637","C","1.5987482","4.8306065","1.52359","4.9484512","1.8576616","5.0379653","C", "1.9860795","5.0723748","2.2155555","4.9678227","2.3676284","4.8056312","C","2.6253563","4.5307504","2.6497332","4.5328675","2.7268401","4.8368824","C","2.8605098","5.3638848","2.3264901","6.4808604","1.6782299","7.0301956","C","1.3498639","7.30845","0.75844624","8.0404548","0.36396655","8.6568609","C","-0.58027706","10.132325","-0.69217806","10.238528","-1.4487256","10.377186","C","-2.2048498","10.515767","-4.6836995","9.9021604","-6.41268","9.1484214","C","-9.9464649","7.6078865","-10.697587","7.3186028", "-12.142194","6.9417312","C","-13.020384","6.712621","-14.184145","6.4654454","-14.72833","6.3924328","C","-15.272516","6.3194263","-15.731691","6.241583","-15.748724","6.2194535","C","-15.813855","6.1348086","-16.609132","-4.7586323","-16.562804","-4.9315285","C","-16.551052","-4.9753876","-16.154402","-5.0929474","-15.681351","-5.192769","L","-15.681352","-5.1927657","z","M","11.288619","-1.446424","L","10.957631","-0.2111606","L","11.627189","-0.031753373","C","13.374637","0.43647423","14.580622", "0.18262123","15.042031","-0.75056578","C","15.503958","-1.6847955","14.648263","-2.6070187","12.514834","-3.4742549","L","11.634779","-3.8320046","L","11.627191","-3.2568392","C","11.623019","-2.9405087","11.470661","-2.1258178","11.288619","-1.446424","z"],
            dx:t*17,
            dy:t*17,
            attrs:{
                scale:t,
                fill:"white"
            }
            }
        };D.flower=function(t){
        t=t?1+0.1*t:1;return{
            path:["M","14.407634","0.14101164","C","13.49394","-0.67828198","12.640683","-1.3981484","11.695412","-1.9684748","C","9.0580339","-3.5615387","6.1975385", "-4.0965167","3.8809003","-3.2050972","C","-1.0202735","-1.4355585","-2.2650956","-0.75266958","-6.1678175","-0.75266958","L","-6.1678175","-2.0100414","C","-1.8745566","-2.0888183","1.0024122","-3.7090503","1.8649218","-6.1147565","C","2.2734082","-7.1733737","2.0690534","-8.5444386","0.7737959","-9.8037723","C","-0.82956951","-11.36162","-5.2455289","-11.821547","-6.0950803","-7.2474282","C","-5.3751604","-7.7316963","-3.8041596","-7.6860056","-3.2477662","-6.7174716","C","-2.8775009","-5.9772878", "-3.0228781","-5.1443269","-3.3412911","-4.7534348","C","-3.7218578","-4.1236184","-4.935379","-3.5168459","-6.1678175","-3.5168459","L","-6.1678175","-5.6886834","L","-8.5890734","-5.6886834","L","-8.5890734","-1.1787104","C","-9.8368017","-1.2379009","-10.838424","-1.918296","-11.394817","-3.1843135","C","-11.92063","-3.0214395","-12.984452","-2.2582108","-12.911997","-1.2099015","C","-14.045721","-1.0028338","-14.687381","-0.80225028","-15.717737","0.14101164","C","-14.687714","1.0836088","-14.046053", "1.2744822","-12.911997","1.4815506","C","-12.984786","2.5298263","-11.92063","3.2930879","-11.394817","3.4559626","C","-10.838424","2.1902771","-9.8368017","1.5095164","-8.5890734","1.4503588","L","-8.5890734","5.9603315","L","-6.1678175","5.9603315","L","-6.1678175","3.788495","C","-4.935379","3.788495","-3.7218578","4.3958989","-3.3412911","5.0250837","C","-3.0228781","5.4159757","-2.8775009","6.2482381","-3.2477662","6.9891209","C","-3.8041596","7.9569902","-5.3751604","8.003345","-6.0950803", "7.5190778","C","-5.2455353","12.093197","-0.82956631","11.643978","0.7737959","10.08583","C","2.0693864","8.827128","2.2734082","7.4453226","1.8649218","6.3864056","C","1.00208","3.980998","-1.8745566","2.3705098","-6.1678175","2.2920986","L","-6.1678175","1.0243179","C","-2.2650956","1.0243179","-1.0206064","1.7065088","3.8809003","3.4767455","C","6.1975385","4.367168","9.0580339","3.8331873","11.695412","2.2401238","C","12.640683","1.669431","13.493608","0.95964074","14.407634","0.14101164","z"],
            dx:t*15,
            dy:t*15,
            attrs:{
                scale:t,
                fill:"white"
            }
            }
        };D.rect=function(t){
        t||(t=5);return{
            path:["M",(3*t).toString(),t.toString(),"L",(-3*t).toString(),t.toString(),"L",(-3*t).toString(),(-t).toString(),"L",(3*t).toString(),(-t).toString(),"z"],
            dx:3*t,
            dy:3*t,
            attrs:{
                stroke:"black",
                fill:"white",
                "stroke-width":1
            }
            }
        }
    })(this);(function(D){
    var t=D.Joint;t.Mixin(t.prototype,{
        compact:function(){
            var F=this.startObject(),g=this.endObject(),i=this._registeredObjects,k=i.length,s={
                object:"joint",
                euid:this.euid(),
                opt:this._opt,
                from:undefined,
                to:undefined,
                registered:{
                    start:[],
                    end:[],
                    both:[]
                }
                };if(F.wholeShape)s.from=F.wholeShape.euid();if(g.wholeShape)s.to=g.wholeShape.euid();if(this.isStartDummy())s.from=F.attrs.cx+"@"+F.attrs.cy;if(this.isEndDummy())s.to=g.attrs.cx+"@"+g.attrs.cy;for(;k--;){
                F=i[k];s.registered[F._capToStick|| "both"].push(F.euid())
                }return s
            },
        stringify:function(){
            return JSON.stringify(this.compact())
            }
        });t.Mixin(t.dia,{
        clone:function(){
            return this.parse(this.stringify(t.paper()))
            },
        parse:function(F){
            F=JSON.parse(F);var g,i,k,s=[],x,v,J={},L=[];F instanceof Array||(F=[F]);x=0;for(v=F.length;x<v;x++){
                g=F[x];i=g.module;k=g.object;if(k==="joint"){
                    s.push(g);L.push(g)
                    }else{
                    if(this[i])if(this[i][k])i=this[i][k].create(g);else{
                        console.error("Object "+k+" of module "+i+" is missing.");return
                    }else{
                        console.error("Module "+ i+" is missing.");return
                    }if(g.euid)J[g.euid]=i;i.translate(g.dx,g.dy);i.scale(g.sx,g.sy);L.push(i)
                    }
                }this.hierarchize(J);this.createJoints(s,J);return L
            },
        hierarchize:function(F){
            var g,i;for(g in F)if(F.hasOwnProperty(g)){
                i=F[g];i.properties.parent&&F[i.properties.parent]&&F[i.properties.parent].addInner(i)
                }
            },
        createJoints:function(F,g){
            for(var i=F.length,k,s,x,v,J,L,R=["start","end","both"],Z=R.length;i--;){
                k=F[i];s=g[k.from];x=g[k.to];s=s?s.wrapper:{
                    x:k.from.split("@")[0],
                    y:k.from.split("@")[1]
                    };x= x?x.wrapper:{
                    x:k.to.split("@")[0],
                    y:k.to.split("@")[1]
                    };x=this.Joint(s,x,k.opt);s=[];for(Z=R.length;Z--;){
                    L=R[Z];for(J=k.registered[L].length;J--;)if(g[k.registered[L][J]]){
                        v=g[k.registered[L][J]];v._capToStick=L;s.push(v)
                        }
                    }x.registerForever(s)
                }
            },
        stringify:function(F){
            var g,i,k,s=[];g=this._registeredObjects;var x=this._registeredJoints;F=F.euid();if(g[F]){
                g=g[F];for(i=g.length;i--;){
                    k=g[i];k.object&&s.push(k.stringify())
                    }
                }if(x[F]){
                g=x[F];for(i=g.length;i--;){
                    k=g[i];s.push(k.stringify())
                    }
                }return"["+ s.join(",")+"]"
            }
        });t.Mixin(t.dia.Element.prototype,{
        stringify:function(){
            return JSON.stringify(t.Mixin(this.properties,{
                euid:this.euid()
                }))
            },
        clone:function(){
            return t.dia.parse(this.stringify())[0]
            }
        })
    })(this);