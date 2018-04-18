/*
 * general.js
 * Created on 19 de febrero de 2008, 16:50
 *   
 */

/*
 *  @company COFAR 
*  @param nametable nombre de la tabla
 */
var divBloquePantalla;
function bloquearPantalla(){
    if(divBloquePantalla !== null){
        var dominioSistemaDlCalendar = window.location.pathname.split("/")[1];
        divBloquePantalla = document.createElement("div");
        var center =document.createElement("center");
        divBloquePantalla.appendChild(center);
        var divImg = document.createElement("div");
        center.appendChild(divImg);
        divImg.style.height = "64px";
        divImg.style.width = "64px";
        divImg.style.backgroundColor = "#fff";
        divImg.style.marginTop = "60px";
        var img = document.createElement("img");
        img.src = '/'+dominioSistemaDlCalendar+'/img/load3.gif';
        img.style.opacity=0.8;
        divImg.appendChild(img);
        document.body.appendChild(divBloquePantalla);
        divBloquePantalla.style.opacity = 0.8;
        divBloquePantalla.style.height = "100%";
        divBloquePantalla.style.width = "100%";
        divBloquePantalla.style.top = "0px";
        divBloquePantalla.style.backgroundColor = "#ccc";
        divBloquePantalla.style.position = "fixed";
    }
    else{
        divBloquePantalla.style.display = '';
    }
}
function desBloquearPantalla(){
    divBloquePantalla.style.display = 'none';
}
function abrirVentana(url)
{
    url += (url.split("?").length > 1 ? '&' : '?')+'DATA='+(new Date()).getTime().toString();
    window.open(url,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
}
var eventoMensajeTransaccionExitosa=function(){};
var eventoMensajeTransaccionFallida=function(){
    Richfaces.hideModalPanel('panelMensajeTransaccion');
};
function mostrarMensajeTransaccion()
{
    mostrarMensajeTransaccionEvento(function(){});
}
function mostrarMensajeTransaccionEvento(eventoTransaccionExitosa)
{   
    reRenderMensajeTransaccion();
    Richfaces.showModalPanel('panelMensajeTransaccion');
    this.eventoMensajeTransaccionExitosa=function(){
        try
        {
            eventoTransaccionExitosa();
        }
        catch(e){}
        Richfaces.hideModalPanel('panelMensajeTransaccion');
    };
    
}
function redireccionar(dir)
{
    window.location.href=dir+'?data='+(new Date()).getTime().toString();
}


/*
 *  @author Wilmer Manzaneda Chavez
 *  @company COFAR 

 *  @param nametable nombre de la tabla
 */
//funcion validad seleccion de al menos un registro o mas
function alMenosUno(nametable)
{
    var count=0;
    var tabla=document.getElementById(nametable);
    for(var i=0;i<tabla.rows.length;i++)
    {
        if(tabla.rows[i].cells[0].getElementsByTagName('input').length>0&&tabla.rows[i].cells[0].getElementsByTagName('input')[0].type=='checkbox')
        {
            if(tabla.rows[i].cells[0].getElementsByTagName('input')[0].checked)
            {
                count++;
            }
        }
        
    }
    if(count==0)
        alert('No selecciono ningun registro');
    return (count>0);          
}
function seleccionarTodosCheckBox(checkBox)
{
    var tablaBuscar = checkBox.parentNode.parentNode.parentNode.parentNode.getElementsByTagName("tbody")[0];
    var index=checkBox.parentNode.cellIndex;
    for (var i =0; i < tablaBuscar.rows.length; i++)
    {
        if(tablaBuscar.rows[i].cells[index].getElementsByTagName("input")[0]!=null)
        {
            tablaBuscar.rows[i].cells[index].getElementsByTagName("input")[0].checked=checkBox.checked;
            if(tablaBuscar.rows[i].cells[index].getElementsByTagName("input")[0].onclick!=null)
                tablaBuscar.rows[i].cells[index].getElementsByTagName("input")[0].onclick();    
        }
        
    }
}
//funciones para mostrar mensajes
function seleccionarRegistro(checked)
{
     checked.parentNode.parentNode.style.backgroundColor=(checked.checked?'#90EE90':'');
}
function mostrarMensajeHint(mensaje,input)
{
    if(document.getElementById("mensajeHintSistema")==null)
    {
        var span=document.createElement("span");
        span.className='hint';
        span.id='mensajeHintSistema';
        input.parentNode.appendChild(span);
    }
    input.parentNode.style.position='relative';
    document.getElementById("mensajeHintSistema").style.left=input.offsetLeft;
    document.getElementById("mensajeHintSistema").style.top=input.offsetTop-18;
    document.getElementById("mensajeHintSistema").style.display='inline';
    document.getElementById("mensajeHintSistema").innerHTML=mensaje;
    try
    {
        if(document.getElementById("mensajeHintSistema").addEventListener)
        {
            
            document.getElementById("mensajeHintSistema").addEventListener("click",function(){ocultarMensajeHint();},true);
            input.addEventListener("click",function(){ocultarMensajeHint();},true);
            input.addEventListener("change",function(){ocultarMensajeHint();},true);
            input.addEventListener("keypress",function(){ocultarMensajeHint();},true);
        }
        else
        {
            document.getElementById("mensajeHintSistema").attachEvent("onclick",function(){ocultarMensajeHint();});
            input.attachEvent("onclick",function(){ocultarMensajeHint();});
            input.attachEvent("onkeypress",function(){ocultarMensajeHint();});
            input.attachEvent("onchange",function(){ocultarMensajeHint();});
        }
    }
    catch(e){alert("datos no soportados favor comuniquese con sistemas "+e.toString());}
}
function ocultarMensajeHint()
{
    try
    {
        var mensaje=document.getElementById("mensajeHintSistema");
        mensaje.parentNode.removeChild(mensaje);
    }
    catch(e){}
}




function buscarCeldaAgregar(input,fila)
{
    var tablaBuscar = input.parentNode.parentNode.parentNode.parentNode.getElementsByTagName("tbody")[0];
    var textoBuscar= input.value.toLowerCase();
    var encontrado=false;
    for (var i =1; i < tablaBuscar.rows.length; i++)
    {
        encontrado=false;
        if ((tablaBuscar.rows[i].cells[0].getElementsByTagName("input")[0]!=null&&tablaBuscar.rows[i].cells[0].getElementsByTagName("input")[0].checked)||textoBuscar.length==0 || (tablaBuscar.rows[i].cells[fila].innerHTML.toLowerCase().indexOf(textoBuscar) > -1))
        {
            encontrado= true;
        }

        if(encontrado)
        {
            tablaBuscar.rows[i].style.display = '';
        } else {
            tablaBuscar.rows[i].style.display = 'none';
        }
    }
}
function redondeoHalfUp(numero,cantidadDecimales)
{
    numero=new Number(numero);
    numero=numero*Math.pow(10,2);
    numero=numero.toFixed()/100;
    return numero;
}
function redondear(numero,cantidadDecimales)
{
    numero=new Number(numero);
    return numero.toFixed(cantidadDecimales);
}
function valorPorDefecto(input)
{
    if(input.value=='')
    {
        input.value="0";
    }
   
}
function validarFecha(input)
{
    if(input!=null)
    {
        var fechaCorrecta = true;
        if (input.value == ""){
            fechaCorrecta=false;
        }
        if (input.value != "")
        {
            fechaCorrecta = fechaCorrecta && (valAno(input));
            fechaCorrecta = fechaCorrecta && (valMes(input));
            fechaCorrecta = fechaCorrecta && (valDia(input));
            fechaCorrecta = fechaCorrecta && (valSep(input));
        }
        input.style.backgroundColor='#ffffff';
        if(!fechaCorrecta)
        {
            mostrarMensajeHint('La fecha introducida no es correcta',input);
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }
    }
    return true;

}
function validarMayorIgualACero(input)
{
    if(input!=null)
    {
        if(validarNumeroValido(input))
        {
            input.style.backgroundColor='#ffffff';
            if(parseInt(input.value)<0)
            {
                mostrarMensajeHint('Debe registrar una cantidad mayor igual a cero',input);
                input.style.backgroundColor='#F08080';
                input.focus();
                return false;
            }
        }
        else
            return false;
    }
    return true;

}
function validarMayorACeroById(idInput)
{
    var input=document.getElementById(idInput);
    return validarMayorACero(input);
}
function validarIntervaloValoresById(idInput,valorMinimo,valorMaximo)
{
    var input=document.getElementById(idInput);
    return validarIntervaloValores(input,valorMinimo,valorMaximo);
}
function validarIntervaloValores(input,valorMinimo,valorMaximo)
{
    if(input!=null)
    {
        if(validarNumeroValido(input))
        {
            input.style.backgroundColor='#ffffff';
            if(parseFloat(input.value)<valorMinimo || parseFloat(input.value)>valorMaximo)
            {
                mostrarMensajeHint('Debe registrar una cantidad entre '+valorMinimo+' y '+valorMaximo,input);
                input.style.backgroundColor='#F08080';
                input.focus();
                return false;
            }
        }
        else
            return false;
    }
    return true;
}

function validarMayorACero(input)
{
    if(input!=null)
    {
        if(validarNumeroValido(input))
        {
            input.style.backgroundColor='#ffffff';
            if(parseFloat(input.value)<=0)
            {
                mostrarMensajeHint('Debe registrar una cantidad mayor a 0',input);
                input.style.backgroundColor='#F08080';
                input.focus();
                return false;
            }
        }
        else
            return false;
    }
    return true;
}
function validarRegistroNoVacioById(idInputTexto)
{
    return validarRegistroNoVacio(document.getElementById(idInputTexto));
}
function validarRegistroNoVacio(inputTexto)
{
    if(inputTexto!=null)
    {
        inputTexto.style.backgroundColor='#ffffff';
        if(inputTexto.value=='')
        {
            mostrarMensajeHint('El dato requerido no puede estar vacio',inputTexto);
            inputTexto.style.backgroundColor='#F08080';
            inputTexto.focus();
            return false;
        }
        return true;
    }
    return true;
}
function validarNumeroValido(inputNumero)
{
    inputNumero.style.backgroundColor='#ffffff';
    if (isNaN(inputNumero.value))
    {
        mostrarMensajeHint('No se reconoce el numero introducido',inputNumero);
        inputNumero.style.backgroundColor='#F08080';
        inputNumero.focus();
        return false;
    }
    return true;
}
function validarRegistroEntero(inputNumero)
{
  inputNumero.value=(inputNumero.value==''?'0':inputNumero.value);
  inputNumero.style.backgroundColor='#ffffff';
   if (isNaN(inputNumero.value)){
       inputNumero.style.backgroundColor='#F08080';
        inputNumero.focus();
        alert("No se reconoce el numero "+inputNumero.value);
        return false;
    }
    else{
        if (inputNumero.value % 1 == 0) {
            return true;
        }
        else{
            inputNumero.style.backgroundColor='#F08080';
            inputNumero.focus();
            alert("Solo se permiten numeros enteros");
            return false;
        }
    }
    alert("Numero invalido")
    inputNumero.style.backgroundColor='#F08080';
    inputNumero.focus();
    return false;
}
function validarSeleccionMayorACeroById(idSelect)
{
    var select=document.getElementById(idSelect);
    return validarSeleccionMayorACero(select);
}
function validarSeleccionMayorACero(select)
{
    if(select!==null && select !== undefined)
    {
        select.style.backgroundColor='#ffffff';
        if(parseFloat(select.value)<=0||select.value=='')
        {
            mostrarMensajeHint('Debe seleccionar una opción',select);
            select.style.backgroundColor='#F08080';
            select.focus();
            return false;
        }
        return true;
    }
    return true;
}
function validarSeleccionMayorIgualACero(select)
{
    if(select!==null)
    {
        select.style.backgroundColor='#ffffff';
        if(parseFloat(select.value)<0)
        {
            mostrarMensajeHint('Debe seleccionar una opción',select);
            select.style.backgroundColor='#F08080';
            select.focus();
            return false;
        }
        return true;
    }
    return true;
}

function resizableSplit(){
                    colLeft--;
                    colRight++;
                    var texto='colLeft'+'%,'+colRight+'%';
                    parent.document.getElementById('main').cols=texto;
                    if(colLeft!=10){
                      setTimeout("resizableSplit()",1000);    
                    }
                }
function resizableSplitOnclick(){
            var values=parent.document.getElementById('main').cols;
            var cadenas=values.split(",");
            var x1=cadenas[0].split("%")[0];
            var y1=cadenas[1].split("%")[0];
            var obj=document.getElementById('icon');
            if(x1==0){
                obj.src='../img/collapse.gif';
                parent.document.getElementById('main').cols='20%,80%';
                
            }else{
                obj.src='../img/expand.gif';
                parent.document.getElementById('main').cols='0%,100%';
            }
            
}

function resizableSplitMove(){
    var icon=document.getElementById('icon');
    icon.style.left=parseInt(window.event.clientX+document.documentElement.scrollLeft+document.body.scrollLeft+10)+'px';
    icon.style.top=parseInt(window.event.clientY+document.documentElement.scrollTop+document.body.scrollTop)+'px';

}

function carga()
{
    posicion=3;
    
    // IE
    if(navigator.userAgent.indexOf("MSIE")>=0) navegador=0;
    // Otros
    else navegador=1;
}
 
function evitaEventos(event)
{
    // Funcion que evita que se ejecuten eventos adicionales
    if(navegador==0)
    {
        window.event.cancelBubble=true;
        window.event.returnValue=false;
    }
    if(navegador==1) event.preventDefault();
}
 
function comienzoMovimiento(event, id)
{
    
    elMovimiento=document.getElementById(id);
    
     // Obtengo la posicion del cursor
    if(navegador==0)
     {
        cursorComienzoX=window.event.clientX+document.documentElement.scrollLeft+document.body.scrollLeft;
         cursorComienzoY=window.event.clientY+document.documentElement.scrollTop+document.body.scrollTop;
 
        document.attachEvent("onmousemove", enMovimiento);
        document.attachEvent("onmouseup", finMovimiento);
    }
    if(navegador==1)
    {    
        cursorComienzoX=event.clientX+window.scrollX;
        cursorComienzoY=event.clientY+window.scrollY;
        
        document.addEventListener("mousemove", enMovimiento, true); 
        document.addEventListener("mouseup", finMovimiento, true);
    }
    elComienzoX=parseInt(elMovimiento.style.left);
    elComienzoY=parseInt(elMovimiento.style.top);
    // Actualizo el posicion del elemento
    elMovimiento.style.zIndex=++posicion;
    evitaEventos(event);
}
 
function enMovimiento(event)
{  
    var xActual, yActual;
    if(navegador==0)
    {    
        xActual=window.event.clientX+document.documentElement.scrollLeft+document.body.scrollLeft;
        yActual=window.event.clientY+document.documentElement.scrollTop+document.body.scrollTop;
    }  
    if(navegador==1)
    {
        xActual=event.clientX+window.scrollX;
        yActual=event.clientY+window.scrollY;
    }
    
    
    elMovimiento.style.left=(elComienzoX+xActual-cursorComienzoX)+"px";
    elMovimiento.style.top=(elComienzoY+yActual-cursorComienzoY)+"px";
 
    evitaEventos(event);
}
 
function finMovimiento(event)
{
    if(navegador==0)
    {    
        document.detachEvent("onmousemove", enMovimiento);
        document.detachEvent("onmouseup", finMovimiento);
    }
    if(navegador==1)
    {
        document.removeEventListener("mousemove", enMovimiento, true);
        document.removeEventListener("mouseup", finMovimiento, true);
    }
}

 function closePanelCalculo(){
                    document.getElementById('form1:panelCalcular').style.visibility='hidden';
                    document.getElementById('panelsuper').style.visibility='hidden';
                }
 function closePanelBuscar(){
                    document.getElementById('form1:panelBuscar').style.visibility='hidden';
                    document.getElementById('panelsuper').style.visibility='hidden';
 }
 function closePanelBuscar1(){
                    document.getElementById('form1:panelBuscar1').style.visibility='hidden';
                    document.getElementById('panelsuper').style.visibility='hidden';
 }

function creaAjax(){
         var objetoAjax=false;
         try {
          /*Para navegadores distintos a internet explorer*/
          objetoAjax = new ActiveXObject("Msxml2.XMLHTTP");
         } catch (e) {
          try {
                   /*Para explorer*/
                   objetoAjax = new ActiveXObject("Microsoft.XMLHTTP");
                   }
                   catch (E) {
                   objetoAjax = false;
          }
         }

         if (!objetoAjax && typeof XMLHttpRequest!='undefined') {
          objetoAjax = new XMLHttpRequest();
         }
         return objetoAjax;
}

function valInputMay(input)
{
    input.value = input.value.toUpperCase();
}
function valMAY()
{
    if ((event.keyCode > 96 && event.keyCode < 123) || event.keyCode > 223 && event.keyCode < 253)
    {  var tecla=parseInt(event.keyCode);
        tecla=tecla-32;
        event.keyCode=tecla;
        
        event.returnValue=true;

    }
}

function valNum(event)
{
    var key=(window.event?window.event.keyCode:event.which);
    if ((key < 48 || key > 57) && key!=44 && key!=45 && key!=46 &&key!==8&&key!==0)
     {  
        alert('Introduzca sólo Números');
        if(window.event)
            event.returnValue = false;
        else
            event.preventDefault();
     }
}

function editarItem(nametable)
{
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input').length>0)
                    {
                        if(cel.getElementsByTagName('input')[0].type=='checkbox')
                        {
                          if(cel.getElementsByTagName('input')[0].checked)
                          {
                           count++;
                          }
                        }
                         
                     }
                      
                   }
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }                                      
}
function editarVariosItems(nametable){

                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input').length>0)
                    {
                        if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                              if(cel.getElementsByTagName('input')[0].checked){
                               count++;
                             }                         
                         }                      
                       }
                   }
                    if(count==0){
                       alert('No selecciono ningun registro');
                       return false;
                }
   return true;
}

