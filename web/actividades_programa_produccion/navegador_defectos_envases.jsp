<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>


<f:view>

<html>
<head>
    <title>SISTEMA</title>
    <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    <script type="text/javascript" src='../js/general.js' ></script>
    <script type="text/javascript" src='../js/treeComponet.js' ></script>
    
    <script>
        //var $jq = jQuery.noConflict();
          /*KeyboardJS.on('a', function() {
               alert('you pressed a!');
          });*/
          //var focused;
          function getCodigo(codigo,cod_programa_prod,cod_com_prod,cod_lote_prod,cod_formula_maestra){
                 //  alert(codigo);
                   location='../seguimiento_programa_produccion/navegador_seguimiento_programa.jsf?codigo='+codigo+'&cod_programa_prod='+cod_programa_prod+'&cod_com_prod='+cod_com_prod+'&cod_formula_maestra='+cod_formula_maestra+'&cod_lote_prod='+cod_lote_prod;
          }
          /*
          function eliminar(nametable){
               var count1=0;
               var elements1=document.getElementById(nametable);
               var rowsElement1=elements1.rows;
               //alert(rowsElement1.length);            
               for(var i=1;i<rowsElement1.length;i++){
                    var cellsElement1=rowsElement1[i].cells;
                    var cel1=cellsElement1[0];
                    if(cel1.getElementsByTagName('input').length>0){
                        if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel1.getElementsByTagName('input')[0].checked){
                               count1++;
                           }
                        }
                    }
                    
               }
               //alert(count1);
               if(count1==0){
                    alert('No escogio ningun registro');
                    return false;
               }else{
                
                
                    if(confirm('Desea Eliminar el Registro')){
                        if(confirm('Esta seguro de Eliminar el Registro')){
                            var count=0;
                            var elements=document.getElementById(nametable);
                            var rowsElement=elements.rows;
                            
                            for(var i=0;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[0];
                                if(cel.getElementsByTagName('input').length>0){
                                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                        if(cel.getElementsByTagName('input')[0].checked){
                                            count++;
                                        }
                                    }
                                }

                            }
                            if(count==0){
                            //alert('No escogio ningun registro');
                            return false;
                            }
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                }
           }
           */
          /*
           function sumaTotales(nametable){
               var elements=document.getElementById(nametable);
               var rowsElement=elements.rows;
               var totalHh=0;
               var totalHm=0;
               var totalHhStd=0;
               var totalHmStd=0;

                 for(var i=1;i<rowsElement.length-1;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cellHh=cellsElement[2];
                    var cellHm=cellsElement[3];
                    var cellHhStd=cellsElement[8];
                    var cellHmStd=cellsElement[9];
                    totalHh = totalHh+ parseFloat( cellHh.getElementsByTagName('span')[0].innerHTML.replace(",","."));
                    //alert(cellHh.getElementsByTagName('span')[0].innerHTML.replace(",","."));
                    totalHm = totalHm+ parseFloat( cellHm.getElementsByTagName('input')[0].value.replace(".",","));
                    totalHhStd = totalHhStd+ parseFloat(cellHhStd.getElementsByTagName('span')[0].innerHTML);
                    totalHmStd = totalHmStd+ parseFloat( cellHmStd.getElementsByTagName('span')[0].innerHTML);
                    //alert(cellHhStd.getElementsByTagName('span')[0].innerHTML);
                    //alert(cellHh.getElementsByTagName('input')[0].value);
                    document.getElementById("form1:actividadesFormulaMaestra:totalHh").innerHTML = totalHh;
                    document.getElementById("form1:actividadesFormulaMaestra:totalHm").innerHTML = totalHm;
                    document.getElementById("form1:actividadesFormulaMaestra:totalHhStd").innerHTML = totalHhStd;
                    document.getElementById("form1:actividadesFormulaMaestra:totalHmStd").innerHTML = totalHmStd;
               }
           }
    */
   /*
           function difFechaas(fecha){
               var fechaInicio = fecha.parentNode.parentNode.getElementsByTagName("td")[4].getElementsByTagName("input")[0].value;
               var fechaFinal = fecha.parentNode.parentNode.getElementsByTagName("td")[5].getElementsByTagName("input")[0].value;
               var fechaInicio1 = new Date(fechaInicio);
               var fechaFinal1 = new Date(fechaFinal);
               //alert(fechaInicio+":00");
               //alert(fechaFinal+":00");
               //alert(fechaFinal1.getTime()-fechaInicio1.getTime());
               var dif = (fechaFinal1-fechaInicio1)/3600000;
               //var dif = Math.round(((fechaFinal1.getTime()-fechaInicio1.getTime())/3600000.0)*100)/100;
               fecha.parentNode.parentNode.getElementsByTagName("td")[2].getElementsByTagName("span")[0].innerHTML=dif;
           }
    */
   /*
           function prueba(elem){
               alert(elem.value.length);
           }
    */
   
           function deshabilitarPrimeraFecha(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   //alert(rowsElement.length);
                   if(rowsElement.length>=2){
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel0=cellsElement[0];
                    var cel1=cellsElement[1];
                    var cel3=cellsElement[3];
                    var cel4=cellsElement[4];
                    var cel5=cellsElement[5];
                    var cel6=cellsElement[6];
                    if(cel5.getElementsByTagName('input')[0].type=='text'){
                        //alert("tiene el registro");
                          /*if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }*/
                        //alert(cel.getElementsByTagName('input')[0].value);
                        cel0.getElementsByTagName('input')[0].disabled = true;
                        cel1.getElementsByTagName('select')[0].disabled = true;
                        cel3.getElementsByTagName('input')[0].disabled = true;
                        cel4.getElementsByTagName('input')[0].disabled = true;
                        cel5.getElementsByTagName('input')[0].disabled = true;
                        cel5.getElementsByTagName('input')[1].disabled = true;
                        cel6.getElementsByTagName('input')[0].disabled = true;
                        cel6.getElementsByTagName('input')[1].disabled = true;


                        
                        //document.getElementById('form1:codProducto').disabled=true;
                     }
                     break;
                   }
                   }
                   //5 0,1
                   //6 0,1
                   /*if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }*/
                }
        //inicio ale unidades medida
           function redondeo2decimales(numero)
                {
                var original=parseFloat(numero);
                var result=Math.round(original*100)/100 ;
                return result;
                }
           function getNumeroDehoras(fechaIni,fechaFin)
           {
                if(fechaIni.length==16&&fechaFin.length==16)
                {
                var fec=fechaIni.split(" ");
                var d1=fec[0].split("/");
                var h1=fec[1].split(":");
                var dat1 = new Date(d1[2], parseFloat(d1[1]), parseFloat(d1[0]),parseFloat(h1[0]),parseFloat(h1[1]),0);

                 var de2 = fechaFin.split(" ");

                 var d2=de2[0].split("/");
                 var h2=de2[1].split(":");

                 var dat2 = new Date(d2[2], parseFloat(d2[1]), parseFloat(d2[0]),parseFloat(h2[0]),parseFloat(h2[1]),0);
                 var fin = dat2.getTime() - dat1.getTime();
                 var dias=0;
                 if(dat1!='NaN'&& dat2!='Nan')
                 {
                    var dias =redondeo2decimales(fin / (1000 * 60 * 60));
                 }


                return dias;
                }
                return 0;
            }
            function calcularDiferenciaFechas(obj)
            {
                var fecha1=obj.parentNode.parentNode.cells[6].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[6].getElementsByTagName('input')[1].value;
                var fecha2=obj.parentNode.parentNode.cells[7].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[7].getElementsByTagName('input')[1].value;
                obj.parentNode.parentNode.cells[2].getElementsByTagName('input')[0].value=getNumeroDehoras(fecha1,fecha2);
            }
            function calcularDiferenciaHoras(obj)
            {
                var fecha1=obj.parentNode.parentNode.cells[2].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[3].getElementsByTagName('input')[0].value;
                var fecha2=obj.parentNode.parentNode.cells[2].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[4].getElementsByTagName('input')[0].value;
                //alert(fecha1 + ' ' + fecha2);
                obj.parentNode.parentNode.cells[5].getElementsByTagName('input')[0].value=getNumeroDehoras(fecha1,fecha2);
                return true;
            }
            function posNextInput(obj)
            {
                obj.parentNode.parentNode.cells[3].getElementsByTagName('input')[0].focus();

            }
            A4J.AJAX.onError = function(req,status,message){
            window.alert("Ocurrio un error "+message+" continue con su transaccion ");
            }
            A4J.AJAX.onExpired = function(loc,expiredMsg){
            if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
            return loc;
            } else {
            return false;
            }
            }
            var tabla=null;
                function calcularTotalesTabla()
                {
                    tabla=document.getElementById("tablaDatosDefectos");
                    var sumaTotal=0;
                    if(tabla.rows[0].cells.length>2)
                    {
                        var sumaColumnas=new Array((tabla.rows[0].cells.length-2>0)?(tabla.rows[0].cells.length-2):0);
                        for(var i=0;i<sumaColumnas.length;i++)
                            {
                                sumaColumnas[i]=0;
                            }
                        for(var fila=1;fila<(tabla.rows.length-1);fila++)
                            {
                                var contCol=0;
                                var sumaDefectos=0;
                                for(var col=1;col<(tabla.rows[fila].cells.length-1);col++)
                                    {
                                        valorCelda=parseFloat(tabla.rows[fila].cells[col].getElementsByTagName('input')[0].value)
                                        sumaDefectos+=valorCelda;
                                        sumaColumnas[contCol]+=valorCelda;
                                        contCol++;
                                    }

                                    tabla.rows[fila].cells[tabla.rows[fila].cells.length-1].getElementsByTagName('span')[0].innerHTML=sumaDefectos;
                                    sumaTotal+=sumaDefectos;
                            }
                        for(var j=0;j<sumaColumnas.length;j++)
                            {
                                tabla.rows[tabla.rows.length-1].cells[j+1].getElementsByTagName('span')[0].innerHTML=sumaColumnas[j];
                            }
                        tabla.rows[tabla.rows.length-1].cells[tabla.rows[0].cells.length-1].getElementsByTagName('span')[0].innerHTML=sumaTotal;
                    }
                }
                function calcularSuma(celda)
                {
                    var sumaCol=0;
                    var sumaFila=0;
                    var columna=celda.parentNode.cellIndex;
                    var filaSuma=celda.parentNode.parentNode.rowIndex;
                    var sumaTotal=0;
                    for(var col=1;col<(tabla.rows[0].cells.length-1);col++)
                        {
                            sumaFila+=parseFloat((tabla.rows[filaSuma].cells[col].getElementsByTagName('input')[0].value!='')?tabla.rows[filaSuma].cells[col].getElementsByTagName('input')[0].value:0);
                        }
                    tabla.rows[filaSuma].cells[tabla.rows[0].cells.length-1].getElementsByTagName('span')[0].innerHTML=sumaFila;
                    var ultimaCol=tabla.rows[0].cells.length-1;
                    for(var fila=1;fila<(tabla.rows.length-1);fila++)
                        {
                            sumaTotal+=parseFloat((tabla.rows[fila].cells[ultimaCol].getElementsByTagName('span')[0].innerHTML!='')?tabla.rows[fila].cells[ultimaCol].getElementsByTagName('span')[0].innerHTML:0);
                            sumaCol+=parseFloat((tabla.rows[fila].cells[columna].getElementsByTagName('input')[0].value!='')?tabla.rows[fila].cells[columna].getElementsByTagName('input')[0].value:0);
                        }
                    tabla.rows[tabla.rows.length-1].cells[columna].getElementsByTagName('span')[0].innerHTML=sumaCol;
                    tabla.rows[tabla.rows.length-1].cells[ultimaCol].getElementsByTagName('span')[0].innerHTML=sumaTotal;

                }
                function valEnteros()
                {
                  if ((event.keyCode < 48 || event.keyCode > 57) )
                     {
                        alert('Solo puede registrar numeros enteros');
                        event.returnValue = false;
                     }
                }
                function mas_action(){
                    last = this;
                }
                function colocaFocusUltimaFila(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   //alert(rowsElement.length);
                   if(rowsElement.length>=2){
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel0=cellsElement[0];
                    var cel1=cellsElement[1];
                    var cel3=cellsElement[3];
                    var cel4=cellsElement[4];
                    var cel5=cellsElement[5];
                    var cel6=cellsElement[6];
                    if(cel5.getElementsByTagName('input')[0].type=='text'){
                        //alert("tiene el registro");
                          /*if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }*/
                        //alert(cel.getElementsByTagName('input')[0].value);
                        cel0.getElementsByTagName('input')[0].disabled = true;
                        cel1.getElementsByTagName('select')[0].disabled = true;
                        cel3.getElementsByTagName('input')[0].disabled = true;
                        cel4.getElementsByTagName('input')[0].disabled = true;
                        cel5.getElementsByTagName('input')[0].disabled = true;
                        cel5.getElementsByTagName('input')[1].disabled = true;
                        cel6.getElementsByTagName('input')[0].disabled = true;
                        cel6.getElementsByTagName('input')[1].disabled = true;



                        //document.getElementById('form1:codProducto').disabled=true;
                     }
                     break;
                   }
                   }
                   //5 0,1
                   //6 0,1
                   /*if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }*/
                }
                function focusUltimaFila(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   //alert(rowsElement.length);
                   if(rowsElement.length>=1){
                           for(var i=1;i<rowsElement.length;i++){
                            var cellsElement=rowsElement[i].cells;
                            //var cel0=cellsElement[0];
                            var cel1=cellsElement[1];
                                //cel0.getElementsByTagName('input')[0].disabled = true;
                                cel1.getElementsByTagName('select')[0].focus();                             
                           }
                   }
                   //5 0,1
                   //6 0,1
                   /*if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }*/
                }
        </script>
        <style type="text/css">
            .input{
                border:none;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
            }
        </style>
        <%--final ale unidades medida sumaTotales('form1:actividadesFormulaMaestra') --%>
        
