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

 

var Util={
	valueOptionsSelected:"",
        nameOptionsSelected:"",
	getValueOptionsSelected:function(){
		return this.valueOptionsSelected;
		
	},
	getNameOptionsSelected:function(){
		return this.nameOptionsSelected;
	},
            valuesNamesOptionsSelected:function(obj){
                var names=new Array();
                var values=new Array();
		var j=0;
		for(var i=0;i<=obj.options.length-1;i++)
		{	if(obj.options[i].selected)
			{	values[j]=obj.options[i].value;
                                names[j]=obj.options[i].text;
				j++;
			}
		}
                this.valueOptionsSelected=values;
                this.nameOptionsSelected=names;
                
                
		
	},
        selectedAllOptions:function(objCheckBox,objSelect){
            for(var  i=0;i<objSelect.options.length;i++)
                    objSelect.options[i].selected=objCheckBox.checked;
        },
        createAjaxObject:function(){
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


};


function valMAY()
{
     
    if ((event.keyCode > 96 && event.keyCode < 123) || event.keyCode > 223 && event.keyCode < 253)
    {   var tecla=parseInt(event.keyCode);
        tecla=tecla-32;
        event.keyCode=tecla;
        event.returnValue=true;

    }
}

function valNum()
{  if ((event.keyCode < 48 || event.keyCode > 57) && event.keyCode!=44 && event.keyCode!=45 && event.keyCode!=46)
     {  
        alert('Introduzca solo Números.');
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

function carga(id)
{
    //alert('hola');
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
 /* ANULAR ITEM */
function anularItem(nametable,columna,varData,columna2){       
                    
                   var count=0;
                   var idIA='0';
                   var idIA2='0';
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;        
                    var cel=cellsElement[0];                    
                     var celda=cel.getElementsByTagName('input')[0];
                        if(celda!=null){
                                    if(celda.type=='checkbox'){
                                        if(celda.checked){
                                            idIA=cellsElement[columna].getElementsByTagName('SPAN')[0].innerHTML;      
                                            idIA2=cellsElement[columna2].getElementsByTagName('SPAN')[0].innerHTML;
                                            count++;
                                          }
                                    }
                            }
                   }
                    /*if(cel.getElementsByTagName('input')[0].type=='checkbox'){                                                  
                         if(cel.getElementsByTagName('input')[0].checked){                                                        
                           idIA=cellsElement[columna].getElementsByTagName('SPAN')[0].innerHTML;      
                           idIA2=cellsElement[columna2].getElementsByTagName('SPAN')[0].innerHTML;
                           count++;
                         }
                     }                      
                   }*/
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
    if(varData=='EDITAR'){
        return true;
    }
    var a=confirm("Esta seguro de anular?")
    if(a==1){        
        return true;
     }
    else
        return false;    
}

/******************************** EDITAR ITEM *********************************/
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
//window.onload=carga;
var elMovimiento;
var cursorComienzoX;
var cursorComienzoY;
var navegador;
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
                   var a=confirm("Esta seguro de anular?");
                   if(a==1)
                        return true;
                   else
                        return false;
}
function anularItemCobranza(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    var celda=cel.getElementsByTagName('input')[1];
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
                   var a=confirm("Esta seguro de anular?");
                   if(a==1)
                        return true;
                   else
                        return false;
}
// SCRIPT PARA APROBAR O RECHAZAR PEDIDOS
function AprobarRechazarPedido(nametable,varData){
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
                   var a=confirm("Esta seguro de "+varData+" el pedido?");
                   if(a==1)
                        return true;
                   else
                   return false;
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
                    oTxt.focus();
                    }
                  }
                }

var colLeft=15;
var colRight=85;

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
                /**************************************************************************************************/
                /**************************************************************************************************/
                /********************* FORMATO DE NUMERO EN JAVA SCRIPT*******************************/
function formatAsMoney(mnt) { 
    mnt -= 0; 
    mnt = (Math.round(mnt*100))/100; 
    return (mnt == Math.floor(mnt)) ? mnt + '.00' : ( (mnt*10 == Math.floor(mnt*10)) ? mnt + '0' : mnt); 
}
function formatCurrency(num) { 
    num = num.toString().replace(/$|,/g,''); 
    if(isNaN(num)) 
        num = "0"; 
        sign = (num == (num = Math.abs(num))); 
        num = Math.floor(num*100+0.50000000001); 
        cents = num%100; 
        num = Math.floor(num/100).toString(); 
    if(cents<10) 
        cents = "0" + cents; 
    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++) 
        num = num.substring(0,num.length-(4*i+3))+'.'+ 
    num.substring(num.length-(4*i+3)); 
    return (((sign)?'':'-') + 'Bs. ' + num + ',' + cents); 
}
function formatCurrency1(num) { 
    num = num.toString().replace(/$|,/g,''); 
    if(isNaN(num)) 
        num = "0"; 
        sign = (num == (num = Math.abs(num))); 
        num = Math.floor(num*100+0.50000000001); 
        cents = num%100; 
        num = Math.floor(num/100).toString(); 
    if(cents<10) 
        cents = "0" + cents; 
    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++) 
        num = num.substring(0,num.length-(4*i+3))+','+ 
    num.substring(num.length-(4*i+3)); 
    return (((sign)?'':'-')+ num + '.' + cents); 
}
function formatCuatroDigitos(num) { 
    num = num.toString().replace(/$|,/g,''); 
    if(isNaN(num)) 
        num = "0"; 
        sign = (num == (num = Math.abs(num))); 
        num = Math.floor(num*100+0.50000000001); 
        cents = num%100; 
        num = Math.floor(num/100).toString(); 
    if(cents<10) 
        cents = "0" + cents; 
    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++) 
        num = num.substring(0,num.length-(4*i+3))+'.'+ 
    num.substring(num.length-(4*i+3)); 
    return (((sign)?'':'-') + 'Bs. ' + num + ',' + cents); 
}
function formatoPresupuesto(num) { 
    num = num.toString().replace(/$|,/g,''); 
    if(isNaN(num)) 
        num = "0"; 
        sign = (num == (num = Math.abs(num))); 
        num = Math.floor(num*100+0.50000000001); 
        cents = num%100; 
        num = Math.floor(num/100).toString(); 
    if(cents<10) 
        cents = "0" + cents; 
    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++) 
        num = num.substring(0,num.length-(4*i+3))+','+ 
    num.substring(num.length-(4*i+3)); 
    return (((sign)?'':'-')+ num); 
}
