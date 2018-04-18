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
{  if ((event.keyCode < 48 || event.keyCode > 57) && event.keyCode!=44 && event.keyCode!=45 && event.keyCode!=46)
     {  
        alert('Introduzca solo números.');
        event.returnValue = false;
     }
}
function editarItem(nametable){
    
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=0;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                        alert(cel.getElementsByTagName('input')[0].checked);
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
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

function editarItemUno(nametable){
    
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    var celda=cel.getElementsByTagName('input')[0];
                        if(celda!=null){
                                    if(celda.type=='checkbox'){
                                        if(celda.checked)count++;
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


function anularItemUno(nametable){
    
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    var celda=cel.getElementsByTagName('input')[0];
                        if(celda!=null){
                                    if(celda.type=='checkbox'){
                                        if(celda.checked)count++;
                                    }
                            }
                   }
                    

                    if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   /*else if(count>1){
                       alert('Solo puede anular un registro');
                       return false;
                   }*/
                   var a=confirm("Esta seguro de anular?");
                   if(a==1)
                        return true;
                   else
                        return false;
                    

                   
                   
                }


function editarItem2(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=2;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
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


function anularItem(nametable,columna,varData,columna2){       
                   /*var count=0;
                   var idIA='0';
                   var idIA2='0';
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=2;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;        
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          
                       
                         if(cel.getElementsByTagName('input')[0].checked){
                           idIA=cellsElement[columna].getElementsByTagName('SPAN')[0].innerHTML;      
                           idIA2=cellsElement[columna2].getElementsByTagName('SPAN')[0].innerHTML;      
                           count++;
                         }
                       
                         
                     }
                      
                   }                              
                if(count==0){
                    alert('No escogio ningun registro');
                    return false;
                }
                else if(count>1){
                    alert('Solo puede escoger un registro');
                    return false;
                }    
    

    if (idIA=='ANULADA' && varData=='EDITAR'){
        alert("Este Registro NO puede ser Editado");
        return false;
    }
    if (varData=='EDITAR' && idIA=='NORMAL'  && idIA2=='1' ){
        alert("Este Registro NO puede ser Editado");
        return false;
    }
    if (idIA=='NORMAL'  && idIA2=='1' &&  varData=='ANULAR'){
        alert("Este Registro NO puede ser Anulado");
        return false;
    }
    if (idIA=='ANULADA'  && idIA2=='1' &&  varData=='ANULAR'){
        alert("Este Registro ya esta Anulado");
        return false;
    }
    if (idIA=='ANULADA'  && idIA2=='0' &&  varData=='ANULAR'){
        alert("Este Registro ya esta Anulado");
        return false;
    }
    var a=confirm("Esta seguro de anular?")
    if(a==1){
        return true;
     }
    else
        return false;
    */

    
}
function delItem(nametable){

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
    var a=confirm("Esta seguro de Elimianar los Datos?")
    if(a==1){
        var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
        cantidadeliminar.value=count;
        return true;
     }
    else
        return false;   
}
function onrowmouseout(obj){
    obj.style.backgroundColor='#FFFFFF';
}
function onrowmouseover(obj){
    obj.style.backgroundColor='#CCDFFA';
}


/*****************************************/

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
  
 
//window.onload=carga;
var elMovimiento;
var cursorComienzoX;
var cursorComienzoY;
var navegador;
