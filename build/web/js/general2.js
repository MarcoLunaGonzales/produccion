/*
 * general.js
 * Created on 19 de febrero de 2008, 16:50
 *   
 */

/*
 *  @author Wilmer Manzaneda Chavez
 *  @company COFAR 
 *  @param nametable nombre de la tabla
 */

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


function valMAY()
{
     
    if ((event.keyCode > 96 && event.keyCode < 123) || event.keyCode > 223 && event.keyCode < 253)
    {  var tecla=parseInt(event.keyCode);
        tecla=tecla-32;
        event.keyCode=tecla;
        
        event.returnValue=true;

    }
}

function valNum()

{
    if ((event.keyCode < 48 || event.keyCode > 57) && event.keyCode!=44 && event.keyCode!=45 && event.keyCode!=46)
     {  
        alert('Introduzca sólo Números');
        event.returnValue = false;
     }
}

function editarItem(nametable){
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
    var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
    cantidadeliminar.value=count;
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
    var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
cantidadeliminar.value=count;
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
                    //oTxt.value = "";
                    return false;
                    oTxt.focus();
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