</head>
<body bgcolor="#F2E7F2" onload="" >
                
                <div align="center">
                        <a4j:form id="form2">
                            <%--h:outputText value="#{ManagedActividadesProgramaproduccion.cargarSeguimientoProgramaProduccionPersonal}" /--%>
                                <h:panelGroup id="contenidoSeguimientoProgramaProduccionPersonal" >
                                <div align="center">
                                 <h:panelGrid columns="2"  styleClass="navegadorTabla" headerClass="headerClassACliente" style="border:1px solid #0A5B99;" id="datosSolicitudMantenimiento">
                                        <f:facet name="header">
                                            <h:outputText value="Datos Programa Produccion"  />
                                        </f:facet>
                                        <h:outputText value="Producto :" styleClass="outputText1" />
                                        <h:outputText value="#{ManagedActividadesProgramaproduccion.programaProduccion.formulaMaestra.componentesProd.nombreProdSemiterminado}" styleClass="outputText1"   />
                                        <h:outputText value="Lote :" styleClass="outputText1" />
                                        <h:outputText value="#{ManagedActividadesProgramaproduccion.programaProduccion.codLoteProduccion}" styleClass = "outputText1" />
                                        <h:outputText value="Actividad :" styleClass="outputText1" />
                                        <h:outputText value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccion.actividadesProduccion.nombreActividad}"  styleClass = "outputText1"/>
                                        <h:outputText value="Personal que Inspecciono :" styleClass="outputText1" />
                                        <h:panelGroup>
                                        <h:outputText value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionPersonal.personal.nombrePersonal}"  styleClass = "outputText1"/>&nbsp;
                                        <h:outputText value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionPersonal.personal.apPaternoPersonal}"  styleClass = "outputText1"/>&nbsp;
                                        <h:outputText value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionPersonal.personal.apMaternoPersonal}"  styleClass = "outputText1"/>
                                        </h:panelGroup>
                                 </h:panelGrid>
                            <br/>

                            
                                 <h:panelGroup id="contenidoRegistroDefectosEnvase">
                                                 <table class="dr-table rich-table" id="tablaDatosDefectos" style="border-style:solid;border-color:black" cellpadding="0" cellspacing="0">
                                                        <tr class="dr-table-subheader rich-table-subheader" >
                                                         <td class="dr-table-subheadercell rich-table-subheadercell headerClassACliente">
                                                            <h:outputText value="Defectos"/>
                                                        </td>
                                                        <a4j:repeat value="#{ManagedActividadesProgramaproduccion.headerColumns}" var="headerColumn" >
                                                            <td class="dr-table-subheadercell rich-table-subheadercell headerClassACliente">
                                                            <h:outputText value="#{headerColumn}"/>
                                                            </td>
                                                        </a4j:repeat>
                                                         <td class="dr-table-subheadercell rich-table-subheadercell headerClassACliente">
                                                            <h:outputText value="TOTAL"/>
                                                        </td>
                                                       </tr>

                                                         <a4j:repeat value="#{ManagedActividadesProgramaproduccion.defectosEnvaseLoteList}" var="data" >
                                                             <tr>
                                                                <td class="dr-table-subheadercell rich-table-subheadercell">
                                                                    <h:outputText value="#{data.defectoEnvase.nombreDefectoEnvase}" styleClass="outputText2"/>
                                                                </td>
                                                                 <a4j:repeat value="#{data.defectosEnvasePersonalList}" var="datos">
                                                                     <td class="dr-table-subheadercell rich-table-subheadercell">
                                                                         <h:inputText value="#{datos.cantidadDefectosEncontrados}" size="6" styleClass="inputText"
                                                                         onkeypress="valEnteros();" onkeyup="calcularSuma(this)"  >
                                                                             <f:convertNumber pattern="##"/>
                                                                         </h:inputText>
                                                                     </td>
                                                                 </a4j:repeat>
                                                                    <td class="dr-table-subheadercell rich-table-subheadercell">
                                                                        <span class="outputText2" style="color:#FF0000">0.0</span>
                                                                    </td>
                                                            </tr>
                                                        </a4j:repeat>
                                                        <tr>
                                                         <td class="dr-table-subheadercell rich-table-subheadercell">
                                                                        <span class="outputText2"><b>TOTAL</b></span>
                                                         </td>
                                                         <a4j:repeat value="#{ManagedActividadesProgramaproduccion.headerColumns}" var="headerColumn" >
                                                            <td class="dr-table-subheadercell rich-table-subheadercell" >
                                                                        <span class="outputText2" style="color:#FF0000">0.0</span>
                                                            </td>

                                                        </a4j:repeat>
                                                          <td class="dr-table-subheadercell rich-table-subheadercell">
                                                                        <b><span class="outputText2" style="color:#FF0000">0.0</span></b>
                                                         </td>
                                                        </tr>
                                                </table>
                                                <script>calcularTotalesTabla();</script>
                                        <br/>



                                        <br>
                                        
                                    <h:commandButton action="#{ManagedActividadesProgramaproduccion.guardarRegistroDefectos_action}" type="button" value="Guardar"
                                    styleClass="btn" accesskey="g" />
                                    <h:commandButton action="#{ManagedActividadesProgramaproduccion.cancelarDefectos_action}" type="button" value="Cancelar"
                                    styleClass="btn" accesskey="c" />
                                   </h:panelGroup>

                            <br/>
                            <%--input onclick="location='navegador_actividades_programa.jsf'" type="button" class="btn" value="Cancelar" /--%>
                            </div>
                            </h:panelGroup>
                        </a4j:form>

    

        

        
         
         <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="400" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
         <h:panelGroup   id="panelsuper"  styleClass="panelSuper" style="visibility:hidden"  >
         </h:panelGroup>
         
         </div>


</body>
</html>

</f:view>