////este script sirve para la edicion en conjunto
function editarItems(nametable){

                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }                         
                     }                      
                   }
                    if(count==0){
                       alert('No selecciono ningun registro');
                       return false;
                }
   return true;
}
//fin Edicion

function eliminarItem(nametable){

                   var count=0;

                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }
                         
                     }
                      
                   }

                    if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                }
   return true;
}
/****************************************************************/
                /********************** VALIDAR FECHA ***************************/
                function esDigito(sChr){
                    var sCod = sChr.charCodeAt(0);
                    return ((sCod > 47) && (sCod < 58));
                }
                function valSep(oTxt){
                    var bOk = false;
                    bOk = bOk || ((oTxt.value.charAt(2) == "-") && (oTxt.value.charAt(5) == "-"));
                    bOk = bOk || ((oTxt.value.charAt(2) == "/") && (oTxt.value.charAt(5) == "/"));
                    return bOk;
                }
                function finMes(oTxt){
                    var nMes = parseInt(oTxt.value.substr(3, 2), 10);
                    var nRes = 0;
                    switch (nMes){
                    case 1: nRes = 31; break;
                    case 2: nRes = 29; break;
                    case 3: nRes = 31; break;
                    case 4: nRes = 30; break;
                    case 5: nRes = 31; break;
                    case 6: nRes = 30; break;
                    case 7: nRes = 31; break;
                    case 8: nRes = 31; break;
                    case 9: nRes = 30; break;
                    case 10: nRes = 31; break;
                    case 11: nRes = 30; break;
                    case 12: nRes = 31; break;
                    }
                    return nRes;
                }
                function valDia(oTxt){
                    var bOk = false;
                    var nDia = parseInt(oTxt.value.substr(0, 2), 10);
                    bOk = bOk || ((nDia >= 1) && (nDia <= finMes(oTxt)));
                    return bOk;
                }
                function valDia(oTxt){
                    var bOk = false;
                    var nDia = parseInt(oTxt.value.substr(0, 2), 10);
                    bOk = bOk || ((nDia >= 1) && (nDia <= finMes(oTxt)));
                    return bOk;
                }

                function valMes(oTxt){
                    var bOk = false;
                    var nMes = parseInt(oTxt.value.substr(3, 2), 10);
                    bOk = bOk || ((nMes >= 1) && (nMes <= 12));
                    return bOk;
                }

                function valAno(oTxt){
                    var bOk = true;
                    var nAno = oTxt.value.substr(6);
                    /*bOk = bOk && ((nAno.length == 2) || (nAno.length == 4));*/
                    bOk = bOk && (nAno.length == 4) && (nAno>1000) ;
                    if (bOk){
                        for (var i = 0; i < nAno.length; i++){
                        bOk = bOk && esDigito(nAno.charAt(i));
                        }
                    }
                    return bOk;
                }
                function valFecha(oTxt){                    
                    var bOk = true;
                    if (oTxt.value == ""){
                        alert("Fecha inválida");
                        oTxt.focus();
                    }
                    if (oTxt.value != ""){
                    bOk = bOk && (valAno(oTxt));
                    bOk = bOk && (valMes(oTxt));
                    bOk = bOk && (valDia(oTxt));
                    bOk = bOk && (valSep(oTxt));
                    if (!bOk){
                        alert("Fecha inválida");
                    ///oTxt.value = "";
                    oTxt.focus();
                    return false;
                    
                    }
                  }
                  return true;
                }
                function valFecha1(oTxt){
                    
                    var bOk = true;
                    if (oTxt.value == ""){
                        alert("Fecha inválida");
                        oTxt.focus();
                    }
                    if (oTxt.value != ""){
                    bOk = bOk && (valAno1(oTxt));
                    
                    bOk = bOk && (valMes1(oTxt));
                    
                    bOk = bOk && (valDia1(oTxt));
                    
                    bOk = bOk && (valSep(oTxt));
                    
                    bOk = bOk && (valHora1(oTxt));
                    
                    bOk = bOk && (valMinuto1(oTxt));
                    //bOk = bOk && (valSegundo1(oTxt));
                    bOk = bOk && (valSep2(oTxt));
                    
                    if (!bOk){
                        alert("Fecha inválida");
                    //oTxt.value = "";
                    oTxt.focus();
                    }
                  }
                }
                function valDia1(oTxt){
                    var bOk = false;
                    var nDia = parseInt(oTxt.value.substr(0, 2), 10);
                    bOk = bOk || ((nDia >= 1) && (nDia <= finMes(oTxt)));
                    return bOk;
                }
                function valMes1(oTxt){
                    var bOk = false;
                    var nMes = parseInt(oTxt.value.substr(3, 2), 10);
                    bOk = bOk || ((nMes >= 1) && (nMes <= 12));
                    return bOk;
                }

                function valAno1(oTxt){
                    var bOk = true;
                    var nAno = oTxt.value.substr(6,4);
                    /*bOk = bOk && ((nAno.length == 2) || (nAno.length == 4));*/
                    bOk = bOk && (nAno.length == 4) && (nAno>1000) ;
                    if (bOk){
                        for (var i = 0; i < nAno.length; i++){
                        bOk = bOk && esDigito(nAno.charAt(i));
                        }
                    }
                    return bOk;
                }
                function valSep2(oTxt){
                    var bOk = false;
                    bOk = bOk || ((oTxt.value.charAt(13) == ":"));
                    //bOk = bOk || ((oTxt.value.charAt(13) == ":") && (oTxt.value.charAt(16) == ":"));
                    return bOk;
                }
                function valHora1(oTxt){
                    
                    var bOk = false;
                    var nMes = parseInt(oTxt.value.substr(11, 2), 10);
                    bOk = bOk || ((nMes >= 0) && (nMes <= 23));
                    return bOk;
                }
                function valMinuto1(oTxt){
                    var bOk = false;
                    var nMes = parseInt(oTxt.value.substr(14), 10);
                    bOk = bOk || ((nMes >= 0) && (nMes <= 59));
                    return bOk;
                }
                function valSegundo1(oTxt){
                    var bOk = false;
                    var nMes = parseInt(oTxt.value.substr(17), 10);
                    bOk = bOk || ((nMes >= 0) && (nMes <= 59));
                    return bOk;
                }
//onscroll
    function asociarEventosInicio()
    {
        if(document.getElementById("bottonesAcccion")!=null)
        {
            var b=parseInt(document.body.scrollTop)+parseInt(document.body.clientHeight)-parseInt(document.getElementById("bottonesAcccion").clientHeight);
                document.getElementById("bottonesAcccion").style.top=
                (b);
            window.onscroll=function()
            {

                var a=parseInt(document.body.scrollTop)+parseInt(document.body.clientHeight)-parseInt(document.getElementById("bottonesAcccion").clientHeight);
                document.getElementById("bottonesAcccion").style.top=
                (a);

            };
            window.onresize=function()
            {
                var a=parseInt(document.body.scrollTop)+parseInt(document.body.clientHeight)-parseInt(document.getElementById("bottonesAcccion").clientHeight);
                document.getElementById("bottonesAcccion").style.top=
                (a);
            };
        }
    }
    window.onload=function()
    {
        asociarEventosInicio();
    };
                        









